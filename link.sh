#!/bin/bash

if ! command -v pup &> /dev/null || ! command -v curl &> /dev/null; then
    echo "⚠️ 'curl' hoặc 'pup' chưa được cài đặt."
    echo "   hãy cài đặt chúng rồi mình tiếp tục nha! (♡ >ω< ♡)"
    exit 1
fi

OUTPUT_FILE="data.txt"
> "OUTPUT_FILE"

echo "♻️  Đã dọn dẹp và chuẩn bị file '$OUTPUT_FILE' "
read -p "💖 Vui lòng nhập tổng số trang bạn muốn thu thập: " TOTAL_PAGES

if ! [[ "$TOTAL_PAGES" =~ ^[0-9]+$ ]] || [ "$TOTAL_PAGES" -eq 0 ]; then
    echo "😥 Oops! Có vẻ như đây không phải là một con số hợp lệ."
    exit 1
fi

echo "🚀 Okay các sếp! Hãy sẽ bắt đầu hành trình 'khám phá' $TOTAL_PAGES thôi. Hẹ hẹ hẹ!"

BASE_URL="https://truyenqqgo.com/truyen-moi-cap-nhat/trang-1.html"

SELECTOR='div.book_avatar > a[href]'

for (( page=1; page<=TOTAL_PAGES; page++ ))
do
    if [ "$page" -eq 1 ]; then
        current_url="$BASE_URL"
        echo -e "\n🔎 Đang phân tích Trang 1 tại: $current_url"
    else
        current_url="${BASE_URL}page/trang-${page}/"
        echo -e "\n🔎 Đang phân tích Trang $page tại: $current_url"
    fi

     
    links_found=$(curl -sL "$current_url" | pup "$SELECTOR attr{href}")

    if [ -n "$links_found" ]; then
        echo "$links_found" >> "$OUTPUT_FILE"
        count=$(echo "$links_found" | wc -l)
        echo "✅ Tìm thấy và đã lưu $count link từ khu vực chỉ định!"
    else
        echo "không tìm thấy link nào khớp với bộ lọc siêu chính xác này ở trang hiện tại.>
    fi
    
    echo "💤 Tạm nghỉ 2 giây..."
    sleep 2

done

# --- [[ 🏆 BƯỚC 5: BÁO CÁO CHIẾN CÔNG! 🏆 ]] ---
total_links=$(cat "$OUTPUT_FILE" | wc -l)
echo -e "\n🎉 Hoàn thành xuất sắc nhiệm vụ"
echo "✨ Toàn bộ $total_links 'viên ngọc' link đã được cất giữ an toàn trong file '$OUTPUT_FILE'."
