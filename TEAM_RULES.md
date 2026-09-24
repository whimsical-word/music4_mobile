# 📋 TEAM_RULES.md — Quy định Làm việc Nhóm & Chuẩn Môn học PRM393
## 🎵 Music Streaming App — PRM393 (Flutter & Spring Boot Microservices)

> **Phiên bản**: 2.1.0 (Tối ưu hóa các điểm nghẽn kỹ thuật & Chuẩn hóa Rubric PRM393)  
> **Áp dụng cho**: 5 thành viên (T1, T2, T3, T4, T5)  
> **Mục tiêu**: Tối ưu điểm **C6 (1.5đ Git/Process/AI Log)**, **C8 (0.5đ Ownership)**, **C10 (2.5đ Defense)** và **+0.5đ Bonus**.

---

## 🌿 PHẦN 1: QUY TẮC GIT & BRANCHING STRATEGY

### 1.1 Mô hình Phân nhánh (Git Branching)
Mỗi thành viên làm việc độc lập trên branch của mình, **TUYỆT ĐỐI KHÔNG commit trực tiếp vào `main` hoặc `develop`**.

```
main                          ← Branch nộp bài / Release APK (chỉ trigger build APK khi merge)
│
develop                       ← Branch tích hợp chung (PR vào đây được CI/CD test tự động)
│
├── feature/[MSSV]-player-screen        ← T1 làm
├── feature/[MSSV]-auth-flow            ← T2 làm
├── feature/[MSSV]-home-recommendation  ← T3 làm
├── feature/[MSSV]-playlist-crud        ← T4 làm
├── feature/[MSSV]-search-notif         ← T5 làm (Leader)
├── bugfix/[MSSV]-fix-token-refresh     ← Sửa lỗi
└── release/v1.0.0                      ← Chuẩn bị nộp bài
```

**Cú pháp đặt tên nhánh bắt buộc:**
- Feature mới: `feature/[MSSV]-[TenFeature]` (VD: `feature/CE190036-player-audio`)
- Sửa lỗi: `bugfix/[MSSV]-[TenLoi]` (VD: `bugfix/CE190737-fix-token-refresh`)

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
- `[CE190036] feat(player): implement background audio service with LockCachingAudioSource`
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

| Thành viên | MSSV & Họ tên | Domain phụ trách | Màn hình sở hữu (Vertical Slice) | Bonus Target (+0.5đ) |
|---|---|---|---|---|
| **T1** | `CE190036` — Nguyễn Trung Kiên | Media & Streaming | `MusicPlayerScreen`, `UploadTrackScreen` | **Offline-first**: Cache nhạc cục bộ với `LockCachingAudioSource` (`just_audio`) an toàn cho Byte-range stream |
| **T2** | `CE190737` — Lê Minh Nhựt | Auth & User Profile | `LoginScreen`, `RegisterScreen`, `UserProfileScreen` | **Deep Link**: Google OAuth2 callback (`app_links`) |
| **T3** | `CE190284` — Nguyễn Hữu Tài | Discovery & AI | `HomeScreen`, `HistoryScreen`, `ArtistProfileScreen`, `FavoritesScreen` | **Real-time Data**: Tự động refresh gợi ý nhạc sau khi nghe |
| **T4** | `CE191634` — Nguyễn Việt Đan Quỳnh | Content & Engagement | `AlbumDetailScreen`, `TrackDetailScreen`, `PlaylistScreen`, `PlaylistDetailScreen` | **Device / Share**: Tạo shareable link nhạc `share_plus` |
| **T5 (Leader)** | `CE190614` — Nguyễn Tấn Quốc | Core & Infrastructure | `SearchScreen`, `NotificationScreen`, `CategoryDetailScreen`, `AdminDashboardScreen`, App Core | **CI/CD Pipeline**: GitHub Actions auto-test PR vào `develop` & auto-build APK khi merge `main` |

---

## 🔍 PHẦN 3: QUY TRÌNH PULL REQUEST & CODE REVIEW VÒNG TRÒN KÉP (DUAL-RING PEER REVIEW)

1. **Trước khi tạo PR:**
   - Chạy `flutter analyze` (phải 0 errors, 0 warnings).
   - Chạy `flutter test` (tất cả test phải Pass).
   - Rebase với branch `develop` mới nhất.

2. **Ma trận Review chéo Vòng tròn kép (Mỗi người review đúng 2 người, được 2 người review):**
   - **T1** review code của: **T2**, **T3**
   - **T2** review code của: **T3**, **T4**
   - **T3** review code của: **T4**, **T5**
   - **T4** review code của: **T5**, **T1**
   - **T5 (Leader)** review code của: **T1**, **T2**
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
| 25/09 | CE190036 | Player / Cache | "Cách cache file audio mp3 bằng LockCachingAudioSource trong just_audio" | Đoạn code LockCachingAudioSource | Tùy biến hàm fallback: nếu không có mạng thì lấy từ cache, có mạng thì vừa play vừa tải vào cache | Passed (Chạy offline mượt) |

---

## 🚀 PHẦN 5: DEFINITION OF DONE (DOD) & CHUẨN CODE (C4 & C5)

Một tính năng chỉ được xem là "HOÀN THÀNH" khi:
- [x] Chạy thực tế mượt mà trên emulator hoặc thiết bị thật (không crash).
- [x] Có đầy đủ 3 trạng thái giao diện: **Loading** (xoay vòng/skeleton), **Error** (báo lỗi + nút Thử lại), **Data/Empty** (dữ liệu hoặc trạng thái rỗng).
- [x] Đã hoàn thành từ **UI -> State Provider -> Repository -> API Data Source** (Vertical Slice).
- [x] **Quy chuẩn State (Tránh cực đoan / Tránh over-engineering)**:
  - Bắt buộc dùng **Riverpod** cho Business Logic, API data fetching, User/Token/Player state và chia sẻ dữ liệu liên màn hình. (Cấm dùng `setState` cho API/Domain logic).
  - Cho phép dùng **`StatefulWidget`** cho trạng thái UI cục bộ ngắn hạn (Ephemerals) như: ẩn/hiện mật khẩu trong form, đóng/mở dropdown local, `AnimationController`.
- [x] **Lộ trình Kiểm thử (Testing Roadmap)**:
  - **Tuần 2 (CP2)**: Bắt buộc có **1 Unit Test** kiểm thử chính luồng Vertical Slice của mình (Mocktail).
  - **Tuần 4 (CP4)**: Bắt buộc có thêm **1 Widget Test** kiểm thử tương tác giao diện.
- [x] Đã được log đầy đủ vào **AI Log** (Google Sheet + file Markdown).
- [x] Đã được tạo PR và duyệt bởi ít nhất 1 thành viên theo ma trận vòng tròn kép.
