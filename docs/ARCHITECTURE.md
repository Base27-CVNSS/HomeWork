# Kiến trúc HomeWork

## Mục tiêu

HomeWork ưu tiên khả năng chạy lâu dài trên Windows, ít phụ thuộc và dễ bảo trì. Phiên bản 1.0.0 chỉ dùng Flutter SDK, không phụ thuộc package bên thứ ba trong runtime.

## Các lớp chính

| Lớp | Thư mục | Trách nhiệm |
|---|---|---|
| Giao diện | `lib/presentation/` | Bố cục desktop, màn hình, dialog và widget dùng lại. |
| Trạng thái | `lib/state/` | Điều phối thao tác người dùng, bộ lọc, thống kê và lưu dữ liệu. |
| Mô hình | `lib/models/` | Kiểu dữ liệu công việc và chuyển đổi JSON. |
| Lưu trữ | `lib/data/` | Đọc/ghi `%APPDATA%\HomeWork\workspace.json`, phục hồi khi JSON lỗi. |
| Đóng gói | `.github/`, `installer/`, `tooling/` | Tạo Windows runner, gắn icon, build, kiểm thử và tạo installer. |

## Luồng dữ liệu

1. `main.dart` khởi tạo `WorkspaceStore` và nạp dữ liệu vào `WorkspaceController`.
2. UI theo dõi `WorkspaceController` qua `ChangeNotifier`.
3. Mọi thao tác thêm, hoàn thành, xóa hoặc đổi giao diện cập nhật state trước, sau đó ghi JSON.
4. Dữ liệu không rời khỏi máy trừ khi người dùng tự sao chép tệp workspace.

## Nguyên tắc làm sạch

- Không nhập mã Dart/Java/Kotlin dịch ngược từ XAPK.
- Không nhập token, phản hồi đăng nhập mẫu hoặc endpoint nội bộ.
- Không dùng font, ảnh hay tài nguyên legacy không có giấy phép rõ ràng.
- Chỉ giữ tài liệu phân tích ở môi trường riêng; kho công khai chứa mã viết lại sạch.
- Mọi tích hợp mạng tương lai phải có hợp đồng rõ ràng, cấu hình ngoài mã nguồn và kiểm thử bảo mật.

## Mở rộng sau 1.0

Các hướng phù hợp với kiến trúc hiện tại:

- Mô hình dự án tùy chỉnh thay vì bốn nhóm mặc định.
- Tìm kiếm toàn văn và nhắc việc cục bộ.
- Xuất/nhập workspace có mã hóa.
- Đồng bộ tùy chọn qua adapter riêng, tắt mặc định.
- Cơ chế migration theo `schemaVersion` khi mô hình JSON thay đổi.
