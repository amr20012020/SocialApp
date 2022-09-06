import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:social_app/layout/cubit/cubit.dart';
import 'package:social_app/layout/cubit/states.dart';
import 'package:social_app/model/user_model.dart';
import 'package:social_app/shared/components/componets.dart';

import 'chatDetails.dart';

class ChatsScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context)
  {
    return BlocConsumer<SocialCubit,SocialStates>(
      listener: (context,state) {},
      builder: (context,state)
      {
        return Conditional.single(
            widgetBuilder: (BuildContext context) => ListView.separated(
              physics: BouncingScrollPhysics(),
              itemBuilder: (context,index) => buildChatItem(SocialCubit.get(context).users[index],context),
              separatorBuilder: (context ,index) => myDivider(),
              itemCount: SocialCubit.get(context).users.length,
            ),
            context: context,
            fallbackBuilder: (BuildContext context) => CircularProgressIndicator(),
            conditionBuilder: (BuildContext context) => SocialCubit.get(context).users.length > 0,
        );
      },
    );
  }

  Widget buildChatItem(SocialUserModel model, context) => InkWell(
    onTap: (){
      navigateTo(context, ChatDetails(userModel: model,));
    },
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
          children:
          [
            CircleAvatar(
              radius: 25.0,
              backgroundImage: NetworkImage(
                '${model.image}',
              ),
            ),
            SizedBox(width: 15.0,),
            Text(
              '${model.name}',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  height: 1.4
              ),
            ),
          ],
        ),
    ),
  );

}
