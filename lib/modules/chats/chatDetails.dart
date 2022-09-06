import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/cubit.dart';
import 'package:social_app/layout/cubit/states.dart';
import 'package:social_app/model/messageModel.dart';
import 'package:social_app/model/user_model.dart';
import 'package:social_app/shared/styles/Icon_broken.dart';
import 'package:social_app/shared/styles/colors.dart';

class ChatDetails extends StatelessWidget
{
  SocialUserModel userModel;

  ChatDetails({Key? key, required this.userModel}) : super(key: key);

  var messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context){
        return BlocConsumer<SocialCubit, SocialStates>(
        builder: (context, state)
        {
          SocialCubit.get(context).getMessages(receiverId: userModel!.uId!);
          return Scaffold(
            appBar: AppBar(
              titleSpacing: 0.0,
              title: Row(
                children: [
                  CircleAvatar(
                    radius: 20.0,
                    backgroundImage: NetworkImage('${userModel.image}',),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Text('${userModel.name}',),
                ],
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Expanded(
                      child: ListView.separated(
                          itemBuilder: (context, index){
                            var message = SocialCubit.get(context).messages[index];
                            if(SocialCubit.get(context).userModel!.uId==message.senderId){
                              return buildMyMessage(message);
                            }
                            return buildMessage(message);
                          },
                          separatorBuilder: (context,state) => const SizedBox(height: 15,),
                          itemCount: SocialCubit.get(context).messages.length,
                      ),
                  ),
                  Spacer(),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(24.0),
                    ),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Row(
                      children:
                      [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15.0),
                            child: TextFormField(
                              controller: messageController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Type Your Message Here....',),
                            ),
                          ),
                        ),
                        IconButton(
                            onPressed: (){
                              //SocialCubit.get(context).getMessageImage();
                            },
                            icon: Icon(
                              Icons.camera_alt_outlined,
                              color: Colors.red,
                            ),
                        ),
                        const SizedBox(width: 5,),
                        Container(
                          //height: 40.0,
                          // color: defaultColor,
                          decoration: BoxDecoration(
                            color: defaultColor,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: MaterialButton(
                            onPressed: ()
                            {
                                SocialCubit.get(context).sendMessage(
                                  receiverId: userModel!.uId!,
                                  dateTime: DateTime.now().toString(),
                                  text: messageController.text,
                                );
                              messageController.clear();
                            },
                            minWidth: 1,
                            child: Icon(
                              IconBroken.Send,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }, listener: (context,state) {},
      );
      },
    );
  }


  Widget buildMessage(MessageUserModel model) =>  Align(
    alignment: AlignmentDirectional.centerStart,
    child: Container(
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadiusDirectional.only(
          bottomEnd: Radius.circular(10.0),
          topEnd: Radius.circular(10.0),
          topStart: Radius.circular(10.0),
        ),
        // border: Border.all(width: 1, color: Colors.red),
      ),
      padding: EdgeInsets.symmetric(
        vertical: 5.0,
        horizontal: 10.0,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${model.text}',
            style: const TextStyle(
              fontSize: 14,
            ),
          ),
          Text(
            '${model.dateTime.toString().substring(11,16)}',
            style: TextStyle(color: Colors.grey[400],fontSize: 10),
          ),
        ],
      ),
    ),
  );

  Widget buildMyMessage(MessageUserModel model) => Align(
    alignment: AlignmentDirectional.centerEnd,
    child: Container(
      decoration: BoxDecoration(
        color: defaultColor.withOpacity(.2),
        borderRadius: BorderRadiusDirectional.only(
          bottomStart: Radius.circular(10.0),
          topEnd: Radius.circular(10.0),
          topStart: Radius.circular(10.0),
        ),
        // border: Border.all(width: 1, color: Colors.red),
      ),
      padding: EdgeInsets.symmetric(
        vertical: 5.0,
        horizontal: 10.0,
      ),
      child: Text(
        '${model.text}',
      ),
    ),
  );
}
