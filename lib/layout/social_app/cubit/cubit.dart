
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:test123/layout/social_app/cubit/states.dart';
import 'package:test123/layout/social_app/social_layout.dart';
import 'package:test123/models/social_app/comment_model.dart';
import 'package:test123/models/social_app/notification_model.dart';
import 'package:test123/shared/components/constants.dart';
import 'package:video_player/video_player.dart';

import '../../../models/social_app/message_model.dart';

import '../../../models/social_app/follow_model.dart';
import '../../../models/social_app/post_model.dart';
import '../../../models/social_app/social_user_model.dart';

import '../../../models/social_app/story_model.dart';
import '../../../modules/social_app/chats/chats_screen.dart';
import '../../../modules/social_app/feeds/feeds_screen.dart';
import '../../../modules/social_app/new_post/new_post_screen.dart';
import '../../../modules/social_app/profile/profile_screen.dart';
import '../../../modules/social_app/users/users_screen.dart';



class SocialCubit extends Cubit<SocialStates> {
  SocialCubit() : super(SocialInitialState());

  static SocialCubit get(context) => BlocProvider.of(context);


  //BottomNav//////////////////////////////////////////////////////////
  int currentIndex = 0;

  List<Widget> screens =
  [
    FeedsScreen(),
    ChatsScreen(),
    NewPostScreen(),
    UsersScreen(),
    ProfileScreen(),
  ];

  List<Widget> appbarTitles =
  [
    const Text('Home'),
    const Text('Chats'),
    const Text ('Post'),
    const Text('Search'),
    const Text('Profile'),
  ];

  void changeBottomNav(int index)
  {
    searchController.text= '';
    if (index == 1) getUsers();
    if(index == 2)
      emit(SocialNewPostState());
    else
    {
      currentIndex = index;
      emit(SocialChangeBottomNavState());
    }
  }
  //BottomNav//////////////////////////////////////////////////////////


  //Profile//////////////////////////////////////////////////////////
  SocialUserModel? userModel;
  int? numPosts;
  List<PostModel> gridPosts = [];
  List<PostModel> listViewPosts = [];
  List<String> listViewPostsId = [];
  List<FollowModel> followers=[];
  List<FollowModel> followings=[];
  List ids=[];
  bool isList=true;

  void getUserData()
  {
    emit(SocialGetUserLoadingState());

    FirebaseFirestore.instance.collection('posts').orderBy('time',descending: true).where('uId',isEqualTo: uId).snapshots().listen((event) {
      listViewPosts = [];
      listViewPostsId = [];
      numPosts=event.docs.length;
      event.docs.forEach((element) {
        listViewPostsId.add(element.id);
        listViewPosts.add(PostModel.fromJson(element.data()));
      });
      emit(SocialGetPostsSuccessState());
    });

    FirebaseFirestore.instance.collection('posts').where('uId',isEqualTo: uId).where('postImage',isNotEqualTo:'').orderBy('postImage').orderBy('time',descending: true)
        .snapshots().listen((value) {
      gridPosts = [];
      value.docs.forEach((element) {
        gridPosts.add(PostModel.fromJson(element.data()));
      });
    });

    FirebaseFirestore.instance.collection('users')
        .doc(uId).collection('followers')
        .snapshots().listen((value) {
      followers = [];
      value.docs.forEach((element) {
        followers.add(FollowModel.fromJson(element.data()));
      });
      emit(SocialGetUserSuccessState());
    });

    FirebaseFirestore.instance.collection('users')
        .doc(uId).collection('followings')
        .snapshots().listen((value) {
      followings = [];
      ids=[];
      value.docs.forEach((element) {
       followings.add(FollowModel.fromJson(element.data()));
      });
      followings.forEach((element) {
        ids.add(element.uId);
      });
    });

    FirebaseFirestore.instance.collection('users').doc(uId).get().then((value)
    {
      userModel = SocialUserModel.fromJson(value.data()!);
      // print('${userModel!.name}');
      emit(SocialGetUserSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(SocialGetUserErrorState(error.toString()));
    });
  }

  void togglePosts(){
    if(isList ==true){
      isList =false;
    }else{
      isList =true;
    }
    emit(SocialToggleSuccessState());
  }
  
  File? profileImage;
  File? coverImage;
  var picker = ImagePicker();

  Future<void> getProfileImage() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      print(pickedFile.path);
      emit(SocialProfileImagePickedSuccessState());
    } else {
      print('No image selected.');
      emit(SocialProfileImagePickedErrorState());
    }
  }

  Future<void> getCoverImage() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      coverImage = File(pickedFile.path);
      emit(SocialCoverImagePickedSuccessState());
    } else {
      print('No image selected.');
      emit(SocialCoverImagePickedErrorState());
    }
  }

  void uploadProfileImage({
    required String name,
    required String phone,
    required String bio,
  })
  {
    emit(SocialUserUpdateLoadingState());

    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(profileImage!.path).pathSegments.last}')
        .putFile(profileImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value)
      {
        //emit(SocialUploadProfileImageSuccessState());
        // print(value);
        updateUser(
          name:name,
          phone:phone,
          bio:bio,
          image:value,
        );
      }).catchError((error) {
        print('$error.......1');
        emit(SocialUploadProfileImageErrorState());
      });
    }).catchError((error) {
      print('$error.......2');
      emit(SocialUploadProfileImageErrorState());
    });
  }

  void uploadCoverImage({
    required String name,
    required String phone,
    required String bio,
  })
  {
    emit(SocialUserUpdateLoadingState());

    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(coverImage!.path).pathSegments.last}')
        .putFile(coverImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {

        updateUser(
          name:name,
          phone:phone,
          bio:bio,
          cover:value,
        );
      }).catchError((error)
      {
        emit(SocialUploadCoverImageErrorState());
      });
    }).catchError((error)
    {
      emit(SocialUploadCoverImageErrorState());
    });
  }
  List<String> nameArray = [];

  void updateUser({
    required String name,
    required String phone,
    required String bio,
    String? cover,
    String? image,
  })
  {
    for (int i = 0; i < name.length; i++) {
      nameArray.add(name.substring(0, i + 1).toLowerCase());
    }
    emit(SocialUserUpdateLoadingState());
    SocialUserModel model = SocialUserModel(
      name: name,
      phone: phone,
      bio: bio,
      email: userModel!.email,
      cover: cover??userModel!.cover,
      image: image??userModel!.image,
      uId: uId,
      isEmailVerified: false,
        nameArray: nameArray
    );

    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .update(model.toMap())
        .then((value)
    {
      getUserData();
      getPosts();
      emit(SocialUserUpdateSuccessState());
    })
        .catchError((error)
    {
      emit(SocialUserUpdateErrorState());
    });
  }

  void clickFollow(String uIdPerson){
    emit(SocialFollowLoadingState());
    if (!ids.contains(uIdPerson)){
    FirebaseFirestore.instance.collection('users').doc(uIdPerson).collection('followers').doc(uId).set({
      'name':'${userModel!.name}',
      'image':'${userModel!.image}',
      'uId':'${userModel!.uId}',
    }).then((value) {});
    FirebaseFirestore.instance.collection('users').doc(uId).collection('followings').doc(uId).
    set({
        'name':'${profileModel!.name}',
        'image':'${profileModel!.image}',
        'uId':'${profileModel!.uId}',
      }).then((value) {
      // getUserData();
      emit(SocialFollowSuccessState());
    });
    }

    if (ids.contains(uIdPerson)) {
      FirebaseFirestore.instance.collection('users').doc(uIdPerson).collection('followers').doc(uId).delete().then((value) {});
      FirebaseFirestore.instance.collection('users').doc(uId).collection('followings').doc(uId).
      delete().then((value) {
        // getUserData();
        emit(SocialFollowSuccessState());
      });
    }
  }
  //Profile//////////////////////////////////////////////////////////



  //Post//////////////////////////////////////////////////////////
  File? postFile;
  VideoPlayerController? videoPlayerController;
  var isPlay =false;

  Future<void> getPostImage() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      postFile = File(pickedFile.path);
      emit(SocialPostImagePickedSuccessState());
    } else {
      print('No image selected.');
      emit(SocialPostImagePickedErrorState());
    }
  }

  Future<void> getPostVideo() async {
    final pickedFile = await picker.pickVideo(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      postFile = File(pickedFile.path);
      videoPlayerController= VideoPlayerController.file(postFile!)..initialize().then((value) {
        emit(SocialPostImagePickedSuccessState());
      });
      emit(SocialPostImagePickedSuccessState());
    } else {
      print('No image selected.');
      emit(SocialPostImagePickedErrorState());
    }
  }

  void editPlayingVideo (){
    if(videoPlayerController!.value.isPlaying){
      videoPlayerController!.pause();
      isPlay=false;
    }
    else{
      videoPlayerController!.play();
      isPlay=true;
    }
    emit(SocialEditVideoSuccessState());
  }

  void removePostFile()
  {
    if(videoPlayerController!=null){
      videoPlayerController!.pause();
    }
    isPlay=false;
    videoPlayerController=null;
    postFile = null;
    emit(SocialRemovePostImageState());
  }

  void uploadPostFile({
    required String dateTime,
    required String text,
    required String time,
  })
  {
    emit(SocialCreatePostLoadingState());

    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('posts/${Uri.file(postFile!.path).pathSegments.last}')
        .putFile(postFile!)
        .then((value) {
      value.ref.getDownloadURL().then((value)
      {
        if(videoPlayerController==null) {
          createPost(
          text: text,
          dateTime: dateTime,
          postImage: value,
            time: time,
        );
        }
        else{
          createPost(
            text: text,
            dateTime: dateTime,
            postVideo: value,
            time: time
          );
        }
      }).catchError((error)
      {
        emit(SocialCreatePostErrorState());
      });
    }).catchError((error)
    {
      emit(SocialCreatePostErrorState());
    });
  }


  void createPost({
    required String dateTime,
    required String text,
    String? postImage,
    String? postVideo,
    required time
  })
  {
    emit(SocialCreatePostLoadingState());

    PostModel model = PostModel(
      name: userModel!.name,
      image: userModel!.image,
      uId:uId,
      dateTime: dateTime,
      time:time,
      text: text,
      postImage: postImage??'',
      postVideo: postVideo??'',
      likes: {},
    );
    FirebaseFirestore.instance
        .collection('posts')
        .add(model.toMap())
        .then((value)
    {
      getUserData();
      getPosts();
      emit(SocialCreatePostSuccessState());
    }).catchError((error) {emit(SocialCreatePostErrorState());});
  }

  List<PostModel> posts = [];
  List<String> postsId = [];
  void getPosts ()
  {
    FirebaseFirestore.instance.collection('posts').orderBy('time',descending: true).snapshots().listen((event) {
      posts=[];
      postsId=[];
      event.docs.forEach((element) {

         postsId.add(element.id);
         posts.add(PostModel.fromJson(element.data()));
      });
      emit(SocialGetPostsSuccessState());
    });
  }

  void likePost(String postId) {
    PostModel? post;
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId).get().then((value) {
          post=PostModel.fromJson(value.data()!);
    }).then((value) {
      print('${post!.likes![uId]}');
      if(post!.likes![uId] == 'true') {
        FirebaseFirestore.instance
            .collection('posts')
            .doc(postId)
            .set({'likes': {'$uId': 'false'}},SetOptions(merge: true))
            .then((value) {
          deleteLikeToNotification(postId);
          emit(SocialLikePostSuccessState());
        }).catchError((error) {
          emit(SocialLikePostErrorState(error.toString()));
        });
      }
      else {
        FirebaseFirestore.instance
            .collection('posts')
            .doc(postId)
            .set({'likes': {'$uId': 'true'}},SetOptions(merge: true),)
            .then((value) {
          addLikeToNotification(postId);
          emit(SocialLikePostSuccessState());
        }).catchError((error) {
          emit(SocialLikePostErrorState(error.toString()));
        });
      }
    });
  }

  void addLikeToNotification(String postId){
    var now=DateTime.now();
    FirebaseFirestore.instance.collection('notifications')
        .doc(uId)
        .collection('notificationItems')
        .doc(postId)
        .set({
        'notify': FieldValue.arrayUnion([ {
    'type': 'like',
    'comment' : '',
    'name': userModel!.name,
    'uId': uId,
    'image': userModel!.image,
    'postId': postId,
    'dateTime': ''
    }])
    },SetOptions(merge: true)
    );
  }

  PostModel? postDetails;
  void getPostDetails(String postId)
  {
    emit(SocialGetPostDetailsLoadingState());

    FirebaseFirestore.instance.collection('posts').doc(postId).get().then((value) {
      postDetails=null;
    postDetails=PostModel.fromJson(value.data()!);
      emit(SocialGetPostDetailsSuccessState());
    });
  }
  void deleteLikeToNotification(String postId){
    FirebaseFirestore.instance.collection('notifications')
        .doc(uId)
        .collection('notificationItems')
        .doc(postId)
        .set({
      'notify': FieldValue.arrayRemove([ {
        'type': 'like',
        'comment' : '',
        'name': userModel!.name,
        'uId': uId,
        'image': userModel!.image,
        'postId': postId,
        'dateTime':''
      }])
    },SetOptions(merge: true)
    );

  }

  void addCommentToNotification(String postId , String comment){
    String now='${DateTime.now()}';
    FirebaseFirestore.instance.collection('notifications')
        .doc(uId)
        .collection('notificationItems')
        .doc(postId)
        .set({
      'notify':  FieldValue.arrayUnion( [ {
        'type': 'comment',
        'comment':comment,
        'name': userModel!.name,
        'uId': uId,
        'image': userModel!.image,
        'postId': postId,
        'dateTime': now
      }])

    },SetOptions(merge: true));
  }

  List<NotificationModel> notificationModel = [];
  void getNotification (){
   emit(SocialGetNotificationsLoadingState());
    FirebaseFirestore.instance.collection('notifications')
        .doc(uId)
        .collection('notificationItems').limit(50).snapshots().listen((value) {
      notificationModel =[];
      value.docs.forEach((element) {
    notificationModel.add(NotificationModel.fromJson(element.data()['notify'] as List));
    emit(SocialGetNotificationsSuccessState());
      });
    });
  }

  void commentPost({
    required String postId,
    required String name,
    required String dateTime,
    required String text,
    required String image,
    required String uId,
  }) {
    CommentModel commentModel=CommentModel(
      name: name,
      dateTime: dateTime,
      text: text,
      image: image,
      uId: uId
    );
        FirebaseFirestore.instance
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .add(commentModel.toMap()).then((value) {
              getPosts();
              getUserData();
              addCommentToNotification(postId ,text);
          emit(SocialCommentPostSuccessState());
        }).catchError((error) {
          emit(SocialCommentPostErrorState(error.toString()));
        });
  }

  List<CommentModel> commentsModel= [];
  void getComments (String postId)
  {
    emit(SocialGetCommentsLoadingState());
    FirebaseFirestore.instance.collection('posts').doc(postId).collection('comments').orderBy('dateTime').snapshots().listen((event) {
     commentsModel=[];
     event.docs.forEach((element)
     {
       commentsModel.add(CommentModel.fromJson(element.data()));
     });
      emit(SocialGetCommentsSuccessState());
    });
  }

  void deletePost(postId){
    FirebaseFirestore.instance.collection('posts').doc(postId).delete().then((value) {
      emit(SocialDeletePostSuccessState());
    }).catchError((error){
      emit(SocialDeletePostErrorState(error));
    });
  }
  //Post//////////////////////////////////////////////////////////


  //Story//////////////////////////////////////////////////////////
  File? storyFile;

  Future<void> getStoryImage(context) async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      storyFile = File(pickedFile.path);
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Center(
                child: Text(
                 'Are you sure about the story?',
                  style: TextStyle(fontSize: 18),
                )),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
                  children: [
                    OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                           'cancel'
                        )),
                    OutlinedButton(
                        onPressed: () {
                          var time=DateTime.now();
                         uploadStoryFile(dateTime: '$time') ;
                         Navigator.pop(context);
                        },
                        child: const Text(
                          'done'
                            ))
                  ],
                )
              ],
            ),
          ));
      emit(SocialPostImagePickedSuccessState());
    } else {
      print('No image selected.');
      emit(SocialPostImagePickedErrorState());
    }
  }

  void uploadStoryFile({
    required String dateTime,
  })
  {
    emit(SocialCreatePostLoadingState());

    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('stories/${Uri.file(storyFile!.path).pathSegments.last}')
        .putFile(storyFile!)
        .then((value) {
      value.ref.getDownloadURL().then((value)
      {
          createStory(
            dateTime: dateTime,
            storyImage: value,
          );
      }).catchError((error)
      {
        emit(SocialCreatePostErrorState());
      });
    }).catchError((error)
    {
      emit(SocialCreatePostErrorState());
    });
  }

  void createStory({
    required String dateTime,
    required String storyImage,
  })
  {
    emit(SocialCreatePostLoadingState());

    StoryModel model = StoryModel(
      name: userModel!.name,
      image: userModel!.image,
      uId:uId,
      dateTime: dateTime,
      storyImage:storyImage
    );
    FirebaseFirestore.instance
        .collection('stories')
        .doc(uId)
        .set({
      'story': FieldValue.arrayUnion([model.toMap()])
    },SetOptions(merge: true))
        .then((value)
    {
      getStories();
      emit(SocialCreatePostSuccessState());
    }).catchError((error) {emit(SocialCreatePostErrorState());});
  }

  Map storyMap={};
  List<StoryModel> stories = [];
  List<String> idStories = [];

  void getStories ()
  {
    emit(SocialGetStoryLoadingState());

    FirebaseFirestore.instance.collection('stories').snapshots().listen((event) {
      stories=[];
      storyMap={};
      idStories=[];
      event.docs.forEach((element) {
        idStories.add(element.id);
        List s= element['story'] as List ;
        s.forEach((e) {
          stories.add(StoryModel.fromJson(e));
        });
        storyMap.addEntries(<String,List<StoryModel>>{element.id:stories}.entries);
        stories=[];
      });
      emit(SocialGetStorySuccessState());
    });
  }

  //Story//////////////////////////////////////////////////////////



  //Chat//////////////////////////////////////////////////////////
  List<SocialUserModel>? users;
  void getUsers()
  {

    emit(SocialGetAllUsersLoadingState());
    FirebaseFirestore.instance.collection('users').get().then((value)
    {
      users = [];
      value.docs.forEach((element)
      {
        if (element.data()['uId'] != userModel!.uId) {
          users!.add(SocialUserModel.fromJson(element.data()));
        }
      });

      emit(SocialGetAllUsersSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(SocialGetAllUsersErrorState(error.toString()));
    });
  }

  void sendMessage({
    required String receiverId,
    required String dateTime,
    required String text,
  }) {
    MessageModel model = MessageModel(
      text: text,
      senderId: userModel!.uId,
      receiverId: receiverId,
      dateTime: dateTime,
    );

    // set my chats

    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .add(model.toMap())
        .then((value) {
      emit(SocialSendMessageSuccessState());
    }).catchError((error) {
      emit(SocialSendMessageErrorState());
    });

    // set receiver chats

    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(userModel!.uId)
        .collection('messages')
        .add(model.toMap())
        .then((value) {
      emit(SocialSendMessageSuccessState());
    }).catchError((error) {
      emit(SocialSendMessageErrorState());
    });
  }

  List<MessageModel> messages = [];

  void getMessages({
    required String receiverId,
  }) {
    emit(SocialGetMessagesLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
      messages = [];

      event.docs.forEach((element) {
        messages.add(MessageModel.fromJson(element.data()));
      });

      emit(SocialGetMessagesSuccessState());
    });
  }

  //Chat//////////////////////////////////////////////////////////


  //Search//////////////////////////////////////////////////////////
  List<SocialUserModel>? searchUsers;
  void search(String value){
    emit(SocialSearchLoadingState());
    searchUsers=[];
    FirebaseFirestore.instance.collection('users').where('nameArray',arrayContains: value).where('isEmailVerified',isEqualTo: true).where('name',isNotEqualTo: userModel!.name).get().then((value) {
      value.docs.forEach((element) {
        searchUsers!.add(SocialUserModel.fromJson(element.data()));
      });
      emit(SocialSearchSuccessState());
    }).catchError((error){
      emit(SocialSearchErrorState(error));
    });
  }
  //Search//////////////////////////////////////////////////////////


  //ProfileVisit//////////////////////////////////////////////////////////
  int? numPostsVisit;
  List<PostModel> gridPostsVisit = [];
  List<PostModel> listViewPostsVisit = [];
  List<String> listViewPostsIdVisit = [];
  List<FollowModel> followersVisit=[];
  List<FollowModel> followingsVisit=[];
  bool isListVisit=true;
  SocialUserModel? profileModel;

  void getProfile(uId) {
    emit(SocialGetUserLoadingState());

    FirebaseFirestore.instance.collection('posts').orderBy(
        'time', descending: true).where('uId', isEqualTo: uId)
        .snapshots()
        .listen((event) {
      listViewPostsVisit = [];
      listViewPostsIdVisit = [];
      numPostsVisit = event.docs.length;
      event.docs.forEach((element) {
        listViewPostsIdVisit.add(element.id);
        listViewPostsVisit.add(PostModel.fromJson(element.data()));
      });
      emit(SocialGetPostsSuccessState());
    });


    FirebaseFirestore.instance.collection('posts')
        .where('uId', isEqualTo: uId).where('postImage', isNotEqualTo: '')
        .orderBy('postImage').orderBy('time', descending: true)
        .snapshots()
        .listen((value) {
      gridPostsVisit = [];
      value.docs.forEach((element) {
        gridPostsVisit.add(PostModel.fromJson(element.data()));
      });
    });

    FirebaseFirestore.instance.collection('users')
        .doc(uId).collection('followers')
        .snapshots().listen((value) {
      followersVisit = [];
      value.docs.forEach((element) {
        followersVisit.add(FollowModel.fromJson(element.data()));
      });
    });

    FirebaseFirestore.instance.collection('users')
        .doc(uId).collection('followings')
        .snapshots().listen((value) {
      followingsVisit = [];
      value.docs.forEach((element) {
        followingsVisit.add(FollowModel.fromJson(element.data()));
      });
      // print('$followings');
    });

    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .snapshots()
        .listen((value) {
      profileModel = SocialUserModel.fromJson(value.data()!);
      emit(SocialGetUserSuccessState());
    });
  }

  void togglePostsVisit(){
    if(isListVisit ==true){
      isListVisit =false;
    }else{
      isListVisit =true;
    }
    emit(SocialToggleSuccessState());
  }
//ProfileVisit//////////////////////////////////////////////////////////

}