// ignore_for_file: unnecessary_nullable_for_final_variable_declarations, await_only_futures

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthProvider {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Singleton instance of GoogleSignIn
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  bool _isGoogleInitialized = false;

  String? _verificationId;

  AuthProvider();

  /// Initialize GoogleSignIn. Provide your OAuth client IDs if needed.
  Future<void> initializeGoogle({
    String? clientId,
    String? serverClientId,
    List<String>? scopes,
  }) async {
    if (!_isGoogleInitialized) {
      await _googleSignIn.initialize(
        clientId: clientId,
        serverClientId: serverClientId,
      );
      _isGoogleInitialized = true;
    }
  }

  /// GOOGLE LOGIN
  Future<UserCredential> googleLogin() async {
    // Initialize (only once)
    // **Important**: For google_sign_in >= 7.0.0, on Android you often need to pass your Web Client ID
    // via serverClientId so that idToken is returned. :contentReference[oaicite:0]{index=0}
    await initializeGoogle(
      serverClientId: 'YOUR_WEB_OAUTH_CLIENT_ID.apps.googleusercontent.com',
      scopes: ['email', 'openid', 'profile'], // or any scopes you need
    );

    // Start authentication (sign-in + optionally request authorization)
    final GoogleSignInAccount? googleUser = await _googleSignIn.authenticate(
      scopeHint: ['email', 'openid', 'profile'],
    );

    if (googleUser == null) {
      throw Exception("Google Sign-In cancelled by user.");
    }

    // After sign in, you can (optionally) request authorization for more scopes
    // to get an accessToken. In new API, authentication (sign in) and authorization (scopes) are separated.
    final GoogleSignInClientAuthorization authorization = await googleUser
        .authorizationClient
        .authorizeScopes(['email', 'openid', 'profile']);

    // Now you can get accessToken from the authorization object
    final String? accessToken = authorization.accessToken;
    final String? idToken = (await googleUser.authentication).idToken;

    if (idToken == null) {
      throw Exception("Failed to get ID Token from Google.");
    }

    // Create a credential for Firebase
    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: accessToken,
      idToken: idToken,
    );

    // Sign in with Firebase
    return await _auth.signInWithCredential(credential);
  }

  /// ---------------------------------------------------------
  /// PHONE LOGIN (SEND OTP)
  Future<void> phoneSignIn(String phone) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        throw e.message ?? "Phone verification failed";
      },
      codeSent: (String id, int? token) {
        _verificationId = id;
      },
      codeAutoRetrievalTimeout: (String id) {
        _verificationId = id;
      },
    );
  }

  /// VERIFY OTP
  Future<UserCredential> verifyOTP(String otp) async {
    if (_verificationId == null) {
      throw Exception("Verification ID is null. Request OTP again.");
    }

    final PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: _verificationId!,
      smsCode: otp,
    );

    return await _auth.signInWithCredential(credential);
  }

  /// EMAIL LOGIN
  Future<UserCredential> loginWithEmail(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  /// LOGOUT
  Future<void> logout() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }
}
