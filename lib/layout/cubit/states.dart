abstract class SocialStates {}

class SocialInitialState extends SocialStates {}


 // Users

class SocialGetUserLoadingState extends SocialStates {}

class SocialGetUserSuccessState extends SocialStates {}

class SocialGetUserErrorState extends SocialStates {
  final String error;

  SocialGetUserErrorState(this.error);
}

class SocialGetAllUsersLoadingState extends SocialStates {}

class SocialGetAllUsersSuccessState extends SocialStates {}
class SocialLoadingGetAllUserDataState extends SocialStates {}

class SocialGetAllUsersErrorState extends SocialStates {
  final String error;

  SocialGetAllUsersErrorState(this.error);
}


 // post

class SocialGetPostsLoadingState extends SocialStates {}

class SocialGetPostsSuccessState extends SocialStates {}

class SocialUserUpdateLoadingState extends SocialStates {}

class SocialGetPostsErrorState extends SocialStates {
  final String error;

  SocialGetPostsErrorState(this.error);
}

class SocialLikePostSuccessState extends SocialStates {}

class SocialLikePostErrorState extends SocialStates {
  final String error;

  SocialLikePostErrorState(this.error);
}

class SocialChangeBottomNavState extends SocialStates {}

class SocialNewPostState extends SocialStates {}

// profile

class SocialProfileImagePickedSuccessState extends SocialStates {}

class SocialProfileImagePickedErrorState extends SocialStates {}

class SocialCoverImagePickedSuccessState extends SocialStates {}

class SocialCoverImagePickedErrorState extends SocialStates {}

class SocialUploadProfileImageSuccessState extends SocialStates {}

class SocialUpdateUserImageLoadingState extends SocialStates {}

class SocialUpdateUserImageSuccessState extends SocialStates {}

class SocialUpdateUserImageErrorState extends SocialStates {}


class SocialUpdateUserCoverSuccessState extends SocialStates {}

class SocialUploadProfileImageErrorState extends SocialStates {}

class SocialUploadCoverImageSuccessState extends SocialStates {}

class SocialUploadCoverImageErrorState extends SocialStates {}

class SocialUserUpdateProfileLoadingState extends SocialStates {}

class SocialUserUpdateCoverLoadingState extends SocialStates {}

class SocialUserUpdateErrorState extends SocialStates {}

// create post

class SocialCreatePostLoadingState extends SocialStates {}

class SocialCreatePostSuccessState extends SocialStates {}

class SocialCreatePostErrorState extends SocialStates {}

class SocialPostImagePickedSuccessState extends SocialStates {}

class SocialPostImagePickedErrorState extends SocialStates {}

class SocialRemovePostImageState extends SocialStates {}



// create Comment

class SocialCreateCommentLoadingState extends SocialStates {}

class SocialCreateCommentSuccessState extends SocialStates {}

class SocialCreateCommentErrorState extends SocialStates {}

class SocialCommentImagePickedSuccessState extends SocialStates {}

class SocialCommentImagePickedErrorState extends SocialStates {}

class SocialRemoveCommentImageState extends SocialStates {}

// chat

class SocialSendMessageSuccessState extends SocialStates {}

class SocialSendMessageErrorState extends SocialStates {}

class SocialGetMessagesSuccessState extends SocialStates {}
class SocialLogOutState extends SocialStates {}

class SocialLogOutSuccessState extends SocialStates
{
  // final String uId;
  //
  // SocialLogOutSuccessState(this.uId);


}

class SocialLogOutErrorState extends SocialStates
{
  final String error;

  SocialLogOutErrorState(this.error);

}



   // Stories
class SocialCreateStoryLoadingState extends SocialStates {}

class SocialCreateStoryErrorState extends SocialStates {}

class SocialCreateStorySuccessState extends SocialStates {}

class SocialGetStoryLoadingState extends SocialStates {}

class SocialGetStorySuccessState extends SocialStates {}

class SocialUpdateUserPasswordLoadingState extends SocialStates {}

class SocialUpdateUserPasswordSuccessState extends SocialStates {}

class AppChangeModeState extends SocialStates {}
class SocialChangePasswordVisibilityState extends SocialStates {}


class SocialUpdateUserPasswordErrorState extends SocialStates
{
  final String error;

  SocialUpdateUserPasswordErrorState(this.error);

}

class SocialGetStoryErrorState extends SocialStates
{
  final String error;

  SocialGetStoryErrorState(this.error);

}



//comments
class SocialGetCommentsSuccessState extends SocialStates {}


class SocialGetCommentsNumberLoadingState extends SocialStates {}

class SocialGetCommentsNumberSuccessState extends SocialStates {}

class SocialCommentPostsSuccessState extends SocialStates {}

class SocialCommentPostsErrorState extends SocialStates {
  String error;
  SocialCommentPostsErrorState(this.error);
}

class SocialGetCommentsNumberErrorState extends SocialStates {
  String error;
  SocialGetCommentsNumberErrorState(this.error);
}
