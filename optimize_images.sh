#!/bin/bash

cd /Users/duongnguyen/project/freelancer/web_cuoi/ngocsangquynhnhu30032026/public/images

echo "=== Tối ưu hóa ảnh JPG ==="
echo "Kích thước ban đầu:"
du -sh .

echo ""
echo "Bắt đầu xử lý..."

for file in *.jpg; do
    echo "Xử lý: $file"
    convert "$file" -interlace Plane -quality 85 -strip "/tmp/${file}"
    mv "/tmp/${file}" "$file"
done

echo ""
echo "=== Kích thước sau khi tối ưu hóa ==="
du -sh .

echo ""
echo "Chi tiết từng file:"
ls -lh *.jpg | awk '{printf "%-10s %10s\n", $9, $5}'
