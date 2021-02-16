import 'dart:convert';

class User {
  final String id;
  final String username;
  final String email;
  final String lang;
  final int level;
  final String profilePhoto;
  final DateTime createdAt;

  User(
      {this.id,
      this.username,
      this.email,
      this.lang,
      this.level,
      this.profilePhoto,
      this.createdAt});
}
