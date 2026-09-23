# NutriMom Backend API Specification v1

Tài liệu contract end-to-end cho Flutter và Java Spring Boot.  
Base URL local: `http://localhost:8080/api/v1`  
Trạng thái: nhóm `/auth` đã có trong `EXE_BE`; các nhóm còn lại là contract cần triển khai.

## 1. Chuẩn chung

### 1.1 Giao thức

- HTTPS ở staging/production; JSON UTF-8; field dùng `snake_case`.
- Thời gian dùng ISO-8601 UTC (`2026-08-10T12:30:00Z`); ngày thuần dùng `yyyy-MM-dd`.
- ID public dùng UUID; không lộ khóa tăng dần.
- Client gửi `X-Request-Id` (UUID), `X-Device-Id`, `Accept-Language: vi-VN`.
- Mutation có nguy cơ gửi lặp nhận `Idempotency-Key`.
- Access token: `Authorization: Bearer <JWT>`.

### 1.2 Envelope

Thành công:

```json
{
  "data": {},
  "meta": {
    "request_id": "d2d39392-d39b-4e31-a241-782a087e8f18",
    "server_time": "2026-08-10T12:30:00Z"
  }
}
```

Lỗi:

```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Dữ liệu không hợp lệ.",
    "fields": {"display_name": "Không được để trống"},
    "retryable": false,
    "request_id": "d2d39392-d39b-4e31-a241-782a087e8f18"
  }
}
```

Phân trang cursor:

```json
{
  "data": {"items": []},
  "meta": {"next_cursor": "opaque", "has_more": false}
}
```

HTTP: `200` đọc/sửa, `201` tạo, `202` job async, `204` xóa; `400` validation, `401` chưa xác thực, `403` thiếu quyền, `404`, `409`, `422`, `429`, `500`.

### 1.3 Enum cốt lõi

- `UserRole`: `MOM`, `PARTNER`, `FAMILY_MEMBER`, `EXPERT`, `CONTENT_EDITOR`, `ADMIN`.
- `PregnancyStatus`: `ACTIVE`, `COMPLETED`, `LOSS_REPORTED`, `ARCHIVED`.
- `RecordCategory`: `PRENATAL_VISIT`, `ULTRASOUND`, `LAB_RESULT`, `PRESCRIPTION`, `DISCHARGE`, `OTHER`.
- `MeasurementType`: `WEIGHT`, `BLOOD_PRESSURE`, `HEART_RATE`, `BLOOD_GLUCOSE`.
- `Severity`: `INFO`, `ATTENTION`, `URGENT`, `CRITICAL`.
- `ConsultationStatus`: `REQUESTED`, `CONFIRMED`, `IN_PROGRESS`, `COMPLETED`, `CANCELLED`.
- `ScanType`: `FOOD`, `MEDICAL_DOCUMENT`.
- `ScanStatus`: `CREATED`, `UPLOADING`, `QUEUED`, `PROCESSING`, `SUCCEEDED`, `FAILED`, `EXPIRED`.

## 2. Authentication và session – đã triển khai

### POST `/auth/otp/request`

```json
{
  "phone": "0905551234",
  "purpose": "REGISTER",
  "accepted_terms": true,
  "device_id": "stable-installation-id"
}
```

`purpose`: `REGISTER` hoặc `LOGIN`. Response:

```json
{
  "data": {
    "challenge_id": "5e23b166-0f0f-4164-b3fd-df4225c348ea",
    "masked_phone": "+84******234",
    "delivery_channel": "DEBUG",
    "expires_in": 300,
    "resend_after": 45,
    "debug_code": "629104"
  },
  "meta": {}
}
```

`debug_code` chỉ có local. Lỗi: `ACCOUNT_NOT_FOUND`, `PHONE_ALREADY_EXISTS`, `TERMS_NOT_ACCEPTED`, `OTP_RESEND_TOO_SOON`, `OTP_REQUEST_IN_PROGRESS`.

### POST `/auth/otp/verify`

```json
{
  "challenge_id": "5e23b166-0f0f-4164-b3fd-df4225c348ea",
  "code": "629104",
  "device_id": "stable-installation-id",
  "display_name": "Nguyễn An"
}
```

```json
{
  "data": {
    "new_user": true,
    "authentication": {
      "access_token": "eyJ...",
      "expires_in": 900,
      "refresh_token": "opaque-token",
      "refresh_expires_in": 2592000,
      "token_type": "Bearer",
      "user": {
        "id": "uuid",
        "phone": "+84905551234",
        "display_name": "Nguyễn An",
        "roles": ["MOM"],
        "onboarding_status": "PROFILE_REQUIRED"
      }
    }
  }
}
```

OTP 6 số, hết hạn 5 phút, cooldown 45 giây, tối đa 5 lần thử, dùng một lần và khóa theo thiết bị.

### POST `/auth/register`

Đăng ký bằng mật khẩu cho kịch bản quản trị/test:

```json
{
  "phone": "0901234567",
  "password": "NutriMom@123",
  "display_name": "Nguyễn An",
  "accepted_terms": true,
  "device_id": "device-id"
}
```

### POST `/auth/login`

```json
{"phone":"0901234567","password":"NutriMom@123","device_id":"device-id"}
```

### POST `/auth/refresh`

```json
{"refresh_token":"opaque-token","device_id":"device-id"}
```

Refresh token được rotate. Tái sử dụng token cũ trả `401 INVALID_REFRESH_TOKEN` và có thể thu hồi token family.

### POST `/auth/logout`

```json
{"refresh_token":"opaque-token"}
```

Idempotent, response `{"data":{"logged_out":true}}`.

### GET `/auth/me`

Trả identity tối thiểu của token hiện tại. Dữ liệu hồ sơ đầy đủ lấy từ `/users/me`.

## 3. Onboarding, user và preferences

### GET `/reference-data/roles`

Trả role có thể chọn, `code`, `display_name`, `description`, `allowed_relationships`, `sort_order`.

### GET `/users/me`

```json
{
  "data": {
    "id": "uuid",
    "phone": "+84901234567",
    "email": "an@example.com",
    "display_name": "Nguyễn An",
    "role": "MOM",
    "avatar_key": "preset_2",
    "avatar_url": null,
    "date_of_birth": "1997-04-18",
    "onboarding_status": "COMPLETED",
    "created_at": "2026-08-10T10:00:00Z",
    "version": 3
  }
}
```

### PATCH `/users/me`

```json
{
  "display_name": "Nguyễn Minh An",
  "email": "an@example.com",
  "date_of_birth": "1997-04-18",
  "avatar_key": "preset_2",
  "version": 3
}
```

Trả `409 VERSION_CONFLICT` nếu hồ sơ đã bị sửa trên thiết bị khác.

### GET/PATCH `/users/me/preferences`

```json
{
  "locale": "vi-VN",
  "timezone": "Asia/Ho_Chi_Minh",
  "theme": "SYSTEM",
  "weight_unit": "KG",
  "length_unit": "CM",
  "glucose_unit": "MMOL_L",
  "backup_enabled": true,
  "push_enabled": true,
  "email_enabled": false,
  "quiet_hours": {"enabled": true, "from": "22:00", "to": "06:30"}
}
```

### DELETE `/users/me`

Yêu cầu re-auth, body `{"reason":"..."}`. Trả `202` với `deletion_request_id`, `scheduled_for`; có endpoint hủy trong thời gian grace nếu chính sách cho phép.

## 4. Pregnancy profile và nội dung theo tuần

### POST `/pregnancies`

```json
{
  "estimated_due_date": "2027-01-20",
  "last_menstrual_period": "2026-04-15",
  "is_first_pregnancy": true,
  "multiple_pregnancy": false,
  "care_facility_name": "Bệnh viện Phụ sản",
  "timezone": "Asia/Ho_Chi_Minh"
}
```

Ít nhất một trong `estimated_due_date`/`last_menstrual_period`; BE tính tuổi thai và lưu nguồn tính.

### GET `/pregnancies/current`

Trả `id`, `status`, mốc đầu vào, `gestational_week`, `gestational_day`, `trimester`, `estimated_due_date`, `days_until_due`, `calculation_source`, `version`.

### PATCH `/pregnancies/{pregnancy_id}`

Cho phép cập nhật mốc theo xác nhận y tế, cơ sở chăm sóc và trạng thái. Mọi thay đổi ngày dự sinh phải có audit.

### GET `/pregnancy-content/weeks/{week}`

```json
{
  "data": {
    "week": 24,
    "baby": {"length_cm_range":[28.0,31.0],"weight_g_range":[550,750],"comparison_label":"..."},
    "development_summary": "...",
    "maternal_changes": ["..."],
    "care_topics": ["..."],
    "warning_signs": ["..."],
    "sources": [{"name":"WHO","url":"https://..."}],
    "reviewed_by": "BS. ...",
    "reviewed_at": "2026-07-01T00:00:00Z",
    "content_version": 4
  }
}
```

## 5. Dashboard aggregate

### GET `/dashboard/mom`

Query `pregnancy_id` tùy chọn. Trả một payload gồm:

- `profile_summary`, `pregnancy_summary`, `baby_summary`.
- `next_appointment`, `health_snapshot`, `care_progress`.
- `active_alerts`, `recommended_articles`, `upcoming_reminders`.
- `scan_quota`, `subscription`, `unread_notification_count`.

Mỗi block có thể `null`; không trả lỗi toàn endpoint nếu một dịch vụ phụ tạm lỗi. `meta.partial_failures` liệt kê block lỗi.

### GET `/dashboard/partner`

Yêu cầu thành viên đã được cấp quyền. Trả dữ liệu tối thiểu theo scope: thai kỳ tổng quan, việc được giao, lịch được chia sẻ, cảnh báo mà mẹ cho phép và activity feed.

## 6. Prenatal care plan

### GET `/care-plans/current`

```json
{
  "data": {
    "pregnancy_id": "uuid",
    "milestones": [{
      "id": "uuid",
      "week": 28,
      "title": "Khám thai theo hẹn",
      "description": "...",
      "status": "UPCOMING",
      "source_name": "WHO",
      "source_url": "https://..."
    }],
    "progress": {"completed": 2,"total": 8}
  }
}
```

### GET `/verified-guidance`

Query: `week`, `topic`, `locale`, `cursor`, `limit`. Mỗi mục gồm nguồn, reviewer, reviewed/next_review date, evidence level, disclaimer.

### GET `/preparation-items`

Trả checklist theo nhóm. Item có `id`, `group_code`, `title`, `completed`, `completed_at`, `sort_order`.

### PATCH `/preparation-items/{id}`

```json
{"completed":true,"version":1}
```

### GET/PUT `/birth-plans/current`

```json
{
  "companion": "Chồng",
  "preferred_facility": "...",
  "pain_management_note": "...",
  "newborn_care_note": "Da kề da nếu phù hợp",
  "free_text_note": "...",
  "version": 2
}
```

## 7. Medical records và file

### GET `/medical-records`

Query: `pregnancy_id`, `category`, `from`, `to`, `cursor`, `limit`. Item gồm `id`, `category`, `title`, `occurred_at`, `facility_name`, `clinician_name`, `summary`, `attachment_count`, `version`.

### POST `/medical-records`

```json
{
  "pregnancy_id": "uuid",
  "category": "ULTRASOUND",
  "title": "Siêu âm tuần 24",
  "occurred_at": "2026-08-10T02:00:00Z",
  "facility_name": "Bệnh viện ...",
  "clinician_name": "BS. ...",
  "summary": "...",
  "note": "...",
  "attachment_ids": ["uuid"]
}
```

### GET/PATCH/DELETE `/medical-records/{id}`

- GET trả đầy đủ file và quyền chia sẻ.
- PATCH gửi field thay đổi + `version`.
- DELETE là soft delete, ghi audit; trả `204`.

### POST `/files/upload-sessions`

```json
{"purpose":"MEDICAL_RECORD","file_name":"sieu-am.pdf","mime_type":"application/pdf","size_bytes":245112,"sha256":"hex"}
```

Response `file_id`, `upload_url`, `headers`, `expires_at`. Client upload trực tiếp object storage rồi gọi:

### POST `/files/{file_id}/complete`

Server kiểm tra checksum/MIME, quét malware, chuyển trạng thái `READY`. Download dùng `GET /files/{id}/download-url`, URL ngắn hạn. Không public bucket.

## 8. Appointment questions

### GET/POST `/appointment-questions`

POST:

```json
{"pregnancy_id":"uuid","appointment_id":null,"text":"Tình trạng phù chân này có cần khám sớm không?"}
```

### PATCH `/appointment-questions/{id}`

`{"discussed":true,"discussed_at":"2026-08-12T03:00:00Z","version":1}`.

### DELETE `/appointment-questions/{id}`

Chỉ owner hoặc người có quyền được xóa.

## 9. Health measurements và alerts

### POST `/health-measurements`

```json
{
  "pregnancy_id": "uuid",
  "type": "BLOOD_PRESSURE",
  "measured_at": "2026-08-10T01:00:00Z",
  "source": "MANUAL",
  "values": {"systolic":120,"diastolic":80},
  "unit": "MMHG",
  "note": "Đo sau khi nghỉ 5 phút"
}
```

Các loại khác dùng `values.value`. Backend validate phạm vi vật lý, không tự chẩn đoán chỉ từ một phép đo.

### GET `/health-measurements`

Query: `type`, `from`, `to`, `cursor`, `limit`. Trả `status`, `rule_version`, `created_at`.

### GET `/health-summary`

Query `range=7D|30D|TRIMESTER`. Trả latest, series `{measured_at,value...}`, trend và unit đã chuẩn hóa.

### GET `/health-alerts`

Query `status=ACTIVE`. Alert gồm `severity`, `title`, `message`, `recommended_action`, `measurement_ids`, `source`, `created_at`, `acknowledged_at`.

### POST `/health-alerts/{id}/acknowledge`

Ghi nhận đã đọc, không đồng nghĩa đã xử trí y tế.

## 10. Calendar và reminders

### GET/POST `/calendar/events`

```json
{
  "type": "PRENATAL_APPOINTMENT",
  "title": "Khám thai định kỳ",
  "starts_at": "2026-08-25T02:00:00Z",
  "ends_at": "2026-08-25T03:00:00Z",
  "timezone": "Asia/Ho_Chi_Minh",
  "location": "Bệnh viện ...",
  "note": "Mang sổ khám",
  "recurrence_rule": null,
  "reminders": [{"minutes_before":1440},{"minutes_before":120}]
}
```

### GET/PATCH/DELETE `/calendar/events/{id}`

PATCH dùng `version`; recurring event hỗ trợ scope `THIS|THIS_AND_FUTURE|ALL`.

### GET `/calendar/month`

Query `year`, `month`, `timezone`; response gọn để vẽ calendar (`date`, `event_count`, `types`).

## 11. Nutrition

### POST `/nutrition-plans`

```json
{
  "pregnancy_id":"uuid",
  "goal":"BALANCED_PREGNANCY",
  "dietary_pattern":"OMNIVORE",
  "allergies":["PEANUT"],
  "conditions":["GESTATIONAL_DIABETES"],
  "excluded_foods":[],
  "target_energy_kcal":null
}
```

Trả `202` nếu sinh plan async. Plan có `status: DRAFT|REVIEW_REQUIRED|ACTIVE|ARCHIVED`, `generated_by`, `reviewed_by`, disclaimer.

### GET `/nutrition-plans/current`

Trả ngày/tuần, meal gồm `id`, `meal_type`, `scheduled_time`, `foods`, `energy_kcal`, macro, allergens và nguồn khuyến nghị.

### POST/PATCH/DELETE `/nutrition-plans/{plan_id}/meals[/{meal_id}]`

Chỉ plan draft hoặc quyền chuyên gia. Mọi thay đổi lưu revision.

### GET `/food-safety/search?q=`

Trả match, pregnancy-specific warning, severity, reason, safe alternative, sources, reviewed info. Không dùng danh sách cảnh báo hard-code trong `AppState`.

## 12. Knowledge/blog CMS

### GET `/article-categories`

`id`, `slug`, `name`, `icon_code`, `sort_order`, `article_count`.

### GET `/articles`

Query: `category`, `week`, `tag`, `q`, `sort`, `cursor`, `limit`. List item: title, excerpt, thumbnail, reading time, reviewer, reviewed date, bookmark state.

### GET `/articles/{id-or-slug}`

Trả body dạng sanitized HTML/blocks, citations, author, reviewer, evidence level, published/updated/review dates, applicable weeks, disclaimer và related articles.

### POST/DELETE `/articles/{id}/bookmark`

Idempotent. `GET /bookmarks/articles` để đồng bộ bookmark đa thiết bị.

### Admin CMS

- `POST /admin/articles`, `PATCH /admin/articles/{id}`.
- `POST /admin/articles/{id}/submit-review`.
- `POST /admin/articles/{id}/approve` (medical reviewer).
- `POST /admin/articles/{id}/publish`.
- Không cho cùng người vừa viết vừa tự duyệt nếu chính sách yêu cầu tách vai trò.

## 13. Experts, availability và consultation

### GET `/experts`

Filter `specialty`, `language`, `available_from`, `cursor`. Trả tên, avatar, specialty, verified license status, experience, languages, rating aggregate, next available slot; không lộ dữ liệu giấy phép nhạy cảm.

### GET `/experts/{id}` và `/experts/{id}/availability`

Availability query `from`, `to`, `timezone`; slot có `slot_id`, starts/ends, price, currency, channel.

### POST `/consultations`

```json
{
  "expert_id":"uuid",
  "slot_id":"uuid",
  "pregnancy_id":"uuid",
  "channel":"CHAT",
  "topic":"Phù chân ở tuần 24",
  "question":"...",
  "shared_record_ids":["uuid"]
}
```

Giữ slot bằng transaction; `409 SLOT_UNAVAILABLE` khi đã đặt. Response có `consultation_id`, status và payment requirement.

### GET/PATCH `/consultations/{id}`

PATCH chỉ cho phép cancel/reschedule theo state machine. Hoàn tất có expert summary, recommendation và follow-up; luôn phân biệt tư vấn với cấp cứu.

## 14. Chat và assistant

### GET/POST `/conversations`

Conversation type `EXPERT` hoặc `AI_ASSISTANT`, participants, consultation id, last message, unread count.

### GET `/conversations/{id}/messages`

Cursor pagination. Message có `id`, `sender`, `type`, `text`, `attachment`, `sent_at`, `delivered_at`, `read_at`, `safety_labels`.

### POST `/conversations/{id}/messages`

```json
{"client_message_id":"uuid","type":"TEXT","text":"..."}
```

`client_message_id` unique để chống gửi trùng. WebSocket `/ws` phát `message.created`, `message.read`, `consultation.status_changed`.

### AI assistant

- `POST /assistant/conversations`, `POST /assistant/conversations/{id}/messages`.
- Response có citations, safety notice, `escalation_recommended`, `emergency_detected`.
- Không trả chẩn đoán chắc chắn, không thay bác sĩ; prompt/output lưu theo chính sách riêng tư và được redaction.

## 15. AI scan – camera vẫn là luồng cốt lõi

### GET `/scan-quota`

```json
{"data":{"plan":"FREE","limit":1,"used":0,"remaining":1,"resets_at":"2026-08-11T00:00:00+07:00"}}
```

### POST `/scan-jobs`

```json
{"type":"FOOD","file_id":"uuid","pregnancy_id":"uuid","client_context":{"locale":"vi-VN"}}
```

Trả `202` với `job_id`, `status`, `estimated_seconds`. Quota chỉ bị trừ một lần theo idempotency key.

### GET `/scan-jobs/{id}`

Trả progress, failure code hoặc result.

Food result:

```json
{
  "detected_items":[{"name":"...","confidence":0.91}],
  "nutrition_estimate":{"energy_kcal":420,"protein_g":20},
  "pregnancy_safety":{"status":"REVIEW","warnings":[],"sources":[]},
  "model":{"name":"...","version":"..."},
  "disclaimer":"Kết quả chỉ mang tính tham khảo."
}
```

Medical document result gồm `document_type`, OCR blocks `{text,bounding_box,confidence}`, extracted fields `{code,label,value,unit,reference_range}`, flags, model/version, disclaimer. Người dùng phải xác nhận trước khi lưu thành medical record.

### POST `/scan-jobs/{id}/confirm`

Body chứa correction và tùy chọn `create_medical_record`. Không tự động ghi OCR chưa xác nhận vào hồ sơ chính thức.

## 16. Family sharing

### GET/POST `/family-groups`

Một pregnancy có group active. Owner là mẹ bầu.

### POST `/family-invitations`

```json
{
  "relationship":"PARTNER",
  "scopes":["PREGNANCY_SUMMARY","SHARED_CALENDAR","FAMILY_TASKS"],
  "expires_in_hours":48
}
```

Trả one-time token/deep link. Không cho scope medical record mặc định.

### POST `/family-invitations/accept`

`{"token":"opaque"}`; kiểm tra tài khoản, expiry, one-time use.

### GET/PATCH/DELETE `/family-members[/{member_id}]`

PATCH thay scopes; DELETE thu hồi ngay token/session subscription liên quan và ghi audit.

### `/family/tasks`

- GET list theo assignee/status.
- POST tạo `{title,description,priority,due_at,assignee_id}`.
- PATCH complete/reassign với version.
- DELETE soft delete.

## 17. Subscription, catalog và commerce

### GET `/subscription-plans` và `/subscriptions/me`

Plan trả server-side price, currency, interval, entitlements, scan quota. Không lấy giá từ Flutter.

### POST `/checkout-sessions`

`{"plan_id":"uuid","provider":"...","return_url":"..."}`. Trạng thái cuối lấy từ signed webhook, không tin callback client.

### Product/store (chỉ triển khai nếu giữ module)

- `GET /product-categories`, `GET /products`, `GET /products/{id}`.
- `GET /carts/current`, `POST /carts/current/items`, `PATCH/DELETE /carts/current/items/{id}`.
- `POST /orders`, `GET /orders/{id}`.
- Server kiểm tra giá/tồn kho, dùng snapshot price và idempotency.

## 18. Notifications và activity feed

### POST `/devices`

Đăng ký push token `{platform,push_token,device_id,app_version}`; upsert, token được mã hóa.

### GET `/notifications`

Cursor list; fields `type`, `title`, `body`, `deep_link`, `read_at`, `created_at`.

### POST `/notifications/{id}/read`, `/notifications/read-all`

Idempotent.

### GET `/activity-feed`

Trả hoạt động mà caller có quyền xem; không làm rò dữ liệu medical qua message preview.

## 19. Search, config và observability

- `GET /search?q=&types=ARTICLE,EXPERT&cursor=`.
- `GET /app-config`: minimum app version, maintenance, support contacts, emergency disclaimer, feature flags không nhạy cảm.
- `GET /reference-data`: enums cần hiển thị.
- Actuator chỉ expose health/readiness có bảo vệ; metrics Prometheus ở network nội bộ.
- Audit event bắt buộc cho login, xem/tải hồ sơ, thay quyền chia sẻ, sửa nội dung y tế, admin action.

## 20. Error code bắt buộc

`VALIDATION_ERROR`, `UNAUTHORIZED`, `FORBIDDEN`, `RESOURCE_NOT_FOUND`, `VERSION_CONFLICT`, `IDEMPOTENCY_CONFLICT`, `RATE_LIMITED`, `OTP_EXPIRED`, `INVALID_OTP`, `OTP_ATTEMPTS_EXCEEDED`, `OTP_CHALLENGE_USED`, `OTP_DEVICE_MISMATCH`, `INVALID_REFRESH_TOKEN`, `FILE_TOO_LARGE`, `UNSUPPORTED_FILE_TYPE`, `MALWARE_DETECTED`, `UPLOAD_NOT_COMPLETE`, `SLOT_UNAVAILABLE`, `QUOTA_EXCEEDED`, `SCAN_FAILED`, `SHARING_SCOPE_REQUIRED`, `CONTENT_NOT_REVIEWED`.

## 21. Security và retention

- Password Argon2id hoặc BCrypt strength phù hợp; OTP/token chỉ lưu hash.
- Refresh token rotate/revoke; access JWT 15 phút.
- SQL Server Transparent Data Encryption ở hạ tầng nếu có; cột nhạy cảm mã hóa ứng dụng/KMS khi cần.
- Object storage private, presigned URL ngắn hạn, antivirus và checksum.
- Row-level authorization ở service; không chỉ ẩn nút FE.
- Rate limit OTP/login/scan/chat/upload; CAPTCHA/risk engine khi abuse.
- Backup, restore drill, retention và xóa dữ liệu theo consent/pháp luật áp dụng.
- Không log token, OTP, password, nội dung hồ sơ, file URL có chữ ký.

## 22. Contract test tối thiểu

- Happy path và mọi lỗi auth/OTP/refresh rotation.
- IDOR: user A không đọc/sửa record, file, pregnancy, consultation của user B.
- Family scope thay đổi có hiệu lực ngay.
- Optimistic locking cho profile, record, reminder, plan.
- Idempotency cho booking, order, scan, upload complete.
- Cursor ổn định khi có insert mới.
- Upload sai MIME/checksum/quá cỡ/malware.
- Webhook sai chữ ký/replay.
- Nội dung chưa duyệt không xuất hiện trên API public.
- JSON schema/OpenAPI được Flutter contract test parse thành công.
