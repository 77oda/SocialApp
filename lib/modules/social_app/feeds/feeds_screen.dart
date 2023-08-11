import 'dart:ui';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test123/shared/components/constants.dart';
import 'package:video_viewer/video_viewer.dart';
import '../../../layout/social_app/cubit/cubit.dart';
import '../../../layout/social_app/cubit/states.dart';
import '../../../models/social_app/post_model.dart';
import '../../../shared/styles/colors.dart';
import '../../../shared/styles/icon_broken.dart';

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
          child: state is! SocialGetPostsLoadingState?
            ConditionalBuilder(
            condition: SocialCubit.get(context).posts.isNotEmpty,
            builder: (context) => SingleChildScrollView(
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
                          height: 200.0,
                          width: double.infinity,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'communicate with friends',
                            style: Theme.of(context).textTheme.subtitle1!.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) => buildPostItem(SocialCubit.get(context).posts[index],context,index),
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
            fallback: (context) =>Center(child: Text('No posts',style: Theme.of(context).textTheme.caption!.copyWith(fontSize: 15),),),
          ):
          const Center(child: CircularProgressIndicator()),

        );
      },
    );
  }

  Widget buildPostItem(PostModel model, context,index) {
    List likes =[];
    model.likes!.forEach((key, value) {
      if(value=='true'){
        likes!.add(key);
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
              CircleAvatar(
                radius: 25.0,
                backgroundImage: NetworkImage(
                  '${model.image}',
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
              IconButton(
                icon: const Icon(
                  Icons.more_horiz,
                  size: 16.0,
                ),
                onPressed: () {},
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
                  onTap: (){},
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
                          '0 comment',
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
}