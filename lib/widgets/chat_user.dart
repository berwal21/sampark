import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/api/api.dart';
import 'package:chatapp/helper/mydateutil.dart';
import 'package:chatapp/main.dart';
import 'package:chatapp/model/chat_usermodel.dart';
import 'package:chatapp/model/message.dart';
import 'package:chatapp/screens/chattingscreen.dart';
import 'package:chatapp/widgets/profile_dialog.dart';
import 'package:flutter/material.dart';

class ChatUser extends StatefulWidget {
  final ChatUsermodel user;
  const ChatUser({super.key, required this.user});

  @override
  State<ChatUser> createState() => _ChatUserState();
}

class _ChatUserState extends State<ChatUser> {
  // last msg info
  Message? _message;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: mq.width * .04, vertical: 4),
      elevation: 1,
      //color: Colors.blue[100],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => Chattingscreen(user: widget.user),
            ),
          );
        },
        child: StreamBuilder(
          stream: APIs.getLastMessage(widget.user),
          builder: (context, snapshot) {
            final data = snapshot.data?.docs;
            final list =
                data?.map((e) => Message.fromJson(e.data())).toList() ?? [];

            if (list.isNotEmpty) _message = list[0];

            return ListTile(
              //profile picture
              leading: InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) => ProfileDialog(user: widget.user),
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(mq.height * .3),
                  child: CachedNetworkImage(
                    height: mq.height * .055,
                    width: mq.height * .055,
                    imageUrl: widget.user.image,
                    errorWidget:
                        (context, url, error) =>
                            CircleAvatar(child: Icon(Icons.person)),
                  ),
                ),
              ),
              //username
              title: Text(widget.user.name),
              //last message
              subtitle: Text(
                _message != null ? _message!.msg : widget.user.about,
                maxLines: 1,
              ),
              // last msg time
              trailing:
                  _message == null
                      ? null
                      : _message!.read.isEmpty &&
                          _message!.fromId != APIs.user.uid
                      ? Container(
                        width: 15,
                        height: 15,
                        decoration: BoxDecoration(
                          color: Colors.greenAccent.shade400,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      )
                      : Text(
                        MyDateUtil.getLastMsgTime(
                          context: context,
                          time: _message!.sent,
                        ),
                        style: TextStyle(color: Colors.black87),
                      ),
            );
          },
        ),
      ),
    );
  }
}
