
import 'package:flash_chat_flutter_with_firebase/helper/my_date_util.dart';
import 'package:flutter/material.dart';

import '../api/apis.dart';
import '../models/chat_user.dart';

class ViewProfileScreen extends StatefulWidget {
  const ViewProfileScreen({super.key, required this.user});
  static const String id = "profile_screen";
  final ChatUser user;

  @override
  State<ViewProfileScreen> createState() => _ViewProfileScreenState();
}

class _ViewProfileScreenState extends State<ViewProfileScreen> {

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          title: Text(widget.user.name),
        ),
        floatingActionButton:      Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Joined On : ', style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),),
            Text(
              MyDateUtil.getLastMessageTime(context: context, time:  widget.user.createdAt,showYear: true),
              style: TextStyle(
                color: Colors.black45,
                fontSize: 20,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        body: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: mediaQuery.size.width * .05),
          child: SingleChildScrollView(
            child: Column(children: [
              SizedBox(
                width: mediaQuery.size.width,
                height: mediaQuery.size.height * .05,
              ),
              ClipOval( // image from server
                          child: CircleAvatar(
                            radius: 90,
                            child: FadeInImage.assetNetwork(
                              image: widget
                                  .user.image, // replace with your image URL
                              width: mediaQuery.size.width * .70,
                              height: mediaQuery.size.height * .70,
                              fit: BoxFit.cover,
                              imageErrorBuilder:
                                  (context, error, stackTrace) {
                                return Icon(Icons
                                    .error); // display an error icon when image fails to load
                              },
                              placeholder: 'images/logo.png',
                            ),
                          ),
                        ),
              SizedBox(
                height: mediaQuery.size.height * .02,
              ),
              Text(
                widget.user.email,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(
                height: mediaQuery.size.height * .04,
              ),

              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('About : ', style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),),
                  Text(
                    widget.user.about,
                    style: TextStyle(
                      color: Colors.black45,
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),

            ]),
          ),
        ),
      ),
    );
  }

}
