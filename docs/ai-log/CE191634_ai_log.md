# 🤖 AI Assistance Log — T4
- **Họ và tên**: Nguyễn Việt Đan Quỳnh
- **Mã sinh viên**: `CE191634`
- **Vai trò**: Thành viên 4 (Content & Playlist Engagement)
- **Domain phụ trách**: Album Detail Listener View (`AlbumDetailScreen`), Track Detail + Comments (`TrackDetailScreen`), Playlist CRUD (`PlaylistScreen`, `PlaylistDetailScreen`), Share Deep Link (`share_plus`)

---

## 📋 Bảng Nhật ký Sử dụng AI Chi tiết (Tuần 1 — Sprint 1)

| Ngày | Feature / Module | Prompt chi tiết gửi AI | Kết quả AI sinh ra | Bạn đã chỉnh sửa, tối ưu & test lại như thế nào? | Kết quả & Commit SHA |
|---|---|---|---|---|---|
| **25/09/2026** | **Playlist / PlaylistScreen Skeleton** | "Tạo PlaylistScreen Flutter dạng grid 2 cột hiển thị danh sách playlist cá nhân, có FAB để tạo playlist mới, dialog nhập tên — Material 3" | PlaylistScreen với `GridView.builder` 2 cột và `AlertDialog` nhập tên, nhưng không có validation tên rỗng và không tối ưu Optimistic UI | - Thêm validation: nếu tên rỗng hiện `SnackBar` lỗi thay vì cho phép tạo.<br>- Tách `PlaylistCard` thành sub-widget riêng (< 80 dòng) theo quy tắc Clean Code nhóm.<br>- Chuẩn bị hook `PlaylistNotifier.createPlaylist()` với Optimistic Update (cập nhật UI trước khi API trả về, rollback nếu lỗi). | **In Progress**<br>(Commit chờ push Tuần 1) |
