import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/layout/cubit/states.dart';
import 'package:social_app/model/CommentModel.dart';
import 'package:social_app/model/messageModel.dart';
import 'package:social_app/model/post_model.dart';
import 'package:social_app/model/user_model.dart';
import 'package:social_app/modules/loginScreen/cubit/states.dart';
import 'package:social_app/modules/setting/profile.dart';
import 'package:social_app/modules/setting/settingsScreen.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';

import '../../modules/addPost/addPost.dart';
import '../../modules/chats/chatsScreen.dart';
import '../../modules/feeds/feedsScreen.dart';
import '../../modules/setting/profileScreen.dart';
import '../../modules/signUpScreen/cubit/states.dart';
import '../../modules/user/userScreen.dart';
import '../../shared/components/componets.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class SocialCubit extends Cubit<SocialStates> {
  SocialCubit() : super(SocialInitialState());

  static SocialCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  IconData suffix = Icons.visibility_off_outlined;
  bool isPassword = true;


  void changePasswordVisibility() {
    isPassword = !isPassword;
    suffix =
    isPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined;
    //emit(SocialChangePasswordVisibilityState());
  }


  List<Widget> screens = [
    FeedsScreen(),
    ChatsScreen(),
    NewPostScreen(),
   // profile(),
    ProfileScreen(),
    SettingsScreen(),
  ];

  List<String> titles = [
    'Home',
    'Chat',
    'Post',
    'Profile',
    'Settings',
  ];

  void changeBottomNav(int index)
  {
    if(index == 1)
      getUsers();
    if(index == 2)
      emit(SocialNewPostState());
    else
      {
        currentIndex = index;
        emit(SocialChangeBottomNavState());
      }
  }

  SocialUserModel? userModel;

  void getUserData() {
    uId = CacheHelper.getData(key: 'uId');
    emit(SocialGetUserLoadingState());
    FirebaseFirestore.instance.collection('users').doc(uId).get().then((value) {
      userModel = SocialUserModel.fromJson(value.data()!);
      emit(SocialGetUserSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(SocialGetUserErrorState(error.toString()));
    });
  }

  File? profileImage;
  var picker = ImagePicker();

  Future<void> getProfileImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      emit(SocialProfileImagePickedSuccessState());
    } else {
      showToast(text: 'No Image Selected', state: ToastStates.ERROR);
      emit(SocialProfileImagePickedErrorState());
    }
  }

  File? coverImage;

  Future<void> getCoverImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      coverImage = File(pickedFile.path);
      emit(SocialCoverImagePickedSuccessState());
    } else {
      showToast(text: 'No Image Selected', state: ToastStates.ERROR);
      emit(SocialCoverImagePickedErrorState());
    }
  }


  void uploadProfileImage({
     required String name,
     required String phone,
     required String bio,
}) {
    emit(SocialUserUpdateProfileLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(profileImage!.path).pathSegments.last}')
        .putFile(profileImage!)
        .then((value) 
    {
          value.ref.getDownloadURL()
              .then((value)
          {
            emit(SocialUploadProfileImageSuccessState());
            print(value);
            profileImageUrl =value;
            updateUser(
                name: name,
                phone: phone,
                bio: bio,
                image: value
            );
          }).catchError((error){
            emit(SocialUploadProfileImageErrorState());
          });
    }).catchError((error){
      emit(SocialUploadProfileImageErrorState());
    });
  }


  String profileImageUrl = '';
  void uploadprofileImage()
  {
    emit(SocialUserUpdateProfileLoadingState());
    firebase_storage.FirebaseStorage
        .instance.ref()
        .child('users/${Uri.file(profileImage!.path).pathSegments.last}')
        .putFile(profileImage!)
        .then((value){
          value.ref.getDownloadURL().then((value) {
            emit(SocialUploadProfileImageSuccessState());
            profileImageUrl = value;
            updateUserImage(image: value);
          }).catchError((error){
            emit(SocialUploadProfileImageErrorState());
            showToast(text: error.toString(), state: ToastStates.ERROR);
          });
    }).catchError((error){
      emit(SocialUploadProfileImageErrorState());
      showToast(text: error.toString(), state: ToastStates.ERROR);
    });
  }


  void updateUserImage({required String image}){
    emit(SocialUpdateUserImageLoadingState());
    SocialUserModel? model = SocialUserModel(
        email: userModel!.email,
        uId: userModel!.uId,
        image: image,
        isEmailVerified: false,
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .update({
      'image' : image,
    }).then((value){
      getUserData();
      showToast(text: 'Update Successful', state: ToastStates.SUCCESS);
      emit(SocialUpdateUserImageSuccessState());
    }).catchError((error){
      emit(SocialUpdateUserImageErrorState());
    });
  }

   String coverImageUrl = '';
  void uploadCoverImage() {
    emit(SocialUpdateUserCoverSuccessState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(coverImage!.path).pathSegments.last}')
        .putFile(coverImage!)
        .then((value)
    {
      value.ref.getDownloadURL()
          .then((value)
      {
        emit(SocialUploadCoverImageSuccessState());
        print(value);
        coverImageUrl = value;
        //updateUser(name: name, phone: phone, bio: bio,cover: value);
      }).catchError((error){
        emit(SocialUploadCoverImageErrorState());
      });
    }).catchError((error){
      emit(SocialUploadCoverImageErrorState());
    });
  }


  void updateUserPassword({required String password}){
    emit(SocialUpdateUserPasswordLoadingState());
    FirebaseAuth.instance.currentUser?.updatePassword(password).then((value){
      showToast(
          text: 'Update Successful',
          state: ToastStates.SUCCESS,
      );
      emit(SocialUpdateUserPasswordLoadingState());
      getUserData();
    }).catchError((error){
      showToast(
          text: 'Process failed\nYou Should Re-login Before Change Password',
          state: ToastStates.ERROR,
      );
      emit(SocialUpdateUserPasswordErrorState(error.toString()));
    });
  }


  File? postImage;

  Future<void> getPostImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      postImage = File(pickedFile.path);
      emit(SocialPostImagePickedSuccessState());
    } else {
      showToast(text: 'No Image Selected', state: ToastStates.ERROR);
      emit(SocialPostImagePickedErrorState());
    }
  }

  void uploadPostImage({
    required String dateTime,
    required String text,
  }) {
    emit(SocialCreatePostLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('posts/${Uri.file(postImage!.path).pathSegments.last}')
        .putFile(postImage!)
        .then((value)
    {
      value.ref.getDownloadURL()
          .then((value)
      {
        emit(SocialUploadCoverImageSuccessState());
        print(value);
        createPost(dateTime: dateTime, text: text,postImage: value);
      }).catchError((error){
        emit(SocialCreatePostErrorState());
      });
    }).catchError((error){
      emit(SocialCreatePostErrorState());
    });
  }


  void createPost({
    required String dateTime,
    required String text,
    String? postImage,
  })
  {
    emit(SocialCreatePostLoadingState());
    PostModel model = PostModel(
        userModel!.name,
        userModel!.uId,
        userModel!.image,
        text,
        postImage ?? '',
        dateTime
    );

    FirebaseFirestore.instance
        .collection('posts')
        .add(model.toMap())
        .then((value)
    {
      emit(SocialCreatePostSuccessState());

    }).catchError((error){
      emit(SocialCreatePostErrorState());
    });
  }

  void removePostImage()
  {
    postImage = null;
    emit(SocialRemovePostImageState());
  }

  void updateUser({
   required String name,
   required String phone,
   required String bio,
    String? image,
    String? cover,
})
  {
    emit(SocialUserUpdateLoadingState());

    if(coverImage != null)
    {
     // uploadCoverImage(name: name, bio: bio, phone: phone);
    } else if(profileImage != null)
    {
      uploadProfileImage(name: name, phone: phone, bio: bio);
      //uploadProfileImage(name: '', bio: '');
    }else{
      updateUse(name: name, phone: phone, bio: bio);
    }
  }


  void updateUse({
    required String name,
    required String phone,
    required String bio,
    String? image,
    String? cover,
})
  {
    SocialUserModel model = SocialUserModel(
      name: name,
      phone: phone,
      uId: userModel!.uId,
      bio: bio,
      isEmailVerified: false,
      email: userModel!.email,
      image: image ?? userModel!.image,
      cover: cover ?? userModel!.cover,
    );
    FirebaseFirestore.instance.collection('users')
        .doc(userModel!.uId)
        .update(model.toMap())
        .then((value)
    {
      showToast(text: "Update Successful", state: ToastStates.SUCCESS);
      getUserData();
    }).catchError(
            (error){
          emit(SocialUserUpdateErrorState());
        });

  }


    List<PostModel> posts = [];
    List<String> postsId = [];
    List<int> likes = [];

  void getPosts()
  {
    posts = [];
    postsId = [];
    likes = [];
    emit(SocialGetPostsLoadingState());
    FirebaseFirestore.instance
        .collection('posts')
        .get()
        .then((value)
    {
      value.docs.forEach((element)
      {
        element.reference.collection('likes')
            .get()
            .then((value)
        {
          likes.add(value.docs.length);
          postsId.add(element.id);
          posts.add(PostModel.fromJson(element.data()));
        }).catchError((error){});
      });
    }).catchError((error){
          emit(SocialGetPostsErrorState(error.toString()));
    });

  }




  void likePost(String postId)
  {
    FirebaseFirestore.instance.collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(userModel!.uId)
        .set({
      'likes' : true,
    }).then((value){
      emit(SocialLikePostSuccessState());
    }).catchError((error){
      emit(SocialLikePostErrorState(error.toString()));

    });
  }


  void uploadStoryImage({
     required String dateTime,
     required String text,
}){
    emit(SocialCreateStoryLoadingState());
    firebase_storage.FirebaseStorage
        .instance.ref().child('story/${Uri.file(postImage!.path).pathSegments.last}')
         .putFile(postImage!)
         .then((value){
           value.ref.getDownloadURL().then((value){
             emit(SocialCreateStorySuccessState());
             createStory(dateTime: dateTime, text: text);
           }).catchError((error){
             emit(SocialCreateStoryErrorState());
           });
    }).catchError((error){
      emit(SocialCreateStoryErrorState());
    });
    
}


void createStory({
  required String dateTime,
  required String text,
  String? postImage,
}){
    emit(SocialCreateStoryLoadingState());
    PostModel? model = PostModel(
         userModel!.name,
        uId,
        userModel!.image ?? "" ,
        text,
        postImage,
        dateTime
    );
    FirebaseFirestore.instance
        .collection('story')
        .add(model.toMap())
        .then((value){
          emit(SocialCreateStorySuccessState());
          getStory();
    }).catchError((error){
      emit(SocialCreateStoryErrorState());
      showToast(text: error.toString(), state: ToastStates.ERROR);
    });

}


late List<PostModel> story = [];
  List<String> storyId = [];


  void getStory(){
    storyId = [];
    story = [];
    emit(SocialGetStoryLoadingState());
    FirebaseFirestore.instance.collection('story')
        .get().then((value)
    {
          for(var element in value.docs){
            story.add(PostModel.fromJson(element.data()));
            storyId.add(element.id);
            emit(SocialGetStorySuccessState());
          }
    }).catchError((error){
      emit(SocialGetStoryErrorState(error.toString()));
    });
  }


 /* void updateUserImage({
  required String image,
}){
    emit(SocialUserUpdateLoadingState());
    SocialUserModel? model = SocialUserModel(
        email: userModel!.email,
        name: userModel!.name,
        phone: userModel!.phone,
        uId: userModel!.uId,
        image: image,
        cover: userModel!.cover,
        bio: userModel!.bio,
        isEmailVerified: false,
    );

    FirebaseFirestore.instance.collection('users').doc(userModel!.uId).update({
      'image' : image,
    }).then((value){
      getUserData();
      showToast(text: 'Update Successful', state: ToastStates.SUCCESS);
      emit(SocialUserUpdateProfileLoadingState());
    }).catchError((error){
      emit(SocialUserUpdateProfileLoadingState());
      showToast(text: 'Update Failed', state: ToastStates.ERROR);
    });
  } */


   late List<CommentModel> comments = [];
   List<int> nComments = [];



   void commentsPost(String postId, comment){
     CommentModel? commentModel = CommentModel(
       name: userModel!.name,
       image: userModel!.image,
       dateTime: DateTime.now().toString(),
       comment: comment,
     );

     FirebaseFirestore.instance.collection('posts').doc(postId)
         .collection('comments')
         .add
       (
         commentModel.toMap(),
     ).then((value) {
       emit(SocialCommentPostsSuccessState());
       getPostComments(postId);
     }).catchError((error){
       emit(SocialCommentPostsErrorState(error.toString()));
     });

   }


   void getPostComments(String postId)
   {
     FirebaseFirestore.instance.collection('posts')
         .doc(postId).collection('comments').get()
         .then((value){
           value.docs.forEach((element) {
             comments.add(CommentModel.fromJson(element.data()));
             emit(SocialCreateCommentSuccessState());
           });
     }).catchError((error){
       showToast(text: error.toString(), state: ToastStates.ERROR);
     });

   }


   int? getPostCommentNumber(postId){
     nComments = [];
     emit(SocialGetCommentsNumberLoadingState());
     FirebaseFirestore.instance.collection('posts')
         .doc(postId).collection('comments').get().then((value) {
           emit(SocialGetCommentsNumberSuccessState());
           return value.docs.length;
     }).catchError((error){
       emit(SocialGetCommentsNumberErrorState(error.toString()));
     });
     return null;
   }


   List<SocialUserModel> users = [];

   void getUsers()
   {
     if(users.length == 0)
       {
         emit(SocialGetAllUsersLoadingState());
         FirebaseFirestore.instance
             .collection('users')
             .get()
             .then((value)
         {
           value.docs.forEach((element)
           {
             if(element.data()['uId'] != userModel!.uId)
               users.add(SocialUserModel.fromJson(element.data()));
           });
         }).catchError((error){
           emit(SocialGetPostsErrorState(error.toString()));
         });
       }
   }


   void sendMessage({
     required String receiverId,
     required String dateTime,
     required String text,
}){
     MessageUserModel model = MessageUserModel(
       text: text,
       senderId: userModel!.uId,
       receiverId: receiverId,
       dateTime: dateTime,
     );

       //set my chats
     FirebaseFirestore.instance
         .collection('users')
         .doc(userModel!.uId)
          .collection('chats')
           .doc(receiverId)
          .collection('messages')
          .add(model.toMap()).then((value)
     {
            emit(SocialSendMessageSuccessState());
     }).catchError((error){
       emit(SocialSendMessageErrorState());
     });

     // set receiver chat
     FirebaseFirestore.instance
         .collection('users')
         .doc(receiverId)
         .collection('chats')
         .doc(userModel!.uId)
         .collection('messages')
         .add(model.toMap()).then((value)
     {
       emit(SocialSendMessageSuccessState());
     }).catchError((error){
       emit(SocialSendMessageErrorState());
     });

   }

   List<MessageUserModel> messages = [];

   void getMessages({
     required String receiverId,
}) {
     FirebaseFirestore.instance
         .collection('users')
         .doc(userModel!.uId)
         .collection('chats')
         .doc(receiverId)
         .collection('messages')
         .orderBy('dateTime')
         .snapshots()
         .listen((event)
     {
       messages = [];
       event.docs.forEach((element)
       {
         messages.add(MessageUserModel.fromJson(element.data()));
       });
       emit(SocialGetMessagesSuccessState());

     });

   }






}
