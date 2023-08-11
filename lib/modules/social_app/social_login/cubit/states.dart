abstract class SocialLoginStates {}

class SocialLoginInitialState extends SocialLoginStates {}

class SocialLoginLoadingState extends SocialLoginStates {}

class SocialLoginSuccessState extends SocialLoginStates
{
  final String uId;

  SocialLoginSuccessState(this.uId);
}

class SocialGoogleLoginSuccessState extends SocialLoginStates
{
  final String uId;

  SocialGoogleLoginSuccessState(this.uId);
}
class SocialLoginErrorState extends SocialLoginStates
{
  final String error;

  SocialLoginErrorState(this.error);
}

class SocialChangePasswordVisibilityState extends SocialLoginStates {}

class SocialPassResentLoadingState extends SocialLoginStates {}

class SocialPassResentErrorState extends SocialLoginStates {
  final String error;

  SocialPassResentErrorState(this.error);
}

class SocialPassResentSuccessState extends SocialLoginStates {
}