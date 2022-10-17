import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hotreloader/hotreloader.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:wit_canteen_app/auth/check.dart';
import 'package:wit_canteen_app/auth/google_sign_in.dart';
import 'package:wit_canteen_app/auth/sign_up.dart';
import 'package:wit_canteen_app/globals.dart';
import 'package:wit_canteen_app/onboard/onboarding.dart';
import 'package:wit_canteen_app/screens/home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //reloader = await HotReloader.create();
  //print('cndn--${open['open']}');
  runApp(MyApp());
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GoogleSignInProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'WIT Canteen App',
        /*builder: (BuildContext context, Widget? widget) {
          ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
            return Container();
          };
          //print(FirebaseAuth.instance.currentUser!.uid);
          return widget!;
        },*/
        builder: (context, child) => ResponsiveWrapper.builder(
            BouncingScrollWrapper.builder(context, child!),
            maxWidth: getWidth(context),
            minWidth: 300,
            defaultScale: true,
            mediaQueryData:
                MediaQuery.of(context).copyWith(textScaleFactor: 0.8),
            breakpoints: [
              const ResponsiveBreakpoint.resize(300, name: MOBILE),
              const ResponsiveBreakpoint.autoScale(800, name: TABLET),
              const ResponsiveBreakpoint.autoScale(1000, name: TABLET),
              const ResponsiveBreakpoint.resize(1200, name: DESKTOP),
              const ResponsiveBreakpoint.autoScale(2460, name: "4K"),
            ],
            background: Container(color: const Color(0xFFF5F5F5))),
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.orange),
        ),
        home: Authenticate(),
      ),
    );
  }
}
