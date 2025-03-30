// ignore_for_file: deprecated_member_use

import 'package:chatapp/api/api.dart';
import 'package:chatapp/helper/dialog.dart';
import 'package:chatapp/main.dart';
import 'package:chatapp/model/chat_usermodel.dart';
import 'package:chatapp/screens/profile_screen.dart';
import 'package:chatapp/widgets/chat_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ChatUsermodel> list = [];
  final List<ChatUsermodel> searchList = [];

  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    APIs.getSelfInfo();

    // APIs.updateActiveStatus(true);
    SystemChannels.lifecycle.setMessageHandler((message) {
      if (APIs.auth.currentUser != null) {
        if (message.toString().contains('resume'))
          APIs.updateActiveStatus(true);
        if (message.toString().contains('pause'))
          APIs.updateActiveStatus(false);
      }

      return Future.value(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () {
          if (_isSearching) {
            setState(() {
              _isSearching = !_isSearching;
            });
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            leading: Icon(Icons.home),
            title:
                _isSearching
                    ? TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Name Email...',
                      ),
                      autofocus: true,
                      style: TextStyle(fontSize: 17, letterSpacing: 0.5),
                      onChanged: (val) {
                        searchList.clear();

                        for (var i in list) {
                          if (i.name.toLowerCase().contains(
                                val.toLowerCase(),
                              ) ||
                              i.email.toLowerCase().contains(
                                val.toLowerCase(),
                              )) {
                            searchList.add(i);
                          }
                          setState(() {
                            searchList;
                          });
                        }
                      },
                    )
                    : Text("Sampark"),
            actions: [
              IconButton(
                onPressed: () {
                  setState(() {
                    _isSearching = !_isSearching;
                  });
                },
                icon: Icon(_isSearching ? Icons.cancel_sharp : Icons.search),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProfileScreen(user: APIs.me),
                    ),
                  );
                },
                icon: Icon(Icons.more_vert),
              ),
            ],
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: FloatingActionButton(
              onPressed: () {
                _addChatUserDialod();
              },
              child: Icon(Icons.add_comment_rounded),
            ),
          ),
          body: StreamBuilder(
            stream: APIs.getMyUsersId(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                // if data is loading
                case ConnectionState.waiting:
                case ConnectionState.none:
                  return Center(child: CircularProgressIndicator());

                case ConnectionState.active:
                case ConnectionState.done:
                  return StreamBuilder(
                    // fetch data from firestore
                    stream: APIs.getAllUser(
                      snapshot.data?.docs.map((e) => e.id).toList() ?? [],
                    ),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        // if data is loading
                        case ConnectionState.waiting:
                        case ConnectionState.none:
                        // return Center(child: CircularProgressIndicator());

                        case ConnectionState.active:
                        case ConnectionState.done:
                          final data = snapshot.data?.docs;
                          list =
                              data
                                  ?.map((e) => ChatUsermodel.fromJson(e.data()))
                                  .toList() ??
                              [];

                          if (list.isNotEmpty) {
                            return ListView.builder(
                              itemCount:
                                  _isSearching
                                      ? searchList.length
                                      : list.length,
                              physics: BouncingScrollPhysics(),
                              padding: EdgeInsets.only(top: mq.height * .01),
                              itemBuilder: (context, index) {
                                return ChatUser(
                                  user:
                                      _isSearching
                                          ? searchList[index]
                                          : list[index],
                                );
                              },
                            );
                          } else {
                            return Center(
                              child: Text(
                                "No users found",
                                style: TextStyle(fontSize: 20),
                              ),
                            );
                          }
                      }
                    },
                  );
              }
            },
          ),
        ),
      ),
    );
  }

  void _addChatUserDialod() {
    String email = '';

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            contentPadding: EdgeInsets.only(
              left: 24,
              right: 24,
              top: 20,
              bottom: 10,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Row(
              children: [
                Icon(Icons.person_add, color: Colors.blue, size: 28),
                Text('  Add User'),
              ],
            ),

            content: TextFormField(
              maxLines: null,
              onChanged: (value) => email = value,

              decoration: InputDecoration(
                hintText: 'Email Id',
                prefixIcon: Icon(Icons.email, color: Colors.blue),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            actions: [
              MaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Colors.blue, fontSize: 16),
                ),
              ),
              MaterialButton(
                onPressed: () async {
                  Navigator.pop(context);
                  if (email.isNotEmpty)
                    await APIs.addChatUser(email).then(
                      (value) => {
                        if (!value)
                          {
                            Dialogs.showSnackBar(
                              context,
                              'User does not Exists!',
                            ),
                          },
                      },
                    );
                },
                child: Text(
                  'Add',
                  style: TextStyle(color: Colors.blue, fontSize: 16),
                ),
              ),
            ],
          ),
    );
  }
}
