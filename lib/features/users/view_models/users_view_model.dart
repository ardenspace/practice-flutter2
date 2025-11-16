import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/users/models/user_profile_model.dart';

class UsersViewModel
    extends AsyncNotifier<UserProfileModel> {
  @override
  FutureOr<UserProfileModel> build() {
    return UserProfileModel.empty();
  }

  Future<void> createProfile(
    UserCredential credential,
  ) async {
    state = AsyncValue.data(
      UserProfileModel(
        uid: credential.user!.uid,
        email: credential.user!.email ?? "anon@anon.com",
        name: credential.user!.displayName ?? "Anon",
        bio: 'undefined',
        link: 'undefined',
      ),
    );
  }
}

final usersProvider = AsyncNotifierProvider(
  () => UsersViewModel(),
);
