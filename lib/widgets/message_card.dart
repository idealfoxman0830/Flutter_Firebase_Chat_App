import 'package:flutter/material.dart';

import '../api/apis.dart';
import '../main.dart';
import '../models/message.dart';

class MessageCard extends StatefulWidget {
  const MessageCard({super.key, required this.message});
  final Message message;
  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;

    return APIs.authuser.uid == widget.message.fromId
        ? _greenMessage()
        : _blueMessage();
  }

  // sender or another user messages
  Widget _blueMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xffC5D1E7FF),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              border: Border.all(color: Color(0xffB9D8E7FF)),
            ),
            padding: EdgeInsets.all(mq.width * .04),
            margin: EdgeInsets.symmetric(
                vertical: mq.height * .02, horizontal: mq.width * .04),
            child: Text(
              widget.message.msg + "hello this is me sourav barman i am grom joypurhat ",
              style: TextStyle(fontSize: 15, color: Colors.black87),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: mq.width * .04),
          child: Text(widget.message.sent,
          style: TextStyle(
            fontSize: 13,
            color: Colors.black45,
          ),
          ),
        ),

      ],
    );
  }

  // our  user messages
  Widget _greenMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SizedBox(
              width: mq.width * 0.04,
            ),
            Icon(Icons.done_all_outlined,
            color: Colors.blue,
              size: 20,
            ),
            SizedBox(
              width: 1,
            ),
            Text(widget.message.read+ '12.00 AM',
              style: TextStyle(
                fontSize: 13,
                color: Colors.black45,
              ),
            ),
          ],
        ),
        Flexible(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.green.shade200,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
                bottomLeft: Radius.circular(30),
              ),
              border: Border.all(color: Color(0xffB9D8E7FF)),
            ),
            padding: EdgeInsets.all(mq.width * .04),
            margin: EdgeInsets.symmetric(
                vertical: mq.height * .02, horizontal: mq.width * .04),
            child: Text(
              widget.message.msg + "hello this is me sourav barman i am grom joypurhat ",
              style: TextStyle(fontSize: 15, color: Colors.black87),
            ),
          ),
        ),

      ],
    );
  }
}
