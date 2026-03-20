#!/bin/bash

cd "/Users/duongnguyen/project/freelancer/web_cuoi/ngocsangquynhnhu30032026/public/images"

echo "=== Tối ưu hóa cực cấp - Giảm dung lượng tối đa ==="
echo ""
echo "Kích thước hiện tại:"
du -sh .
echo ""

for file in *.jpg; do
    echo "Xử lý: $file"
    
    # Aggressive optimization: quality 60, smaller dimensions, better compression
    convert "$file" \
        -resize 1200x1800 \
        -interlace Plane \
        -quality 60 \
        -strip \
        -colorspace sRGB \
        -sampling-factor 4:2:0 \
        "/tmp/${file}"
    
    # Additional compression with mogrify
    if command -v mogrify &> /dev/null; then
        mogrify -quality 55 "/tmp/${file}" 2>/dev/null
    fi
    
    # Check output size
    if [ -f "/tmp/${file}" ]; then
        original_size=$(ls -lh "$file" | awk '{print $5}')
        optimized_size=$(ls -lh "/tmp/${file}" | awk '{print $5}')
        original_bytes=$(stat -f%z "$file" 2>/dev/null)
        optimized_bytes=$(stat -f%z "/tmp/${file}" 2>/dev/null)
        reduction=$((100 - (optimized_bytes * 100 / original_bytes)))
        
        echo "  $original_size → $optimized_size (giảm $reduction%)"
        mv "/tmp/${file}" "$file"
    fi
done

echo ""
echo "=== Kích thước sau tối ưu hóa cực cấp ==="
du -sh .

echo ""
echo "Chi tiết từng file:"
ls -lh *.jpg | awk '{total+=$5} {printf "%-10s %10s\n", $9, $5} END {printf "\nTổng cộng: %s\n", total}'
