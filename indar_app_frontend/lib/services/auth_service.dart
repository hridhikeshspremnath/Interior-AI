import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'api_service.dart';

class AuthService {
  static final _supabase = Supabase.instance.client;

 static Future<void> login({
  required String email,
  required String password,
}) async {
  await _supabase.auth.signInWithPassword(
    email: email,
    password: password,
  );
  await syncWithBackend();  // ← public now
}

  static Future<void> register({
    required String email,
    required String password,
  }) async {
    await _supabase.auth.signUp(
      email: email,
      password: password,
    );
  }

  static Future<void> signInWithGoogle() async {
    // OAuth is a redirect flow — session is NOT ready after this call
    // StreamBuilder in main.dart picks up the session after redirect
    // and _syncWithBackend is called from there
    await _supabase.auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: 'io.supabase.indar://login-callback',
    );
  }

  static Future<void> logout() async {
    await _supabase.auth.signOut();
  }

  static Future<void> resetPassword(String email) async {
    await _supabase.auth.resetPasswordForEmail(email);
  }

  static Future<void> updateName(String name) async {
    try {
      await ApiService.patch('/api/auth/me/name', body: {'name': name});
    } catch (e) {
      debugPrint('Update name failed: $e');
    }
  }

  // Change from private to public
static Future<void> syncWithBackend() async {
  try {
    await ApiService.get('/api/auth/me');
    debugPrint('Backend sync successful');
  } catch (e) {
    debugPrint('Backend sync failed: $e');
  }
}

  static bool get isLoggedIn =>
      _supabase.auth.currentSession != null;
}