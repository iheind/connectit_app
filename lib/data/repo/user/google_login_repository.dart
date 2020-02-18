import 'package:connectit_app/data/model/result.dart';
import 'package:connectit_app/data/model/user.dart';
import 'package:connectit_app/data/model/void_result.dart';
import 'package:connectit_app/di/injector.dart';
import 'package:connectit_app/utils/log_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';

import 'base/login_repository.dart';

class GoogleLoginRepository extends LoginRepository {
  final GoogleSignIn _googleSignIn;

  GoogleLoginRepository({@required GoogleSignIn googleSignIn}) : _googleSignIn = googleSignIn;

  @override
  Future<Result<User>> login() async {
    try {
      final googleUser = await _googleSignIn.signIn();

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final firebaseUser = await getFirebaseUser(credential);
      final user = User(
        id: firebaseUser.uid,
        name: firebaseUser.displayName,
        email: firebaseUser.email ?? googleUser.email,
        avatar: firebaseUser.photoUrl.replaceAll('s96-c', 's300-c'),
        provider: LoginProvider.google,
      );
      logger.d(user);
      return registerUser(user);
    } catch (e, s) {
      logger.e(e, s);
      return Result.error('${e?.toString()}');
    }
  }

  @override
  Future<bool> isLoggedIn() => _googleSignIn.isSignedIn();

  @override
  Future<VoidResult> logout() async {
    try {
      await _googleSignIn.signOut();
      return const VoidResult.success();
    } catch (error) {
      return VoidResult.error('${error.message}');
    }
  }
}
