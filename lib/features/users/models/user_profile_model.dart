import 'dart:convert';

class UserProfileModel {
  final String uid;
  final String email;
  final String name;
  final String bio;
  final String link;
  final bool? hasAvatar;

  UserProfileModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.bio,
    required this.link,
    required this.hasAvatar,
  });

  UserProfileModel.empty()
    : uid = '',
      email = '',
      name = '',
      bio = '',
      link = '',
      hasAvatar = false;

  UserProfileModel.fromJson(Map<String, dynamic> json)
    : uid = json["uid"],
      email = json["email"],
      name = json["name"],
      bio = json["bio"],
      link = json["link"],
      hasAvatar = json["hasAvatar"];

  Map<String, String> toJson() {
    return {
      "uid": uid,
      "email": email,
      "name": name,
      "bio": bio,
      "link": link,
    };
  }

  // bio JSON에서 intro 값 가져오기
  String? get bioIntro {
    try {
      if (bio.isEmpty || bio == 'undefined') return null;
      final bioJson =
          jsonDecode(bio) as Map<String, dynamic>;
      return bioJson["intro"] as String?;
    } catch (e) {
      return null;
    }
  }

  // bio JSON에서 birthday 값 가져오기
  String? get bioBirthday {
    try {
      if (bio.isEmpty || bio == 'undefined') return null;
      final bioJson =
          jsonDecode(bio) as Map<String, dynamic>;
      return bioJson["birthday"] as String?;
    } catch (e) {
      return null;
    }
  }

  // intro만 업데이트하고 birthday는 유지하는 헬퍼
  String updateBioIntro(String newIntro) {
    try {
      Map<String, dynamic> bioJson;

      // 기존 bio가 있으면 파싱, 없으면 새로 생성
      if (bio.isNotEmpty && bio != 'undefined') {
        bioJson = jsonDecode(bio) as Map<String, dynamic>;
      } else {
        bioJson = {};
      }

      // intro 업데이트 (birthday는 그대로 유지)
      bioJson["intro"] = newIntro;

      return jsonEncode(bioJson);
    } catch (e) {
      // 파싱 실패 시 새로 생성
      return jsonEncode({"intro": newIntro});
    }
  }

  UserProfileModel copyWith({
    String? uid,
    String? email,
    String? name,
    String? bio,
    String? link,
    bool? hasAvatar,
  }) {
    return UserProfileModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      name: name ?? this.name,
      bio: bio ?? this.bio,
      link: link ?? this.link,
      hasAvatar: hasAvatar ?? this.hasAvatar,
    );
  }
}
