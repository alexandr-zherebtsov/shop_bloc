class UserModel {
  String? uid;
  String? name;
  String? email;
  String? phone;

  UserModel({
    this.uid,
    this.name,
    this.email,
    this.phone,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uid'] = uid;
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    return data;
  }

  UserModel copyWith({
    final String? uid,
    final String? name,
    final String? email,
    final String? phone,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
    );
  }
}
