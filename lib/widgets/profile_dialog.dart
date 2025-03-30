import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/main.dart';
import 'package:chatapp/model/chat_usermodel.dart';
import 'package:chatapp/screens/view_profile_screen.dart';
import 'package:flutter/material.dart';

class ProfileDialog extends StatelessWidget {
  const ProfileDialog({super.key, required this.user});
  final ChatUsermodel user;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: SizedBox(
        height: mq.height * .35,
        width: mq.width * .6,
        child: Stack(
          children: [
            Positioned(
              left: mq.width * .1,
              top: mq.height * .075,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(mq.height * .25),
                child: CachedNetworkImage(
                  width: mq.width * .5,
                  imageUrl: user.image,
                  errorWidget:
                      (context, url, error) =>
                          CircleAvatar(child: Icon(Icons.person)),
                ),
              ),
            ),

            Positioned(
              left: mq.width * .04,
              top: mq.height * .02,
              width: mq.width * .55,
              child: Text(
                user.name,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ),

            Positioned(
              right: 8,
              top: 6,
              child: MaterialButton(
                minWidth: 0,
                padding: EdgeInsets.all(0),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ViewProfileScreen(user: user),
                    ),
                  );
                },
                child: Icon(Icons.info_outline, size: 30, color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
