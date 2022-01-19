import 'package:supabase_flutter/supabase_flutter.dart';

class Backend {
  const Backend._();

  static final instance = Supabase.instance.client;

  static const ANON_KEY =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJvbGUiOiJhbm9uIiwiaWF0IjoxNjQyNTkwMzQwLCJleHAiOjE5NTgxNjYzNDB9.C_ypnSzMz8m6bY7EDgHmS6Mh1fc48j6I-HA5izzC84Q";
  static const URL = "https://fiuopmawkwjgohrrzdxg.supabase.co";
}
