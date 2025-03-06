#!/bin/sh

# Kiểm tra xem có cần tải xuống phiên bản mới nhất của JMusicBot không
# và tải xuống nếu phiên bản mới nhất chưa được tải xuống
DOWNLOAD=false

# Đảm bảo rằng script sẽ chạy trong một vòng lặp để bot tự khởi động lại
# khi bạn sử dụng lệnh shutdown
LOOP=true

download() {
    if [ $DOWNLOAD = true ]; then
        URL=$(curl -s https://api.github.com/repos/jagrosh/MusicBot/releases/latest \
           | grep -i "browser_download_url.*\.jar" \
           | sed 's/.*\(http.*\)"/\1/')
        FILENAME=$(echo $URL | sed 's/.*\/\([^\/]*\)/\1/')
        if [ -f $FILENAME ]; then
            echo "Phiên bản mới nhất đã được tải xuống (${FILENAME})"
        else
            curl -L $URL -o $FILENAME
        fi
    fi
}

run() {
    java -Dnogui=true -jar $(ls -t JMusicBot* | head -1)
}

while $LOOP; do
    download
    run
done 
