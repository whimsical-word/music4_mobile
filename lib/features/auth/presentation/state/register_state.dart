sealed class RegisterState {
  const RegisterState();
}

class RegisterInitial extends RegisterState {
  const RegisterInitial();

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is RegisterInitial;

  @override
  int get hashCode => runtimeType.hashCode;
}

class RegisterLoading extends RegisterState {
  const RegisterLoading();

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is RegisterLoading;

  @override
  int get hashCode => runtimeType.hashCode;
}

class RegisterSuccess extends RegisterState {
  final String message;
  const RegisterSuccess([this.message = 'Đăng ký tài khoản thành công!']);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RegisterSuccess &&
          runtimeType == other.runtimeType &&
          message == other.message;

  @override
  int get hashCode => message.hashCode;
}

class RegisterError extends RegisterState {
  final String message;
  const RegisterError(this.message);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RegisterError &&
          runtimeType == other.runtimeType &&
          message == other.message;

  @override
  int get hashCode => message.hashCode;
}
