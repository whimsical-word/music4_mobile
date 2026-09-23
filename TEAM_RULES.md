# 📋 TEAM_RULES.md — Quy định Làm việc Nhóm & Chuẩn Môn học PRM393
## 🎵 Music Streaming App — PRM393 (Flutter & Spring Boot Microservices)

> **Phiên bản**: 2.0.0 (Cập nhật sau khi T4 rời nhóm)  
> **Áp dụng cho**: 5 thành viên (T1, T2, T3, T5, T6)  
> **Mục tiêu**: Tối ưu điểm **C6 (1.5đ Git/Process/AI Log)**, **C8 (0.5đ Ownership)**, **C10 (2.5đ Defense)** và **+0.5đ Bonus**.

---

## 🌿 PHẦN 1: QUY TẮC GIT & BRANCHING STRATEGY

### 1.1 Mô hình Phân nhánh (Git Branching)
Mỗi thành viên làm việc độc lập trên branch của mình, **TUYỆT ĐỐI KHÔNG commit trực tiếp vào `main` hoặc `develop`**.

```
main                          ← Branch nộp bài / Release APK (chỉ merge khi có release tag)
│
develop                       ← Branch tích hợp chung (PR vào đây)
│
├── feature/[MSSV]-player-screen        ← T1 làm
├── feature/[MSSV]-auth-flow            ← T2 làm
├── feature/[MSSV]-home-recommendation  ← T3 làm
├── feature/[MSSV]-playlist-crud        ← T5 làm
├── feature/[MSSV]-search-notif         ← T6 làm
├── bugfix/[MSSV]-fix-token-refresh     ← Sửa lỗi
└── release/v1.0.0                      ← Chuẩn bị nộp bài
```

**Cú pháp đặt tên nhánh bắt buộc:**
- Feature mới: `feature/[MSSV]-[TenFeature]` (VD: `feature/SE123456-player-audio`)
- Sửa lỗi: `bugfix/[MSSV]-[TenLoi]` (VD: `bugfix/SE123456-fix-audio-stream`)

---

### 1.2 Quy chuẩn Commit Message (BẮT BUỘC có MSSV để lấy điểm C8 & C6)

> ⚠️ **Quy định môn học**: Commit message không có Mã Sinh Viên sẽ **không thể chứng minh ai là tác giả đoạn code đó** khi bảo vệ trước hội đồng.

**Format chuẩn:**
```text
[MSSV] <type>(<scope>): <Mô tả ngắn gọn bằng tiếng Anh hoặc tiếng Việt rõ nghĩa>
```

**Các `type` chuẩn Conventional Commits:**
- `feat`: Thêm tính năng mới (UI, Logic, API)
- `fix`: Sửa lỗi (bug fix)
- `refactor`: Tái cấu trúc code (không đổi logic bên ngoài)
- `test`: Viết thêm Unit Test hoặc Widget Test
- `docs`: Sửa tài liệu, README, AI Log
- `chore`: Cấu hình build, cài thêm package pubspec

**Ví dụ Hợp Lệ (Ăn trọn điểm C6, C8):**
- `[CE190036] feat(player): implement background audio service with just_audio`
- `[CE190737] feat(auth): add auto-refresh token interceptor for Dio`
- `[CE190284] feat(home): integrate AI recommendations API and render horizontal list`
- `[CE191634] feat(playlist): add create and delete playlist with optimistic UI`
- `[CE190614] feat(search): implement search with 300ms debounce`
- `[CE190036] test(player): add unit test for PlayerNotifier state transitions`

**Ví dụ BỊ TRỪ ĐIỂM (Cấm tuyệt đối):**
- ❌ `update`
- ❌ `fix bug`
- ❌ `commit code`
- ❌ `WIP`
- ❌ `feat: update UI` (Thiếu MSSV)

**Tần suất tối thiểu**: Mỗi người phải có **ít nhất 2 - 3 commits có ý nghĩa / tuần** (rải đều các ngày trong tuần, không được dồn vào ngày nộp bài).

---

## 👥 PHẦN 2: CODE OWNERSHIP & MA TRẬN PHÂN CÔNG (5 THÀNH VIÊN)

| Thành viên | Domain phụ trách | Màn hình sở hữu (Vertical Slice) | Bonus Target (+0.5đ) |
|---|---|---|---|
| **T1 (CE190036)** | Media & Streaming | `MusicPlayerScreen`, `UploadTrackScreen` | **Offline-first**: Cache nhạc cục bộ với `flutter_cache_manager` |
| **T2 (CE190737)** | Auth & User Profile | `LoginScreen`, `RegisterScreen`, `UserProfileScreen` | **Deep Link**: Google OAuth2 callback |
| **T3 (CE190284)** | Discovery & AI | `HomeScreen`, `HistoryScreen`, `ArtistProfileScreen`, `FavoritesScreen` | **Real-time Data**: Tự động refresh gợi ý nhạc sau khi nghe |
| **T5 (CE191634)** | Content & Engagement | `AlbumDetailScreen`, `TrackDetailScreen`, `PlaylistScreen`, `PlaylistDetailScreen` | **Device / Share**: Tạo shareable link nhạc `share_plus` |
| **T6 (CE190614)** | Core & Infrastructure | `SearchScreen`, `NotificationScreen`, `CategoryDetailScreen`, `AdminDashboardScreen`, App Core | **CI/CD**: Tự động test & build APK bằng GitHub Actions |

---

## 🔍 PHẦN 3: QUY TRÌNH PULL REQUEST & CODE REVIEW CHÉO

1. **Trước khi tạo PR:**
   - Chạy `flutter analyze` (phải không có lỗi đỏ).
   - Chạy `flutter test` (tất cả test phải Pass).
   - Rebase với branch `develop` mới nhất.

2. **Quy tắc Review chéo (Peer Review):**
   - **T1** review code của **T3, T5**
   - **T2** review code của **T1, T6**
   - **T3** review code của **T2, T5**
   - **T5** review code của **T1, T3**
   - **T6** review code của **T2, T5**
   - *Bắt buộc phải có ít nhất 1 thành viên Approve và comment nhận xét mới được merge vào `develop`.*
   - *Tuyệt đối không tự Approve và tự Merge PR của chính mình (Self-merge).*

---

## 🤖 PHẦN 4: QUY ĐỊNH VỀ AI ASSISTANCE LOG (QUAN TRỌNG NHẤT ĐỂ TRÁNH BỊ TRỪ ĐIỂM C6)

### 4.1 Quy định sử dụng AI:
- Được phép dùng AI (ChatGPT, Claude, Gemini, Copilot) để hỗ trợ: lên khung code (boilerplate), gợi ý giải thuật, giải thích lỗi, viết mock test.
- **Bắt buộc phải hiểu 100% dòng code được đưa vào dự án** (giảng viên sẽ hỏi trực tiếp ở phần Defense 2.5đ).
- **Mọi đoạn code sinh ra từ AI đều phải được ghi lại trong AI Log.**

### 4.2 Định dạng bảng AI Log (Áp dụng cho cả Google Sheet và file Markdown):

| Ngày | Người thực hiện (MSSV) | Feature / Module | Prompt chi tiết đã gửi cho AI | Kết quả AI sinh ra | Bạn đã chỉnh sửa, tối ưu & test lại như thế nào? | Trạng thái (Passed / Failed) |
|---|---|---|---|---|---|---|
| 24/09 | CE190737 | Auth / Interceptor | "Viết Dio Interceptor tự động refresh JWT token khi gặp lỗi 401 trong Flutter" | Sinh ra class DioInterceptor có hàm onError | Sửa lại logic Queue để hứng các request đồng thời, tích hợp `FlutterSecureStorage` và viết Unit Test mock 401 | Passed (Unit Test 100%) |
| 25/09 | CE190036 | Player / Cache | "Cách cache file audio mp3 bằng flutter_cache_manager và just_audio" | Đoạn code setAudioSource từ CacheManager | Tùy biến hàm fallback: nếu không có mạng thì lấy từ cache, có mạng thì vừa play vừa tải vào cache | Passed (Chạy offline mượt) |

---

## 🚀 PHẦN 5: DEFINITION OF DONE (DOD) CHO TỪNG TÍNH NĂNG

Một tính năng chỉ được xem là "HOÀN THÀNH" khi:
- [x] Chạy thực tế mượt mà trên emulator hoặc thiết bị thật (không crash).
- [x] Có đầy đủ 3 trạng thái giao diện: **Loading** (xoay vòng), **Error** (báo lỗi + nút Thử lại), **Data/Empty** (dữ liệu hoặc trạng thái rỗng).
- [x] Đã hoàn thành từ **UI -> State Provider -> Repository -> API Data Source** (Vertical Slice).
- [x] Có ít nhất **1 Unit Test** hoặc **1 Widget Test** đi kèm.
- [x] Đã được log đầy đủ vào **AI Log**.
- [x] Đã được tạo PR và duyệt bởi ít nhất 1 thành viên khác.
