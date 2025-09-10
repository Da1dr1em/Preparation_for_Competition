import os
import torch
import torch.nn as nn
import torch.optim as optim
from torchvision import transforms, datasets
from torch.utils.data import DataLoader

# GPU设置（在实例化模型前添加）
print(f"CUDA available: {torch.cuda.is_available()}")
if torch.cuda.is_available():
    # 指定要使用的GPU ID（如果有多个GPU）
    os.environ["CUDA_VISIBLE_DEVICES"] = "0"  # 使用第一个GPU
    print(f"GPU count: {torch.cuda.device_count()}")
    print(f"GPU name: {torch.cuda.get_device_name(0)}")
    # 设置cudnn
    torch.backends.cudnn.benchmark = True
    torch.backends.cudnn.deterministic = False
else:
    print("WARNING: GPU not available, using CPU!")

# 目的是在电脑端训练得到参数，然后部署到fpga版上
# 想要实现mobilenetv3 - small 的结构

# MobileNetV3 Small Block
class HardSwish(nn.Module):
    def forward(self, x):
        return x * torch.clamp(x + 3, 0, 6) / 6

class SeBlock(nn.Module):
    def __init__(self, in_channels, reduction=4):
        super().__init__()
        self.pool = nn.AdaptiveAvgPool2d(1)
        self.fc = nn.Sequential(
            nn.Linear(in_channels, in_channels // reduction),
            nn.ReLU(inplace=True),
            nn.Linear(in_channels // reduction, in_channels),
            nn.Hardsigmoid()
        )
    def forward(self, x):
        b, c, _, _ = x.size()
        y = self.pool(x).view(b, c)
        y = self.fc(y).view(b, c, 1, 1)
        return x * y

class MobileNetV3SmallBlock(nn.Module):
    def __init__(self, in_channels, out_channels, kernel_size, stride, use_se, activation):
        super().__init__()
        self.use_se = use_se
        self.activation = activation
        self.conv = nn.Sequential(
            nn.Conv2d(in_channels, out_channels, kernel_size, stride, kernel_size//2, bias=False),
            nn.BatchNorm2d(out_channels),
            activation()
        )
        if use_se:
            self.se = SeBlock(out_channels)
        else:
            self.se = nn.Identity()
    def forward(self, x):
        x = self.conv(x)
        x = self.se(x)
        return x

class MobileNetV3Small(nn.Module):
    def __init__(self, num_classes=10):
        super().__init__()
        self.features = nn.Sequential(
            nn.Conv2d(1, 16, 3, 2, 1, bias=False),  # 输入1通道
            nn.BatchNorm2d(16),
            HardSwish(),

            MobileNetV3SmallBlock(16, 16, 3, 2, True, nn.ReLU),    # 下采样
            MobileNetV3SmallBlock(16, 24, 3, 2, False, nn.ReLU),   # 下采样
            MobileNetV3SmallBlock(24, 24, 3, 1, False, nn.ReLU),
            MobileNetV3SmallBlock(24, 40, 5, 2, True, HardSwish),  # 下采样
            MobileNetV3SmallBlock(40, 40, 5, 1, True, HardSwish),
            MobileNetV3SmallBlock(40, 48, 5, 1, True, HardSwish),
            MobileNetV3SmallBlock(48, 96, 5, 2, True, HardSwish),  # 下采样
        )
        self.pool = nn.AdaptiveAvgPool2d(1)
        self.classifier = nn.Sequential(
            nn.Linear(96, 10)
        )
    def forward(self, x):
        x = self.features(x)
        x = self.pool(x)
        x = x.view(x.size(0), -1)
        x = self.classifier(x)
        return x

# 数据预处理
transform = transforms.Compose([
    transforms.Grayscale(num_output_channels=1),  # 保证单通道
    transforms.Resize((28, 28)),                  # 保证尺寸一致
    transforms.ToTensor(),
    transforms.Normalize((0.1307,), (0.3081,))
])

# 加载图片数据集
train_dataset = datasets.ImageFolder(
    root=r'D:\\Working\\mnist_jpg_training_and_test\\training',
    transform=transform
)
test_dataset = datasets.ImageFolder(
    root=r'D:\\Working\\mnist_jpg_training_and_test\\test',
    transform=transform
)
train_loader = DataLoader(train_dataset, batch_size=64, shuffle=True)
test_loader  = DataLoader(test_dataset, batch_size=1000, shuffle=False)

# 实例化模型
device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
print(f"Using device: {device}")
model = MobileNetV3Small().to(device)
optimizer = optim.Adam(model.parameters(), lr=0.001)
criterion = nn.CrossEntropyLoss()

# 训练函数
def train(epoch):
    model.train()
    for batch_idx, (data, target) in enumerate(train_loader):
        data, target = data.to(device), target.to(device)
        optimizer.zero_grad()
        output = model(data)
        loss = criterion(output, target)
        loss.backward()
        optimizer.step()
        if batch_idx % 100 == 0:
            print(f'Train Epoch: {epoch} [{batch_idx * len(data)}/{len(train_loader.dataset)}] Loss: {loss.item():.6f}')

# 测试函数
def test():
    model.eval()
    test_loss = 0
    correct = 0
    with torch.no_grad():
        for data, target in test_loader:
            data, target = data.to(device), target.to(device)
            output = model(data)
            test_loss += criterion(output, target).item()
            pred = output.argmax(dim=1)
            correct += pred.eq(target).sum().item()
    test_loss /= len(test_loader)
    print(f'\nTest set: Average loss: {test_loss:.4f}, Accuracy: {correct}/{len(test_loader.dataset)} ({100. * correct / len(test_loader.dataset):.2f}%)\n')

# 主流程
for epoch in range(1, 3):  # 训练5轮
    train(epoch)
    test()

# 保存模型参数
torch.save(model.state_dict(), "mobilenetv3_small_mnist.pth")
