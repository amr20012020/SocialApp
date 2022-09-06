import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:social_app/layout/cubit/cubit.dart';
import 'package:social_app/layout/cubit/states.dart';
import 'package:social_app/model/CommentModel.dart';
import 'package:social_app/shared/components/componets.dart';

import '../../layout/social_layout.dart';

class CommentScreen extends StatelessWidget {
   CommentScreen({Key? key,required this.postId,required this.index}) : super(key: key);


  int index;
  String postId;

  @override
  Widget build(BuildContext context) {
    var commentController = TextEditingController();
    var formKey = GlobalKey<FormState>();
    return BlocConsumer<SocialCubit,SocialStates>(
        listener: (context,state){
           //navigateAndFinish(context,SocialLayout());
          //showToast(text: 'Commented', state: ToastStates.SUCCESS);
        },
        builder: (context,state)
        {
          var cubit = SocialCubit.get(context);
         return Scaffold(
            appBar: AppBar(
              title: const Text('Comments'),
            ),
            body: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Conditional.single(
                                context: context,
                                conditionBuilder: (BuildContext context) => cubit.comments.isNotEmpty,
                                widgetBuilder: (BuildContext context) {
                                  List<CommentModel> model = cubit.comments;
                                  cubit.comments = [];
                                  return ListView.separated(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) => buildCommentItem(context, model[index]),
                                      separatorBuilder: (context, index) => const SizedBox(height:12),
                                      itemCount: model.length,
                                  );
                                },
                                fallbackBuilder: (BuildContext context) => Center(
                                  child: Text(
                                    '',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22,
                                    ),
                                  ),
                                )),
                          ],
                        ),
                      ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      style: TextStyle(
                        color: Colors.red,
                      ),
                      controller: commentController,
                      validator: (String? value){
                        if(value!.isEmpty){
                          return 'comment is empty';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(
                          color: Colors.red,
                        ),
                        errorStyle: TextStyle(
                          color: Colors.red,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.arrow_forward_ios_outlined,color: Colors.black,),
                          onPressed: ()
                          {
                            if(formKey.currentState!.validate()){
                              SocialCubit.get(context).commentsPost(
                                  SocialCubit.get(context).postsId[index],
                                  commentController.text,
                              );
                              commentController.text = '';
                              navigateAndFinish(context, SocialLayout());
                            //  showToast(text: 'Comment Success', state: ToastStates.SUCCESS);
                            }
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        hintText: 'Write a Comment...',
                        hintStyle: TextStyle(color: Colors.red
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10,),
                ],
              ),
            ),
          );
        },
    );
  }
}

Widget buildCommentItem(context, CommentModel commentModel) => Padding(
    padding: const EdgeInsets.all(8.0),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      CircleAvatar(
        radius: 25.0,
        backgroundImage: NetworkImage(
          commentModel.image!,
        ),
      ),
      const SizedBox(width: 15.0,),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            commentModel.comment!,
            style: Theme.of(context).textTheme.caption!.copyWith(
                color: Colors.black
            ),
          ),
          const SizedBox(height: 5.0,),
          Text(
            commentModel.dateTime.toString().substring(0,16),
            style: Theme.of(context).textTheme.caption!.copyWith(color: Colors.black45,fontSize: 12),
          ),
         /* const SizedBox(height: 5.0,),
          IconButton(
              onPressed: () {},
              icon: Icon(Icons.more_horiz, size: 16.0,)),*/
        ],
      ),
      SizedBox(
        width: 15.0,
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                  onPressed: ()
                  {


                  },
                  icon: Icon(Icons.more_horiz, size: 16.0,)),
            ],
          ),
        ],
      ),
    ],
  ),
);
