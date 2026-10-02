# 🤖 AI Assistance Log — T2
- **Họ và tên**: Lê Minh Nhựt
- **Mã sinh viên**: `CE190737`
- **Vai trò**: Thành viên 2 (Auth & User Security)
- **Domain phụ trách**: Authentication Flow (`LoginScreen`, `RegisterScreen`, `Forget Password Screen, Reset Password Screen), User Profile (`UserProfileScreen`), JWT Token Rotation (Dio `AuthInterceptor`), Google OAuth2 Deep Link (`app_links`)

---

## 📋 Bảng Nhật ký Sử dụng AI Chi tiết (Tuần 1 — Sprint 1)

Đây là bảng báo cáo đã được bổ sung thêm dòng ngày 26/09 (Tuần 1) cho giao diện User Profile:

| Ngày | Feature / Module | Prompt chi tiết gửi AI | Kết quả AI sinh ra | Bạn đã chỉnh sửa, tối ưu & test lại như thế nào? | Kết quả & Commit SHA |
|---|---|---|---|---|---|
| **25/09/2026** | **Auth / Login UI** | "Viết giao diện LoginScreen Flutter, có input username, password (ẩn/hiện) và nút Login." | UI form cơ bản dùng `StatefulWidget`, style hardcode, chưa bắt validation form. | Áp dụng `AppColors.primary`, đưa input vào `Form` và viết logic validator cơ bản. | **Done**<br>(Tuần 1) |
| **26/09/2026** | **Auth / User Profile UI** | "Tạo giao diện UserProfileScreen hiển thị avatar, tên user, email và danh sách tùy chọn (Settings, Logout)." | Layout cơ bản với `CircleAvatar` và `ListTile`. Code các menu item bị lặp lại nhiều. | Tách các item menu thành widget con dùng chung. Thêm `CachedNetworkImage` để xử lý load ảnh avatar mượt hơn. | **Done**<br>(Tuần 1) |
| **30/09/2026** | **Auth / Login Logic** | "Review code feature Login triển khai Clean Architecture, cấu trúc lại theo hướng hiện đại dùng Riverpod (Notifier) và sealed AuthState." | Phát hiện vi phạm Clean Architecture. Sinh code `AuthState` (sealed class) và `AuthNotifier` chuẩn. | Xóa thư mục `providers/` cũ. Đổi `LoginScreen` sang `ConsumerStatefulWidget`, dùng `ref.listen` (chuyển trang) và `ref.watch` (hiện loading). | **Done**<br>(Tuần 2) |