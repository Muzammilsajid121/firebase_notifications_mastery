import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_notifications/firebase_options.dart';
import 'package:firebase_notifications/homepage.dart';
import 'package:firebase_notifications/notification_servies.dart';
import 'package:flutter/material.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
    FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundMessagingHandler);
  runApp(const MyApp());
}

//To handle notifications in background
@pragma('vm:entry-point')
Future<void>_firebaseBackgroundMessagingHandler(RemoteMessage message) async{
  await Firebase.initializeApp;
  print('This is background messsage +$message.notification!.title.toString()');

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

