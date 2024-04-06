import 'package:flutter/material.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
     appBar: AppBar(
      backgroundColor: Colors.yellow,
      title:const  Text("You are Redirected 🙄"),
      centerTitle: true,
     ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
    Text("Did you observe something? 😂"),
    Text("You are redirected to this screen"),
    Text(" If you open the app yourself "),
    Text("you cant find this screen🤗"),
    Text("You are seeing it just because the"),
    Text("developer wants it to happen😎")

          ],
        )
      ),
    );
  }
}