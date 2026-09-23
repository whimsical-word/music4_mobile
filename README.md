# 🎵 Music4 Mobile — PRM393 (Flutter App)

> **Môn học**: PRM393 — Mobile Programming (FPT University)
> **Kiến trúc**: Lean Architecture (Feature-First) + Riverpod 2.6 + GoRouter + Dio
> **Backend**: Spring Boot 3.5 Microservices + AWS S3 + Sentence Transformers AI

---

## 👥 Thành viên nhóm & Phân công (5 thành viên)

| TV | MSSV | Họ và tên | Domain | Màn hình sở hữu (Vertical Slice) | Bonus Feature (+0.5đ) |
|---|---|---|---|---|---|
| **T1** | `CE190036` | Nguyễn Trung Kiên | Media & Streaming | `MusicPlayerScreen`, `UploadTrackScreen` | **Offline-first**: Cache audio với `flutter_cache_manager` |
| **T2** | `CE190737` | Lê Minh Nhựt | Auth & Security | `LoginScreen`, `RegisterScreen`, `UserProfileScreen` | **OAuth2 Deep Link**: Google callback |
| **T3** | `CE190284` | Nguyễn Hữu Tài | AI & Analytics | `HomeScreen`, `HistoryScreen`, `ArtistProfileScreen` | **Real-time Data**: Auto-refresh gợi ý AI |
| **T5** | `CE191634` | Nguyễn Việt Đan Quỳnh | Content & Engagement | `AlbumDetailScreen`, `TrackDetailScreen`, `PlaylistScreen`, `PlaylistDetailScreen`, `FavoritesScreen` | **Share Deep Link**: Share bài hát qua Zalo/FB |
| **T6 (Leader)** | `CE190614` | Nguyễn Tấn Quốc | Search & Admin & Core | `SearchScreen`, `NotificationScreen`, `CategoryDetailScreen`, `AdminDashboardScreen`, App Core | **CI/CD**: GitHub Actions tự build APK |

---

## 🗺️ Sơ đồ phân công theo Domain gốc

```
T1 — Media Core (S3 & Streaming)
 └── MusicPlayerScreen (just_audio + audio_service)
 └── UploadTrackScreen (Multipart S3 upload)

T2 — Auth & Security (JWT + Spring Security)
 └── LoginScreen (JWT + Riverpod)
 └── RegisterScreen (Listener / Artist roles)
 └── UserProfileScreen (PATCH avatar + profile)

T3 — AI & Analytics (Recommendation + History)
 └── HomeScreen (AI gợi ý nhạc, Top trending)
 └── HistoryScreen (Lịch sử nghe)
 └── ArtistProfileScreen (Follow artist - nhận từ T4)

T5 — Content Manager + Engagement (nhận Playlist/Favorite từ T4)
 └── AlbumDetailScreen (Album + danh sách tracks)
 └── TrackDetailScreen (Like, Add to playlist, Comment)
 └── PlaylistScreen (Danh sách playlists)
 └── PlaylistDetailScreen (CRUD tracks trong playlist)
 └── FavoritesScreen (Bài hát yêu thích)

T6 — Search & Admin & Core Infrastructure
 └── SearchScreen (Debounce 300ms, multi-type)
 └── NotificationScreen (SSE real-time - nhận từ T4)
 └── CategoryDetailScreen (Duyệt theo thể loại)
 └── AdminDashboardScreen (Quản lý User/Artist)
 └── App Core (GoRouter, Dio, Theme, Constants)
```

---

## 🤖 Bảng Nhật Ký Sử Dụng AI (AI Assistance Log)

- 🔗 **Google Sheets Live Log**: https://docs.google.com/spreadsheets/d/1gfuj-Q10eHTEdaLELEnz1Urb_14PyrhNmgS899TVymM/edit?usp=sharing
- 📂 **Lịch sử Git AI Log**: Xem tại thư mục `docs/ai-log/`

---

## 📜 Quy định Làm việc Nhóm & Commit Git
Xem chi tiết tại: [TEAM_RULES.md](./TEAM_RULES.md)

**Quy tắc Commit BẮT BUỘC có MSSV:**
```bash
[MSSV] <type>(<scope>): <Mô tả ngắn gọn>
```

| Thành viên | Ví dụ commit chuẩn |
|---|---|
| T1 — CE190036 | `[CE190036] feat(player): implement audio streaming with just_audio` |
| T2 — CE190737 | `[CE190737] feat(auth): add JWT auto-refresh interceptor` |
| T3 — CE190284 | `[CE190284] feat(home): integrate AI recommendations API` |
| T5 — CE191634 | `[CE191634] feat(playlist): implement create and delete playlist` |
| T6 — CE190614 | `[CE190614] feat(search): implement debounce search with GoRouter` |

---

## 🚀 Hướng dẫn Cài đặt & Chạy ứng dụng

1. **Clone repo**:
   ```bash
   git clone https://github.com/whimsical-word/music4_mobile.git
   cd music4_mobile
   ```

2. **Cài đặt packages**:
   ```bash
   flutter pub get
   ```

3. **Chạy Code Generation (Freezed / Riverpod)**:
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. **Chạy ứng dụng**:
   ```bash
   flutter run
   ```
