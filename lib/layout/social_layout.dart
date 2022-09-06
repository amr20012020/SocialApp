import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/cubit.dart';
import 'package:social_app/layout/cubit/states.dart';
import 'package:social_app/modules/addPost/addPost.dart';
import 'package:social_app/modules/loginScreen/loginScreen.dart';
import 'package:social_app/modules/setting/profileScreen.dart';
import 'package:social_app/shared/adaptive/adaptivw_indicator.dart';
import 'package:social_app/shared/components/componets.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/shared/styles/Icon_broken.dart';

import '../modules/addPost/addStory.dart';

class SocialLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {
        if (state is SocialNewPostState) {
          navigateTo(context, NewPostScreen());
        }
      },
      builder: (context, state) {
        var cubit = SocialCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Text(cubit.titles[cubit.currentIndex]),
            actions: [
              IconButton(onPressed: (){}, icon: Icon(IconBroken.Notification)),
              IconButton(onPressed: (){}, icon: Icon(IconBroken.Search)),
              cubit.userModel != null
                  ? InkWell(
                onTap: (){
                  navigateTo(context, ProfileScreen());
                },
                child: CircleAvatar(
                  radius: 24,
                  child: CircleAvatar(
                    radius: 22.0,
                    backgroundImage: NetworkImage('${cubit.userModel!.image}'),
                  ),
                ),
              ) : Center(
                child: AdaptiveIndicator(
                  os: getOS(),
                ),
              ),
              SizedBox(width: 5,),
            ],
          ),
          body: cubit.screens[cubit.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: cubit.currentIndex,
            onTap: (index){
              cubit.changeBottomNav(index);
            },
            items: [
              BottomNavigationBarItem(
                  icon: Icon(IconBroken.Home), label: 'Home'),
              BottomNavigationBarItem(
                  icon: Icon(IconBroken.Chat), label: 'Chats'),
              BottomNavigationBarItem(
                  icon: Icon(IconBroken.Paper_Upload), label: 'Post'),
              BottomNavigationBarItem(
                  icon: Icon(IconBroken.User), label: 'Profile'),
              BottomNavigationBarItem(
                  icon: Icon(IconBroken.Setting), label: 'Setting'),
            ],
          ),
        );
      },
    );
  }
}
