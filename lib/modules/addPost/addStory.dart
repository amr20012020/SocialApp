import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/cubit.dart';
import 'package:social_app/layout/cubit/states.dart';
import 'package:social_app/layout/social_layout.dart';
import 'package:social_app/shared/components/componets.dart';
import 'package:social_app/shared/styles/Icon_broken.dart';

class NewStoryScreen extends StatelessWidget {
  const NewStoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var textController = TextEditingController();
    return BlocConsumer<SocialCubit, SocialStates>(
        listener: (context, state) {
          if(state is SocialCreateStorySuccessState)
            {
              navigateAndFinish(context, SocialLayout());
              showToast(text: 'Story Shared', state: ToastStates.SUCCESS);
            }
        },
        builder: (context, state) {
          var cubit = SocialCubit.get(context);
          var userModel = cubit.userModel;
          return Scaffold(
            appBar: defaultAppBar(
                context: context,
                title: 'Create Story',
                actions: [
                  defaultTextButton(
                      function: ()
                      {
                        var now = DateTime.now();
                        if(cubit.postImage == null){
                          cubit.createStory(
                              dateTime: now.toString(),
                              text: textController.text,
                          );
                        } else {
                          cubit.uploadStoryImage(
                              dateTime: now.toString(),
                              text: textController.text,
                          );
                        }

                      },
                      text: 'Post'),
                ]),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  if (state is SocialCreateStoryLoadingState)
                    const LinearProgressIndicator(),
                  if (state is SocialCreateStoryLoadingState)
                    const SizedBox(
                      height: 15,
                    ),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 25.0,
                        backgroundImage: NetworkImage(userModel!.image!),
                      ),
                      const SizedBox(
                        width: 15.0,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  '${userModel.name}',
                                  style: TextStyle(
                                      color: Colors.black,
                                      height: 1.4,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                      child: TextFormField(
                        style: TextStyle(
                          color: Colors.black,
                        ),
                        controller: textController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          errorStyle: TextStyle(color: Colors.red),
                          labelStyle: TextStyle(color: Colors.green),
                          hintStyle: TextStyle(color: Colors.red),
                          hintText: 'What is your mind ${userModel.name}...',
                        ),
                      ),
                  ),
                  const SizedBox(height: 20,),
                  if(cubit.postImage != null)
                    Stack(
                      alignment: AlignmentDirectional.topEnd,
                      children: [
                        Container(
                          height: 140.0,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            image: DecorationImage(
                              image: FileImage(cubit.postImage!),
                              fit: BoxFit.cover,
                            )
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                          child: CircleAvatar(
                            radius: 20,
                            child: IconButton(
                              onPressed: (){
                                cubit.removePostImage();
                              },
                              icon: const Icon(
                                Icons.close, size: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 20,),
                  Row(
                    children: [
                      Expanded(
                          child: TextButton(
                            onPressed: () {
                              cubit.getPostImage();
                            },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const
                            [
                              Icon(
                                IconBroken.Image,
                              ),
                              SizedBox(width: 5,),
                              Text('Add Photo'),
                            ],
                          ),
                          )),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }
}
