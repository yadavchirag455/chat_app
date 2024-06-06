import 'dart:developer';
import 'package:chat_app_yt_shivam_gupta_may/screens/home.dart';
import 'package:chat_app_yt_shivam_gupta_may/services/database.dart';
import 'package:chat_app_yt_shivam_gupta_may/services/shared_preferance.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:random_string/random_string.dart';

// ignore: must_be_immutable
class ChatPage extends StatefulWidget {
  String name, username;
  ChatPage({required this.name, required this.username});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _messageController = TextEditingController();

  String? myUserName, myEmailId, myName, messageId, chatRoomId;

  Stream? messageStream;
  getTheSharedPref() async {
    myUserName = await SharedPreferanceHelper().getUserName();
    myName = await SharedPreferanceHelper().getUserDisplayName();
    myEmailId = await SharedPreferanceHelper().getUserEmail();
    chatRoomId = await getChatRoomIdBYUsername(myUserName!, widget.username);
    setState(() {});

    log(" Chat Page  // get the Share pewfwrance function  // checking my Data which is stored is write or wrong");
    log("Others username = $widget.username");
    log(myUserName!);
    log(myName!);
    log(myEmailId!);
    log(chatRoomId!);
  }

  onTheLoad() async {
    await getTheSharedPref();
    await getAndSetMessages();

    setState(() {});
  }

  Widget chatMessageTile(String message, bool sendByMe) {
    return Row(
      mainAxisAlignment:
          sendByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Flexible(
            child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(24),
                  topRight: const Radius.circular(24),
                  bottomRight: sendByMe
                      ? const Radius.circular(0)
                      : const Radius.circular(24),
                  bottomLeft: sendByMe
                      ? const Radius.circular(24)
                      : const Radius.circular(0)),
              color: sendByMe ? Colors.grey[200] : Colors.blueGrey[200]),
          child: Text(
            message,
            style: const TextStyle(fontSize: 18),
          ),
        ))
      ],
    );
  }

  Widget chatMessage() {
    return StreamBuilder(
        stream: messageStream,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  padding: const EdgeInsets.only(bottom: 90, top: 130),
                  itemCount: snapshot.data.docs.length,
                  reverse: true,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data.docs[index];
                    return chatMessageTile(
                        ds["message"], myUserName == ds["sendBy"]);
                  })
              : const Center(
                  child: CircularProgressIndicator(),
                );
        });
  }

  addMessage(bool sendClick) {
    if (_messageController.text != null) {
      String message = _messageController.text;
      _messageController.clear();

      DateTime now = DateTime.now();
      String formatedDateTime = DateFormat('h:mma').format(now);

      Map<String, dynamic> messageInfoMap = {
        "message": message,
        "sendBy": myUserName,
        "ts": formatedDateTime,
        "time": FieldValue.serverTimestamp()
      };

      messageId ??= randomAlphaNumeric(10);

      DatabaseMethod()
          .addMessage(chatRoomId!, messageId!, messageInfoMap)
          .then((value) {
        Map<String, dynamic> lastMessageInfoMap = {
          "lastMessage": message,
          "lastMessageSendTs": formatedDateTime,
          "time": FieldValue.serverTimestamp(),
          "lastMessageSendBy": myUserName,
        };
        DatabaseMethod()
            .updateLastMesssageSend(chatRoomId!, lastMessageInfoMap);

        if (sendClick) {
          messageId = null;
        }
      });
    }
  }

  Future<String> getChatRoomIdBYUsername(String a, String b) async {
    log("Chatpage     //  getChatRoomIdByUsername //  checking incomnning data my Username $a");
    log("Chatpage     //  getChatRoomIdByUsername //  checking incomnning data others Usernaemm $b");
    String? myId = await SharedPreferanceHelper().getUserId();
    // String? secondPersonUsernameChatUser =
    //     (await DatabaseMethod().getUserByUsername(a)) as String?;

    QuerySnapshot secondPersonChatUser =
        await DatabaseMethod().getUserByUsername(b);

    String id = secondPersonChatUser.docs[0]["id"];

    setState(() {});

    log("MyID  " + myId!);

    log(" Second Person  on chatpage ${id}  ");

    // .codeUnitAt(0)      .codeUnitAt(0)
    if (int.parse(id) > int.parse(myId!)) {
      log((id.codeUnitAt(0) > myId!.codeUnitAt(0)).toString());
      return "${myId.toString()}_${id.toString()}";
    } else {
      return "${id.toString()}_${myId.toString()}";
    }
  }

  getAndSetMessages() async {
    messageStream = await DatabaseMethod().getChatRoomMessage(chatRoomId);
    setState(() {});
  }

  @override
  void initState() {
    onTheLoad();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF553370),
      body: Container(
        margin: const EdgeInsets.only(top: 40),
        child: Stack(
          children: [
            Container(
                margin: const EdgeInsets.only(top: 50),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 1.12,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30))),
                child: chatMessage()),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                children: [
                  GestureDetector(
                      onTap: () {
                        log('back button in chat ---- basically on chat page is tapped');
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => Home()));
                      },
                      child: const Icon(Icons.arrow_back)),
                  const SizedBox(width: 10),
                  Text(
                    widget.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: Color(0xFFc199cd)),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 20, bottom: 20, right: 20),
              alignment: Alignment.bottomCenter,
              child: Material(
                elevation: 5,
                child: Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(30)),
                  child: TextFormField(
                    controller: _messageController,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter Your Message',
                        hintStyle: const TextStyle(color: Colors.black38),
                        suffixIcon: GestureDetector(
                            onTap: () {
                              addMessage(true);
                            },
                            child: const Icon(Icons.send)),
                        contentPadding: const EdgeInsets.only(left: 15)),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
