/// Result of the last finished full synchronisation (backend `lastFullSync`).
class VectorSyncRun {
  final DateTime? finishedAt;
  final int synced;
  final int failed;
  final int removedOrphans;

  const VectorSyncRun({
    required this.finishedAt,
    required this.synced,
    required this.failed,
    required this.removedOrphans,
  });

  factory VectorSyncRun.fromJson(Map<String, dynamic> json) {
    return VectorSyncRun(
      finishedAt: DateTime.tryParse(json['finishedAt'] as String? ?? ''),
      synced: (json['synced'] as num?)?.toInt() ?? 0,
      failed: (json['failed'] as num?)?.toInt() ?? 0,
      removedOrphans: (json['removedOrphans'] as num?)?.toInt() ?? 0,
    );
  }
}

/// `GET /api/recommendations/sync/status`: tracks in SQL against the vectors in
/// Elasticsearch.
class VectorSyncStatus {
  final int sqlTracks;

  /// Null when the backend could not reach Elasticsearch.
  final int? indexedVectors;
  final bool inSync;
  final bool syncRunning;

  /// Null until a full synchronisation has finished since the backend started.
  final VectorSyncRun? lastFullSync;

  const VectorSyncStatus({
    required this.sqlTracks,
    required this.indexedVectors,
    required this.inSync,
    required this.syncRunning,
    required this.lastFullSync,
  });

  /// How many tracks have no vector yet (0 when unknown or complete).
  int get missingVectors {
    final indexed = indexedVectors;
    if (indexed == null) return 0;
    return sqlTracks > indexed ? sqlTracks - indexed : 0;
  }

  factory VectorSyncStatus.fromJson(Map<String, dynamic> json) {
    final last = json['lastFullSync'];

    return VectorSyncStatus(
      sqlTracks: (json['sqlTracks'] as num?)?.toInt() ?? 0,
      indexedVectors: (json['indexedVectors'] as num?)?.toInt(),
      inSync: json['inSync'] as bool? ?? false,
      syncRunning: json['syncRunning'] as bool? ?? false,
      lastFullSync:
          last is Map<String, dynamic> ? VectorSyncRun.fromJson(last) : null,
    );
  }
}
