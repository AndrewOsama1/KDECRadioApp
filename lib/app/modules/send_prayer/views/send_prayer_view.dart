import 'package:church_app/app/core/app_export.dart';
import 'package:church_app/app/data/firebase_controller.dart';
import 'package:church_app/app/models/user_info.dart';
import 'package:church_app/app/modules/authentication/controllers/authentication_controller.dart';
import 'package:church_app/app/modules/authentication/views/authentication_view.dart';
import 'package:church_app/app/modules/home/controllers/home_controller.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:giffy_dialog/giffy_dialog.dart';

import '../../../core/utils/size_utils.dart';
import '../../../widgets/change_language_widget.dart';
import '../../../widgets/search_delegate.dart';
import '../../notifications/views/notifications_view.dart';

final ScrollController _scrollController = ScrollController();

@override
void dependencies() {
  Get.put<AuthenticationController>(AuthenticationController());
}

class SendPrayerView extends StatefulWidget {
  const SendPrayerView({Key? key}) : super(key: key);

  @override
  _SendPrayerViewState createState() => _SendPrayerViewState();
}

class _SendPrayerViewState extends State<SendPrayerView> {
  final TextEditingController _messageController = TextEditingController();
  late DatabaseReference _databaseReference;
  String _roomId = '';
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();
    _databaseReference = FirebaseDatabase.instance.reference();
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      _roomId = user.uid;
    }

    _ensureChatRoomExists();
  }

  Future<void> _ensureChatRoomExists() async {
    final roomSnapshot =
        await _databaseReference.child('rooms').child(_roomId).once();

    final _firebaseMessaging = FirebaseMessaging.instance;

    String? currentToken = await _firebaseMessaging.getToken();
    String? userValue =
        Get.find<FirebaseController>().firebaseUser.value?.displayName ??
            FirebaseAuth.instance.currentUser?.email;

    Map<dynamic, dynamic>? snapshotData =
        roomSnapshot.snapshot.value as Map<dynamic, dynamic>?;

    if (snapshotData == null) {
      await _databaseReference.child('rooms').child(_roomId).set({
        'lastSeen': DateTime.now().toUtc().millisecondsSinceEpoch,
        'roomId': _roomId,
        'unSeen': false,
        'user': userValue,
        'Token': currentToken,
      });
    } else {
      // Room exists, check if the stored token is different from the current token.
      final storedToken = snapshotData['Token'] as String?;

      if (storedToken != null && storedToken != currentToken) {
        // Update the token in the database with the current token.
        await _databaseReference.child('rooms').child(_roomId).update({
          'Token': currentToken,
        });
      }
    }
  }

  void _showLoginAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return GiffyDialog.image(
          Image.asset(
            'assets/images/background.png',
            height: 0,
            fit: BoxFit.cover,
          ),
          title: Text(
            'Login Needed'.tr,
            textAlign: TextAlign.center,
          ),
          content: Text(
            'In Order to send a message you need to login first .'.tr,
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, 'CANCEL'),
              child: Text(
                'Cancel'.tr,
                style: TextStyle(color: Colors.black),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AuthenticationView()),
              ),
              child:
                  Text('Login Now'.tr, style: TextStyle(color: Colors.black)),
            ),
          ],
        );
      },
    );
  }

  void _sendMessage() {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null || user.isAnonymous) {
      // User is not logged in with an email, show the alert
      _showLoginAlert();
      return; // Don't proceed with sending the message
    }

    final String message = _messageController.text.trim();
    if (message.isNotEmpty) {
      // Get the current Unix timestamp
      final int timestamp = DateTime.now().toUtc().millisecondsSinceEpoch;

      // Send the message to the Firebase Realtime Database with the timestamp
      _databaseReference.child('messages').push().set({
        'content': message,
        'date': timestamp,
        'from': FirebaseAuth.instance.currentUser?.email,
        'roomId': _roomId,
        'seen': false,
        'type': 'default',
      });

      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            onPressed: () {
              showSearch(context: context, delegate: SearchWidgetDelegate());
            },
            icon: const Icon(
              Icons.search,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const NotificationsView()));
            },
            icon: const Icon(
              Icons.notifications,
              color: Colors.white,
            ),
          ),
          const ChangeLanguageWidget(),
        ],
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  'assets/images/good2.jpg'), // Your background image
              fit: BoxFit.cover,
            ),
          ),
          // Make the background image cover the whole screen
          width: double.infinity,
          height: double.infinity,
          child: Column(
            children: <Widget>[
              Padding(
                padding: getPadding(top: 5, bottom: 10),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Send'.tr,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: AppStyle.txtUrbanistRomanBoldm,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Text(
                          'Prayer'.tr,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style: AppStyle.txtUrbanistRomanBoldm,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: StreamBuilder(
                  stream: _databaseReference
                      .child('messages')
                      .orderByChild('roomId')
                      .equalTo(_roomId)
                      .onValue,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final messages = snapshot.data?.snapshot.value
                          as Map<dynamic, dynamic>?;

                      if (messages != null) {
                        // Trigger auto-scroll when the message list changes
                        WidgetsBinding.instance?.addPostFrameCallback((_) {
                          _scrollController.jumpTo(
                            _scrollController.position.maxScrollExtent,
                          );
                        });

                        return _buildMessages(messages);
                      }
                    }

                    return Container();
                  },
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Material(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.white,
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 25.0, top: 2, bottom: 2),
                          child: TextField(
                            controller: _messageController,
                            decoration: InputDecoration(
                              hintText: 'Type a message...'.tr,
                            ),
                          ),
                        ),
                      ),
                    ),
                    MaterialButton(
                        shape: const CircleBorder(),
                        color: Colors.white,
                        onPressed: () {
                          _sendMessage();
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Icon(
                            Icons.send,
                            color: Colors.black,
                          ),
                        )
                        // Text(
                        //   'Send',
                        //   style: kSendButtonTextStyle,
                        // ),
                        ),
                  ],
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: Row(
              //     children: <Widget>[
              //       Expanded(
              //         child: TextField(
              //           controller: _messageController,
              //           decoration: InputDecoration(
              //             hintText: 'Type a message...',
              //           ),
              //         ),
              //       ),
              //       IconButton(
              //         icon: Icon(Icons.send),
              //         onPressed: _sendMessage,
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildMessages(Map<dynamic, dynamic> messages) {
  final List<Widget> messageWidgets = [];

  // Convert messages to a list of Map entries for sorting
  final List<MapEntry<dynamic, dynamic>> messageEntries =
      messages.entries.toList();

  // Sort messages by timestamp in ascending order
  messageEntries.sort((a, b) {
    final timestampA = a.value['date'];
    final timestampB = b.value['date'];
    return timestampA.compareTo(timestampB);
  });

  for (final entry in messageEntries) {
    final value = entry.value;
    final msgText = value['content'];
    final msgSender = value['from'];
    final currentUser = FirebaseAuth.instance.currentUser?.email;

    final msgBubble = MessageBubble(
      msgText: msgText,
      msgSender: msgSender,
      user: currentUser == msgSender,
    );
    messageWidgets.add(msgBubble);
  }

  return ListView(
    controller: _scrollController,
    // Start scrolling from the bottom
    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
    children: messageWidgets,
  );
}

class MessageBubble extends StatelessWidget {
  final String msgText;
  final String msgSender;
  final bool user;

  const MessageBubble({
    super.key,
    required this.msgText,
    required this.msgSender,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment:
            user ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Text(
              msgSender,
              style: const TextStyle(
                  fontSize: 10, fontFamily: 'ArabicSukar', color: Colors.white),
            ),
          ),
          Material(
            borderRadius: BorderRadius.only(
              bottomLeft: const Radius.circular(50),
              topLeft:
                  user ? const Radius.circular(50) : const Radius.circular(0),
              bottomRight: const Radius.circular(50),
              topRight:
                  user ? const Radius.circular(0) : const Radius.circular(50),
            ),
            color: user ? Colors.white : Colors.blue,
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(
                msgText,
                style: TextStyle(
                  color: user ? Colors.black : Colors.white,
                  fontFamily: 'ArabicSukar',
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
