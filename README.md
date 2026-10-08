# NutriMom

Ứng dụng Flutter hỗ trợ theo dõi hành trình thai kỳ, ghi nhật ký hằng ngày, lên thực đơn tham khảo, quản lý lịch khám, hồ sơ sức khỏe và đọc nội dung kiến thức.

## Chạy dự án

Yêu cầu Flutter SDK tương thích với Dart 3.5. Tại thư mục dự án:

```bash
flutter pub get
flutter run
flutter test
```

## Tính năng hiện có

- **Hôm nay:** tuần thai, ngày dự sinh, lịch sắp tới và lối vào các công cụ thường dùng.
- **Thai kỳ:** nhật ký cảm nhận, năng lượng, triệu chứng và ghi chú; lịch sử có thể sửa hoặc xóa. Nhật ký được lưu trong vùng dữ liệu ứng dụng trên điện thoại/máy tính, hoặc local storage của trình duyệt khi chạy web. Dữ liệu này chưa được mã hóa riêng.
- **Ăn uống:** thực đơn mẫu và các bữa ăn do người dùng tự thêm. Gợi ý mẫu không phải chế độ ăn cá nhân hóa.
- **Trợ lý:** nội dung trả lời mẫu theo từ khóa, chưa kết nối mô hình AI hay hồ sơ cá nhân.
- **Mô phỏng quét:** giao diện camera và kết quả dinh dưỡng/xét nghiệm là dữ liệu cố định để xem thử. Kết quả mẫu không được ghi vào hồ sơ sức khỏe.

Các dữ liệu demo khác như tài khoản, lịch, chỉ số, hồ sơ y tế và thực đơn hiện do `AppState` giữ trong bộ nhớ; chúng sẽ mất khi khởi động lại ứng dụng. OTP, gói trả phí và một số luồng gia đình cũng đang là bản mô phỏng. Không dùng các nội dung mẫu để tự chẩn đoán hoặc thay đổi điều trị.
