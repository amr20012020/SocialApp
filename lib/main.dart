import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:social_app/modules/loginScreen/loginScreen.dart';
import 'package:social_app/shared/bloc_observer.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';
import 'package:social_app/shared/styles/themes.dart';
import 'package:splash_screen_view/SplashScreenView.dart';

import 'layout/cubit/cubit.dart';
import 'layout/social_layout.dart';

void main() async {
  // بيتأكد ان كل حاجه هنا في الميثود خلصت و بعدين يتفح الابلكيشن
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    //options: DefaultFirebaseOptions.currentPlatform,
  );
 // token = await FirebaseMessaging.instance.getToken();
  //print(' token is :  $token');
  // foreground fcm
//  FirebaseMessaging.onMessage.listen((event)
//  {
//    print('on message');
//    print(event.data.toString());
//
//    showToast(text: 'on message', state: ToastStates.SUCCESS,);
//  });
  // when click on notification to open app
//  FirebaseMessaging.onMessageOpenedApp.listen((event)
//  {
//    print('on message opened app');
//    print(event.data.toString());
//    showToast(text: 'on message opened app', state: ToastStates.SUCCESS,);
//  });
  // background fcm
  //FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  Bloc.observer = MyBlocObserver();
  await CacheHelper.init();
  bool ?isDark = CacheHelper.getData(key: 'isDark');
  Widget? widget;
  uId = CacheHelper.getData(key: 'uId');
  if (uId != null) {
    widget = SocialLayout();
  } else {
    widget = LoginScreen();
  }
  runApp(MyApp(
    isDark: isDark,
    startWidget: widget,
  ));
}

class MyApp extends StatelessWidget {
  final bool ?isDark;
  final Widget? startWidget;

  MyApp({
    this.isDark,
    this.startWidget,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (BuildContext context) => AppCubit()
              ..changeAppMode(
                // fromShared: isDark!,
              ),
          ),
          BlocProvider(
            create: (BuildContext context) => SocialCubit()
              ..getUserData()..getPosts()..getStory(),
          ),
        ],
        child: BlocConsumer<AppCubit, AppStates>(
          listener: (context, state) {},
          builder: (context, state) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: lightTheme,
              darkTheme: darkTheme,
              themeMode: AppCubit.get(context).isDark!
                  ? ThemeMode.dark
                  : ThemeMode.light,
              home: SplashScreenView(
                navigateRoute: startWidget,
                duration: 5000,
                imageSize: 130,
                imageSrc: "assets/images/social-media.png",
                text: "Social App",
                textType: TextType.ColorizeAnimationText,
                textStyle: TextStyle(
                  fontSize: 40.0,
                ),
                colors: [
                  Colors.blue,
                  Colors.deepOrange,
                  Colors.yellow,
                  Colors.lightBlue,
                ],
                backgroundColor: AppCubit.get(context).isDark!
                    ? HexColor('333739')
                    : Colors.white,
              ),
            );
          },
        ));
  }
}