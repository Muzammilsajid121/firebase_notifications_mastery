import 'package:firebase_notifications/notification_servies.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //Instance of our notifications services class
  NotificationServices notificationServices = NotificationServices();

  @override
  void initState() {
    super.initState();
    notificationServices.requestNotificationPermission();  //requestNotificationPermission is our func
    notificationServices.isTokenRefresh();
    notificationServices.firebaseinit(context);

    notificationServices.getDeviceToken().then((value) =>
    print("Device Token, $value"),);
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
        centerTitle: true,
      ),
      // body: Column(
      //   children: [
      //     Text("Hiii")
      //   ],
      // ),

    );
  }
}