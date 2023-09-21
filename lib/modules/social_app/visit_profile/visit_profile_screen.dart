import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test123/modules/social_app/social_login/social_login_screen.dart';
import 'package:test123/shared/network/local/cache_helper.dart';
import 'package:test123/shared/styles/colors.dart';
import 'package:video_viewer/video_viewer.dart';
import '../../../layout/social_app/cubit/cubit.dart';
import '../../../layout/social_app/cubit/states.dart';
import '../../../shared/components/components.dart';
import '../../../shared/components/constants.dart';
import '../../../shared/styles/icon_broken.dart';
import '../comments/comments_screen.dart';
import '../edit_profile/edit_profile_screen.dart';

class VisitProfileScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var profileModel = SocialCubit.get(context).profileModel;
        return Scaffold(
          appBar: AppBar(
            title: const Text(''),
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
          body: ConditionalBuilder(
            condition: state is! SocialGetUserLoadingState,
            builder: (context) => SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 190.0,
                      child: Stack(
                        alignment: AlignmentDirectional.bottomCenter,
                        children: [
                          Align(
                            alignment: AlignmentDirectional.topCenter,
                            child: Container(
                              height: 140.0,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(
                                    4.0,
                                  ),
                                  topRight: Radius.circular(
                                    4.0,
                                  ),
                                ),
                                image: DecorationImage(
                                  image: NetworkImage(
                                    '${profileModel!.cover}',
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          CircleAvatar(
                            radius: 64.0,
                            backgroundColor:
                            Theme.of(context).scaffoldBackgroundColor,
                            child: CircleAvatar(
                              radius: 60.0,
                              backgroundImage: NetworkImage(
                                '${profileModel.image}',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      '${profileModel.name}',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    Text(
                      '${profileModel.bio}',
                      style: Theme.of(context).textTheme.caption,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              child: Column(
                                children: [
                                  Text(
                                    '${SocialCubit.get(context).numPostsVisit}',
                                    style: Theme.of(context).textTheme.subtitle2,
                                  ),
                                  Text(
                                    'Posts',
                                    style: Theme.of(context).textTheme.caption,
                                  ),
                                ],
                              ),
                              onTap: () {},
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              child: Column(
                                children: [
                                  Text(
                                    SocialCubit.get(context).followersVisit == null ? '0' :'${SocialCubit.get(context).followersVisit.length}',
                                    style: Theme.of(context).textTheme.subtitle2,
                                  ),
                                  Text(
                                    'Followers',
                                    style: Theme.of(context).textTheme.caption,
                                  ),
                                ],
                              ),
                              onTap: () {},
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              child: Column(
                                children: [
                                  Text(
                                    SocialCubit.get(context).followingsVisit == null ? '0' :'${SocialCubit.get(context).followingsVisit.length}',
                                    style: Theme.of(context).textTheme.subtitle2,
                                  ),
                                  Text(
                                    'Followings',
                                    style: Theme.of(context).textTheme.caption,
                                  ),
                                ],
                              ),
                              onTap: () {},
                            ),
                          ),
                        ],
                      ),
                    ),
                    // if(SocialCubit.get(context).userModel.followings)
                    OutlinedButton(
                      onPressed: () {
                        SocialCubit.get(context).clickFollow('${SocialCubit.get(context).profileModel!.uId}');
                      },
                      child:  Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            SocialCubit.get(context).ids.contains(SocialCubit.get(context).profileModel!.uId) ? 'unFollow'  :'Follow',
                          )
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                SocialCubit.get(context).isListVisit == false
                                    ? SocialCubit.get(context).togglePostsVisit()
                                    : null;
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.list,
                                    color: SocialCubit.get(context).isListVisit == true
                                        ? defaultColor
                                        : Colors.black,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    'Posts',
                                    style: TextStyle(
                                        color: SocialCubit.get(context).isListVisit == true
                                            ? defaultColor
                                            : Colors.black),
                                  )
                                ],
                              ),
                            )),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              SocialCubit.get(context).isListVisit == true
                                  ? SocialCubit.get(context).togglePostsVisit()
                                  : null;
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.grid_on,
                                  color: SocialCubit.get(context).isListVisit == false
                                      ? defaultColor
                                      : Colors.black,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  'Photos',
                                  style: TextStyle(
                                      color:
                                      SocialCubit.get(context).isListVisit == false
                                          ? defaultColor
                                          : Colors.black),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (SocialCubit.get(context).isListVisit == false) gridViewVisit(context),
                    if (SocialCubit.get(context).isListVisit == true) listViewVisit(context)
                  ],
                ),
              ),
            ),
            fallback: (context) =>const Center(child: CircularProgressIndicator()),
          )
        );
      },
    );
  }
}

Widget gridViewVisit(context) {
  return SocialCubit.get(context).gridPostsVisit.isNotEmpty
      ? GridView.count(
          crossAxisCount: 3,
          childAspectRatio: 1.0,
          mainAxisSpacing: 1.0,
          crossAxisSpacing: 1.0,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children:
              List.generate(SocialCubit.get(context).gridPostsVisit.length, (index) {
            return Image.network(
              '${SocialCubit.get(context).gridPostsVisit[index].postImage}',
              fit: BoxFit.cover,
            );
          }),
        )
      : Padding(
          padding: const EdgeInsets.only(top: 100),
          child: Center(
            child: Text(
              'No photos',
              style: Theme.of(context).textTheme.caption,
            ),
          ),
        );
}

Widget listViewVisit(context) {
  return SocialCubit.get(context).listViewPostsVisit.isNotEmpty
      ? ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            var model = SocialCubit.get(context).listViewPostsVisit[index];
            var postId = SocialCubit.get(context).listViewPostsIdVisit[index];
            List likes = [];
            model.likes!.forEach((key, value) {
              if (value == 'true') {
                likes!.add(key);
              }
            });
            return Card(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              elevation: 7.0,
              margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
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
                                style: Theme.of(context)
                                    .textTheme
                                    .caption!
                                    .copyWith(
                                      height: 1.4,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 15.0,
                        ),
                        const Row(
                          children: [
                            // IconButton(
                            //   icon: const Icon(
                            //     Icons.delete,
                            //     size: 18.0,
                            //     color: Colors.red,
                            //   ),
                            //   onPressed: () {
                            //     SocialCubit.get(context).deletePost(postId);
                            //   },
                            // ),
                            Padding(
                              padding: EdgeInsets.only(right: 12, left: 3),
                              child: Icon(
                                Icons.more_horiz,
                                size: 18.0,
                              ),
                            ),
                          ],
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
                    if (model.text != '')
                      Padding(
                        padding: const EdgeInsetsDirectional.only(bottom: 5.0),
                        child: Text(
                          '${model.text}',
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1!
                              .copyWith(color: Colors.black),
                        ),
                      ),
                    if (model.postImage != '')
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          '${model.postImage}',
                          fit: BoxFit.cover,
                        ),
                      ),
                    if (model.postVideo != '')
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: VideoViewer(
                            enableVerticalSwapingGesture: false,
                            style: VideoViewerStyle(
                                forwardAndRewindStyle: ForwardAndRewindStyle(
                                    backgroundColor: defaultColor),
                                progressBarStyle: ProgressBarStyle(
                                    backgroundColor: defaultColor),
                                loading: const CircularProgressIndicator(
                                  color: defaultColor,
                                ),
                                playAndPauseStyle: PlayAndPauseWidgetStyle(
                                    background: defaultColor)),
                            controller: VideoViewerController(),
                            source: {
                              "SubRip Text": VideoSource(
                                video: VideoPlayerController.network(
                                    '${model.postVideo}'),
                              )
                            }),
                      ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Container(
                        width: double.infinity,
                        height: 1.0,
                        color: Colors.grey[300],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 7),
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 5.0,
                              ),
                              child: Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      SocialCubit.get(context).likePost(postId);
                                    },
                                    child: Icon(
                                      likes.contains(uId)
                                          ? Icons.favorite
                                          : Icons.favorite_border_outlined,
                                      size: 22.0,
                                      color: defaultColor,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5.0,
                                  ),
                                  Text(
                                    '${likes!.length}',
                                    style: Theme.of(context).textTheme.caption,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
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
                                      style:
                                          Theme.of(context).textTheme.caption,
                                    ),
                                  ],
                                ),
                              ),
                              onTap: () {
                                SocialCubit.get(context).getComments(postId);
                                navigateTo(
                                    context, CommentsScreen(postId: postId));
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          separatorBuilder: (context, index) => const SizedBox(
            height: 8.0,
          ),
          itemCount: SocialCubit.get(context).listViewPostsVisit.length,
        )
      : Padding(
          padding: const EdgeInsets.only(top: 100),
          child: Center(
            child: Text(
              'No posts',
              style: Theme.of(context).textTheme.caption,
            ),
          ),
        );
}
