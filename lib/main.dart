import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test123/shared/bloc_observer.dart';
import 'package:test123/shared/components/components.dart';
import 'package:test123/shared/components/constants.dart';
import 'package:test123/shared/network/local/cache_helper.dart';
import 'package:test123/shared/styles/themes.dart';
import 'layout/social_app/cubit/cubit.dart';
import 'layout/social_app/cubit/states.dart';
import 'layout/social_app/social_layout.dart';
import 'modules/social_app/social_login/social_login_screen.dart';



Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async
{
  //print('on background message');
  print(message.data.toString());

  showToast(text: 'on background message', state: ToastStates.SUCCESS,);
}




void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  var token = await FirebaseMessaging.instance.getToken();


  // foreground fcm
  FirebaseMessaging.onMessage.listen((event)
  {
    //print('on message');
    print(event.data.toString());

    showToast(text: 'on message', state: ToastStates.SUCCESS,);
  });

  // when click on notification to open app
  FirebaseMessaging.onMessageOpenedApp.listen((event)
  {
   // print('on message opened app');
    print(event.data.toString());

    showToast(text: 'on message opened app', state: ToastStates.SUCCESS,);
  });

  // background fcm
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);



  // FirebaseAuth.instance.authStateChanges().listen((user) {
  //   if (user == null) {
  //     initialPage = SocialLoginScreen();
  //   } else {
  //     initialPage = SocialLayout();
  //   }
  // });

  await CacheHelper.init();
  Widget widget;
  Bloc.observer = MyBlocObserver();
  uId = CacheHelper.getData(key: 'uId');


  if(uId != null)
  {
    widget = SocialLayout();
  } else
  {
    widget = SocialLoginScreen();
  }

  runApp(MyApp(startWidget: widget,));
}

class MyApp extends StatelessWidget {

  final Widget startWidget;
  final bool? isDark;

  MyApp({
    required this.startWidget,   this.isDark,
  });
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) => SocialCubit()..getPosts()..getStories()..getUserData()..getUsers(),
        ),
      ],
      child: BlocConsumer<SocialCubit, SocialStates>(
        listener: (context,state){},
        builder: (context,state){
          return MaterialApp(
            theme: lightTheme,
            themeMode:ThemeMode.light,
            home: startWidget,
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}



