import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test123/modules/social_app/notifications/notifications_screen.dart';

import '../../modules/social_app/new_post/new_post_screen.dart';
import '../../shared/components/components.dart';
import '../../shared/styles/icon_broken.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';
var searchController =TextEditingController();

class SocialLayout extends StatelessWidget {


  Widget searchWidget(context){
    return SizedBox(
      height: 52,
      child: TextFormField(
        controller: searchController,
        onChanged:(value) {
          SocialCubit.get(context).search(value);
        } ,
        style: const TextStyle(color: Colors.black),
        decoration:  InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30)
          ),
          hintText: 'Search for a user',
          prefixIcon: const Icon(IconBroken.Search),
          suffixIcon: IconButton(onPressed: (){
            searchController.text='';
            SocialCubit.get(context).emit(SocialSearchSuccessState());
          }, icon: const Icon(Icons.clear,color: Colors.grey,)),
        ),
      ),
    );
  }


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
          appBar: cubit.currentIndex == 3 ?
          AppBar(
           title: searchWidget(context) ,
          ) : 
          AppBar(
            title: cubit.appbarTitles[cubit.currentIndex],
            actions: [
                IconButton(
                  icon: const Icon(
                    IconBroken.Notification,
                  ),
                  onPressed: () {
                    SocialCubit.get(context).getNotification();
                    navigateTo(context, NotificationsScreen());
                  },
                ),
              const SizedBox(width: 5,)
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
                activeIcon: Icon(IconBroken.Home,size: 25,),
                icon: Icon(
                  IconBroken.Home,
                  size: 22,
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                activeIcon: Icon(IconBroken.Chat,size: 25,),
                icon: Icon(
                  IconBroken.Chat,
                  size: 22,
                ),
                label: 'Chats',
              ),
              BottomNavigationBarItem(
                activeIcon: Icon(IconBroken.Paper_Upload,size: 25,),
                icon: Icon(
                  IconBroken.Paper_Upload,
                  size: 25,
                ),
                label: 'Post',
              ),
              BottomNavigationBarItem(
                activeIcon: Icon(IconBroken.Search,size: 25,),
                icon: Icon(
                  IconBroken.Search,
                  size: 22,
                ),
                label: 'Users',
              ),
              BottomNavigationBarItem(
                activeIcon: Icon(IconBroken.Profile,size: 25,),
                icon: Icon(
                  IconBroken.Profile,
                  size: 22,
                ),
                label: 'Profile',
              ),
            ],
          ),
        );
      },
    );
  }
}


