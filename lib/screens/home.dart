import 'dart:developer';
import 'package:chat_app_yt_shivam_gupta_may/services/database.dart';
import 'package:chat_app_yt_shivam_gupta_may/services/shared_preferance.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'chat_page.dart';
import 'chat_room_list_tile.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool searchTab = false;

  String? myName, myEmail, myUsername, myId;
  Stream? chatRoomStream;

  var querySearchList = [];
  var tempSearchList = [];

  onTheLoad() async {
    // await getSharedPref();
    myName = await SharedPreferanceHelper().getUserDisplayName();
    myEmail = await SharedPreferanceHelper().getUserEmail();
    myUsername = await SharedPreferanceHelper().getUserName();
    myId = await SharedPreferanceHelper().getUserId();

    setState(() {});
    log('myUsername :: $myUsername');
    log('myName :: $myName');
    log('myEmail ::$myEmail');
    log('myId:: $myId');
    log('This log is in onTheLoad function all the data is from Shared Pref');

    chatRoomStream = await DatabaseMethod().getChatRooms();
    setState(() {});
    // log(chatRoomStream!.length.toString());
    // log('logggggg1');
  }

  String getChatRoomIdBYUsername(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b"; // a and b ko interchange kiya hai
    }
  }

  intiateSearch(String value) {
    // if (value.length == 0) {
    // log('value :: $value');

    setState(() {
      querySearchList = [];
      tempSearchList = [];
    });
    // }
    setState(() {
      searchTab = true;
    });

    var capitalizadValue =
        value.substring(0, 1).toUpperCase() + value.substring(1);

    if (querySearchList.isEmpty && value.length == 1) {
      // log('if');
      DatabaseMethod().Search(value).then((QuerySnapshot docs) {
        for (int i = 0; i < docs.docs.length; ++i) {
          querySearchList.add(docs.docs[i].data());
        }
        // log('querySearchList :: ${querySearchList.length}');
        tempSearchList = querySearchList;
        setState(() {});
      });
    } else {
      // log('else');
      tempSearchList = [];
      querySearchList.forEach((element) {
        // if (element["username"].startsWith(capitalizadValue)) {
        //   setState(() {
        tempSearchList.add(element);
        setState(() {});
        // log('${tempSearchList.length}');
        //   });
        // }
      });
    }
  }

  Widget ChatRoomList() {
    return StreamBuilder(
      stream: chatRoomStream,
      builder: (context, AsyncSnapshot snapshot) {
        // log('This log is in Home.dart Page----------------------------${snapshot.hasData}-----${snapshot.data.docs.length}');
        return snapshot.hasData
            ? ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: snapshot.data!.docs.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data!.docs[index];
                  return ChatRoomListTile(
                    chatRoomId: ds.id,
                    myUserName: myUsername!,
                    lastmessage: ds["lastMessage"],
                    time: ds["lastMessageSendTs"],
                  );
                },
              )
            : const Center(child: CircularProgressIndicator());
      },
    );
  }

  //  ye search ke andr aataa hai (search bar wala card hai )
  Widget buildResultCard(data) {
    return GestureDetector(
      onTap: () async {
        searchTab = false;
        setState(() {});
        var chatRoomId = getChatRoomIdBYUsername(myUsername!, data["username"]);

        Map<String, dynamic> chatRoomInfoMap = {
          "users": [myUsername, data["username"]]
        };
        await DatabaseMethod().createChatRoom(chatRoomId, chatRoomInfoMap);

        // log('==========================================${data["username"]}');
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => ChatPage(
                      name: data["name"],
                      username: data["username"],
                    )));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Material(
          elevation: 5,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Row(
              children: [
                Column(
                  children: [
                    Text(
                      data["name"],
                      style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      data["username"],
                      style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    onTheLoad();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF553370),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  searchTab
                      ? Expanded(
                          child: TextField(
                          onChanged: (value) {
                            intiateSearch(value);
                          },
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Search User',
                              hintStyle: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20,
                                  color: Colors.white)),
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 20),
                        ))
                      : const Text(
                          'ChatApp',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              color: Color(0xFFc199cd)),
                        ),
                  // ye search button hai Icons and functinallity
                  GestureDetector(
                    onTap: () {
                      searchTab = true;

                      setState(() {});
                    },
                    child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: const Color(0xFF3a2144),
                            borderRadius: BorderRadius.circular(10)),
                        child: searchTab
                            ? GestureDetector(
                                onTap: () {
                                  searchTab = false;
                                  setState(() {});
                                },
                                child: const Icon(
                                  Icons.close,
                                  color: Color(0xFFc199cd),
                                ),
                              )
                            : const Icon(
                                Icons.search,
                                color: Color(0xFFc199cd),
                              )),
                  )
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 20, top: 20),
              margin: const EdgeInsets.only(top: 30),
              height: MediaQuery.of(context).size.height / 1.17,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                  color: Colors.white),
              child: Column(
                children: [
                  // search jb on ho rha hai tb list aaraaa hai  logo ki

                  searchTab
                      ? ListView(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          primary: false,
                          shrinkWrap: true,
                          children: tempSearchList.map((element) {
                            return buildResultCard(element);
                          }).toList())
                      : ChatRoomList()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
