import '../../domain/models/user_profile.dart';

class UserProfileState {
  final UserProfile? profile;
  final bool isEditing;

  const UserProfileState({this.profile, this.isEditing = false});

  UserProfileState copyWith({UserProfile? profile, bool? isEditing}) {
    return UserProfileState(
      profile: profile ?? this.profile,
      isEditing: isEditing ?? this.isEditing,
    );
  }
}
