import 'package:flutter/rendering.dart';

class FirebaseUser{
  late String displayName;
  late String email;
  late String photoUrl;
  late String uid;

  FirebaseUser({
    required this.displayName,
    required this.email,
    required this.photoUrl,
    required this.uid,
  });
}