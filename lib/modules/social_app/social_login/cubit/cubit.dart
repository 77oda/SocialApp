import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test123/modules/social_app/social_login/cubit/states.dart';


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
      // print(value.user.email);
      // print(value.user.uid);
      if(FirebaseAuth.instance.currentUser!.emailVerified ==true) {
        emit(SocialLoginSuccessState(value.user!.uid));
      }
      if(FirebaseAuth.instance.currentUser!.emailVerified ==false) {
        emit(SocialLoginErrorState('This email is not verified'));
      }

    }).catchError((error)
    {
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

  // Future<void> logOut() async {
  //   await FirebaseAuth.instance.signOut();
  // }
  //
  // User getLoggedInUser() {
  //   User firebaseUser = FirebaseAuth.instance.currentUser!;
  //   return firebaseUser;
  // }
}