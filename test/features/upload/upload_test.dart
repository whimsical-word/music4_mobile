import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:music4_mobile/features/upload/data/repositories/upload_repository.dart';
import 'package:music4_mobile/features/upload/presentation/providers/upload_provider.dart';

class MockDio extends Mock implements Dio {}
class MockUploadRepository extends Mock implements UploadRepository {}

void main() {
  late MockDio mockDio;
  late UploadRepository uploadRepository;
  late File dummyAudio;
  late File dummyCover;

  setUpAll(() async {
    registerFallbackValue(RequestOptions(path: ''));
    registerFallbackValue(FormData());
    registerFallbackValue(Options());

    final tempDir = Directory.systemTemp.createTempSync('upload_test_');
    dummyAudio = File('${tempDir.path}/test_audio.mp3')..writeAsStringSync('dummy audio content');
    dummyCover = File('${tempDir.path}/test_cover.png')..writeAsStringSync('dummy cover content');
  });

  setUp(() {
    mockDio = MockDio();
    uploadRepository = UploadRepository(mockDio);
  });

  group('[CE190036] UploadRepository Unit Tests UC41 UC46', () {
    test('uploadTrack sends multipart request to /api/tracks successfully', () async {
      when(() => mockDio.post(
            '/api/tracks',
            data: any(named: 'data'),
            onSendProgress: any(named: 'onSendProgress'),
            options: any(named: 'options'),
          )).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/api/tracks'),
          statusCode: 200,
          data: {'id': 100, 'title': 'Test Song'},
        ),
      );

      await expectLater(
        uploadRepository.uploadTrack(
          title: 'Test Song',
          categoryIds: [1],
          albumId: '2',
          artistIds: [2],
          audioFilePath: dummyAudio.path,
          coverFilePath: dummyCover.path,
        ),
        completes,
      );

      verify(() => mockDio.post(
            '/api/tracks',
            data: any(named: 'data'),
            onSendProgress: any(named: 'onSendProgress'),
            options: any(named: 'options'),
          )).called(1);
    });

    test('uploadTrack handles 400 Bad Request with server message', () async {
      when(() => mockDio.post(
            '/api/tracks',
            data: any(named: 'data'),
            onSendProgress: any(named: 'onSendProgress'),
            options: any(named: 'options'),
          )).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/api/tracks'),
          response: Response(
            requestOptions: RequestOptions(path: '/api/tracks'),
            statusCode: 400,
            data: {'message': 'Tên bài hát đã tồn tại!'},
          ),
          type: DioExceptionType.badResponse,
        ),
      );

      expect(
        () => uploadRepository.uploadTrack(
          title: 'Existing Song',
          categoryIds: [1],
          audioFilePath: dummyAudio.path,
          coverFilePath: dummyCover.path,
        ),
        throwsA(predicate((e) => e.toString().contains('Tên bài hát đã tồn tại!'))),
      );
    });

    test('uploadTrack handles 413 Payload Too Large', () async {
      when(() => mockDio.post(
            '/api/tracks',
            data: any(named: 'data'),
            onSendProgress: any(named: 'onSendProgress'),
            options: any(named: 'options'),
          )).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/api/tracks'),
          response: Response(
            requestOptions: RequestOptions(path: '/api/tracks'),
            statusCode: 413,
          ),
          type: DioExceptionType.badResponse,
        ),
      );

      expect(
        () => uploadRepository.uploadTrack(
          title: 'Large Song',
          categoryIds: [1],
          audioFilePath: dummyAudio.path,
          coverFilePath: dummyCover.path,
        ),
        throwsA(predicate((e) => e.toString().contains('vượt quá dung lượng'))),
      );
    });
  });

  group('[CE190036] UploadNotifier Unit Tests UC41 UC46', () {
    late MockUploadRepository mockRepo;
    late UploadNotifier notifier;

    setUp(() {
      mockRepo = MockUploadRepository();
      notifier = UploadNotifier(mockRepo);
    });

    test('initial state has default values', () {
      expect(notifier.state.isLoading, false);
      expect(notifier.state.progress, 0.0);
      expect(notifier.state.isSuccess, false);
      expect(notifier.state.error, isNull);
    });

    test('uploadTrack success updates state to isSuccess = true and progress = 1.0', () async {
      when(() => mockRepo.uploadTrack(
            title: any(named: 'title'),
            categoryIds: any(named: 'categoryIds'),
            albumId: any(named: 'albumId'),
            artistIds: any(named: 'artistIds'),
            audioFilePath: any(named: 'audioFilePath'),
            coverFilePath: any(named: 'coverFilePath'),
            onSendProgress: any(named: 'onSendProgress'),
          )).thenAnswer((invocation) async {
        final progressCb = invocation.namedArguments[#onSendProgress] as void Function(int, int)?;
        progressCb?.call(50, 100);
      });

      await notifier.uploadTrack(
        title: 'New Track',
        categoryIds: [1],
        audioFilePath: dummyAudio.path,
        coverFilePath: dummyCover.path,
      );

      expect(notifier.state.isLoading, false);
      expect(notifier.state.isSuccess, true);
      expect(notifier.state.progress, 1.0);
      expect(notifier.state.error, isNull);
    });

    test('uploadTrack failure updates error and sets isLoading = false', () async {
      when(() => mockRepo.uploadTrack(
            title: any(named: 'title'),
            categoryIds: any(named: 'categoryIds'),
            albumId: any(named: 'albumId'),
            artistIds: any(named: 'artistIds'),
            audioFilePath: any(named: 'audioFilePath'),
            coverFilePath: any(named: 'coverFilePath'),
            onSendProgress: any(named: 'onSendProgress'),
          )).thenThrow(Exception('Lỗi mạng giả lập'));

      await notifier.uploadTrack(
        title: 'New Track',
        categoryIds: [1],
        audioFilePath: dummyAudio.path,
        coverFilePath: dummyCover.path,
      );

      expect(notifier.state.isLoading, false);
      expect(notifier.state.isSuccess, false);
      expect(notifier.state.error, contains('Lỗi mạng giả lập'));
    });

    test('reset clears error and returns state to initial', () {
      notifier.reset();
      expect(notifier.state.isLoading, false);
      expect(notifier.state.progress, 0.0);
      expect(notifier.state.isSuccess, false);
      expect(notifier.state.error, isNull);
    });
  });
}
