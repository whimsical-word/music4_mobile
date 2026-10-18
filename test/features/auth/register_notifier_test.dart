import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:music4_mobile/features/auth/domain/entities/register_request.dart';
import 'package:music4_mobile/features/auth/domain/entities/user_entity.dart';
import 'package:music4_mobile/features/auth/domain/usecases/register_use_case.dart';
import 'package:music4_mobile/features/auth/presentation/notifiers/register_notifier.dart';
import 'package:music4_mobile/features/auth/presentation/notifiers/register_state.dart';

class MockRegisterUseCase extends Mock implements RegisterUseCase {}

void main() {
  late MockRegisterUseCase mockRegisterUseCase;
  late RegisterNotifier registerNotifier;

  const tRequest = RegisterRequest(
    name: 'Test User',
    email: 'test@example.com',
    username: 'testuser',
    password: 'password123',
    role: 'listener',
  );

  setUpAll(() {
    registerFallbackValue(tRequest);
  });

  setUp(() {
    mockRegisterUseCase = MockRegisterUseCase();
    registerNotifier = RegisterNotifier(registerUseCase: mockRegisterUseCase);
  });

  tearDown(() {
    registerNotifier.dispose();
  });

  test('initial state should be RegisterInitial', () {
    expect(registerNotifier.state, const RegisterInitial());
  });

  test('should emit [RegisterLoading, RegisterSuccess] when registration succeeds', () async {
    when(() => mockRegisterUseCase(any()))
        .thenAnswer((_) async => const Success(null));

    final expectedStates = <RegisterState>[];
    registerNotifier.addListener((state) {
      expectedStates.add(state);
    });

    await registerNotifier.register(tRequest);

    expect(expectedStates, [
      const RegisterInitial(),
      const RegisterLoading(),
      const RegisterSuccess(),
    ]);
    verify(() => mockRegisterUseCase(tRequest)).called(1);
  });

  test('should emit [RegisterLoading, RegisterError] when registration fails', () async {
    const errorMessage = 'Username already exists';
    when(() => mockRegisterUseCase(any()))
        .thenAnswer((_) async => const Error(ServerFailure(errorMessage)));

    final expectedStates = <RegisterState>[];
    registerNotifier.addListener((state) {
      expectedStates.add(state);
    });

    await registerNotifier.register(tRequest);

    expect(expectedStates, [
      const RegisterInitial(),
      const RegisterLoading(),
      const RegisterError(errorMessage),
    ]);
    verify(() => mockRegisterUseCase(tRequest)).called(1);
  });

  test('reset should transition state back to RegisterInitial', () async {
    when(() => mockRegisterUseCase(any()))
        .thenAnswer((_) async => const Success(null));

    await registerNotifier.register(tRequest);
    expect(registerNotifier.state, const RegisterSuccess());

    registerNotifier.reset();
    expect(registerNotifier.state, const RegisterInitial());
  });
}
