# 🤖 AI Assistance Log — T3
- **Họ và tên**: Nguyễn Hữu Tài
- **Mã sinh viên**: `CE190284`
- **Vai trò**: Thành viên 3 (Discovery & AI Analytics)
- **Domain phụ trách**: Home Feed & AI Recommendation (`HomeScreen`), Listening History (`HistoryScreen`), Artist Profile (`ArtistProfileScreen`), Favorites (`FavoritesScreen`), Real-time Recommendation Refresh

---

## 📋 Bảng Nhật ký Sử dụng AI Chi tiết (Tuần 1 — Sprint 1)

| Ngày | Feature / Module | Prompt chi tiết gửi AI | Kết quả AI sinh ra | Bạn đã chỉnh sửa, tối ưu & test lại như thế nào? | Kết quả & Commit SHA |
|---|---|---|---|---|---|
| **25/09/2026** | **Home / HomeScreen Skeleton** | "Tạo HomeScreen Flutter với horizontal scroll dải Banner AI gợi ý, danh sách Top 5 Trending theo hàng ngang, danh sách Recent History theo hàng dọc — sử dụng shimmer loading" | HomeScreen với 3 section dùng `ListView.builder` lồng nhau, shimmer bằng `CircularProgressIndicator` đặt giữa màn hình (sai) | - Thay `CircularProgressIndicator` bằng Shimmer Skeleton đúng cấu trúc (placeholder card khớp với TrackCard thật).<br>- Sửa nested ListView tránh `Vertical viewport was given unbounded height` bằng `shrinkWrap: true` + `NeverScrollableScrollPhysics()`.<br>- Bổ sung Empty State widget khi danh sách rỗng. | **In Progress**<br>(Commit chờ push Tuần 1) |
