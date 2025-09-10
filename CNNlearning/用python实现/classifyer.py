import os
import shutil
import re
#处理training文件夹
src_dir = r'D:\\Working\\mnist_jpg_training_and_test\\training'

# 创建0~9类别文件夹
for i in range(10):
    class_dir = os.path.join(src_dir, str(i))
    if not os.path.exists(class_dir):
        os.makedirs(class_dir)

# 遍历所有图片并移动
for fname in os.listdir(src_dir):
    if fname.lower().endswith('.jpg'):
        # 用正则提取类别数字
        match = re.search(r'_(\d)\.jpg$', fname)
        if match:
            label = match.group(1)
            src_path = os.path.join(src_dir, fname)
            dst_path = os.path.join(src_dir, label, fname)
            shutil.move(src_path, dst_path)

print("整理完成！")