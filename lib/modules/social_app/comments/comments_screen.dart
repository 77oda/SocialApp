import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test123/models/social_app/post_model.dart';
import 'package:test123/models/social_app/social_user_model.dart';

import '../../../layout/social_app/cubit/cubit.dart';
import '../../../layout/social_app/cubit/states.dart';
import '../../../models/social_app/comment_model.dart';
import '../../../shared/components/constants.dart';
import '../../../shared/styles/colors.dart';
import '../../../shared/styles/icon_broken.dart';

class CommentsScreen extends StatelessWidget {
  final String postId;
   CommentsScreen({super.key, required this.postId,});
  var textController = TextEditingController();
  var formKey=GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {
        if(state is SocialCommentPostSuccessState){
          textController.text='';
        }
      },
      builder: (context, state) {
        var userModel = SocialCubit.get(context).userModel;
        return Scaffold(
          appBar: AppBar(
            title: const Text('Comments'),
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
                textController.text='';
              },
              icon: const Icon(
                IconBroken.Arrow___Left_2,
              ),
            ),
            titleSpacing: 5.0,

          ),
          body:ConditionalBuilder(
              condition: state is! SocialGetCommentsLoadingState,
              builder: (context) => Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index)
                        {
                          var comment =SocialCubit.get(context).commentsModel[index];
                          return buildComment(comment,context);
                        },
                        separatorBuilder: (context, index) => const SizedBox(
                          height: 15.0,
                        ),
                        itemCount:SocialCubit.get(context).commentsModel.length ,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey[300]!,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(
                          15.0,
                        ),
                      ),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Form(
                        key: formKey,
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15.0,
                                ),
                                child: TextFormField(
                                  validator: (value){
                                    if(value!.isEmpty)
                                    {
                                      return 'please enter comment';
                                    }
                                  },
                                  style: const TextStyle( color: Colors.black),
                                  controller: textController,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'type your comment here ...',
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              height: 50.0,
                              color: defaultColor,
                              child: MaterialButton(
                                onPressed: () {
                                  var now =DateTime.now();
                                  if(formKey.currentState!.validate()) {
                                    SocialCubit.get(context).commentPost(
                                        postId: postId,
                                        name:'${userModel!.name}',
                                        dateTime: '$now',
                                        text: textController.text ,
                                        image: '${userModel!.image}',
                                        uId: '$uId'
                                    );
                                  }
                                },
                                minWidth: 1.0,
                                child: const Icon(
                                  IconBroken.Send,
                                  size: 16.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ) ,
              fallback: (context) =>const Center(child: CircularProgressIndicator())
          )
        );
      },
    );
  }


  Widget buildComment(CommentModel comment , context) => Align(
    alignment: AlignmentDirectional.centerStart,
    child: Row(
      children: [
        CircleAvatar(
          backgroundImage: NetworkImage('${comment.image}') ,
         radius: 22,
        ),
        const SizedBox(width: 7,),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: defaultColor.withOpacity(
                .2,
              ),
              borderRadius: const BorderRadiusDirectional.only(
                bottomEnd: Radius.circular(
                  10.0,
                ),
                topStart: Radius.circular(
                  10.0,
                ),
                topEnd: Radius.circular(
                  10.0,
                ),
              ),
            ),
            padding: const EdgeInsets.symmetric(
              vertical: 5.0,
              horizontal: 10.0,
            ),
            child: Column(
              crossAxisAlignment:CrossAxisAlignment.start,
              children: [
                Text('${comment.name}',style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 12),),
                Text('${comment.text}',style: Theme.of(context).textTheme.caption),
              ],
            ),
          ),
        ),
      ],
    ),
  );

}
