import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test123/modules/social_app/social_login/cubit/states.dart';

import '../../../../shared/components/constants.dart';

class SocialLoginCubit extends Cubit<SocialLoginStates> {
  SocialLoginCubit() : super(SocialLoginInitialState());

  static SocialLoginCubit get(context) => BlocProvider.of(context);

  void userLogin({
    required String email,
    required String password,
  }) {
    emit(SocialLoginLoadingState());

    FirebaseAuth.instance
        .signInWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((value) {

      if (FirebaseAuth.instance.currentUser!.emailVerified == true) {
        emit(SocialLoginSuccessState(value.user!.uid));
      }
      if (FirebaseAuth.instance.currentUser!.emailVerified == false) {
        emit(SocialLoginErrorState('This email is not verified'));
      }
    }).catchError((error) {
      emit(SocialLoginErrorState(error.toString()));
    });
  }

  IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;

  void changePasswordVisibility() {
    isPassword = !isPassword;
    suffix =
        isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;

    emit(SocialChangePasswordVisibilityState());
  }

  void passwordResent(email) {
    emit(SocialPassResentLoadingState());
    FirebaseAuth.instance.sendPasswordResetEmail(email: email).then((value) {
      emit(SocialPassResentSuccessState());
    }).catchError((error) {
      emit(SocialPassResentErrorState(error.toString()));
    });
  }

  void updateEmailVerivied(){
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .update(
      {'isEmailVerified':true}
    ).then((value) {});
  }

  // Future<void> logOut() async {
  //   await FirebaseAuth.instance.signOut();
  // }
  //
  // User getLoggedInUser() {
  //   User firebaseUser = FirebaseAuth.instance.currentUser!;
  //   return firebaseUser;
  // }

  // Future<UserCredential> signInWithGoogle() async {
  //   // Trigger the authentication flow
  //   final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  //
  //   // Obtain the auth details from the request
  //   final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
  //
  //   // Create a new credential
  //   final credential = GoogleAuthProvider.credential(
  //     accessToken: googleAuth?.accessToken,
  //     idToken: googleAuth?.idToken,
  //   );
  //
  //   // Once signed in, return the UserCredential
  //   return await FirebaseAuth.instance.signInWithCredential(credential);
  // }
}
