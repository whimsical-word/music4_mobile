# 🎵 Music4 Mobile — PRM393 (Music Streaming Application)

> **Môn học**: PRM393 — Mobile Programming / Mobile Application Development (Flutter)  
> **Trường Đại học**: Đại học FPT (FPT University)  
> **Kiến trúc ứng dụng**: Lean Architecture (Feature-First) + Riverpod 2.6 + GoRouter 14 + Dio 5  
> **Hạ tầng Backend**: Spring Boot 3.5 N-Layer Architecture + Microsoft SQL Server + AWS S3 + FastAPI (SBERT Vector AI)  

---

## 📖 1. TỔNG QUAN DỰ ÁN & TỆP NGƯỜI DÙNG MỤC TIÊU (PROJECT OVERVIEW)

### 1.1 Bối cảnh & Mục tiêu (Problem & Objective)
**Music4** là ứng dụng nghe nhạc trực tuyến di động đa nền tảng hiện đại, giải quyết bài toán truyền phát âm thanh chất lượng cao với độ trễ thấp, đồng thời cá nhân hóa trải nghiệm âm nhạc của người dùng thông qua thuật toán Trí tuệ nhân tạo (Content-based AI Vector Search). Hệ thống kết hợp giữa kiến trúc di động hướng tính năng (Feature-First) và hạ tầng điện toán đám mây AWS S3.

### 1.2 Tệp người dùng mục tiêu (Target Users)
1. **Khách vãng lai (Guest Listeners)**:
   - Nghe thử 30 giây các bài hát hot mà không cần đăng ký tài khoản.
   - Tìm kiếm bài hát, album, nghệ sĩ và duyệt danh mục thể loại tự do.
2. **Người nghe chính thức (Registered Listeners)**:
   - Thưởng thức trọn vẹn bài hát chất lượng cao qua cơ chế Byte-range HTTP streaming.
   - Nhận danh sách bài hát gợi ý cá nhân hóa (AI Recommendations) dựa trên gu âm nhạc thực tế.
   - Tạo, chỉnh sửa, xóa và sắp xếp danh sách phát cá nhân (Playlists).
   - Thả tim bài hát yêu thích (Favorites), theo dõi nghệ sĩ (Follow), viết bình luận và đánh giá sao.
   - Tải và nghe nhạc trong điều kiện mất mạng Internet thông qua bộ nhớ đệm an toàn (`LockCachingAudioSource`).
3. **Nghệ sĩ / Nhà sáng tạo nội dung (Artists)**:
   - Truy cập Artist Studio để tải lên bài hát (Audio file) và ảnh bìa (Cover art) lên đám mây AWS S3.
   - Tạo và quản lý Album bài hát cá nhân, gắn thẻ thể loại và nghệ sĩ hợp tác (collab).
   - Theo dõi biểu đồ phân tích lượt nghe, lượt thích và người theo dõi qua Artist Analytics.
4. **Quản trị viên hệ thống (Administrators)**:
   - Giám sát toàn bộ dữ liệu người dùng, nghệ sĩ và danh mục bài hát.
   - Khóa hoặc kích hoạt tài khoản vi phạm chính sách cộng đồng.
   - Quản lý và làm mới kho dữ liệu nhúng vector trên Elasticsearch.

---

## 👥 2. THÀNH VIÊN NHÓM & PHÂN CÔNG QUYỀN SỞ HỮU (OWNERSHIP MATRIX)

> Tuân thủ tuyệt đối quy định: Mỗi thành viên sở hữu ít nhất **2 - 4 màn hình có ý nghĩa** và làm trọn vẹn một **Vertical Slice** (UI → State Provider → Model → Repository → API Call → Unit/Widget Test).

| TV | MSSV | Họ và tên | Domain chính | Màn hình sở hữu (Vertical Slice) | Tính năng Nâng cao (Bonus +0.5đ) |
|---|---|---|---|---|---|
| **T1** | `CE190036` | **Nguyễn Trung Kiên** | Media & Streaming Core | `MusicPlayerScreen`, `UploadTrackScreen`, `AlbumManagementScreen` *(Artist Studio CRUD)* | **Offline-first Audio**: Cache nhạc mp3 an toàn với `LockCachingAudioSource` (`just_audio`) hỗ trợ byte-range streaming |
| **T2** | `CE190737` | **Lê Minh Nhựt** | Auth & User Security | `LoginScreen`, `RegisterScreen`, `UserProfileScreen` | **Device / Deep Link**: Xử lý Google OAuth2 Redirect Callback qua `app_links` |
| **T3** | `CE190284` | **Nguyễn Hữu Tài** | Discovery & AI Analytics | `HomeScreen`, `HistoryScreen`, `ArtistProfileScreen`, `FavoritesScreen` | **Real-time Data**: Tự động reload feed gợi ý AI tức thì sau khi nghe xong bài hát |
| **T4** | `CE191634` | **Nguyễn Việt Đan Quỳnh** | Content & Playlist Engagement | `AlbumDetailScreen` *(Listener view)*, `TrackDetailScreen`, `PlaylistScreen`, `PlaylistDetailScreen` | **Device Share**: Tạo link share bài hát chia sẻ trực tiếp qua Zalo/Facebook/SMS (`share_plus`) |
| **T5 (Lead)** | `CE190614` | **Nguyễn Tấn Quốc** | Core, Search & Admin | `SearchScreen`, `NotificationScreen`, `CategoryDetailScreen`, `AdminDashboardScreen`, App Core | **Voice Search**: Tích hợp Microphone phần cứng, xử lý cấp quyền runtime `RECORD_AUDIO`, package `speech_to_text` (vi_VN) → trigger Elasticsearch |

### 🗺️ Sơ đồ phân vùng kiến trúc theo Domain
```
T1 — Media Core (S3 & Streaming)
 └── MusicPlayerScreen (just_audio + audio_service)
 └── UploadTrackScreen (Multipart S3 upload & Progress)
 └── AlbumManagementScreen (Artist Studio CRUD: Tạo/sửa album, gán track)

T2 — Auth & Security (JWT + Spring Security)
 └── LoginScreen (Form validation + Google OAuth2)
 └── RegisterScreen (Phân quyền Listener / Artist)
 └── UserProfileScreen (Avatar upload + Profile PATCH)

T3 — AI & Analytics (Recommendation + History + Favorites)
 └── HomeScreen (Dải gợi ý nhạc thông minh SBERT AI)
 └── HistoryScreen (Lịch sử nghe có phân trang vô tận)
 └── ArtistProfileScreen (Follow artist & danh sách bài hát hot)
 └── FavoritesScreen (Bộ sưu tập bài hát đã thích)

T4 — Content Manager & Playlist Engagement
 └── AlbumDetailScreen (Chi tiết album dành cho Listener)
 └── TrackDetailScreen (Like, Add to playlist, Comments, Rating)
 └── PlaylistScreen (Quản lý và tạo mới Playlist)
 └── PlaylistDetailScreen (CRUD bài hát trong playlist)

T5 — Search, Admin & Core Infrastructure (Leader)
 └── SearchScreen (Elasticsearch + Voice Search speech_to_text)
 └── NotificationScreen (SSE real-time stream notification)
 └── CategoryDetailScreen (Khám phá bài hát theo thể loại)
 └── AdminDashboardScreen (Thống kê số liệu & quản trị tài khoản)
 └── App Core (GoRouter, Dio Client, Theme, Secure Storage)
```

---

## 🛠️ 3. YÊU CẦU MÔI TRƯỜNG & THIẾT LẬP (PREREQUISITES & CONFIGURATION)

### 3.1 Yêu cầu môi trường (Prerequisites)
- **Flutter SDK**: `^3.27.0` (kênh Stable)
- **Dart SDK**: `^3.13.3`
- **Java**: OpenJDK 17 hoặc 21 (dùng cho Gradle compile & chạy Backend Spring Boot)
- **Android Studio** / **VS Code**: Cài đặt sẵn Flutter & Dart Extension
- **Thiết bị chạy**: Android Emulator (Android 10.0+ / API 29+) hoặc Thiết bị thật có bật USB Debugging.

### 3.2 Cấu hình biến môi trường (`.env`) không lộ Secrets (C7 Requirement)
Ứng dụng sử dụng cấu hình tập trung trong `lib/core/constants/api_endpoints.dart` hoặc file môi trường `.env`.

1. Tạo file `.env` tại thư mục gốc của dự án `music4_mobile/` dựa trên mẫu sau:
   ```env
   # File: .env (Tập tin này được đưa vào .gitignore - KHÔNG commit lên Git)
   BASE_URL=http://10.0.2.2:8080/api      # Dùng 10.0.2.2 cho Android Emulator, localhost cho iOS/Web, hoặc IP LAN máy tính
   AI_SERVICE_URL=http://10.0.2.2:8000    # Cổng dịch vụ FastAPI AI Recommendation
   CONNECT_TIMEOUT=15000                  # Thời gian timeout kết nối (milliseconds)
   RECEIVE_TIMEOUT=15000                  # Thời gian timeout nhận dữ liệu (milliseconds)
   ```
2. Mọi thông tin nhạy cảm như AWS Access Key, AWS Secret Key hoặc Database Password **đều nằm an toàn ở phía Backend Spring Boot**, Mobile Client chỉ giao tiếp qua REST API có bảo mật bằng JWT Bearer Token.

---

## 🖥️ 4. THIẾT LẬP HẠ TẦNG BACKEND & DATABASE (BACKEND SETUP)

Dự án Mobile Client kết nối trực tiếp với hệ sinh thái Backend hoàn chỉnh đã được cấu hình sẵn:

### 4.1 Nguồn mã nguồn Backend
- **Repository Backend**: [https://github.com/whimsical-word/Music4-Backend.git](https://github.com/whimsical-word/Music4-Backend.git)
- **Repository AI Service**: [https://github.com/whimsical-word/Music4-AI.git](https://github.com/whimsical-word/Music4-AI.git)

### 4.2 Thiết lập Cơ sở dữ liệu & Chạy Dịch vụ
1. **Database**: Microsoft SQL Server.
   - Chạy script tạo cơ sở dữ liệu `music_streaming_db_v2.sql` hoặc khôi phục từ bản sao lưu `DemoDB.sql` trong thư mục Backend.
2. **Khởi động AI Recommendation Service (FastAPI)**:
   ```bash
   cd Music4-AI
   pip install -r requirements.txt
   uvicorn main:app --reload --port 8000
   ```
3. **Khởi động Spring Boot REST API**:
   ```bash
   cd Music4-Backend
   ./mvnw spring-boot:run
   ```
   - **Tài liệu API Swagger UI**: `http://localhost:8080/swagger-ui/index.html` (Xem và test trực tiếp 50+ API endpoints).

---

## 🚀 5. HƯỚNG DẪN CÀI ĐẶT & CHẠY ỨNG DỤNG (RUN INSTRUCTIONS)

### 5.1 Cài đặt thư viện & chuẩn bị code
```bash
# 1. Clone repository
git clone https://github.com/whimsical-word/music4_mobile.git
cd music4_mobile

# 2. Tải và cài đặt các packages Flutter
flutter pub get

# 3. Tạo các file tự sinh (Freezed models & Riverpod code generation)
flutter pub run build_runner build --delete-conflicting-outputs
```

### 5.2 Chạy ứng dụng ở chế độ Debug (Debug Mode)
```bash
# Chạy trên thiết bị mặc định đang kết nối
flutter run

# Hoặc chỉ định thiết bị cụ thể
flutter run -d emulator-5554
```

### 5.3 Lệnh Đóng gói Bản phát hành (Build Release APK / AppBundle — C7 & R11)
Hệ thống CI/CD tự động build khi merge vào `main`. Nếu bạn muốn build thủ công trên máy:

```bash
# 1. Build APK chia theo kiến trúc CPU (tối ưu dung lượng nhẹ nhất cho Android)
flutter build apk --release --split-per-abi

# File APK đầu ra nằm tại:
# build/app/outputs/flutter-apk/app-arm64-v8a-release.apk (dành cho hầu hết điện thoại thực tế hiện nay)
# build/app/outputs/flutter-apk/app-x86_64-release.apk (dành cho giả lập Android Studio x86_64)

# 2. Build AppBundle để phân phối trên Google Play Store
flutter build appbundle --release
```

---

## 🧪 6. HƯỚNG DẪN CHẠY KIỂM THỬ (RUNNING TESTS — C5 REQUIREMENT)

Ứng dụng tuân thủ nghiêm ngặt lộ trình kiểm thử tự động, kết hợp giữa `flutter_test` và thư viện giả lập `mocktail`:

```bash
# 1. Chạy toàn bộ các bài Unit Tests & Widget Tests
flutter test

# 2. Chạy test và xuất báo cáo độ bao phủ mã nguồn (Coverage Report)
flutter test --coverage

# 3. Quét tĩnh toàn bộ lỗi cú pháp và chuẩn code linter (C4 Code Quality)
flutter analyze
```

### 📋 Danh mục Kiểm thử của 5 thành viên (Mỗi người ≥ 1 Unit Test + 1 Widget Test):
- **T1 (CE190036)**: Test logic chuyển bài `PlayerNotifier` + Widget test slider tua bài trên `MusicPlayerScreen`.
- **T2 (CE190737)**: Test xác thực `AuthNotifier.login()` khi sai mật khẩu + Widget test form validation `LoginScreen`.
- **T3 (CE190284)**: Test mapping JSON gợi ý AI sang Model + Widget test render danh sách `TrackCard` trên `HomeScreen`.
- **T4 (CE191634)**: Test cập nhật trạng thái Optimistic khi tạo Playlist + Widget test hiển thị Dialog trên `PlaylistScreen`.
- **T5 (CE190614)**: Test thuật toán Debounce 300ms trong `SearchNotifier` + Widget test các tab kết quả trên `SearchScreen`.

---

## 🔐 7. DANH SÁCH TÀI KHOẢN THỬ NGHIỆM (DEMO ACCOUNTS & SEED DATA)

> [TODO: Team sẽ cập nhật nội dung phần này sau vào các tuần cuối.]

---

## ⚠️ 8. CÁC HẠN CHẾ ĐÃ BIẾT & HƯỚNG PHÁT TRIỂN (KNOWN LIMITATIONS — C9 & C10)

> [TODO: Team sẽ cập nhật nội dung phần này sau vào các tuần cuối.]

---

## 📜 9. QUY TẮC LÀM VIỆC NHÓM & QUY TRÌNH KỸ THUẬT (TEAM PROCESS & GIT)

Xem chi tiết đầy đủ tại: [TEAM_RULES.md](./TEAM_RULES.md)

### 9.1 Quy chuẩn Commit Message (BẮT BUỘC có MSSV):
```bash
[MSSV] <type>(<scope>): <Mô tả ngắn gọn bằng tiếng Anh hoặc tiếng Việt rõ nghĩa>
```

| Thành viên | Ví dụ commit hợp lệ đạt chuẩn |
|---|---|
| **T1 — CE190036** | `[CE190036] feat(player): implement background audio service with LockCachingAudioSource` |
| **T2 — CE190737** | `[CE190737] feat(auth): add JWT auto-refresh interceptor with queue mechanism` |
| **T3 — CE190284** | `[CE190284] feat(home): integrate AI recommendations API and render horizontal list` |
| **T4 — CE191634** | `[CE191634] feat(playlist): implement create and delete playlist with optimistic UI` |
| **T5 — CE190614** | `[CE190614] feat(search): implement search with 300ms debounce and filter tabs` |

### 9.2 Quy tắc Phân nhánh & Tích hợp (Branching & PR Review):
- Nhánh `main`: Ổn định, chỉ chứa bản release sẵn sàng nộp bài / demo.
- Nhánh `develop`: Nhánh tích hợp chung, mọi PR đều phải chạy qua CI/CD test xanh trước khi merge.
- Nhánh cá nhân: `feature/[MSSV]-[usecase]`.
- **Ma trận Review chéo Vòng tròn kép (Dual-ring Peer Review)**:
  - T1 review T2 & T3 | T2 review T3 & T4 | T3 review T4 & T5 | T4 review T5 & T1 | T5 review T1 & T2.

---

## 🤖 10. BẢNG NHẬT KÝ SỬ DỤNG AI (AI ASSISTANCE LOG — C6 REQUIREMENT)

Nhóm cam kết sử dụng Trí tuệ Nhân tạo có trách nhiệm, minh bạch và hoàn toàn chịu trách nhiệm về mã nguồn nộp lên:
- 🔗 **Google Sheets Live Log (Nhật ký hàng ngày)**: [Bấm vào đây để xem Google Sheets Live Log của nhóm](https://docs.google.com/spreadsheets/d/1gfuj-Q10eHTEdaLELEnz1Urb_14PyrhNmgS899TVymM/edit?usp=sharing)
- 📂 **Lịch sử Git AI Log (Đồng bộ hàng tuần)**: Xem chi tiết các file markdown trong thư mục [`docs/ai-log/`](./docs/ai-log/)
  - `docs/ai-log/CE190036_ai_log.md` — Nguyễn Trung Kiên (T1)
  - `docs/ai-log/CE190737_ai_log.md` — Lê Minh Nhựt (T2)
  - `docs/ai-log/CE190284_ai_log.md` — Nguyễn Hữu Tài (T3)
  - `docs/ai-log/CE191634_ai_log.md` — Nguyễn Việt Đan Quỳnh (T4)
  - `docs/ai-log/CE190614_ai_log.md` — Nguyễn Tấn Quốc (T5 - Leader)
