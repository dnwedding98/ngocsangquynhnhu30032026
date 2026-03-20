#!/bin/bash

cd "/Users/duongnguyen/project/freelancer/web_cuoi/ngocsangquynhnhu30032026/public/images"

echo "=== Tối ưu hóa ảnh JPG - Nén cực cao với thay đổi kích thước ==="
echo ""
echo "Kích thước ban đầu:"
du -sh .
echo ""

for file in *.jpg; do
    echo "Xử lý: $file"
    
    # Get original dimension
    dimension=$(identify -ping -format "%wx%h" "$file" 2>/dev/null)
    echo "  Kích thước gốc: $dimension"
    
    # Optimize: Resize to max 1500px width, quality 70, aggressive compression
    convert "$file" \
        -resize 1500x2000 \
        -interlace Plane \
        -quality 70 \
        -strip \
        -colorspace sRGB \
        "/tmp/${file}"
    
    # Additional compression with jpegoptim if available
    if command -v jpegoptim &> /dev/null; then
        jpegoptim --max=75 --strip-all "/tmp/${file}" 2>/dev/null
    fi
    
    # Check output size
    if [ -f "/tmp/${file}" ]; then
        original_size=$(ls -lh "$file" | awk '{print $5}')
        optimized_size=$(ls -lh "/tmp/${file}" | awk '{print $5}')
        original_bytes=$(stat -f%z "$file" 2>/dev/null)
        optimized_bytes=$(stat -f%z "/tmp/${file}" 2>/dev/null)
        reduction=$((100 - (optimized_bytes * 100 / original_bytes)))
        
        echo "  Ban đầu: $original_size → Tối ưu: $optimized_size (giảm $reduction%)"
        mv "/tmp/${file}" "$file"
    fi
done

echo ""
echo "=== Kích thước sau khi tối ưu hóa ==="
du -sh .

echo ""
echo "Chi tiết từng file:"
ls -lh *.jpg | awk '{printf "%-10s %10s\n", $9, $5}'
