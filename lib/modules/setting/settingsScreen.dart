import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:social_app/layout/cubit/cubit.dart';
import 'package:social_app/layout/cubit/states.dart';
import 'package:social_app/modules/loginScreen/loginScreen.dart';
import 'package:social_app/modules/setting/editPassword.dart';
import 'package:social_app/modules/setting/editScreen.dart';
import 'package:social_app/shared/components/componets.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';
import 'package:social_app/shared/styles/Icon_broken.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
        listener: (context, state){},
        builder: (context, state){
          var cubit = SocialCubit.get(context);
          return Scaffold(
            backgroundColor: Colors.white,
            /*appBar: AppBar(
              title: const Text('Settings'),
            ),*/
            body: SingleChildScrollView(
              child: Column(
                children: [
                  InkWell(
                    onTap:(){
                      navigateTo(context,EditProfileScreen());
                    },
                    child: Container(
                      width: double.infinity,
                      height: 45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Icon(
                              IconBroken.Edit,
                              color: Colors.red,
                            ),
                            const SizedBox(width: 30,),
                            Text(
                              'Edit Profile',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            Icon(IconBroken.Arrow___Right_2, color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  fullDivider(),
                  const SizedBox(height: 10,),
                  InkWell(
                    onTap: (){
                      navigateTo(context,EditPasswordScreen());
                    },
                    child: Container(
                      width: double.infinity,
                      height: 45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Icon(IconBroken.Unlock,color: Colors.red,),
                            const SizedBox(width: 30,),
                            Text('Edit Password',style: TextStyle(fontSize: 20,color: Colors.black,fontWeight: FontWeight.bold),),
                            const Spacer(),
                            Icon(IconBroken.Arrow___Right_2,color: Colors.black,),
                          ],
                        ),
                      ),
                    ),
                  ),
                  fullDivider(),
                  const SizedBox(height: 10,),
                  Align(
                    alignment: AlignmentDirectional.bottomCenter,
                    child: InkWell(
                      onTap: (){
                        navigateAndFinish(context, LoginScreen());
                        uId = '';
                        showToast(text: "Logout", state: ToastStates.ERROR);
                        CacheHelper.removeData(key: 'uId');
                        cubit.currentIndex = 0;
                      },
                      child: Container(
                        width: double.infinity,
                        height: 45,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: 
                            [
                              Icon(IconBroken.Logout,color: Colors.red,),
                              const SizedBox(width: 30,),
                              Text('LOGOUT',style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              ),
                              const Spacer(),
                              Icon(IconBroken.Arrow___Right_2,color: Colors.black,)
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  fullDivider(),
                ],
              ),
            ),
          );
        },
       );
  }
}
