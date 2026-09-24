# 🤖 AI Assistance Log — T2
- **Họ và tên**: Lê Minh Nhựt
- **Mã sinh viên**: `CE190737`
- **Vai trò**: Thành viên 2 (Auth & User Security)
- **Domain phụ trách**: Authentication Flow (`LoginScreen`, `RegisterScreen`), User Profile (`UserProfileScreen`), JWT Token Rotation (Dio `AuthInterceptor`), Google OAuth2 Deep Link (`app_links`)

---

## 📋 Bảng Nhật ký Sử dụng AI Chi tiết (Tuần 1 — Sprint 1)

| Ngày | Feature / Module | Prompt chi tiết gửi AI | Kết quả AI sinh ra | Bạn đã chỉnh sửa, tối ưu & test lại như thế nào? | Kết quả & Commit SHA |
|---|---|---|---|---|---|
| **25/09/2026** | **Auth / LoginScreen UI** | "Tạo LoginScreen Flutter với TextField email, TextField mật khẩu có toggle ẩn/hiện bằng StatefulWidget, nút Đăng nhập và nút Đăng nhập bằng Google — Material 3, không hardcode màu" | LoginScreen với 2 TextField và ElevatedButton cơ bản, nhưng dùng màu hardcode `Colors.blue` | - Thay màu hardcode bằng `Theme.of(context).colorScheme.primary`.<br>- Tách `PasswordField` ra widget riêng để tái sử dụng trong `RegisterScreen`.<br>- Thêm `TextEditingController.dispose()` trong `deactivate()` tránh memory leak. | **In Progress**<br>(Commit chờ push Tuần 1) |
