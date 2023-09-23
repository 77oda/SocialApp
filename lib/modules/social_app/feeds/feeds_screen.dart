import 'dart:ui';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test123/models/social_app/story_model.dart';
import 'package:test123/shared/components/components.dart';
import 'package:test123/shared/components/constants.dart';
import 'package:video_viewer/video_viewer.dart';
import '../../../layout/social_app/cubit/cubit.dart';
import '../../../layout/social_app/cubit/states.dart';
import '../../../models/social_app/post_model.dart';
import '../../../shared/styles/colors.dart';
import '../../../shared/styles/icon_broken.dart';
import '../comments/comments_screen.dart';
import '../story/story_screen.dart';
import '../visit_profile/visit_profile_screen.dart';

class FeedsScreen extends StatelessWidget
{
  @override
  Widget build(BuildContext context)
  {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state)
      {
        return RefreshIndicator(
          onRefresh: () async{
            SocialCubit.get(context).getPosts();
            await Future.delayed(const Duration(seconds: 2));
          },
          child:ConditionalBuilder(
            condition: SocialCubit.get(context).posts.isNotEmpty && state is! SocialGetStoryLoadingState ,
            builder: (context) =>
                SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children:
                [
                  Card(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    elevation: 5.0,
                    margin: const EdgeInsets.all(
                      8.0,
                    ),
                    child: Stack(
                      alignment: AlignmentDirectional.bottomEnd,
                      children: [
                        const Image(
                          image: NetworkImage(
                            'https://image.freepik.com/free-photo/horizontal-shot-smiling-curly-haired-woman-indicates-free-space-demonstrates-place-your-advertisement-attracts-attention-sale-wears-green-turtleneck-isolated-vibrant-pink-wall_273609-42770.jpg',
                          ),
                          fit: BoxFit.cover,
                          height: 150.0,
                          width: double.infinity,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 35,horizontal: 10),
                          child: Text(
                            'communicate with friends ',
                            style: Theme.of(context).textTheme.subtitle1!.copyWith(
                              color: Colors.white,
                              fontSize: 14
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 20),
                    child: SizedBox(
                      height: 80,
                      child: Row(
                        children: [
                          InkWell(
                            child: Stack(
                              children: <Widget>[
                                 CircleAvatar(
                                   radius: 40,
                                   backgroundImage: NetworkImage(
                                       "${SocialCubit.get(context).userModel!.image}",),
                                 ),
                                Positioned(
                                  bottom: 0.0,
                                  right: 7,
                                  child: Container(
                                    height: 20,
                                    width: 20,
                                    decoration: const BoxDecoration(
                                      color: defaultColor,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.add,
                                      color: Colors.white,
                                      size: 15,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            onTap: (){
                              SocialCubit.get(context).getStoryImage(context);
                            },
                          ),
                          const SizedBox(width: 10,),
                          Expanded(
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                List<StoryModel> model= SocialCubit.get(context).storyMap[SocialCubit.get(context).idStories[index]] as List<StoryModel>;
                                print(model);
                                return buildStoryItem(model,context) ;
                              },
                              separatorBuilder: (context, index) => const SizedBox(
                                width: 10.0,
                              ),
                              itemCount: SocialCubit.get(context).storyMap.length,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) => buildPostItem(SocialCubit.get(context).posts[index],context,index,SocialCubit.get(context).postsId[index],
                        // SocialCubit.get(context).comments[index]
                    ),
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 8.0,
                    ),
                    itemCount: SocialCubit.get(context).posts.length,
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                ],
              ),
            ),
            fallback: (context) =>const Center(child: CircularProgressIndicator()),
        )
        );
      },
    );
  }

  Widget buildPostItem(PostModel model, context,index,String postId ,
      // String comments
      ) {
    List likes =[];
    model.likes!.forEach((key, value) {
      if(value=='true'){
        likes.add(key);
      }
    });
    return Card(
    clipBehavior: Clip.antiAliasWithSaveLayer,
    elevation: 7.0,
    margin: const EdgeInsets.symmetric(
      horizontal: 10.0,
      vertical: 5
    ),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              InkWell(
                onTap: (){
                  if(model.uId != uId){
                  SocialCubit.get(context).getProfile(model.uId);
                  navigateTo(context, VisitProfileScreen());
                  }
                },
                child: CircleAvatar(
                  radius: 25.0,
                  backgroundImage: NetworkImage(
                    '${model.image}',
                  ),
                ),
              ),
              const SizedBox(
                width: 15.0,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '${model.name}',
                          style: const TextStyle(
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(
                          width: 5.0,
                        ),
                        const Icon(
                          Icons.check_circle,
                          color: defaultColor,
                          size: 16.0,
                        ),
                      ],
                    ),
                    Text(
                      '${model.dateTime}',
                      style: Theme.of(context).textTheme.caption!.copyWith(
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 15.0,
              ),
              const Padding(
                padding: EdgeInsets.only(right: 12),
                child: Icon(
                  Icons.more_horiz,
                  size: 18.0,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10.0,
            ),
            child: Container(
              width: double.infinity,
              height: 1.0,
              color: Colors.grey[300],
            ),
          ),
          if(model.text !='')
          Column(
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.only(
                    bottom: 5.0
                ),
                child: Text(
                  '${model.text}',
                  style: Theme.of(context).textTheme.subtitle1!.copyWith(
                    color: Colors.black
                  ),
                ),
              ),
              const SizedBox(height: 5,)
            ],
          ),
          if(model.postImage != '')
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                '${model.postImage}',
                fit: BoxFit.cover,
              ),
            ),
          if(model.postVideo != '')
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: VideoViewer(
                enableVerticalSwapingGesture: false,
                  style: VideoViewerStyle(
                    // volumeBarStyle: VolumeBarStyle(bar: BarStyle.volume(background: defaultColor)),
                    forwardAndRewindStyle: ForwardAndRewindStyle(backgroundColor: defaultColor),
                    progressBarStyle: ProgressBarStyle(backgroundColor: defaultColor),
                      loading: const CircularProgressIndicator(
                        color: defaultColor,
                      ),
                    playAndPauseStyle: PlayAndPauseWidgetStyle(background: defaultColor)
                  ),
                  controller: VideoViewerController(),
                  source: {
                    "SubRip Text":
                    VideoSource(video: VideoPlayerController.network('${model.postVideo}'),
                    )
                  }),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10
            ),
            child: Container(
              width: double.infinity,
              height: 1.0,
              color: Colors.grey[300],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
            horizontal: 7
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 5.0,
                  ),
                  child: InkWell(
                    onTap: () {
                      SocialCubit.get(context).likePost(SocialCubit.get(context).postsId[index]);
                    },
                    child: Row(
                      children: [
                         Icon(
                         likes.contains(uId) ? Icons.favorite :Icons.favorite_border_outlined,
                          size: 22.0,
                          color: defaultColor,
                        ),
                        const SizedBox(
                          width: 5.0,
                        ),
                        Text(
                          '${likes!.length}' ,
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                InkWell(
                  onTap: (){
                    SocialCubit.get(context).getComments(postId);
                    navigateTo(context, CommentsScreen(postId: postId));
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 5.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Icon(
                          IconBroken.Chat,
                          size: 20.0,
                          color: Colors.amber,
                        ),
                        const SizedBox(
                          width: 5.0,
                        ),
                        Text(
                          'comments',
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

 Widget buildStoryItem(List<StoryModel> model,context){
    return  InkWell(
      child: Stack(
        children: <Widget>[
          const CircleAvatar(
            backgroundColor: defaultColor,
            radius: 40,
          ),
          Positioned(
            right: 0.5,
            left: 0.5,
            top: 3,
            bottom: 3,
            child: CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(
                  "${model[0].image}"),
            ),
          ),
        ],
      ),
      onTap: (){
        navigateTo(context, StoryScreen(storyModel: model,));
      },
    );
 }
}