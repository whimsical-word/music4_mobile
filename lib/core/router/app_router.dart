import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'route_names.dart';

import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/user_profile_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/history/presentation/screens/history_screen.dart';
import '../../features/artist_profile/presentation/screens/artist_profile_screen.dart';
import '../../features/player/presentation/screens/music_player_screen.dart';
import '../../features/upload/presentation/screens/upload_track_screen.dart';
import '../../features/playlist/presentation/screens/playlist_screen.dart';
import '../../features/playlist/presentation/screens/playlist_detail_screen.dart';
import '../../features/favorites/presentation/screens/favorites_screen.dart';
import '../../features/track_detail/presentation/screens/track_detail_screen.dart';
import '../../features/album/presentation/screens/album_detail_screen.dart';
import '../../features/search/presentation/screens/search_screen.dart';
import '../../features/notifications/presentation/screens/notification_screen.dart';
import '../../features/categories/presentation/screens/category_detail_screen.dart';
import '../../features/admin/presentation/screens/admin_dashboard_screen.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: RouteNames.home,
  routes: [
    // ─── T3: Home & Discovery ────────────────────────────────────────────
    GoRoute(
      path: RouteNames.home,
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: RouteNames.history,
      name: 'history',
      builder: (context, state) => const HistoryScreen(),
    ),
    GoRoute(
      path: RouteNames.artistProfile,
      name: 'artistProfile',
      builder: (context, state) =>
          ArtistProfileScreen(artistId: state.pathParameters['id']),
    ),

    // ─── T2: Auth & Profile ──────────────────────────────────────────────
    GoRoute(
      path: RouteNames.login,
      name: 'login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: RouteNames.register,
      name: 'register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: RouteNames.profile,
      name: 'profile',
      builder: (context, state) => const UserProfileScreen(),
    ),

    // ─── T1: Player & Upload ─────────────────────────────────────────────
    GoRoute(
      path: RouteNames.player,
      name: 'player',
      builder: (context, state) => const MusicPlayerScreen(),
    ),
    GoRoute(
      path: RouteNames.upload,
      name: 'upload',
      builder: (context, state) => const UploadTrackScreen(),
    ),

    // ─── T5: Content & Engagement ────────────────────────────────────────
    GoRoute(
      path: RouteNames.trackDetail,
      name: 'trackDetail',
      builder: (context, state) =>
          TrackDetailScreen(trackId: state.pathParameters['id']),
    ),
    GoRoute(
      path: RouteNames.albumDetail,
      name: 'albumDetail',
      builder: (context, state) =>
          AlbumDetailScreen(albumId: state.pathParameters['id']),
    ),
    GoRoute(
      path: RouteNames.playlist,
      name: 'playlist',
      builder: (context, state) => const PlaylistScreen(),
    ),
    GoRoute(
      path: RouteNames.playlistDetail,
      name: 'playlistDetail',
      builder: (context, state) =>
          PlaylistDetailScreen(playlistId: state.pathParameters['id']),
    ),
    GoRoute(
      path: RouteNames.favorites,
      name: 'favorites',
      builder: (context, state) => const FavoritesScreen(),
    ),

    // ─── T6: Search, Admin & Core ────────────────────────────────────────
    GoRoute(
      path: RouteNames.search,
      name: 'search',
      builder: (context, state) => const SearchScreen(),
    ),
    GoRoute(
      path: RouteNames.notifications,
      name: 'notifications',
      builder: (context, state) => const NotificationScreen(),
    ),
    GoRoute(
      path: RouteNames.categoryDetail,
      name: 'categoryDetail',
      builder: (context, state) =>
          CategoryDetailScreen(categoryId: state.pathParameters['id']),
    ),
    GoRoute(
      path: RouteNames.admin,
      name: 'admin',
      builder: (context, state) => const AdminDashboardScreen(),
    ),
  ],
);
