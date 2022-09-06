import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:social_app/layout/social_layout.dart';
import 'package:social_app/modules/loginScreen/cubit/cubit.dart';
import 'package:social_app/modules/loginScreen/cubit/states.dart';
import 'package:social_app/modules/signUpScreen/signUp.dart';
import 'package:social_app/shared/adaptive/adaptivw_indicator.dart';
import 'package:social_app/shared/components/componets.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';

class LoginScreen extends StatelessWidget {

  var formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => SocialLoginCubit(),
      child: BlocConsumer<SocialLoginCubit,SocialLoginStates>(
        listener: (context, state){
          if(state is SocialLoginErrorState){
           showToast(text: state.error, state: ToastStates.ERROR);
          }
          if(state is SocialLoginSuccessState){
            CacheHelper.saveData(key: 'uId', value: state.uId)
                .then((value)async{
                  showToast(text: 'Login Success', state: ToastStates.SUCCESS);
                  navigateAndFinish(context, SocialLayout());
            });
          }
        },
        builder: (context,state){
         return Scaffold(
            /*appBar: AppBar(
            systemOverlayStyle: SystemUiOverlayStyle.light,
            backgroundColor: Colors.blue,
          ),*/
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('LOGIN',style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            color: Colors.grey),
                        ),
                        Text('Login Now To Communicate with friends',
                          style: Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.grey),),
                        SizedBox(height: 30.0,),
                        defaultFormField(
                          controller: emailController,
                          validate: (String? value){
                            if(value!.isEmpty){
                              return 'Please enter your email address';
                            }
                          },
                          keyboardType: TextInputType.emailAddress,
                          label: 'Email',
                          prefix: Icons.email_outlined,
                        ),
                        SizedBox(height: 15.0,),
                        defaultFormField(
                            controller: passwordController,
                            keyboardType: TextInputType.visiblePassword,
                            label: 'Password',
                            suffix: SocialLoginCubit.get(context).suffix,
                            onSubmit: (value){
                              if(formKey.currentState!.validate()){
                                SocialLoginCubit.get(context).userLogin(
                                    email: emailController.text,
                                    password: passwordController.text,
                                );
                              }
                            },
                            isPassword: SocialLoginCubit.get(context).isPassword,
                            suffixPressed: (){
                              SocialLoginCubit.get(context).changePasswordVisibility();
                            },
                            prefix: Icons.lock_outline,
                            validate: (String? value){
                              if(value!.isEmpty){
                                return 'password is too short';
                              }
                            }
                        ),
                        SizedBox(height: 30.0,),
                        Conditional.single(
                          context: context,
                          conditionBuilder: (context) => state is! SocialLoginLoadingState,
                          widgetBuilder: (context) => defaultButton(
                            function: (){
                              if(formKey.currentState!.validate()){
                                SocialLoginCubit.get(context).userLogin(
                                    email: emailController.text,
                                    password: passwordController.text,
                                );
                               // navigateAndFinish(context, SocialLayout());
                              }
                            },
                            text: 'Login',
                            isUpperCase: true,
                          ),
                          fallbackBuilder: (context) => Center(
                            child: AdaptiveIndicator(os: getOS(),),
                          ),
                        ),
                        SizedBox(height: 60.0,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Don\'t have an account?'),
                            defaultTextButton(function: (){
                              navigateAndFinish(context, SocialRegisterScreen());
                            }, text: 'SignUp'),
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
