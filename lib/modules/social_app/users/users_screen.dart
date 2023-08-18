import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test123/layout/social_app/social_layout.dart';
import 'package:test123/modules/social_app/visit_profile/visit_profile_screen.dart';
import 'package:test123/shared/styles/colors.dart';
import 'package:test123/shared/styles/icon_broken.dart';

import '../../../layout/social_app/cubit/cubit.dart';
import '../../../layout/social_app/cubit/states.dart';
import '../../../models/social_app/social_user_model.dart';
import '../../../shared/components/components.dart';

class UsersScreen extends StatelessWidget
{
  @override
  Widget build(BuildContext context)
  {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = SocialCubit.get(context);

        return ConditionalBuilder(
            condition: state is !SocialSearchLoadingState,
            builder:(context) => cubit.searchUsers !=null ? searchController.text.isEmpty ? buildNoContent():
            ListView.separated(
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) =>
                  buildSearchItem(SocialCubit.get(context).searchUsers![index], context),
              separatorBuilder: (context, index) => myDivider(),
              itemCount: SocialCubit.get(context).searchUsers!.length,
            ) :buildNoContent() ,
            fallback:(context) => const Center(child: CircularProgressIndicator(),));
      },
    );
  }
}

Widget buildSearchItem(SocialUserModel model, context) =>
    InkWell(
      onTap: (){
        SocialCubit.get(context).getProfile(model.uId);
        navigateTo(context, VisitProfileScreen());
      },
      child: Padding(
  padding: const EdgeInsets.all(20.0),
  child: Row(
      children: [
        CircleAvatar(
          radius: 25.0,
          backgroundImage: NetworkImage(
            '${model.image}',
          ),
        ),
        const SizedBox(
          width: 15.0,
        ),
        Text(
          '${model.name}',
          style: const TextStyle(
            height: 1.4,
          ),
        ),
      ],
  ),
),
    );


Container buildNoContent(){
  return Container(
    child: Center(
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
          children: const [
            Icon(IconBroken.Search,size: 200,color: defaultColor,),
            Text('Find Users',textAlign: TextAlign.center,style: TextStyle(color: Colors.grey,fontSize: 40,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),),
          ]),
    ),
  );
}