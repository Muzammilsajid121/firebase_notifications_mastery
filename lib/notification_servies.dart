import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_notifications/message_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationServices{

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  void requestNotificationPermission() async{
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,  //Sets whether notifications can be displayed to the user on the device.
      badge: true,  //notification dot will appear next to the app icon on the device when there are unread nots.
      announcement: false,  //Siri will read the notification content out when devices are connected to AirPods.
      carPlay: false, //Sets whether notifications will appear when the device is connected to CarPlay.
      criticalAlert: false,
      sound: true,   //nots with sound
      provisional: false, //	Sets whether provisional permissions are granted.
    );

    //For Android
    if(settings.authorizationStatus == AuthorizationStatus.authorized){
      print("User granted permission for android");

    }
    
    //For IOs
    else if(settings.authorizationStatus == AuthorizationStatus.provisional){
      print("User granted permission");
    }
    //
    else{
       print('User declined or has not accepted permission');
    }

  }

  //2nd Function
  //Firebase token p notification behjta
    Future<String?> getDeviceToken() async{
      String? token = await messaging.getToken();
      return token;
      
    }

    //3rd Function
    void isTokenRefresh() async{
     messaging.onTokenRefresh.listen((event) {
      event.toString();
      print("Token is refresh");
     });
    }

    //4th func 
    void firebaseinit(BuildContext context){
      FirebaseMessaging.onMessage.listen((message) { 
      //  showNotifications(message);

          if (Platform.isAndroid) {
        initLocalNotifications(context, message);
        showNotifications(message);
      }
        // print(message.notification!.title.toString());
        // print(message.notification!.body.toString());

        //Print full data / payload
        print(message.data.toString());
        //Print specific data 
        print(message.data['type']);
        print(message.data['id']);

      });
    }

       //5th func
    void initLocalNotifications(BuildContext context, RemoteMessage message) async{
       var androidInitializationSettings = const AndroidInitializationSettings('@mipmap/ic_launcher');
        //
        var initializationSettings = InitializationSettings(
          android: androidInitializationSettings,  );
      
      await _flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: (payload){
          //What to do when notification received
          handleMessage(context, message);
        });
    } 

        //6th func
    Future <void> showNotifications(RemoteMessage message) async{
 
       AndroidNotificationChannel channel =  AndroidNotificationChannel(
        Random.secure().nextInt(1000).toString(), 
        "High Importance Notifications",
        importance: Importance.max,
    );  
    ///////////////***************** */
       AndroidNotificationDetails androidNotificationDetails =  AndroidNotificationDetails(
        channel.id.toString(),
        channel.name.toString() ,
        channelDescription: "Ultra Channel",
        importance: Importance.high,
        priority: Priority.high,
        ticker: "ticker"
    );    

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails
    );
    
      Future.delayed(Duration.zero, (){
       _flutterLocalNotificationsPlugin.show(
        0,
        message.notification!.title.toString(),
        message.notification!.body.toString(),
        notificationDetails
        );
     } );
     //
      }
       
    //7th function
    void handleMessage(BuildContext context, RemoteMessage message){

      // If user tap on notification redirect him to selected screen
      if(message.data['type'] == 'msg'){
        Navigator.push(context, MaterialPageRoute(builder: (context) => const MessageScreen()));
      }

    }

    //7th function
    Future<void> setupInteractMessage(BuildContext context) async{
     
     //When app is terminated
     RemoteMessage? initialMesaage = await FirebaseMessaging.instance.getInitialMessage();
      if(initialMesaage!= null){
        handleMessage(context, initialMesaage);
      }

    //When app is in background
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
        handleMessage(context, event);
     });
    }

    // 8th Function
Future<void> storeNotificationToken() async {
  String? token = await FirebaseMessaging.instance.getToken();
  if (token != null) {
    try {
      await FirebaseFirestore.instance.collection('notifiedusers').doc('i5xAmzE4KCcx83CHuwSc').set({
        'users': FieldValue.arrayUnion([token])
      }, SetOptions(merge: true));
      print('Notification token stored successfully.');
    } catch (e) {
      print('Error storing notification token: $e');
    }
  } else {
    print('Failed to retrieve notification token.');
  }
}


//    // 9th function
// Future<void> sendNotificationsToAll() async {
//   try {
//     // Retrieve the document snapshot
//     DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance.collection('notifiedusers').doc('i5xAmzE4KCcx83CHuwSc').get();

//     // Extract the 'users' field from the document data
//     List<dynamic>? tokenList = snapshot.data()?['users'];
//     if (tokenList != null) {
//       List<String> tokens = List<String>.from(tokenList);

//       // Send notifications via FCM
//       if (tokens.isNotEmpty) {
//         // Construct FCM payload
//         Map<String, dynamic> notification = {
//           'title': 'Your notification title',
//           'body': 'Your notification body',
//         };
        
//         Map<String, dynamic> data = {
//           'type': 'msg', // Define your custom notification type if needed
//           // Add any additional data you want to send with the notification
//         };

//         // Send notifications to each token
//         for (String token in tokens) {
//           await FirebaseMessaging.instance.send(
//             {
//               'notification': notification,
//               'data': data,
//               'token': token,
//             },
//           );
//         }
        
//         print('Notifications sent to all devices.');
//       } else {
//         print('No tokens found in Firestore.');
//       }
//     } else {
//       print('No users field found in Firestore document.');
//     }
//   } catch (e) {
//     print('Error sending notifications: $e');
//   }
// }



    }
    

