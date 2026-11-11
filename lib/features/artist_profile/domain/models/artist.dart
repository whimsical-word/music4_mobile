class Artist {
  final String id;
  final String name;

  /// Resolved image URLs; null when the backend has no image.
  final String? avatarUrl;
  final String? coverUrl;

  /// Null when the backend did not provide it (the header then hides it).
  final int? followersCount;

  Artist({
    required this.id,
    required this.name,
    this.avatarUrl,
    this.coverUrl,
    this.followersCount,
  });

  Artist copyWith({
    String? id,
    String? name,
    String? avatarUrl,
    String? coverUrl,
    int? followersCount,
  }) {
    return Artist(
      id: id ?? this.id,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      coverUrl: coverUrl ?? this.coverUrl,
      followersCount: followersCount ?? this.followersCount,
    );
  }
}
