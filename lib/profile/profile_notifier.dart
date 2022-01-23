import 'package:dm_delights/core/infrastructure.dart';
import 'package:dm_delights/profile/profile.dart';
import 'package:flutter/widgets.dart';

class ProfileNotifier extends ChangeNotifier {
  Profile? profile;
  final firestore = Infrastructure.firestore;
  final auth = Infrastructure.auth;

  ProfileNotifier() {
    listen();
  }

  void listen() {
    final userId = auth.currentUser?.uid;
    if (userId != null) {
      firestore.collection("users").doc(userId).snapshots().listen((event) {
        final data = event.data();
        if (data != null) {
          Profile _profile = Profile.fromMap(data);
          profile = _profile;
          notifyListeners();
        }
      });
    }
  }

  Future<void> update(Map<String, dynamic> doc) async {
    final userId = auth.currentUser?.uid;
    if (userId != null) {
      return await firestore.collection("users").doc(userId).update(doc);
    }
    return;
  }
}
