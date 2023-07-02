
import 'package:flash_chat_flutter_with_firebase/models/chat_user.dart';
import 'package:flutter/material.dart';

import '../screens/chat_screen.dart';

class ChatUserCard extends StatefulWidget {

  final ChatUser chatUser;

  const ChatUserCard({super.key,required this.chatUser});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  @override
  Widget build(BuildContext context) {

    MediaQueryData mediaQuery = MediaQuery.of(context);

    return Card(
      margin: EdgeInsets.symmetric(horizontal: mediaQuery.size.width * 0.04,vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0),),
       color: Colors.cyan.shade50,
      elevation: 0.5,
      child: InkWell(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatScreen(user: widget.chatUser,)));
        },
          child: ListTile(
            leading: ClipOval(
              child: CircleAvatar(
                radius: 25,
                child: FadeInImage.assetNetwork(
                  //placeholder: 'https://i.pinimg.com/originals/80/b5/81/80b5813d8ad81a765ca47ebc59a65ac3.jpg', // replace with your placeholder image path
                  image: widget.chatUser.image, // replace with your image URL
                  width: mediaQuery.size.width * .70,
                  height: mediaQuery.size.height * .70,
                  fit: BoxFit.cover,
                  imageErrorBuilder: (context, error, stackTrace) {
                    return Icon(Icons.error); // display an error icon when image fails to load
                  }, placeholder: 'images/logo.png',
                ),
              ),
            ),

              // mediaQuery.size.width * .70,
              title: Text(widget.chatUser.name),
            subtitle: Text(widget.chatUser.about,maxLines: 1,),
            trailing: Container(
              width: 15,height: 15,decoration: BoxDecoration(
              color: Colors.greenAccent.shade400,
              borderRadius: BorderRadius.circular(20),
            ),
            ),
            //Text('12.00 pm'),
          ),
      ),
    );
  }
}
