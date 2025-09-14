class UserProfile {
  final String fullName;
  final String nickname;
  final String? email;
  final String? phone;
  final String? gender;
  final String? avatarPath; // local image path or network

  UserProfile({
    required this.fullName,
    required this.nickname,
    this.email,
    this.phone,
    this.gender,
    this.avatarPath,
  });

  Map<String, dynamic> toJson() => {
        'fullName': fullName,
        'nickname': nickname,
        'email': email,
        'phone': phone,
        'gender': gender,
        'avatarPath': avatarPath,
      };

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        fullName: json['fullName'] as String? ?? '',
        nickname: json['nickname'] as String? ?? '',
        email: json['email'] as String?,
        phone: json['phone'] as String?,
        gender: json['gender'] as String?,
        avatarPath: json['avatarPath'] as String?,
      );
}