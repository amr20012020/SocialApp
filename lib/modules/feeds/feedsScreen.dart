import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:social_app/layout/cubit/cubit.dart';
import 'package:social_app/layout/cubit/states.dart';
import 'package:social_app/layout/social_layout.dart';
import 'package:social_app/model/post_model.dart';
import 'package:social_app/modules/addPost/addPost.dart';
import 'package:social_app/modules/comments/commentsScreen.dart';
import 'package:social_app/modules/loginScreen/cubit/cubit.dart';
import 'package:social_app/modules/loginScreen/cubit/states.dart';
import 'package:social_app/modules/signUpScreen/signUp.dart';
import 'package:social_app/shared/adaptive/adaptivw_indicator.dart';
import 'package:social_app/shared/components/componets.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';
import 'package:social_app/shared/styles/Icon_broken.dart';
import 'package:social_app/shared/styles/colors.dart';

import '../view_story/view_story_screen.dart';

class FeedsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state){},
      builder: (context, state){
        var cubit = SocialCubit.get(context);
        return Conditional.single(
            context: context,
            conditionBuilder: (BuildContext context) => cubit.posts.isNotEmpty && cubit.userModel != null,
            widgetBuilder: (BuildContext context) => SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children:
                [
                  InkWell(
                    onTap: (){
                      navigateTo(context, NewPostScreen());
                    },
                    child: Container(
                      width: double.infinity,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Row(
                        children: [
                          Padding(
                              padding: const EdgeInsets.all(8.0),
                            child: CircleAvatar(
                              radius: 23,
                              backgroundImage: NetworkImage(
                                cubit.userModel!.image!,
                              ),
                            ),
                          ),
                          Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  border: Border.all(color: Colors.black,width: 2)
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'What is your mind?...',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),
                              ),
                          ),
                          const Padding(
                              padding: EdgeInsets.all(8.0),
                            child: Icon(
                              IconBroken.Image_2,
                              size: 25,
                              color: Colors.orange,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  myDivider(),
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Stories',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 18,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 200,
                    child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index)
                        {
                          return buildStoryItem(context,cubit.story[index],index,cubit.storyId);
                        },
                        separatorBuilder: (context,index) => const SizedBox(width: 10,),
                        itemCount: cubit.story.length,
                    ),
                  ),
                  const SizedBox(height: 20,),
                 /* Card(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    elevation: 5.0,
                    margin: EdgeInsets.all(8.0),
                    child: Stack(
                      alignment: AlignmentDirectional.bottomEnd,
                      children:
                      [
                        Image(
                          image: NetworkImage(
                            'https://api.time.com/wp-content/uploads/2019/08/better-smartphone-photos.jpg',
                          ),
                          fit: BoxFit.cover,
                          height: 200.0,
                          width: double.infinity,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Communicate with friends",
                            style: Theme
                                .of(context)
                                .textTheme
                                .subtitle1
                                ?.copyWith(
                              color: Colors.white,
                            ),),
                        ),
                      ],
                    ),
                  ),*/
                  ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) => buildPostItem(SocialCubit.get(context).posts[index],context, index),
                    separatorBuilder: (context,index) => SizedBox(height: 8.0,),
                    itemCount:  SocialCubit.get(context).posts.length,
                  ),
                  SizedBox(height: 8.0,),
                ],
              ),
            ),
            fallbackBuilder: (BuildContext context) => const Center(child: CircularProgressIndicator(),),
        );
      },
    );
  }
   Widget buildPostItem(PostModel model ,context, index) => Card(
     clipBehavior: Clip.antiAliasWithSaveLayer,
     elevation: 5.0,
     margin: EdgeInsets.symmetric(
       horizontal: 8.0,
     ),
     child: Padding(
       padding: const EdgeInsets.all(8.0),
       child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children:
         [
           Row(
             children:
             [
               CircleAvatar(
                 radius: 25.0,
                 backgroundImage: NetworkImage(
                   '${model.image}',
                 ),
               ),
               SizedBox(width: 15.0,),
               Expanded(
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Row(
                       children: [
                         Text(
                           '${model.name}',
                           style: TextStyle(
                               fontWeight: FontWeight.bold,
                               height: 1.4
                           ),
                         ),
                         SizedBox(width: 5,),
                         Icon(
                           Icons.check_circle,
                           color: Colors.blue,
                           size: 16.0,
                         ),
                       ],
                     ),
                     Text('${model.dateTime}'
                       , style: Theme
                           .of(context)
                           .textTheme
                           .caption
                           ?.copyWith(height: 1.4),),
                   ],
                 ),
               ),
               SizedBox(width: 15.0,),
               IconButton(
                   onPressed: () {},
                   icon: Icon(Icons.more_horiz, size: 16.0,)),
             ],
           ),
           Padding(
             padding: const EdgeInsets.symmetric(vertical: 15.0),
             child: Container(
               width: double.infinity,
               height: 1.0,
               color: Colors.grey[300],
             ),
           ),
           Text(
             '${model.text}',
             style: Theme
                 .of(context)
                 .textTheme
                 .subtitle1,
           ),
           /*Padding(
             padding: const EdgeInsets.only(bottom: 10.0, top: 5.0),
             child: Container(
               width: double.infinity,
               child: Wrap(
                 children:
                 [
                   Padding(
                     padding: const EdgeInsetsDirectional.only(end: 6.0),
                     child: Container(
                       child: MaterialButton(
                         onPressed: () {},
                         minWidth: 1.0,
                         padding: EdgeInsets.zero,
                         child: Text(
                           '#software',
                           style: Theme
                               .of(context)
                               .textTheme
                               .caption
                               ?.copyWith(
                             color: Colors.blue,
                           ),
                         ),
                       ),
                       height: 20.0,
                     ),
                   ),
                   Padding(
                     padding: const EdgeInsetsDirectional.only(end: 6.0),
                     child: Container(
                       child: MaterialButton(
                         onPressed: () {},
                         minWidth: 1.0,
                         padding: EdgeInsets.zero,
                         child: Text(
                           '#flutter',
                           style: Theme
                               .of(context)
                               .textTheme
                               .caption
                               ?.copyWith(
                             color: Colors.blue,
                           ),
                         ),
                       ),
                       height: 20.0,
                     ),
                   ),
                 ],
               ),
             ),
           ),*/
           if(model.postImage != '')
             Padding(
               padding: const EdgeInsetsDirectional.only(top: 15.0),
               child: Container(
                 height: 140.0,
                 width: double.infinity,
                 decoration: BoxDecoration(
                   borderRadius: BorderRadius.circular(4.0),
                   image: DecorationImage(
                     image: NetworkImage(
                       '${model.postImage}',
                     ),
                     fit: BoxFit.cover,
                   ),
                 ),
               ),
             ),
           Padding(
             padding: const EdgeInsets.symmetric(vertical: 5.0),
             child: Row(
               children:
               [
                 Expanded(
                   child: InkWell(
                     child: Padding(
                       padding: const EdgeInsets.symmetric(
                           vertical: 5.0),
                       child: Row(
                         children:
                         [
                           Icon(
                             IconBroken.Heart,
                             size: 20.0,
                             color: Colors.red,
                           ),
                           const SizedBox(width: 5,),
                           Text(
                             '${SocialCubit.get(context).likes[index]}',
                             style: Theme
                               .of(context)
                               .textTheme
                               .caption,),
                         ],
                       ),
                     ),
                   ),
                 ),
                 Expanded(
                   child: InkWell(
                     child: Padding(
                       padding: const EdgeInsets.symmetric(
                           vertical: 5.0),
                       child: Row(
                         mainAxisAlignment: MainAxisAlignment.end,
                         children:
                         [
                           Icon(
                             IconBroken.Chat,
                             size: 20.0,
                             color: Colors.amber,
                           ),
                           SizedBox(width: 5,),
                           Text(
                             /*'${SocialCubit.get(context).comments[index]}' +*/ " comment",
                             style: Theme
                               .of(context)
                               .textTheme
                               .caption,)

                         ],
                       ),
                     ),
                     onTap: ()
                     {
                       SocialCubit.get(context).getPostComments(SocialCubit.get(context).postsId[index]);
                       navigateTo(context, CommentScreen(postId :SocialCubit.get(context).postsId[index], index: index,));
                     },
                   ),
                 ),
               ],
             ),
           ),
           Container(
             width: double.infinity,
             height: 1.0,
             color: Colors.grey[300],
           ),
           Padding(
             padding: const EdgeInsets.only(top: 5.0),
             child: Row(
               children: [
                 Expanded(
                   child: InkWell(
                     onTap: () {
                       SocialCubit.get(context).getPostComments(SocialCubit.get(context).postsId[index]);
                       navigateAndFinish(context, CommentScreen(index: index, postId: SocialCubit.get(context).postsId[index],));
                     },
                     child: Row(
                       children:
                       [
                         CircleAvatar(
                           radius: 18.0,
                           backgroundImage: NetworkImage(
                             '${SocialCubit.get(context).userModel!.image}',
                           ),
                         ),
                         SizedBox(width: 15.0,),
                         Text('Write A Comment...'
                           , style: Theme
                               .of(context)
                               .textTheme
                               .caption
                               ?.copyWith(),),
                       ],
                     ),
                   ),
                 ),
                 InkWell(
                   child: Row(
                     children:
                     [
                       Icon(
                         IconBroken.Heart,
                         size: 20.0,
                         color: Colors.red,
                       ),
                       SizedBox(width: 5,),
                       Text('Like', style: Theme
                           .of(context)
                           .textTheme
                           .caption,)
                     ],
                   ),
                   onTap: ()
                   {
                     SocialCubit.get(context).likePost(SocialCubit.get(context).postsId[index]);
                   },
                 ),
               ],
             ),
           ),
         ],
       ),
     ),
   );



  Widget buildStoryItem(context,PostModel story, index, List<String> storyId)
  {
    return InkWell(
      onTap: ()
      {
        navigateTo(context, ViewStoryScreen(image: story.postImage!, text: story.text));
      },
      child: Conditional.single(
          context: context,
          conditionBuilder: (BuildContext context) => story.postImage != '',
          widgetBuilder: (BuildContext context) => Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.deepOrange,
            ),
            width: 125,
            height: 200,
            child: Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: Card(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Image.network(
                      story.postImage!,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.all(7.0),
                    child: Align(
                      alignment: AlignmentDirectional.topStart,
                      child: Stack(
                        alignment: AlignmentDirectional.bottomEnd,
                        children: [
                          const CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.blue,
                          ),
                          CircleAvatar(
                            radius: 23,
                            backgroundImage: NetworkImage(
                              story.image!,
                            ),
                          ),
                        ],
                      ),
                    ),
                ),
              ],
            ),

          ),
          fallbackBuilder: (BuildContext context) => Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.black54,
            ),
            width: 125,
            height: 200,
            child: Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(story.text!,style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),),
                    ),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: AlignmentDirectional.bottomStart,
                      child: Text(
                        story.name!,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ),
                Padding(
                    padding: const EdgeInsets.all(7.0),
                    child: Align(
                      alignment: AlignmentDirectional.topStart,
                      child: Stack(
                        alignment: AlignmentDirectional.bottomEnd,
                        children: [
                          const CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.red,
                          ),
                          CircleAvatar(
                            radius: 23,
                            backgroundImage: NetworkImage(
                              story.image!,
                            ),
                          ),
                        ],
                      ),
                    ),
                ),
              ],
            ),
          ),
      ),
    );

  }
}
