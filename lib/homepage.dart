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
    notificationServices.setupInteractMessage(context);
    notificationServices.firebaseinit(context);
    notificationServices.storeNotificationToken();

    notificationServices.getDeviceToken().then((value) =>
    print("Device Token, $value"),);
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
        title: const Text("Notifications"),
        centerTitle: true,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
    Text("Wait some time you migth received notifcation from "),
    Text("the developer😂."),
    Text(" If you received it you are lucky🤗"),
    Text(" and if not, you are unlucky😥")
          ],
        )
      ),
      

    );
  }
}