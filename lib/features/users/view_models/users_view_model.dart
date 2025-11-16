import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/authentication/view_models/signup_view_model.dart';
import 'package:tiktok_clone/features/users/Repose/user_repo.dart';
import 'package:tiktok_clone/features/users/models/user_profile_model.dart';

class UsersViewModel
    extends AsyncNotifier<UserProfileModel> {
  late final UserRepository _repository;

  @override
  FutureOr<UserProfileModel> build() {
    _repository = ref.read(userRepo);
    return UserProfileModel.empty();
  }

  Future<void> createProfile(
    UserCredential credential,
  ) async {
    state = const AsyncValue.loading();
    final form = ref.read(signUpForm);
    final name = form["name"] as String?;
    final bio = form["bio"] as String?;

    print("signUpForm 전체: $form");
    print("name 값: $name");
    print("bio 값: $bio");

    final profile = UserProfileModel(
      uid: credential.user!.uid,
      email: credential.user!.email ?? "anon@anon.com",
      name: name ?? "Anon",
      bio: bio ?? "undefined",
      link: 'undefined',
    );
    await _repository.createProfile(profile);
    state = AsyncValue.data(profile);
  }
}

final usersProvider =
    AsyncNotifierProvider<UsersViewModel, UserProfileModel>(
      () => UsersViewModel(),
    );
