import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test123/shared/components/constants.dart';
import 'package:video_player/video_player.dart';
import '../../../layout/social_app/cubit/cubit.dart';
import '../../../layout/social_app/cubit/states.dart';
import '../../../shared/components/components.dart';
import '../../../shared/styles/colors.dart';
import '../../../shared/styles/icon_broken.dart';

class NewPostScreen extends StatelessWidget {
  var textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {
        if(state is SocialCreatePostSuccessState){
          showToast(text: 'Post added successfully', state: ToastStates.SUCCESS);
          SocialCubit.get(context).removePostFile();
          textController.text='';
        }
      },
      builder: (context, state) {
        var userModel = SocialCubit.get(context).userModel;
        return Scaffold(
          appBar: AppBar(
            title: const Text('Create Post'),
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
                SocialCubit.get(context).removePostFile();
                textController.text='';
              },
              icon: const Icon(
                IconBroken.Arrow___Left_2,
              ),
            ),
            titleSpacing: 5.0,
            actions: [
              defaultTextButton(
                function: () {
                  String now = getDate(DateTime.now().toString());
                  if( SocialCubit.get(context).postFile==null && textController.text=='') {
                    showToast(text: 'you should fill description or add photo,video or both!', state: ToastStates.WARNING);
                  }
                  else {
                    if (SocialCubit.get(context).postFile == null) {
                      SocialCubit.get(context).createPost(
                        time: '${DateTime.now()}',
                        dateTime: now,
                        text: textController.text,
                      );
                    }
                    else {
                      SocialCubit.get(context).uploadPostFile(
                        time:'${DateTime.now()}' ,
                        dateTime: now.toString(),
                        text: textController.text,
                      );
                    }
                  }
                },
                text: 'Post',
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: ListView(
              children: [
                if (state is SocialCreatePostLoadingState)
                  const LinearProgressIndicator(),
                if (state is SocialCreatePostLoadingState)
                  const SizedBox(
                    height: 5.0,
                  ),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 25.0,
                      backgroundImage: NetworkImage('${userModel!.image}'),
                    ),
                    const SizedBox(
                      width: 15.0,
                    ),
                    Expanded(
                      child: Text(
                        '${userModel.name}',
                        style: const TextStyle(
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: TextFormField(
                    maxLines: 8,
                    style: const TextStyle(color: Colors.black),
                    controller: textController,
                    decoration: const InputDecoration(
                      hintText: 'what is on your mind ...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 12.0,
                ),
                if(SocialCubit.get(context).postFile != null && SocialCubit.get(context).videoPlayerController != null)
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          height: 400,
                          child: SocialCubit.get(context)
                                  .videoPlayerController!
                                  .value
                                  .isInitialized
                              ? AspectRatio(
                                  aspectRatio: SocialCubit.get(context)
                                      .videoPlayerController!
                                      .value
                                      .aspectRatio,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Stack(
                                      alignment: AlignmentDirectional.topEnd,
                                      children: [
                                        VideoPlayer(
                                            SocialCubit.get(context)
                                                .videoPlayerController!),
                                        IconButton(
                                          icon: const CircleAvatar(
                                            radius: 20.0,
                                            child: Icon(
                                              Icons.close,
                                              size: 16.0,
                                            ),
                                          ),
                                          onPressed: ()
                                          {
                                            SocialCubit.get(context).removePostFile();
                                          },
                                        ),
                                        Align(
                                          alignment: Alignment.center,
                                          child: IconButton(
                                            onPressed: () {
                                              if(state is! SocialCreatePostLoadingState) {
                                                SocialCubit.get(context).editPlayingVideo();
                                              }
                                            },
                                            icon: Icon(SocialCubit.get(context).isPlay
                                                ? Icons.pause
                                                : Icons.play_arrow),
                                            color: defaultColor,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              : Container(),
                        ),

                      ],
                    ),

                if(SocialCubit.get(context).postFile != null && SocialCubit.get(context).videoPlayerController == null)
                  Container(
                    alignment: Alignment.center,
                    height: 400.0,
                   child: Stack(
                     alignment: AlignmentDirectional.topEnd,
                     children: [
                       ClipRRect(
                           borderRadius: BorderRadius.circular(10),
                           child: Image.file(SocialCubit.get(context).postFile!,fit: BoxFit.contain,)),
                       IconButton(
                         icon: const CircleAvatar(
                           radius: 20.0,
                           child: Icon(
                             Icons.close,
                             size: 16.0,
                           ),
                         ),
                         onPressed: ()
                         {
                           SocialCubit.get(context).removePostFile();
                         },
                       ),
                     ],
                   ),
                  ),
                if (SocialCubit.get(context).postFile == null)
                  const SizedBox(height: 400),
                const SizedBox(
                  height: 14.0,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          SocialCubit.get(context).removePostFile();
                          SocialCubit.get(context).getPostImage();
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              IconBroken.Image,
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            Text(
                              'Add photo',
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          SocialCubit.get(context).removePostFile();
                          SocialCubit.get(context).getPostVideo();
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              IconBroken.Video,
                              color: defaultColor,
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            Text(
                              'Add video',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
