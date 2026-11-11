import '../models/home_track_item.dart';

/// Isolated mock presentation data for Week 1 UI task (T3: CE190284).
/// This will be replaced by HomeRepository and real REST API in Week 2 (CP2).
class HomeMockData {
  HomeMockData._();

  static const HomeTrackItem featuredAiTrack = HomeTrackItem(
    id: 'ai-feat-1',
    title: 'Gió Cuốn Hoa Rơi',
    artist: 'Sơn Tùng M-TP & AI Symphony',
    artistId: 'art-1',
    genre: 'Pop / R&B Ballad',
    duration: '3:45',
    playsCount: '1.5M',
    matchPercentage: 98,
  );

  static const List<HomeTrackItem> aiRecommendations = [
    HomeTrackItem(
      id: 'ai-rec-1',
      title: 'Đừng Làm Trái Tim Anh Đau',
      artist: 'Sơn Tùng M-TP',
      artistId: 'art-1',
      genre: 'Pop / R&B',
      duration: '3:32',
      playsCount: '2.4M',
      matchPercentage: 99,
    ),
    HomeTrackItem(
      id: 'ai-rec-2',
      title: 'Chìm Sâu',
      artist: 'RPT MCK ft. Trung Trần',
      artistId: 'art-2',
      genre: 'Hip-Hop / Rap',
      duration: '2:56',
      playsCount: '1.8M',
      matchPercentage: 95,
    ),
    HomeTrackItem(
      id: 'ai-rec-3',
      title: 'Nấu Ăn Cho Em',
      artist: 'Đen ft. PiaLinh',
      artistId: 'art-3',
      genre: 'Acoustic / Rap',
      duration: '4:15',
      playsCount: '3.1M',
      matchPercentage: 93,
    ),
    HomeTrackItem(
      id: 'ai-rec-4',
      title: 'Cắt Đôi Nỗi Sầu',
      artist: 'Tăng Duy Tân',
      artistId: 'art-4',
      genre: 'Dance / Electronic',
      duration: '3:05',
      playsCount: '1.9M',
      matchPercentage: 91,
    ),
    HomeTrackItem(
      id: 'ai-rec-5',
      title: 'Vũ Trụ Có Anh',
      artist: 'Phương Mỹ Chi ft. Pháo',
      artistId: 'art-5',
      genre: 'Folk Pop',
      duration: '3:20',
      playsCount: '1.4M',
      matchPercentage: 88,
    ),
  ];

  static const List<HomeTrackItem> topTrendingTracks = [
    HomeTrackItem(
      id: 'trend-1',
      title: 'Thiên Lý Ơi',
      artist: 'Jack - J97',
      artistId: 'art-6',
      genre: 'Ballad',
      duration: '3:50',
      playsCount: '4.2M',
    ),
    HomeTrackItem(
      id: 'trend-2',
      title: 'Từng Là',
      artist: 'Vũ Cát Tường',
      artistId: 'art-7',
      genre: 'Pop Ballad',
      duration: '3:40',
      playsCount: '3.8M',
    ),
    HomeTrackItem(
      id: 'trend-3',
      title: 'Ngày Đẹp Trời Để Nói Chia Tay',
      artist: 'Lou Hoàng',
      artistId: 'art-8',
      genre: 'R&B / Soul',
      duration: '4:02',
      playsCount: '2.9M',
    ),
    HomeTrackItem(
      id: 'trend-4',
      title: 'Hit Me Up',
      artist: 'Binz ft. Touliver',
      artistId: 'art-9',
      genre: 'Retro Pop / R&B',
      duration: '3:18',
      playsCount: '2.5M',
    ),
    HomeTrackItem(
      id: 'trend-5',
      title: 'Waiting For You',
      artist: 'MONO',
      artistId: 'art-10',
      genre: 'Synth Pop',
      duration: '3:35',
      playsCount: '5.1M',
    ),
  ];
}
