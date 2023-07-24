import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../modules/social_app/new_post/new_post_screen.dart';
import '../../shared/components/components.dart';
import '../../shared/styles/icon_broken.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';

class SocialLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {
        if (state is SocialNewPostState) {
          navigateTo(
            context,
            NewPostScreen(),
          );
        }
      },
      builder: (context, state) {
        var cubit = SocialCubit.get(context);

        return Scaffold(
          appBar: AppBar(
            title: Text(
              cubit.titles[cubit.currentIndex],
            ),
            actions: [
              IconButton(
                icon: const Icon(
                  IconBroken.Notification,
                ),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(
                  IconBroken.Search,
                ),
                onPressed: () {},
              ),
            ],
          ),
          body: cubit.screens[cubit.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: cubit.currentIndex,
            onTap: (index) {
              cubit.changeBottomNav(index);
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(
                  IconBroken.Home,
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  IconBroken.Chat,
                ),
                label: 'Chats',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  IconBroken.Paper_Upload,
                ),
                label: 'Post',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  IconBroken.Location,
                ),
                label: 'Users',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  IconBroken.Setting,
                ),
                label: 'Settings',
              ),
            ],
          ),
        );
      },
    );
  }
}

// Widget stream() => StreamBuilder(
//       stream: FirebaseAuth.instance.authStateChanges(),
//       builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
//         return ConditionalBuilder(
//             condition: FirebaseAuth.instance.currentUser!.emailVerified == true,
//             builder: (context) => Scaffold(
//                   appBar: AppBar(
//                     title: Text(
//                       cubit.titles[cubit.currentIndex],
//                     ),
//                     actions: [
//                       IconButton(
//                         icon: const Icon(
//                           IconBroken.Notification,
//                         ),
//                         onPressed: () {},
//                       ),
//                       IconButton(
//                         icon: const Icon(
//                           IconBroken.Search,
//                         ),
//                         onPressed: () {},
//                       ),
//                     ],
//                   ),
//                   body: cubit.screens[cubit.currentIndex],
//                   bottomNavigationBar: BottomNavigationBar(
//                     currentIndex: cubit.currentIndex,
//                     onTap: (index) {
//                       cubit.changeBottomNav(index);
//                     },
//                     items: const [
//                       BottomNavigationBarItem(
//                         icon: Icon(
//                           IconBroken.Home,
//                         ),
//                         label: 'Home',
//                       ),
//                       BottomNavigationBarItem(
//                         icon: Icon(
//                           IconBroken.Chat,
//                         ),
//                         label: 'Chats',
//                       ),
//                       BottomNavigationBarItem(
//                         icon: Icon(
//                           IconBroken.Paper_Upload,
//                         ),
//                         label: 'Post',
//                       ),
//                       BottomNavigationBarItem(
//                         icon: Icon(
//                           IconBroken.Location,
//                         ),
//                         label: 'Users',
//                       ),
//                       BottomNavigationBarItem(
//                         icon: Icon(
//                           IconBroken.Setting,
//                         ),
//                         label: 'Settings',
//                       ),
//                     ],
//                   ),
//                 ),
//             fallback: (context) => Scaffold(
//                   appBar: AppBar(
//                     title: const Text('News Feed'),
//                   ),
//                   body: Column(
//                     children: [
//                       Container(
//                         color: Colors.amber.withOpacity(.6),
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                           child: Row(
//                             children: [
//                               const Icon(Icons.info_outline),
//                               const SizedBox(
//                                 width: 5,
//                               ),
//                               const Text('Please Verify Your Email'),
//                               const Spacer(),
//                               const SizedBox(
//                                 width: 15,
//                               ),
//                               TextButton(
//                                 onPressed: () async {
//                                   print(
//                                       '${FirebaseAuth.instance.currentUser!.emailVerified}');
//                                   await FirebaseAuth.instance.currentUser!
//                                       .sendEmailVerification()
//                                       .then((value) {
//                                     showToast(
//                                         text: 'Check Your Mail',
//                                         state: ToastStates.SUCCESS);
//                                   });
//                                 },
//                                 child: const Text('Send'),
//                               ),
//                             ],
//                           ),
//                         ),
//                       )
//                     ],
//                   ),
//                 ));
//       },
//     );
