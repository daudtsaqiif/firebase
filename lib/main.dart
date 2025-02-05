import 'package:firebase/ui/pages.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.playIntegrity,
    appleProvider: AppleProvider.appAttest,
    webProvider: ReCaptchaV3Provider('E7732229-8C52-43CD-8E4B-73DB0DDF8A30'),
  );
  await FirebaseAppCheck.instance.setTokenAutoRefreshEnabled(true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SignInPage(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/sign-in': (context) => SignInPage(),
        '/home': (context) => HomePage(),
        '/sign-up': (context) => SignUpPage(),
        '/note': (context) => NotePage(),
        '/profile': (context) => ProfilePage(),
      },
    );
  }
}
