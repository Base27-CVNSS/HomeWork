# Đóng góp cho HomeWork

Cảm ơn bạn muốn cải thiện HomeWork. Hãy giữ thay đổi nhỏ, có mục tiêu rõ ràng và không đưa dữ liệu riêng tư vào commit.

## Quy trình

1. Tạo nhánh từ `main`.
2. Cập nhật hoặc bổ sung kiểm thử cho hành vi thay đổi.
3. Chạy:

   ```powershell
   dart format lib test
   flutter analyze
   flutter test
   ```

4. Mở pull request, mô tả vấn đề, giải pháp và ảnh giao diện nếu có.

## Tiêu chuẩn mã nguồn

- Ưu tiên Flutter SDK trước khi thêm dependency mới.
- Không commit thư mục platform sinh tự động, `build/` hoặc dữ liệu workspace.
- Không hard-code secret, token hay URL nội bộ.
- Không sao chép mã/tài nguyên dịch ngược từ ứng dụng khác.
- Giữ giao diện sử dụng được ở cửa sổ rộng từ 720 px.

## Báo lỗi

Issue nên có phiên bản Windows, phiên bản HomeWork, các bước tái hiện và kết quả mong đợi. Với lỗ hổng bảo mật, làm theo [SECURITY.md](SECURITY.md), không mở issue công khai.
