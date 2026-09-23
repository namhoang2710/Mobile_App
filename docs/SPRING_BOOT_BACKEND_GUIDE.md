# Hướng dẫn triển khai NutriMom bằng Java Spring Boot + SQL Server

Tài liệu này ánh xạ `BACKEND_API_SPEC.md` sang kiến trúc backend. Dự án khung hiện tại: `C:\Users\ADMIN\Desktop\EXE\EXE_BE`.

## 1. Stack đề xuất

- Java 17 LTS, Maven Wrapper.
- Spring Boot 4.1.0, Spring MVC, Validation, Security.
- Spring Data JPA/Hibernate với Microsoft JDBC Driver for SQL Server.
- Flyway migration; không dùng `ddl-auto=update` ngoài thử nghiệm.
- Spring Authorization bằng JWT resource server; access JWT HS256 hiện tại, chuyển RS256/ES256 + KMS khi production nhiều service.
- Redis cho rate limit, OTP cooldown, cache và distributed lock khi triển khai nhiều instance.
- Spring WebSocket/STOMP hoặc raw WebSocket cho chat/event; REST vẫn là nguồn sự thật.
- springdoc-openapi/Swagger UI; Actuator + Micrometer Prometheus.
- Testcontainers SQL Server/Redis cho integration test CI nếu license/runtime cho phép.

## 2. Cấu trúc package theo domain

```text
vn.nutrimom
├─ common/              response, exception, request-id, clock, idempotency
├─ config/              security, openapi, jackson, persistence, websocket
├─ auth/                OTP, password, JWT, refresh session
├─ identity/            user, role, preference, device
├─ pregnancy/           pregnancy profile, weekly content
├─ care/                care plan, preparation, birth plan, questions
├─ medicalrecord/       record, attachment, sharing, audit
├─ health/              measurement, rule evaluation, alert
├─ calendar/            event, recurrence, reminder delivery
├─ nutrition/           plan, meal, food safety
├─ knowledge/           article CMS, review, publish, bookmark
├─ expert/              expert, availability, consultation
├─ messaging/           conversation, message, websocket event
├─ scan/                upload, async job, result, quota
├─ family/              group, invitation, member, scope, task
├─ billing/             plan, entitlement, checkout, webhook
├─ notification/        device, notification, preference
└─ audit/               immutable security/medical access audit
```

Mỗi domain nên có `web`, `application`, `domain`, `infrastructure`. Controller không gọi repository trực tiếp; transaction nằm ở application service.

## 3. Cấu hình profile và secret

`application.yml` chỉ có default không bí mật. Secret qua environment/secret manager:

```yaml
spring:
  datasource:
    url: ${DB_URL:jdbc:sqlserver://localhost:1433;databaseName=NutriMomDB;encrypt=true;trustServerCertificate=true}
    username: ${DB_USERNAME:nutrimom_app}
    password: ${DB_PASSWORD}
  jpa:
    hibernate:
      ddl-auto: validate
    open-in-view: false
  flyway:
    enabled: true
    user: ${DB_MIGRATOR_USERNAME:nutrimom_migrator}
    password: ${DB_MIGRATOR_PASSWORD}
```

- Local có thể `trustServerCertificate=true`; production phải certificate hợp lệ.
- Tách login runtime và migrator.
- Không commit `.env`, JWT secret, SMS key, storage key.
- `server.forward-headers-strategy=framework` sau reverse proxy tin cậy.

## 4. SQL Server baseline

Database đã tạo:

- `NutriMomDB`, collation `Vietnamese_100_CI_AI_SC_UTF8`.
- Schema ứng dụng `app`.
- `READ_COMMITTED_SNAPSHOT ON`, `ALLOW_SNAPSHOT_ISOLATION ON`.
- Query Store bật để theo dõi regression.

Lệnh cần chạy một lần bằng quyền Administrator để bật TCP 1433:

```powershell
Set-Location 'C:\Users\ADMIN\Desktop\EXE\EXE_BE'
powershell -ExecutionPolicy Bypass -File .\scripts\enable-sqlserver-tcp.ps1
```

Sau đó:

```powershell
.\mvnw.cmd spring-boot:run
```

Migration V1 hiện tạo `users`, `roles`, `user_roles`, `otp_challenges`, `refresh_tokens`. Các migration tiếp theo chỉ append (`V2__...sql`), không sửa file đã chạy.

## 5. Kiểu dữ liệu và quy tắc entity

- UUID public: `uniqueidentifier`; tạo ở application.
- Thời gian tuyệt đối: `datetime2(3)` lưu UTC; timezone user là chuỗi IANA.
- Tiền: `decimal(19,4)` + currency ISO-4217.
- Measurement: `decimal(18,6)`, không dùng `float` cho giá trị y tế cần so sánh chính xác.
- Text ngắn: `nvarchar`; nội dung dài `nvarchar(max)` nhưng giới hạn ở validation.
- Trạng thái enum lưu `varchar(40)` để đọc được.
- Mọi aggregate sửa được có `version bigint` (`@Version`).
- Soft delete: `deleted_at`, nhưng unique constraint phải được thiết kế bằng filtered index.
- `created_at`, `updated_at`, `created_by`, `updated_by` do server điền.
- Không serialize JPA entity trực tiếp; dùng request/response DTO.

## 6. Authentication implementation hiện tại

### OTP

- Chuẩn hóa số điện thoại E.164 trước khi lookup.
- Sinh OTP bằng `SecureRandom`, 6 số.
- Chỉ lưu HMAC SHA-256 của OTP; expiry 5 phút, cooldown 45 giây, tối đa 5 lần thử.
- Challenge khóa theo `device_id`, `purpose`, dùng một lần.
- Local response có `debug_code`; profile staging/prod tuyệt đối không có.
- SMS provider nằm sau interface `OtpDeliveryGateway`; retry không tạo mã mới ngoài transaction.

### Token

- Access token 15 phút, claim tối thiểu: `sub`, `roles`, `iat`, `exp`, `jti`.
- Refresh token opaque 30 ngày, chỉ lưu hash, rotate ở mỗi refresh.
- Reuse detection có thể revoke token family và audit.
- Logout idempotent.
- Flutter lưu refresh token bằng secure storage, không SharedPreferences.

### Security filter chain

- Permit `/api/v1/auth/**`, `/v3/api-docs/**`, `/swagger-ui/**`, liveness.
- Các endpoint khác authenticated; admin/expert dùng method security (`@PreAuthorize`).
- JSON authentication error thống nhất envelope, không redirect HTML.
- CORS allowlist theo environment; không dùng `*` với credential.

## 7. Authorization và chia sẻ hồ sơ

RBAC không đủ. Mỗi service cần kiểm tra owner/resource relationship:

```java
authorization.requirePregnancyScope(
    currentUserId,
    pregnancyId,
    SharingScope.MEDICAL_RECORD_READ
);
```

- Owner mẹ bầu có toàn quyền mặc định.
- Family member chỉ thấy scope đã cấp và record cụ thể được share.
- Expert chỉ thấy dữ liệu gắn với consultation và trong thời gian được cấp.
- Admin vận hành không mặc nhiên đọc nội dung y tế.
- Mọi lần xem/tải hồ sơ được audit bất biến.

Tránh query rồi mới kiểm tra ở controller. Repository/service phải ràng buộc `owner_id`/scope để ngăn IDOR.

## 8. API layer

### DTO

Java record + Jakarta Validation:

```java
public record CreateMedicalRecordRequest(
    @NotNull UUID pregnancyId,
    @NotNull RecordCategory category,
    @NotBlank @Size(max = 200) String title,
    @NotNull Instant occurredAt,
    @Size(max = 200) String facilityName,
    @Size(max = 4000) String summary,
    List<UUID> attachmentIds
) {}
```

- Không dùng `Map<String,Object>` cho nghiệp vụ.
- Jackson dùng snake_case toàn cục hoặc `@JsonNaming` nhất quán.
- Enum sai trả validation error, không fallback âm thầm.
- Response mapper không gây N+1; projection/query riêng cho list.

### Error handling

`@RestControllerAdvice` ánh xạ domain exception → code ổn định. Log server có stack trace và request id; response không lộ SQL/class/path.

## 9. Transaction, idempotency và concurrency

- Tạo booking, order, scan quota và refresh rotation dùng transaction.
- `Idempotency-Key` lưu `user_id + endpoint + key + request_hash + response` có TTL.
- Nếu cùng key khác request hash: `409 IDEMPOTENCY_CONFLICT`.
- JPA `@Version` cho update; map `OptimisticLockException` → `409 VERSION_CONFLICT`.
- Booking slot dùng unique constraint/locking, không chỉ kiểm tra `available=true`.
- Event ra ngoài transaction qua outbox table; worker publish rồi đánh dấu.

## 10. File và dữ liệu y tế

- Metadata SQL Server, binary ở object storage private.
- Upload session kiểm tra MIME allowlist, extension, kích thước, checksum.
- Trạng thái: `PENDING_UPLOAD → SCANNING → READY|REJECTED`.
- Antivirus, content sniffing, PDF/image re-encode nếu cần.
- URL upload/download có thời hạn; không lưu presigned URL trong DB.
- Xóa record tạo retention/tombstone theo chính sách, không xóa ngay audit.

## 11. Nội dung y tế và CMS

Entity nên tách:

- `articles`, `article_revisions`, `article_sources`.
- `content_reviews` với reviewer, decision, comment, timestamp.
- `pregnancy_week_contents`, `verified_guidance`.

State machine: `DRAFT → IN_REVIEW → APPROVED → PUBLISHED → ARCHIVED`. Public API chỉ query `PUBLISHED`, `published_at <= now`, review chưa hết hạn. Nội dung sửa tạo revision mới, không ghi đè bản đã phát hành.

## 12. Health rules

- Lưu measurement raw + normalized value.
- Rule engine có bảng/version hoặc code version rõ ràng.
- Alert tham chiếu measurement và rule version.
- Không biến một ngưỡng mẫu thành chẩn đoán. Kết quả dùng `UNKNOWN/ATTENTION/URGENT`, hướng người dùng đến cơ sở y tế phù hợp.
- Rule được chuyên gia duyệt, có effective date và audit.

## 13. Async scan pipeline

```text
Flutter -> upload session -> object storage -> complete
        -> create scan job -> queue -> worker/model
        -> result store -> notification/WebSocket -> Flutter
```

- API không giữ HTTP request chờ model lâu.
- Job retry có giới hạn; dead-letter và mã lỗi rõ.
- Lưu model name/version, prompt/config hash, confidence.
- OCR/AI result là draft; người dùng xác nhận trước khi tạo medical record.
- Xóa file tạm theo retention; redact log.

## 14. WebSocket/chat

- REST tạo conversation và lấy history; WebSocket chỉ push delta.
- Authenticate handshake bằng access token ngắn hạn.
- Mỗi message có `client_message_id` unique chống gửi lặp.
- Persist trước rồi publish.
- Authorization kiểm tra ở subscribe và send.
- Giới hạn kích thước/rate, scan attachment, audit expert access.

## 15. Redis usage

Redis không phải nguồn sự thật cho record y tế. Dùng cho:

- OTP request cooldown/rate counter bổ sung.
- Distributed rate limit và short-lived lock.
- Cache reference data/article list có version.
- Presence/WebSocket routing.
- Job queue chỉ nếu vận hành phù hợp; production có thể dùng broker chuyên dụng.

Thiết kế app vẫn đúng khi cache miss hoặc Redis restart.

## 16. Flyway roadmap

- V1: identity/auth (đã có).
- V2: user profile/preferences/device.
- V3: pregnancy/family/sharing scopes.
- V4: medical record/file/audit.
- V5: measurements/alerts.
- V6: care plan/questions/birth plan/calendar.
- V7: article CMS/review/bookmark.
- V8: expert/availability/consultation/message.
- V9: scan job/quota/result.
- V10: subscription/order/notification/outbox.

Mỗi migration có PK, FK, unique, filtered indexes, query indexes và down-plan vận hành. Flyway production chạy bằng migrator login trước khi rollout app.

## 17. OpenAPI/Swagger

- Swagger UI: `http://localhost:8080/swagger-ui.html`.
- JSON: `http://localhost:8080/v3/api-docs`.
- Mỗi operation khai báo security, error responses, enum và example.
- Tách tag theo domain; operationId ổn định để sinh Dart client.
- CI export `openapi.json`, chạy breaking-change check và Flutter contract test.
- Swagger production nên giới hạn network/auth hoặc tắt UI, vẫn giữ artifact spec.

## 18. Testing pyramid

### Unit

- Domain state machine, pregnancy calculation, permission, rule, quota.
- Clock/UUID/SMS/storage được inject để test xác định.

### Integration

- Repository với SQL Server thật/Testcontainers, không chỉ H2 cho T-SQL/index.
- Flyway chạy từ database rỗng.
- Auth filter, OTP one-time, refresh rotation/reuse.
- IDOR cho mọi resource nhạy cảm.

### API/contract

- MockMvc/WebTestClient kiểm tra envelope, status, JSON schema.
- Consumer contract với Dart models.
- Pagination, idempotency, optimistic lock.

### E2E

- Register OTP → onboarding → pregnancy → dashboard.
- Upload → medical record → family share/revoke.
- Expert booking → chat → completion.
- Scan upload → async result → confirm record.

Dự án hiện đã có integration test auth; `mvnw.cmd clean verify` phải luôn xanh.

## 19. Observability

- Structured JSON log: timestamp, level, service, request_id, user_id đã pseudonymize, route, status, latency.
- Tuyệt đối không log token, OTP, password, medical payload, signed URL.
- Metrics: request latency/error, DB pool, OTP send/fail, auth failure, job duration, queue depth, notification failure.
- Trace propagation qua HTTP/queue.
- Alert cho login spike, SMS error, Flyway failure, job backlog, DB saturation.

## 20. Deployment checklist

- SQL Server TCP/TLS, backup và restore drill.
- Secret manager, key rotation, least-privilege accounts.
- Flyway validate/migrate thành công.
- Readiness kiểm tra DB/Redis cần thiết; liveness không phụ thuộc dịch vụ ngoài.
- Reverse proxy giới hạn body/timeouts; upload trực tiếp object storage.
- CORS allowlist, HSTS, secure headers, rate limit.
- Profile prod tắt OTP debug/demo initializer/Swagger public.
- Rollback app tương thích schema mở rộng; không drop cột cùng release.
- Có runbook mất SMS, DB failover, scan provider fail, data breach và account deletion.

## 21. Thứ tự triển khai thực tế

1. Hoàn thiện auth hiện có, cấu hình SQL Server TCP và SMS adapter.
2. User/preferences/pregnancy + `/dashboard/mom` tối thiểu.
3. Medical record/file + audit + health measurement.
4. Care plan/calendar/questions/birth plan.
5. Article CMS/review/bookmark.
6. Family sharing và partner dashboard.
7. Expert/consultation/chat.
8. AI scan async và quota.
9. Subscription/commerce nếu còn trong scope.
10. Hardening, load/security/restore test và production readiness.
