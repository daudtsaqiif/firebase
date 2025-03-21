import 'package:firebase/ui/pages.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
        '/update-profile': (context) => UpdateProfilePage(),
        '/profile': (context) => ProfilePage(),
        '/change-password': (context) => ChangePasswordPage(),
        '/home-attendance': (context) => HomeAttendancePage(),
        '/attendance': (context) => AttendancePage(),
        '/permittion': (context) => LeavePage(),
        '/history': (context) => HistoryPage(),
      },
    );
  }
}
