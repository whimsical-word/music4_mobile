# 🎵 Music4 Mobile — PRM393 (Flutter App)

> **Môn học**: PRM393 — Mobile Programming (FPT University)  
> **Kiến trúc**: Lean Architecture (Feature-First) + Riverpod 2.6 + GoRouter + Dio  
> **Backend**: Spring Boot 3.5 Microservices + AWS S3 + Sentence Transformers AI  

---

## 👥 Thành viên nhóm & Phân công (5 thành viên)

| TV | MSSV | Họ và tên | Feature / Màn hình sở hữu | Bonus Feature (+0.5đ) |
|---|---|---|---|---|
| **T1** | `SE...` | ... | `MusicPlayerScreen`, `UploadTrackScreen` | **Offline-first**: Cache audio |
| **T2** | `SE...` | ... | `LoginScreen`, `RegisterScreen`, `UserProfileScreen` | **OAuth2 Deep Link** |
| **T3** | `SE...` | ... | `HomeScreen`, `HistoryScreen`, `ArtistProfileScreen` | **Real-time Data Refresh** |
| **T5** | `SE...` | ... | `PlaylistScreen`, `PlaylistDetailScreen`, `FavoritesScreen`, `TrackDetailScreen` | **Device Share Deep Link** |
| **T6 (Leader)** | `CE190614` | ... | `SearchScreen`, `NotificationScreen`, `CategoryDetailScreen`, App Core | **CI/CD GitHub Actions** |

---

## 🤖 Bảng Nhật Ký Sử Dụng AI (AI Assistance Log)

- 🔗 **Google Sheets Live Log**: [Bấm vào đây để xem Google Sheet AI Log](https://docs.google.com/) *(Leader cập nhật link sau)*
- 📂 **Lịch sử Git AI Log**: Xem tại thư mục `docs/ai-log/`

---

## 📜 Quy định Làm việc Nhóm & Commit Git
Xem chi tiết tại: [TEAM_RULES.md](./TEAM_RULES.md)

**Quy tắc Commit BẮT BUỘC có MSSV:**
```bash
[MSSV] <type>(<scope>): <Mô tả ngắn gọn>
```
*Ví dụ*: `[CE190614] feat(core): setup project with Lean Architecture`

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
