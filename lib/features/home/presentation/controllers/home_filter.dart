import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Which sections the Home feed shows (the filter chips).
enum HomeFilter {
  /// Recommendations, trending and featured albums.
  all,

  /// Only the "Gợi ý cho bạn" list, as a full vertical list.
  recommended,

  /// Only the "Thịnh hành" list.
  trending,

  /// Only the featured albums, paged with infinite scroll.
  albums,
}

/// The selected chip. autoDispose: leaving Home resets it to [HomeFilter.all].
final homeFilterProvider = StateProvider.autoDispose<HomeFilter>(
  (ref) => HomeFilter.all,
);
