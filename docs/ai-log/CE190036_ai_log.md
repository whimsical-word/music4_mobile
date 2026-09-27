# 🤖 AI Assistance Log — T1
- **Họ và tên**: Nguyễn Trung Kiên
- **Mã sinh viên**: `CE190036`
- **Vai trò**: Thành viên 1 (Media & Streaming)
- **Domain phụ trách**: Audio Player (`MusicPlayerScreen`), Upload Track (`UploadTrackScreen`), Album Management Artist Studio (`AlbumManagementScreen`), Offline Audio Cache (`LockCachingAudioSource`)

---

## 📋 Bảng Nhật ký Sử dụng AI Chi tiết (Tuần 1 — Sprint 1)

| Ngày | Feature / Module | Prompt chi tiết gửi AI | Kết quả AI sinh ra | Bạn đã chỉnh sửa, tối ưu & test lại như thế nào? | Kết quả & Commit SHA |
|---|---|---|---|---|---|
| **25/09/2026** | **Player / Skeleton UI** | "Tạo MusicPlayerScreen với layout vinyl disc xoay, thanh progress bar, 3 nút play/pause/skip/prev theo chuẩn Material 3, Dark theme Spotify" | Skeleton layout MusicPlayerScreen với AnimationController xoay vinyl và Slider widget cơ bản, màu hardcode `Colors.grey` | - Tách riêng `VinylDiscWidget` thành sub-widget độc lập (< 80 dòng) để tuân thủ quy tắc Clean Code nhóm.<br>- Sửa Slider dùng `SliderTheme` đúng M3 thay vì style cứng.<br>- Thay `Colors.grey` bằng `Theme.of(context).colorScheme.onSurface`.<br>- Thêm `HapticFeedback.lightImpact()` khi bấm play/pause. | **In Progress**<br>(Commit chờ push Tuần 1) |
| **27/09/2026** | **Media / Player UI** | "Viết lại file `music_player_screen.dart` thành StatefulWidget, thêm một AnimationController để đĩa vinyl xoay tròn, và một thanh Slider có thể kéo được để mô phỏng thời lượng bài hát." | Hoàn thiện UI player có thanh Slider, nút play/pause có tác dụng tạm dừng đĩa xoay. | - Nhắc AI fix lỗi font Tiếng Việt UTF-8 (bị lỗi mojibake trên AppBar).<br>- Test trực tiếp trên màn hình giả lập Windows Desktop chạy cực mượt. | **Passed**<br>(Commit `aa80996`) |
