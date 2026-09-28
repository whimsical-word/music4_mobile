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
| **27/09/2026** | **Streaming / Upload Track UI** | "Code màn hình UploadTrackScreen, thiết kế form bám sát Backend model TrackUploadDTO. Thêm khung chọn ảnh bìa, âm thanh và làm thanh LinearProgressIndicator giả lập tải lên." | Màn hình Upload đầy đủ Title, Category, Album, Collab Artists, Audio File, Cover Image. Kèm thanh tiến trình mô phỏng AWS S3. | - Tách màn hình chính thành 3 file Widgets nhỏ để đảm bảo rule code < 80 dòng của team.<br>- Rà soát lại linter lòi ra lỗi Deprecated của `DropdownButtonFormField`, yêu cầu AI sửa thành `initialValue`. | **Passed**<br>(Commit `6042ac3`) |
| **27/09/2026** | **Media / Player UI** | "Viết lại file `music_player_screen.dart` thành StatefulWidget, thêm một AnimationController để đĩa vinyl xoay tròn, thanh Slider, và các nút Shuffle/Repeat." | Hoàn thiện UI player có thanh Slider, nút play/pause có tác dụng tạm dừng đĩa xoay. | - Nhắc AI fix lỗi font Tiếng Việt UTF-8 (bị lỗi mojibake trên AppBar).<br>- Yêu cầu AI tách nhỏ 4 sub-widgets để tuân thủ tuyệt đối rule < 80 dòng. | **Passed**<br>(Commit `1eb4d43`) |
| **27/09/2026** | **Media / Mini Player UI** | "Tạo thanh Mini Player thu gọn giống Spotify nổi trên BottomNavigationBar. Bổ sung hiệu ứng trượt SlideTransition khi đóng/mở Player." | Giao diện Mini Player với Cover, Title, Play/Pause. Logic GoRouter CustomTransitionPage trượt lên/xuống mượt mà. | - Fix lỗi mảng đen đằng sau khi dùng thuộc tính bottomSheet bằng cách dùng cấu trúc Column.<br>- Kiểm tra lại rule linter báo 0 issues. | **Passed**<br>(Commit `1eb4d43`) |
| **27/09/2026** | **Media / Album Management UI** | "Tạo mới màn hình `AlbumManagementScreen`. Tham khảo backend API AlbumController để làm giao diện popup tạo Album, Grid hiển thị Album và nút Xóa bám sát CRUD." | Khởi tạo giao diện Quản lý Album với BottomSheet tạo mới, icon Thùng rác để xóa, và thanh BottomNavigationBar. Khai báo route `/album-management`. | - Bổ sung thanh BottomNavigationBar và logic chuyển trang GoRouter giống HomeScreen.<br>- Xử lý lỗi Deprecated `withOpacity` sang `withValues` để đạt chuẩn linter 0 issues. | **Passed**<br>(Pending Commit) |
