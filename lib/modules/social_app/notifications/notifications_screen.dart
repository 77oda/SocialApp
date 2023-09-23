import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test123/models/social_app/notification_model.dart';
import 'package:test123/modules/social_app/post_details/post_details_screen.dart';
import 'package:test123/shared/components/constants.dart';
import 'package:video_player/video_player.dart';
import '../../../layout/social_app/cubit/cubit.dart';
import '../../../layout/social_app/cubit/states.dart';
import '../../../shared/components/components.dart';
import '../../../shared/styles/colors.dart';
import '../../../shared/styles/icon_broken.dart';
class NotificationsScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Notifications'),
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                IconBroken.Arrow___Left_2,
              ),
            ),
            titleSpacing: 5.0,
          ),
          body:ConditionalBuilder(
              condition: state is! SocialGetNotificationsLoadingState,
              builder: (context) => SocialCubit.get(context).notificationModel!=null ?
              Padding(
                  padding:const EdgeInsets.all(5.0),
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index)
                  {
                   var notification= SocialCubit.get(context).notificationModel[index] ;
                   print('${notification.data}');
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      itemBuilder: (context, index)
                      {
                        return buildNotify(context,notification.data[index]);
                      },
                      itemCount:notification.data.length,
                    );
                  },
                  itemCount:SocialCubit.get(context).notificationModel!.length,
                ),
          ):
              const Center(child: Text('No notification',textAlign: TextAlign.center,style: TextStyle(color: Colors.grey,fontSize: 20,fontWeight: FontWeight.bold,),)),
              fallback: (context) =>const Center(child: CircularProgressIndicator())
          )
        );
      },
    );
  }


  Widget buildNotify(context , NotifyModel model) {
    DateTime? t = DateTime.parse(model.dateTime =='' ? '2023-08-19 02:12:20.793225':"${model.dateTime}");
    String? time= convertToAgo(t);
    return InkWell(
      onTap: (){
        SocialCubit.get(context).getPostDetails('${model.postId}');
        navigateTo(context, PostDetailsScreen(postId: model.postId,));
      },
      child: Column(
        children: [
          ListTile(
            title: RichText(
                overflow: TextOverflow.ellipsis,
                text: TextSpan(
                    style: Theme.of(context).textTheme.bodyText1,
                    children: [
                      TextSpan(
                          text: model.name,
                        style:Theme.of(context).textTheme.bodyText1,
                      ),
                      TextSpan(
                        text: model.type=='like' ? '  Liked your post' : '  replied: ${model.comment}',
                        style:Theme.of(context).textTheme.bodyText2,
                      )
                    ]
                )),
            subtitle: Text(model.dateTime=='' ? '' : time,
              overflow: TextOverflow.ellipsis,
            ),
            leading:  CircleAvatar(
              radius: 30.0,
              backgroundImage: NetworkImage(
                '${model.image}',
              ),
            ),
          ),
          myDivider(),
        ],
      ),
    );}
}

