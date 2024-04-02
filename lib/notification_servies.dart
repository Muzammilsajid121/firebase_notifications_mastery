import 'dart:io';
import 'dart:math';
import 'package:firebase_messaging/firebase_messaging.dart';
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
        });
    } 

        //4th func
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

    //
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
    }
    

