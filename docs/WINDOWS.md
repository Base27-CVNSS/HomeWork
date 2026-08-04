# Hướng dẫn Windows

## Cài đặt nhanh

1. Mở trang [Releases](https://github.com/Base27-CVNSS/HomeWork/releases/latest).
2. Tải `HomeWork-Setup.exe`.
3. Nhấp đúp tệp, chọn **Install**, sau đó giữ tùy chọn **Mở HomeWork**.

Installer cài theo người dùng vào `%LOCALAPPDATA%\Programs\HomeWork`, vì vậy không yêu cầu quyền Administrator.

## Bản portable

1. Tải `HomeWork-Windows-Portable.zip`.
2. Giải nén toàn bộ thư mục; không chạy EXE trực tiếp trong tệp ZIP.
3. Mở `HomeWork.exe` trong thư mục đã giải nén.

Flutter desktop cần các tệp DLL và thư mục `data` đi cùng EXE. Không di chuyển riêng `HomeWork.exe` ra khỏi thư mục portable.

## SmartScreen

Phiên bản cộng đồng chưa có chứng thư ký mã thương mại nên Windows có thể hiển thị **Windows protected your PC**. Nếu tệp được tải đúng từ GitHub Releases của `Base27-CVNSS/HomeWork`, chọn **More info → Run anyway**.

## Sao lưu

Thoát HomeWork rồi sao chép tệp sau tới nơi an toàn:

```text
%APPDATA%\HomeWork\workspace.json
```

Để khôi phục, cài HomeWork, thoát ứng dụng và chép tệp trở lại đúng vị trí.

## Gỡ cài đặt

Mở **Settings → Apps → Installed apps → HomeWork → Uninstall**. Gỡ ứng dụng không tự xóa workspace trong `%APPDATA%`, giúp dữ liệu còn nguyên khi cài lại.
