import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/authentication/view_models/signup_view_model.dart';
import 'package:tiktok_clone/features/repos/authentication_repos.dart';
import 'package:tiktok_clone/features/users/Repose/user_repo.dart';
import 'package:tiktok_clone/features/users/models/user_profile_model.dart';

class UsersViewModel
    extends AsyncNotifier<UserProfileModel> {
  late final UserRepository _userRepository;
  late final AuthenticationRespository
  _authenticationRespository;

  @override
  FutureOr<UserProfileModel> build() async {
    _userRepository = ref.read(userRepo);
    _authenticationRespository = ref.read(authRepo);

    if (_authenticationRespository.isLoggedIn) {
      final profile = await _userRepository.findProfile(
        _authenticationRespository.user!.uid,
      );

      if (profile != null) {
        return UserProfileModel.fromJson(profile);
      }
    }
    return UserProfileModel.empty();
  }

  Future<void> createProfile(
    UserCredential credential,
  ) async {
    state = const AsyncValue.loading();
    final form = ref.read(signUpForm);
    final name = form["name"] as String?;
    final bio = form["bio"] as String?;

    final profile = UserProfileModel(
      uid: credential.user!.uid,
      email: credential.user!.email ?? "anon@anon.com",
      name: name ?? "Anon",
      bio: bio ?? "undefined",
      link: 'undefined',
      hasAvatar: false,
    );
    await _userRepository.createProfile(profile);
    state = AsyncValue.data(profile);
  }

  Future<void> onAvatarUpload() async {
    if (state.value == null) return;
    state = AsyncValue.data(
      state.value!.copyWith(hasAvatar: true),
    );
    await _userRepository.updateUser(state.value!.uid, {
      "hasAvatar": true,
    });
  }
}

final usersProvider =
    AsyncNotifierProvider<UsersViewModel, UserProfileModel>(
      () => UsersViewModel(),
    );
