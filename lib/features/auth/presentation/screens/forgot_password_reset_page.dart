import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music4_mobile/features/auth/presentation/notifiers/forgot_password_notifier.dart';
import 'package:music4_mobile/features/auth/presentation/state/forgot_password_state.dart';

class ForgotPasswordResetPage extends ConsumerStatefulWidget {
  final String email;
  const ForgotPasswordResetPage({super.key, required this.email});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _ForgotPasswordResetPageState();
  }
}

class _ForgotPasswordResetPageState
    extends ConsumerState<ForgotPasswordResetPage> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    ref.listenManual<ForgotPasswordState>(forgotPasswordNotifierProvider, (
      previous,
      next,
    ) {
      if (!mounted) return;

      if (next is ForgotPasswordResetSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đặt lại mật khẩu thành công')),
        );
        Navigator.of(context).popUntil((route) => route.isFirst);
      } else if (next is ForgotPasswordError) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(next.message)));
      }
    });
  }

  String? _validateOtp(String? value) {
    final otp = value?.trim() ?? '';
    if (otp.isEmpty) return 'Vui lòng nhập OTP';
    if (!RegExp(r'^\d{6}$').hasMatch(otp)) return 'OTP phải gồm 6 chữ số';
    return null;
  }

  String? _validatePassword(String? value) {
    final password = value ?? '';
    if (password.isEmpty) return 'Vui lòng nhập mật khẩu mới';
    if (password.length < 6) return 'Mật khẩu tối thiểu 6 ký tự';
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if ((value ?? '').isEmpty) return 'Vui lòng nhập lại mật khẩu';
    if (value != _newPasswordController.text) {
      return 'Mật khẩu nhập lại không đúng';
    }
    return null;
  }

  @override
  void dispose() {
    _otpController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(forgotPasswordNotifierProvider);
    final isLoading = state is ForgotPasswordLoading;
    return Scaffold(
      appBar: AppBar(title: const Text('Đặt lại mật khẩu')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text('Email: ${widget.email}'),
              const SizedBox(height: 12),
              TextFormField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                decoration: const InputDecoration(labelText: 'OTP'),
                validator: _validateOtp,
              ),
              TextFormField(
                controller: _newPasswordController,
                decoration: const InputDecoration(labelText: 'Mật khẩu mới'),
                obscureText: true,
                validator: _validatePassword,
              ),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: const InputDecoration(
                  labelText: 'Nhập lại mật khẩu mới',
                ),
                obscureText: true,
                validator: _validateConfirmPassword,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                          if (!_formKey.currentState!.validate()) return;

                          await ref
                              .read(forgotPasswordNotifierProvider.notifier)
                              .resetPassword(
                                email: widget.email,
                                otp: _otpController.text.trim(),
                                newPassword: _newPasswordController.text,
                              );
                        },
                  child: isLoading
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Đặt lại mật khẩu'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
