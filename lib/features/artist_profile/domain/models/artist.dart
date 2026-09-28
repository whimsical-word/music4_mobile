class Artist {
  final String id;
  final String name;
  final String bio;
  final String avatarUrl;
  final String coverUrl;
  final int followersCount;

  Artist({
    required this.id,
    required this.name,
    required this.bio,
    required this.avatarUrl,
    required this.coverUrl,
    required this.followersCount,
  });

  Artist copyWith({
    String? id,
    String? name,
    String? bio,
    String? avatarUrl,
    String? coverUrl,
    int? followersCount,
  }) {
    return Artist(
      id: id ?? this.id,
      name: name ?? this.name,
      bio: bio ?? this.bio,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      coverUrl: coverUrl ?? this.coverUrl,
      followersCount: followersCount ?? this.followersCount,
    );
  }
}
