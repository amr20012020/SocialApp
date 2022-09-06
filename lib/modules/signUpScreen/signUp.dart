import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:social_app/modules/loginScreen/loginScreen.dart';
import 'package:social_app/modules/signUpScreen/cubit/cubit.dart';
import 'package:social_app/modules/signUpScreen/cubit/states.dart';
import 'package:social_app/shared/adaptive/adaptivw_indicator.dart';
import 'package:social_app/shared/components/componets.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';
import 'package:social_app/shared/styles/Icon_broken.dart';

class SocialRegisterScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var bioController = TextEditingController();
  var passwordController = TextEditingController();
  var phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => SocialRegisterCubit(),
      child: BlocConsumer<SocialRegisterCubit,SocialRegisterStates>(
       listener: (context, state){
         if(state is SocialCreateUserSuccessState){
           CacheHelper.saveData(key: 'uId', value: state.uId)
               .then((value)async
           {
             showToast(text: 'Welcome in Social App', state: ToastStates.SUCCESS);
             navigateAndFinish(context, LoginScreen());
           });
         }
       },
        builder: (context,state){
         return Scaffold(
            resizeToAvoidBottomInset: false,
            body: Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('REGISTER', style: Theme.of(context).textTheme.headline4!.copyWith(color: Colors.black),),
                        Text('REGISTER NOW TO COMMUNICATE WITH FRIENDS', style: Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.grey),),
                        SizedBox(height: 30.0,),
                        defaultFormField(
                          controller: nameController,
                          keyboardType: TextInputType.name,
                          validate: (String ?value){
                            if(value!.isEmpty){
                              return 'Please Enter Your Name';
                            }
                          },
                          label: 'UserName',
                          prefix: Icons.person,
                        ),
                        SizedBox(height: 15.0,),
                        defaultFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          validate: (String? value){
                            if(value!.isEmpty) {
                              return 'Please Enter Your Email Address';
                            }
                          },
                          label: 'Email Address',
                          prefix: Icons.email_outlined,
                        ),
                        SizedBox(height: 15.0,),
                        defaultFormField(
                          controller: bioController,
                          keyboardType: TextInputType.text,
                          validate: (String? value){
                            if(value!.isEmpty) {
                              return 'Please Enter Your Bio';
                            }
                          },
                          label: 'Bio',
                          prefix: IconBroken.Info_Circle,
                        ),
                        SizedBox(height: 15.0,),
                        defaultFormField(
                          controller: phoneController,
                          keyboardType: TextInputType.phone,
                          validate: (String? value){
                            if(value!.isEmpty){
                              return 'Please Enter Your Phone Number';
                            }
                          },
                          label: 'Phone Number',
                          prefix: Icons.phone,
                        ),
                        SizedBox(height: 15.0,),
                        defaultFormField(
                          controller: passwordController,
                          keyboardType: TextInputType.visiblePassword,
                          label: 'Password',
                          /*validate: (String? value){
                            return 'Password is Too Short';
                          },*/
                          prefix: Icons.password,
                        ),
                        SizedBox(height: 30.0,),
                        Conditional.single(
                          context: context,
                          conditionBuilder: (context) => state is! SocialRegisterLoadingState,
                          widgetBuilder: (context) => defaultButton(
                            function: (){
                              if(formKey.currentState!.validate()){
                                SocialRegisterCubit.get(context).userRegister(
                                    name: nameController.text,
                                    email: emailController.text,
                                    password: passwordController.text,
                                    phone: phoneController.text,
                                    bio: bioController.text,
                                );
                              }
                            },
                            text: 'Sign Up',
                            isUpperCase: true,
                          ),
                          fallbackBuilder: (context) => Center(
                            child: AdaptiveIndicator(os: getOS()),
                          ),
                        ),
                        SizedBox(height: 30.0,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Already have account?'),
                            defaultTextButton(function: (){
                              navigateAndFinish(context, LoginScreen());
                            }, text: 'SignIn'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
