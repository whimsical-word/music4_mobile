import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_names.dart';

/// An artist name that opens that artist's profile (`/artist/{id}`) when
/// tapped. Looks exactly like a plain [Text]; without an [artistId] it IS a
/// plain [Text].
class ArtistNameLink extends StatelessWidget {
  final String text;
  final String? artistId;
  final TextStyle? style;
  final int maxLines;

  const ArtistNameLink({
    super.key,
    required this.text,
    required this.artistId,
    this.style,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    final label = Text(
      text,
      style: style,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
    );

    final id = artistId;
    if (id == null || id.isEmpty) return label;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => context.push(RouteNames.artistProfile.replaceFirst(':id', id)),
      child: label,
    );
  }
}
