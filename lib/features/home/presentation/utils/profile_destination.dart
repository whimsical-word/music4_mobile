import '../../../../core/router/route_names.dart';
import '../../../auth/presentation/notifiers/auth_state.dart';

/// Where the profile icon of the Home app bar leads.
///
/// - Artist account -> their own Artist Profile (`/artist/{id}`). The listener
///   profile (`/api/users/{id}`) is for listeners only: an artist's id belongs
///   to the artists table, so it would load the wrong user.
/// - Listener or guest -> the listener profile.
String profileRouteFor(AuthState auth) {
  if (auth is AuthAuthenticated && auth.user.isArtist) {
    return RouteNames.artistProfile.replaceFirst(
      ':id',
      auth.user.id.toString(),
    );
  }
  return RouteNames.userProfile;
}
