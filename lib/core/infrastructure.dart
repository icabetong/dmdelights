import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class Infrastructure {
  static FirebaseAuth get auth => FirebaseAuth.instance;

  static Future<FirebaseApp> init() async {
    return await Firebase.initializeApp();
  }
}
