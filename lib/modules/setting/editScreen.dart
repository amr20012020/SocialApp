import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/layout/cubit/cubit.dart';
import 'package:social_app/layout/cubit/states.dart';
import 'package:social_app/shared/components/componets.dart';
import 'package:social_app/shared/styles/Icon_broken.dart';

/*class EditScreen extends StatelessWidget
{
  const EditScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit,SocialStates>(
      listener: (context, state){},
      builder: (context,state)
      {
        var nameController = TextEditingController();
        var bioController = TextEditingController();
        var phoneController = TextEditingController();
        var userModel = SocialCubit.get(context).userModel;
        var profileImage =SocialCubit.get(context).profileImage;
        var coverImage =SocialCubit.get(context).coverImage;


        nameController.text = userModel!.name;
        bioController.text = userModel!.bio;
        phoneController.text = userModel!.phone;


        return Scaffold(
          appBar: defaultAppBar(
              context: context,
              title: 'Edit Profile',
              actions: [
                defaultTextButton(
                  function: ()
                  {
                    SocialCubit.get(context).updateUser(
                        name: nameController.text,
                        phone: phoneController.text,
                        bio: bioController.text,
                        image: profileImage.toString(),
                    );
                  },
                  text: 'Update',
                ),
                SizedBox(width: 15,),
              ]
          ),
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children:
                [
                  if(state is SocialGetUserLoadingState)
                    LinearProgressIndicator(color: Colors.red,),
                  if(state is SocialGetUserLoadingState)
                    SizedBox(height: 10,),
                   Container(
                     height: 190,
                     child: Stack(
                       alignment: AlignmentDirectional.bottomCenter,
                       children: [
                         Align(
                           alignment: AlignmentDirectional.topCenter,
                           child: Stack(
                             alignment: AlignmentDirectional.topEnd,
                             children:
                             [
                               Container(
                                 height: 140.0,
                                 width: double.infinity,
                                 decoration: BoxDecoration(
                                   borderRadius: const BorderRadius.only(
                                     topLeft: Radius.circular(4),
                                     topRight: Radius.circular(4),
                                   ),
                                   image: DecorationImage(
                                     image: coverImage == null
                                        ? NetworkImage('${userModel.cover}')
                                        : FileImage(coverImage) as ImageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              IconButton(
                                  onPressed: (){
                                    SocialCubit.get(context).getCoverImage();
                                  },
                                  icon: CircleAvatar(
                                      radius: 20.0,
                                      child: Icon(
                                        IconBroken.Camera,
                                        size: 16.0,)
                                  ),
                              ),
                            ],
                          ),
                        ),
                        Stack(
                          alignment: AlignmentDirectional.bottomEnd,
                          children:
                          [
                            CircleAvatar(
                              radius: 64,
                              backgroundColor:
                              Theme.of(context).scaffoldBackgroundColor,
                              child: CircleAvatar(
                                radius: 60,
                                backgroundImage:profileImage == null
                                    ? NetworkImage('${userModel.image}')
                                    : FileImage(profileImage) as ImageProvider,
                              ),
                            ),
                            IconButton(
                              onPressed: (){
                                SocialCubit.get(context).getProfileImage();
                              },
                              icon: CircleAvatar(
                                  radius: 20.0,
                                  child: Icon(
                                    IconBroken.Camera,
                                    size: 16.0,)
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  defaultFormField(
                      controller: nameController,
                      validate: (String ?value)
                      {
                        if(value!.isEmpty)
                        {
                          return 'name must not be empty';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.name,
                      label: 'Name',
                      prefix: IconBroken.User),

                  const SizedBox(
                    height: 15,
                  ),
                  defaultFormField(
                      controller: bioController,
                      validate: (String ?value)
                      {
                        if(value!.isEmpty)
                        {
                          return 'bio must not be empty';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.text,
                      label: 'Bio',
                      prefix: IconBroken.Info_Circle),

                  const SizedBox(
                    height: 15,
                  ),
                  defaultFormField(
                      controller: phoneController,
                      validate: (String ?value)
                      {
                        if(value!.isEmpty)
                        {
                          return 'phone must not be empty';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.phone,
                      label: 'Phone',
                      prefix: IconBroken.Call),
                ],
              ),
            ),
          ),

        );
      },
    );
  }
} */

class EditProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var nameController = TextEditingController();
    var phoneController = TextEditingController();
    var bioController = TextEditingController();
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = SocialCubit.get(context);
        var userModel = SocialCubit.get(context).userModel;
        File? profileImage = SocialCubit.get(context).profileImage;
        File? coverImage = SocialCubit.get(context).coverImage;
        ImageProvider backG;
        ImageProvider backGCover;
        if(profileImage == null){
          backG = NetworkImage('${userModel!.image}');
        } else {
          backG = FileImage(profileImage);
        }
        if(coverImage == null){
          backGCover = NetworkImage('${userModel!.cover}');
        } else {
          backGCover = FileImage(coverImage);
        }
        nameController.text = userModel!.name!;
        phoneController.text = userModel.phone!;
      //  bioController.text = userModel.bio!;

        return Scaffold(
          appBar:
          defaultAppBar(context: context, title: 'Edit profile', actions: [
            defaultTextButton(
                function: () {
                  SocialCubit.get(context).updateUser(
                    name: nameController.text,
                    phone: phoneController.text,
                    bio: bioController.text,
                  );
                },
                text: 'update'),
            SizedBox(
              width: 15,
            )
          ]),
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  if (state is SocialGetUserLoadingState)
                    LinearProgressIndicator(),
                  if (state is SocialGetUserLoadingState)
                    SizedBox(
                      height: 10.0,
                    ),
                  Container(
                    height: 190,
                    child: Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: [
                        Align(
                          child: Stack(
                            alignment: AlignmentDirectional.topEnd,
                            children: [
                              Container(
                                height: 140,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(
                                      4.0,
                                    ),
                                    topRight: Radius.circular(
                                      4.0,
                                    ),
                                  ),
                                  image: DecorationImage(
                                    image: backGCover/*coverImage == null
                                        ? NetworkImage('${userModel.cover}')
                                        : FileImage(coverImage)
                                    as ImageProvider*/,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: CircleAvatar(
                                  radius: 20,
                                  child: Icon(
                                    IconBroken.Camera,
                                    size: 16,
                                  ),
                                ),
                                onPressed: () {
                                  SocialCubit.get(context).getCoverImage();
                                },
                              ),
                            ],
                          ),
                          alignment: AlignmentDirectional.topCenter,
                        ),
                        Stack(
                          alignment: AlignmentDirectional.bottomEnd,
                          children: [
                            CircleAvatar(
                              radius: 64,
                              backgroundColor:
                              Theme.of(context).scaffoldBackgroundColor,
                              child: CircleAvatar(
                                radius: 60,
                                backgroundImage: backG/*profileImage == null
                                    ? NetworkImage('${userModel.image}')
                                    : FileImage(profileImage) as ImageProvider*/,
                              ),
                            ),
                            IconButton(
                              icon: CircleAvatar(
                                radius: 20,
                                child: Icon(
                                  IconBroken.Camera,
                                  size: 16,
                                ),
                              ),
                              onPressed: () {
                                SocialCubit.get(context).getProfileImage();
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  if(SocialCubit.get(context).profileImage != null ||
                      SocialCubit.get(context).coverImage != null)
                        Row(
                      children: [
                        if(SocialCubit.get(context).profileImage != null)
                          Expanded(
                              child: Column(
                                children:
                                [
                                  defaultButton(
                                      function: ()
                                      {
                                        SocialCubit.get(context).uploadProfileImage(
                                            name: nameController.text,
                                            phone: phoneController.text,
                                            bio: bioController.text,
                                        );
                                        showToast(text: "Success", state: ToastStates.SUCCESS);
                                      },
                                      text: 'Upload Profile'),
                                 if(state is SocialUserUpdateProfileLoadingState)
                                   SizedBox(height: 5.0,),
                                 if(state is SocialUserUpdateProfileLoadingState)
                                   LinearProgressIndicator(),
                                 // SizedBox(height: 5,),
                                 // LinearProgressIndicator(),
                                ],
                              )),
                        SizedBox(width: 5.0,),
                        if(SocialCubit.get(context).coverImage != null)
                            Expanded(
                                child: Column(
                                  children: [
                                    defaultButton(
                                        function: () {
                                          SocialCubit.get(context).uploadCoverImage();
                                        },
                                        text: 'Upload Cover'
                                    ),
                                  if(state is SocialUserUpdateCoverLoadingState)
                                    const LinearProgressIndicator(),
                                  if(state is SocialUserUpdateCoverLoadingState)
                                    const SizedBox(height: 5.0,),
                                  //  SizedBox(height: 5,),
                                   // LinearProgressIndicator(),
                                  ],
                                ),
                            ),
                      ],
                    ),
                  if (SocialCubit.get(context).profileImage != null ||
                      SocialCubit.get(context).coverImage != null)
                    SizedBox(
                      height: 20,
                    ),
                  Column(
                    children: [
                      defaultFormField(
                        controller: nameController,
                        keyboardType: TextInputType.name,
                        validate: (String? value) {
                          if (value!.isEmpty) {
                            return 'name must not be empty';
                          }
                          return null;
                        },
                        label: 'Name',
                        prefix: IconBroken.User,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      defaultFormField(
                        controller: bioController,
                        keyboardType: TextInputType.text,
                        validate: (String? value) {
                          if (value!.isEmpty) {
                            return 'bio must not be empty';
                          }
                          return null;
                        },
                        label: 'Bio',
                        prefix: IconBroken.Info_Circle,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      defaultFormField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        validate: (String? value) {
                          if (value!.isEmpty) {
                            return 'phone number must not be empty';
                          }

                          return null;
                        },
                        label: 'Phone',
                        prefix: IconBroken.Call,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
