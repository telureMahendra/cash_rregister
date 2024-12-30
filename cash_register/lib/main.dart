import 'package:cash_register/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();

  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);


  //  if (Platform.isIOS) {
  //     await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
  //   } else {
  //     await Firebase.initializeApp();
  // }


  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {


    return MaterialApp(
      title: 'Bill Calculator',
      theme: ThemeData(


        fontFamily: 'Becham', 
        textTheme: Theme.of(context).textTheme.apply(fontFamily: 'Bold Sans Serif'),
        primarySwatch: Colors.blue,
      ),
      home: const splashScreen(),
    );
  }
}
