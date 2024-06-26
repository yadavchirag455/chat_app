import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../services/database.dart';
import '../services/shared_preferance.dart';

class ChatRoomListTile extends StatefulWidget {
  final String lastmessage, chatRoomId, myUserName, time;

  ChatRoomListTile(
      {required this.chatRoomId,
      required this.myUserName,
      required this.lastmessage,
      required this.time});

  @override
  State<ChatRoomListTile> createState() => _ChatRoomListTileState();
}

class _ChatRoomListTileState extends State<ChatRoomListTile> {
  String? name, username, id, testingId;

  onLoadFunction() async {
    testingId = await SharedPreferanceHelper().getUserId();
    setState(() {});

    getThisUserInfo();
  }

  getThisUserInfo() async {
    id = widget.chatRoomId.substring(0, widget.chatRoomId.indexOf('_')) ==
            testingId.toString()
        ? widget.chatRoomId.substring(6, 11)
        : widget.chatRoomId.substring(0, widget.chatRoomId.indexOf('_'));

    DocumentSnapshot document =
        await FirebaseFirestore.instance.collection("users").doc(id).get();

    username = document.get('username');

    QuerySnapshot querySnapshot =
        await DatabaseMethod().getUserByUsername(username!.toUpperCase());

    name = "${querySnapshot.docs[0]["name"]}";

    setState(() {});
  }

  @override
  void initState() {
    onLoadFunction();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Row(
        children: [
          const CircleAvatar(
            maxRadius: 38,
          ),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                username.toString(),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                widget.time,
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black45),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 2,
                child: Text(
                  widget.lastmessage,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: Colors.black45),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
