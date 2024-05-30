import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../services/database.dart';

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
  String? name, username, id;

  getThisUserInfo() async {
    // log('chat_room_list_tile xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx+${username.toString()}');
    username = widget.chatRoomId.substring(0, widget.chatRoomId.indexOf('_'));

    QuerySnapshot querySnapshot =
        await DatabaseMethod().getUserByUsername(username!.toUpperCase());

    name = "${querySnapshot.docs[0]["name"]}";

    id = "${querySnapshot.docs[0]["id"]}";
    // log('${querySnapshot.docs[0]["username"]} chat_room_list_tile sghvdgasgagagdhawg :: ${widget.chatRoomId.substring(0, widget.chatRoomId.indexOf('_'))}');

    setState(() {});

    log("this log is in ChatRoomListTile ====  ${querySnapshot.docs[0]["name"]}");
    log("this log is in ChatRoomListTile ====  ${querySnapshot.docs[0]["id"]}");
  }

  @override
  void initState() {
    getThisUserInfo();
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
