# Kiểm kê dữ liệu hard-code và kế hoạch nối API cho Flutter

Ngày kiểm kê: 2026-08-10  
Phạm vi: `lib/` của ứng dụng NutriMom sau phục hồi.  
Mục tiêu: mọi dữ liệu nghiệp vụ hiển thị trên app phải đến từ API hoặc cấu hình có phiên bản; FE chỉ giữ design token, enum trình bày và dữ liệu tạm của form.

## 1. Quy ước xử lý

| Loại dữ liệu | Nơi nên lưu | Ví dụ |
|---|---|---|
| Design token | Flutter | màu, radius, spacing trong `app_theme.dart` |
| Enum ổn định | FE + BE cùng mã | `MOM`, `PARTNER`, `MEDICAL_RECORD`, `ARTICLE` |
| Nội dung y tế | Backend CMS có duyệt | cảnh báo, hướng dẫn thai kỳ, bài viết |
| Dữ liệu cá nhân | SQL Server | hồ sơ, thai kỳ, chỉ số sức khỏe, lịch khám |
| Trạng thái đăng nhập | Secure storage + API | access/refresh token, user hiện tại |
| Dữ liệu thời gian thực | API/WebSocket | chat, trạng thái tư vấn, thông báo |
| Demo được chấp nhận | Chỉ ở build `demo/local` | OTP debug và camera mock |

Không đưa màu Flutter (`Color`, `IconData`) vào JSON nghiệp vụ. Backend trả mã như `WARNING`, `ULTRASOUND`; FE ánh xạ sang icon/màu.

## 2. Tổng quan theo mức ưu tiên

### P0 – bắt buộc trước khi phát hành

- Tài khoản, OTP, token, hồ sơ người dùng và thai kỳ.
- Dashboard và hồ sơ chăm sóc thai kỳ.
- Hồ sơ y tế, tệp đính kèm, chỉ số sức khỏe và cảnh báo.
- Lịch, nhắc nhở, bài viết đã kiểm chứng, bác sĩ/chuyên gia và phiên tư vấn.
- Quyền chia sẻ cho thành viên gia đình.
- Xóa toàn bộ dữ liệu mẫu có thể bị hiểu là kết luận y khoa thật.

### P1 – sau luồng cốt lõi

- Kế hoạch dinh dưỡng cá nhân hóa, bookmark, tìm kiếm.
- AI scan với upload, job xử lý, kết quả và disclaimer.
- Subscription, quota scan, giỏ hàng nếu vẫn giữ module thương mại.
- Notification preference, đồng bộ thiết bị sức khỏe.

### Không triển khai API

- Uống nước, đếm cử động thai bằng nút bấm, bộ đếm cơn co và “daily goals” mẫu đã được xóa khỏi điều hướng, widget dùng chung và `AppState`; không thiết kế bảng hay API cho chúng.
- `camera_mock_screen.dart` vẫn giữ vì camera/AI scan là luồng cốt lõi; chỉ adapter chụp/upload đang là mock.
- OTP cố định trong UI cũ là demo. Backend mới đã có OTP 6 số động; FE phải chuyển sang contract thật.

## 3. Ma trận hard-code → API

| Khu vực / file | Dữ liệu đang nằm ở FE | API đích | Ghi chú chuyển đổi |
|---|---|---|---|
| `core/services/app_state.dart` | tên, email, vai trò, tuần thai, ngày dự sinh, premium | `GET/PATCH /users/me`, `GET/PATCH /pregnancies/current`, `GET /subscriptions/me` | Tách `UserStore`, `PregnancyStore`, `EntitlementStore` |
| `welcome_screen.dart` | nội dung giới thiệu | `GET /app-config/onboarding` hoặc asset có version | Có thể cache dài hạn |
| `role_selection_screen.dart` | danh sách role và mô tả | `GET /reference-data/roles` | FE vẫn ánh xạ icon |
| `otp_screen.dart` | mã `1234` | `/auth/otp/request`, `/auth/otp/verify` | Giữ `debug_code` chỉ local |
| `complete_info_screen.dart` | avatar preset | `GET /reference-data/avatar-presets`; `PATCH /users/me` | Hoặc giữ preset là asset FE, BE chỉ lưu `avatar_key` |
| `pregnancy_info_screen.dart` | thông tin form cục bộ | `POST /pregnancies`, `PATCH /pregnancies/{id}` | Server tự tính tuần thai từ mốc đáng tin cậy |
| `home_dashboard_screen.dart` | card, checklist, lời khuyên | `GET /dashboard/mom` | Một aggregate endpoint giảm số request |
| `partner_dashboard_screen.dart` | việc hỗ trợ và cảnh báo | `GET /dashboard/partner`, `/family/tasks` | Kiểm tra quyền chia sẻ |
| `pregnancy_data.dart` | mô tả kích thước/cân nặng theo tuần | `GET /pregnancy-content/weeks/{week}` | Nội dung có nguồn, người duyệt, ngày duyệt |
| `prenatal_care_hub_screen.dart` | mốc khám, hướng dẫn WHO/NHS/ACOG | `/care-plan`, `/verified-guidance` | Link nguồn và phiên bản bắt buộc |
| `prenatal_care_state.dart` | record, câu hỏi, checklist, birth plan | `/medical-records`, `/appointment-questions`, `/birth-plans`, `/preparation-items` | Không giữ lâu dài trong singleton |
| `health_metrics_screen.dart` | cân nặng, HA, nhịp tim, đường huyết, biểu đồ | `/health-measurements`, `/health-summary` | Giá trị có unit, thời điểm, nguồn đo |
| `nutrition_plan_screen.dart` | menu theo chế độ ăn/tiểu đường | `/nutrition-plans`, `/nutrition-plans/{id}/meals` | Kế hoạch phải có trạng thái duyệt |
| `calendar_reminder_screen.dart` | lịch khám/thuốc/lớp học mẫu | `/calendar/events`, `/reminders` | Backend lưu timezone và recurrence |
| `knowledge_screen.dart` | category, article, lượt đọc, nội dung | `/article-categories`, `/articles`, `/bookmarks` | CMS và quy trình kiểm duyệt |
| `consultation_screen.dart` | danh sách bác sĩ, lịch, chat mẫu | `/experts`, `/expert-availability`, `/consultations`, `/conversations` | Chat dùng REST + WebSocket |
| `ai_hub_screen.dart` | quota và hành động scan | `/scan-quota`, `/scan-jobs` | Camera mock tạo file rồi upload |
| `food_scan_result_screen.dart` | món ăn, dinh dưỡng, cảnh báo | `/scan-jobs/{id}/result` | Kết quả AI không thay tư vấn y tế |
| `medical_scan_result_screen.dart` | OCR/chỉ số/diễn giải | `/scan-jobs/{id}/result` | Lưu confidence + vùng OCR |
| `family_screen.dart` | member, invitation, quyền | `/family-groups`, `/family-members`, `/family-invitations` | Người dùng kiểm soát từng scope |
| `invite_family_screen.dart` | mã/link mời | `/family-invitations` | Token một lần, hết hạn |
| `profile_screen.dart` | hồ sơ và menu thống kê | `/users/me`, `/pregnancies/current`, `/subscriptions/me` | Không trả dữ liệu thừa |
| `settings_screen.dart` | theme, unit, backup, device sync | `/users/me/preferences`, `/device-connections` | Theme có thể lưu local + sync |
| `premium_upgrade_flow.dart` | gói, giá, quyền lợi | `/subscription-plans`, `/checkout-sessions` | Giá do server trả, không tin FE |
| `store_screen.dart`, `cart_screen.dart` | category, product, giá, tồn kho | `/products`, `/carts/current`, `/orders` | Nếu loại store thì xóa cả module |
| `chatbox_widget.dart` | hội thoại chatbot mẫu | `/assistant/conversations`, `/assistant/messages` | Có safety policy và escalation |
| `risk_alert_banner.dart` | cảnh báo mẫu | `/health-alerts` | Không suy luận nguy cơ chỉ ở FE |
| `activity_feed_widget.dart` | hoạt động mẫu | `/activity-feed` | Có cursor pagination |

## 4. Dữ liệu màn hình cần lấy từ backend

### 4.1 Dashboard mẹ bầu

Response tối thiểu:

- `user`: `id`, `display_name`, `avatar_url`.
- `pregnancy`: `id`, `gestational_week`, `gestational_day`, `trimester`, `estimated_due_date`, `baby_summary`.
- `next_appointment`: `id`, `title`, `starts_at`, `facility`, `countdown_days`.
- `health_snapshot`: giá trị mới nhất của cân nặng, huyết áp, nhịp tim, đường huyết kèm `measured_at` và `status`.
- `care_progress`: số hồ sơ, mục chuẩn bị hoàn thành, câu hỏi chưa trao đổi.
- `recommended_articles`: `id`, `title`, `thumbnail_url`, `category`, `reviewed_at`, `medical_reviewer`.
- `alerts`: cảnh báo đang hiệu lực với `severity`, `action`, `source`.
- `unread_notification_count` và entitlement/quota liên quan.

### 4.2 Hồ sơ y tế

Mỗi record phải có:

- ID bất biến, `category`, `title`, `occurred_at`, `facility_name`.
- Bác sĩ/chuyên khoa (nếu có), tóm tắt, kết luận nguyên văn, ghi chú người dùng.
- Tệp: `file_id`, `file_name`, MIME, dung lượng, checksum, URL tải có thời hạn.
- `created_by`, `created_at`, `updated_at`, `version` để optimistic locking.
- Quyền chia sẻ và audit ai đã xem/tải.

### 4.3 Nội dung đã kiểm chứng

Không chỉ trả text. Bắt buộc có:

- `source_name`, `source_url`, `evidence_level`.
- `medical_reviewer_id/name`, `reviewed_at`, `next_review_at`.
- `content_version`, `published_at`, `locale`.
- Đối tượng áp dụng, tuần thai min/max, chống chỉ định/tag cảnh báo.
- Disclaimer và số liên hệ khẩn cấp theo khu vực nếu được cấu hình.

### 4.4 Chỉ số sức khỏe

- Dùng giá trị số và unit chuẩn: kg, cm, mmHg, bpm, mmol/L hoặc mg/dL.
- `measured_at` khác `created_at`.
- `source`: `MANUAL`, `DEVICE`, `CLINIC`, `DOCUMENT_SCAN`.
- `status`: `NORMAL`, `ATTENTION`, `URGENT`, `UNKNOWN`; server trả cả `rule_version` và lời giải thích.
- Không tự đổi ngưỡng nguy cơ trong Flutter.

## 5. Trạng thái và cache ở FE

- Access token chỉ ở memory; refresh token trong secure storage.
- Repository gọi API và chuyển DTO → domain model có kiểu rõ ràng, không dùng `Map<String, dynamic>` cho nghiệp vụ.
- Cache SQLite/Isar chỉ lưu dữ liệu cần offline; record y tế nhạy cảm phải mã hóa.
- Mọi mutation dùng trạng thái `idle/loading/success/error` và chống bấm lặp.
- Dùng `ETag`/`version` cho hồ sơ có thể sửa từ nhiều thiết bị.
- Khi logout phải xóa token, cache cá nhân, file tạm và subscription WebSocket.

## 6. Quy tắc demo OTP và camera

### OTP

- Local/dev: hiển thị `debug_code` nếu backend trả và build flag cho phép.
- Staging/prod: backend không bao giờ trả `debug_code`; UI chỉ nhận countdown.
- Không hard-code `1234`; không log mã OTP.

### Camera/AI scan

- `camera_mock_screen.dart` là adapter giao diện demo, không phải tính năng cần xóa.
- Khi tích hợp thật: xin quyền camera → chụp/crop → upload presigned URL → tạo scan job → poll/WebSocket → hiển thị kết quả.
- FE luôn hiển thị confidence, disclaimer và nút “Trao đổi chuyên gia” khi kết quả không chắc chắn.

## 7. Definition of Done chống hard-code

- Không còn tên người dùng, tuần thai, ngày dự sinh, bác sĩ, bài viết, sản phẩm, giá, lịch hoặc chỉ số sức khỏe cố định trong widget.
- Không còn `List<Map<String, dynamic>>` làm nguồn dữ liệu nghiệp vụ.
- Mỗi màn hình có loading, empty, offline, permission denied và API error state.
- Contract test xác nhận JSON FE parse được từ OpenAPI.
- Build production không chứa OTP debug, dữ liệu mẫu hay endpoint localhost.
- Nội dung y tế hiển thị nguồn, người duyệt và ngày duyệt.
- Toàn bộ mutation có idempotency hoặc cơ chế chống gửi trùng.
