import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:social_app/layout/cubit/cubit.dart';
import 'package:social_app/layout/cubit/states.dart';
import 'package:social_app/shared/components/componets.dart';
import 'package:social_app/shared/styles/Icon_broken.dart';
import 'package:social_app/shared/styles/colors.dart';

class EditPasswordScreen extends StatelessWidget {
  const EditPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var newPasswordController = TextEditingController();
    var newPasswordController2 = TextEditingController();
    return BlocConsumer<SocialCubit,SocialStates>(
        builder: (context,state){
          var formKey = GlobalKey<FormState>();
          var cubit = SocialCubit.get(context);
          var userModel = SocialCubit.get(context).userModel;
          return Conditional.single(
              context: context,
              conditionBuilder: (BuildContext context) => userModel!=null,
              widgetBuilder: (BuildContext context){
                return Scaffold(
                  appBar: AppBar(
                    title: const Text('Edit Password'),
                    actions: const [
                      Icon(IconBroken.Edit_Square),
                      SizedBox(
                        width: 10,
                      )
                    ],
                  ),
                  body: Padding(
                    padding: const EdgeInsets.all(20),
                    child: SingleChildScrollView(
                      child: Form(
                        key: formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'You Should Re-Login Before Change Password',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            designedFormField(
                              isPassword: cubit.isPassword,
                              fontColor: defaultColor,
                              controller: newPasswordController,
                              type: TextInputType.visiblePassword,
                              label: 'New Password',
                              validator: (String? value){
                                if(value!.isEmpty){
                                  return 'Password must not be empty';
                                }
                                if(value != newPasswordController2.text){
                                  return 'new Password is not the same';
                                }
                              },
                              prefixIcon: IconBroken.Unlock,
                              //suffixIcon: cubit.suffix,
                            ),
                            const SizedBox(height: 20,),
                            designedFormField(
                              function: (){
                                cubit.changePasswordVisibility();
                              },
                              isPassword: cubit.isPassword,
                              fontColor: defaultColor,
                              controller: newPasswordController2,
                              type: TextInputType.visiblePassword,
                              label: 'Repeat New Password',
                              validator: (String? value){
                                if(value!.isEmpty){
                                  return 'Password must not be empty';
                                }
                                if(value != newPasswordController.text){
                                  return 'new Password is not the same';
                                }
                              },
                              prefixIcon: IconBroken.Unlock,
                            ),
                            const SizedBox(height: 55,),
                            Center(
                              child: defaultButton(
                                radius: 25,
                                function: (){
                                  if(formKey.currentState!.validate()){
                                    cubit.updateUserPassword(
                                        password: newPasswordController.text,
                                    );
                                  }
                                },
                                text: 'Update Password',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
              fallbackBuilder: (BuildContext context) => const Center(child: CircularProgressIndicator(),),
          );
        },
        listener: (context,state){});
  }
}
