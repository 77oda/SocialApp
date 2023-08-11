import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test123/modules/social_app/social_login/social_login_screen.dart';
import 'package:test123/shared/components/components.dart';

import '../social_login/cubit/cubit.dart';
import '../social_login/cubit/states.dart';

class ForgetPassScreen extends StatelessWidget {

  var emailController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => SocialLoginCubit(),
      child: BlocConsumer<SocialLoginCubit, SocialLoginStates>(
        listener: (context,state){
          if (state is SocialPassResentErrorState) {
            showToast(
              text: state.error,
              state: ToastStates.ERROR,
            );
          }
          if(state is SocialPassResentSuccessState)
          {
            showToast(
              text: 'Password resent link send! \n Check your email',
              state: ToastStates.SUCCESS,
            );
            navigateAndFinish(context, SocialLoginScreen());
            emailController.clear();
          }
        },
        builder:(context,state){
          return Scaffold(
            appBar: AppBar(),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'RESENT PASSWORD',
                      style: Theme.of(context).textTheme.headline4!.copyWith(
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'Enter your email and we will send you a password reset link',
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 30,),
                    defaultFormField(
                        controller: emailController,
                        type: TextInputType.emailAddress,
                        label: 'Email',
                        prefix: Icons.email_outlined,
                        validate: (value) {
                          if (value.isEmpty) {
                            return 'please enter your email address';
                          }
                        }),
                    const SizedBox(height: 30,),
                    ConditionalBuilder(
                      condition: state is! SocialPassResentLoadingState,
                        builder: (context) =>defaultButton(text: 'Resent Password',
                            function: (){
                          if(formKey.currentState!.validate()) {
                            SocialLoginCubit.get(context).passwordResent(emailController.text);
                          }
                            }),
                      fallback: (context) =>
                      const Center(child: CircularProgressIndicator()),
                         )
                  ],
                ),
              ),
            ),
          );
        },

      ),
    );
  }
}
