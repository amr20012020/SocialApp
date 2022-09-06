import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:social_app/layout/cubit/cubit.dart';
import 'package:social_app/layout/cubit/states.dart';
import 'package:social_app/layout/social_layout.dart';
import 'package:social_app/shared/components/componets.dart';

class ViewStoryScreen extends StatelessWidget {
  String? image;
  String? text;
  ViewStoryScreen({Key? key, this.text, this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
       // var cubit = SocialCubit.get(context);
        return Scaffold(
          body: SafeArea(
            child: Conditional.single(
              context: context,
              conditionBuilder: (BuildContext context) => image != '',
              widgetBuilder: (BuildContext context) => Stack(
                alignment: AlignmentDirectional.topEnd,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      width: double.infinity,
                      height: double.infinity,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Image.network(
                        image!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.red,
                      child: IconButton(
                        onPressed: () {
                          navigateAndFinish(context, SocialLayout());
                        },
                        icon: const Icon(
                          Icons.close_rounded,
                          size: 25,
                          color: Colors.white,
                        )),
                    ),
                  ),
                  if(text!=null)
                    Padding(
                        padding: const EdgeInsets.all(20.0),
                      child: Align(
                        alignment: AlignmentDirectional.bottomCenter,
                        child: Text(
                          text!,
                          style: const TextStyle(
                            backgroundColor: Colors.black54,
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              fallbackBuilder: (BuildContext context) => Stack(
                alignment: AlignmentDirectional.topEnd,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.black,
                      ),
                      width: double.infinity,
                      height: double.infinity,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Center(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Text(
                                  text!,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.red,
                      child: IconButton(
                        onPressed: () {
                          navigateAndFinish(context, SocialLayout());
                        },
                        icon: const Icon(
                          Icons.close_rounded,
                          size: 25,
                          color: Colors.white,
                        ),
                      ),
                    ),
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
