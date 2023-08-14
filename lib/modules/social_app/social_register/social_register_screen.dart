
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test123/modules/social_app/social_login/social_login_screen.dart';

import '../../../layout/social_app/social_layout.dart';
import '../../../shared/components/components.dart';
import '../../../shared/components/constants.dart';
import '../../../shared/network/local/cache_helper.dart';
import '../../../shared/styles/icon_broken.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';

class SocialRegisterScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => SocialRegisterCubit(),
      child: BlocConsumer<SocialRegisterCubit, SocialRegisterStates>(
        listener: (context, state) {
          if (state is SocialCreateUserSuccessState) {
            showToast(text: 'Check your email and then login', state: ToastStates.SUCCESS);
            CacheHelper.saveData(
              key: 'uId',
              value: SocialRegisterCubit.get(context).id,
            ).then((value)
            {

              uId=SocialRegisterCubit.get(context).id;
              navigateAndFinish(
                context,
                SocialLoginScreen(),
              );
            });

          }
          if (state is SocialRegisterErrorState) {
            showToast(
              text: state.error,
              state: ToastStates.ERROR,
            );

          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  IconBroken.Arrow___Left_2,
                ),
              ),
            ),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'REGISTER',
                          style: Theme.of(context).textTheme.headline4!.copyWith(
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          'Register now to communicate with friends',
                          style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        defaultFormField(
                          controller: nameController,
                          type: TextInputType.name,
                          validate: ( value) {
                            if (value.isEmpty) {
                              return 'please enter your name';
                            }
                            if(value.toString().length < 3){
                              return 'The name is short';
                            }
                          },
                          label: 'User Name',
                          prefix: Icons.person,
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        defaultFormField(
                          controller: emailController,
                          type: TextInputType.emailAddress,
                          validate: ( value) {
                            if (value.isEmpty) {
                              return 'please enter your email address';
                            }
                          },
                          label: 'Email Address',
                          prefix: Icons.email_outlined,
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        defaultFormField(
                          controller: passwordController,
                          type: TextInputType.visiblePassword,
                          suffix: SocialRegisterCubit.get(context).suffix,
                          onSubmit: (value) {},
                          isPassword:
                          SocialRegisterCubit.get(context).isPassword,
                          suffixPressed: () {
                            SocialRegisterCubit.get(context)
                                .changePasswordVisibility();
                          },
                          validate: ( value) {
                            if (value.isEmpty) {
                              return 'password is too short';
                            }
                          },
                          label: 'Password',
                          prefix: Icons.lock_outline,
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        defaultFormField(
                          controller: phoneController,
                          type: TextInputType.phone,
                          validate: ( value) {
                            if (value.isEmpty) {
                              return 'please enter your phone number';
                            }
                            if(value.toString().length != 11  ){
                              return 'Phone number is incorrect';
                            }
                          },
                          label: 'Phone',
                          prefix: Icons.phone,
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        ConditionalBuilder(
                          condition: state is! SocialRegisterLoadingState,
                          builder: (context) => defaultButton(
                            function: () {
                              if (formKey.currentState!.validate()) {
                                SocialRegisterCubit.get(context).userRegister(
                                  name: nameController.text,
                                  email: emailController.text,
                                  password: passwordController.text,
                                  phone: phoneController.text,
                                );
                              }
                            },
                            text: 'register',
                            isUpperCase: true,
                          ),
                          fallback: (context) =>
                              const Center(child: CircularProgressIndicator()),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}