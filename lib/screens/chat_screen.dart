import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flash_chat_flutter_with_firebase/helper/my_date_util.dart';
import 'package:flash_chat_flutter_with_firebase/models/chat_user.dart';
import 'package:flash_chat_flutter_with_firebase/widgets/message_card.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat_flutter_with_firebase/models/message.dart';
import 'package:image_picker/image_picker.dart';
import '../api/apis.dart';
import '../main.dart';

//ChatScreen

class ChatScreen extends StatefulWidget {
  static const String id = "chat_screen";
  const ChatScreen({super.key, required this.user});
  final ChatUser user;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // for storing all messages
  List<Message> _list = [];
  final _textController = TextEditingController();
  bool _showEmoji = false , _isUploading = false;

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: ()=> FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: WillPopScope(
          onWillPop: () {
            if (_showEmoji) {
              setState(() {
                _showEmoji = !_showEmoji;
              });
              return Future.value(false);
            } else {
              return Future.value(true);
            }
          },
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              flexibleSpace: _appBar(),
            ),
            body: Column(
              children: [
                Expanded(
                  child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: APIs.getAllMessages(widget.user),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                            snapshot) {
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        // for(var i in data!){
                        //   print('data : ${jsonEncode(i.data())}');
                        // }

                        return SizedBox();
                        //   Center(
                        //   child: CircularProgressIndicator(),
                        // );
                      }

                      //final List<QueryDocumentSnapshot<Map<String, dynamic>>> documents = snapshot.data!.docs;
                      final data = snapshot.data!.docs;
                      //   print('data ${jsonEncode(data[0].data())}');
                      _list =
                          data.map((e) => Message.fromJson(e.data())).toList() ??
                              [];

                      // _list.clear();
                      // _list.add(Message(
                      //     msg: 'hii',
                      //     read: '',
                      //     told: 'xyz',
                      //     type: Type.text,
                      //     sent: '12:00 AM',
                      //     fromId: APIs.authuser.uid));
                      // _list.add(Message(
                      //     msg: 'hello',
                      //     read: '',
                      //     told: APIs.authuser.uid,
                      //     type: Type.text,
                      //     sent: '12:05 AM',
                      //     fromId: 'xyz'));

                      if (_list.isNotEmpty) {
                        return ListView.builder(
                          reverse: true,
                          itemCount: _list.length,
                          itemBuilder: (BuildContext context, int index) {
                            //  final user = documents[index].data();

                            return MessageCard(message: _list[index]);
                          },
                        );
                      }
                      return Center(
                        child: Text(
                          'Say Hii!🤝',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Progress indicator for showing uploading

                if(_isUploading)
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 8,horizontal: 20),
                          child: CircularProgressIndicator(strokeWidth: 2,),
                      ),
                    ),
                _chatInput(),
                if(_showEmoji)
                  SizedBox(
                    height: mq.height *.35,
                    child: EmojiPicker(
                      textEditingController: _textController,
                      config: Config(
                        columns: 7,
                        emojiSizeMax: 32 *
                            (Platform.isIOS
                                ? 1.30
                                : 1.0), // Issue: https://github.com/flutter/flutter/issues/28894
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _appBar() {
    return InkWell(
      onTap: () {},
      child:  StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: APIs.getUserInfo(widget.user),
        builder:(BuildContext context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
            snapshot){

          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!.docs;
          final _list = data
              .map((e) => ChatUser.fromJson(e.data()))
              .toList();


          return Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
              ),
              ClipOval(
                child: CircleAvatar(
                  radius: 20,
                  child: FadeInImage.assetNetwork(
                    //placeholder: 'https://i.pinimg.com/originals/80/b5/81/80b5813d8ad81a765ca47ebc59a65ac3.jpg', // replace with your placeholder image path
                    image: widget.user.image, // replace with your image URL
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                    imageErrorBuilder: (context, error, stackTrace) {
                      return Icon(Icons
                          .error); // display an error icon when image fails to load
                    },
                    placeholder: 'images/logo.png',
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.user.name,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    _list.isNotEmpty ?
                      _list[0].isOnline ? 'Online' :
                    MyDateUtil.getLastActiveTime(context: context, lastActive: _list[0].lastActive) : MyDateUtil.getLastActiveTime(context: context, lastActive: widget.user.lastActive)
                    ,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _chatInput() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Row(
        children: [
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  // emoji button
                  IconButton(
                    onPressed: () {
                      setState(() {
                      FocusScope.of(context).unfocus();
                        _showEmoji = !_showEmoji;
                      });
                    },
                    icon: Icon(
                      Icons.emoji_emotions,
                      color: Colors.blueAccent,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      onTap: () {
                        if(_showEmoji){
                          setState(() {
                            _showEmoji = !_showEmoji;
                          });
                        }
                      },
                      decoration: InputDecoration(
                        hintText: 'Type Something',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  // gallery button
                  IconButton(
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      // Pick an image.
                      final List<XFile> images=
                          await picker.pickMultiImage(imageQuality: 80);
                      for (var i in images){
                        setState(() {
                          _isUploading = true;
                        });
                        print('image path : ${i.path}');
                        await APIs.sendChatImage(widget.user,File(i.path));
                        setState(() {
                          _isUploading = false;
                        });
                        //    Navigator.pop(context);
                      }
                    },
                    icon: Icon(
                      Icons.image,
                      color: Colors.blueAccent,
                    ),
                  ),
                  // camera button
                  IconButton(
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      // Pick an image.
                      final XFile? image =
                          await picker.pickImage(source: ImageSource.camera,imageQuality: 80);
                      if (image != null) {
                        print('image path : ${image.path}');

                        await APIs.sendChatImage(widget.user,File(image.path));
                    //    Navigator.pop(context);
                      }
                    },
                    icon: Icon(
                      Icons.camera_alt,
                      color: Colors.blueAccent,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // send message button
          MaterialButton(
            onPressed: () {
              if (_textController.text.isNotEmpty) {
                APIs.sendMessage(widget.user, _textController.text,Type.text);
                _textController.text = '';
              }
            },
            shape: CircleBorder(),
            minWidth: 0,
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            color: Colors.lightBlue,
            child: Icon(
              Icons.send,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
