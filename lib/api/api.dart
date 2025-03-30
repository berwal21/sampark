import 'package:chatapp/model/chat_usermodel.dart';
import 'package:chatapp/model/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class APIs {
  static FirebaseAuth auth = FirebaseAuth.instance;

  //push notification
  static FirebaseMessaging fmessaging = FirebaseMessaging.instance;

  //for accesing self info

  static late ChatUsermodel me;

  //for accesing cloud firestore database

  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  // to return current user

  static User get user => auth.currentUser!;

  // for getting current user info

  static Future<void> getSelfInfo() async {
    await firestore.collection('users').doc(user.uid).get().then((user) async {
      if (user.exists) {
        me = ChatUsermodel.fromJson(user.data()!);
        await getFirebaseMsgToken();
        updateActiveStatus(true);
      } else {
        await createUser().then((value) => getSelfInfo());
      }
    });
  }

  // for checking if user exists or not?
  static Future<bool> userExists() async {
    return (await firestore.collection('users').doc(user.uid).get())
        .exists; // returns true if user exists
  }

  // for add user

  static Future<bool> addChatUser(String email) async {
    final data =
        await firestore
            .collection('users')
            .where('email', isEqualTo: email)
            .get(); // returns true if user exists

    if (data.docs.isNotEmpty && data.docs.first.id != user.uid) {
      firestore
          .collection('users')
          .doc(user.uid)
          .collection('my_users')
          .doc(data.docs.first.id)
          .set({});

      return true;
    } else {
      return false;
    }
  }

  // for creating new user

  static Future<void> createUser() async {
    final time = DateTime.now().microsecondsSinceEpoch.toString();

    final chatUser = ChatUsermodel(
      image: user.photoURL!,
      about: "Hey I'm using Sampark !!!",
      name: user.displayName.toString(),
      createdAt: time,
      isOnline: false,
      id: user.uid,
      lastActive: time,
      email: user.email.toString(),
      pushToken: "",
    );

    return await firestore
        .collection('users')
        .doc(user.uid)
        .set(chatUser.toJson());
  }

  // fetching all user from database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUser(
    List<String> usersIds,
  ) {
    return firestore
        .collection('users')
        .where('id', whereIn: usersIds)
        // .where('id', isNotEqualTo: user.uid)
        .snapshots();
  }

  // fetching Myusers from database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getMyUsersId() {
    return firestore
        .collection('users')
        .doc(user.uid)
        .collection('my_users')
        .snapshots();
  }

  static Future<void> updateUserInfo() async {
    await firestore.collection('users').doc(user.uid).update({
      'name': me.name,
      'about': me.about,
    });
  }

  static Future<void> sendFirstMsg(
    ChatUsermodel chatUser,
    String msg,
    Type type,
  ) async {
    await firestore
        .collection('users')
        .doc(chatUser.id)
        .collection('my_users')
        .doc(user.uid)
        .set({})
        .then((value) => sendMessage(chatUser, msg, type));
  }

  // for getting specific user info
  static Stream<QuerySnapshot<Map<String, dynamic>>> getUserInfo(
    ChatUsermodel chatuser,
  ) {
    return firestore
        .collection('users')
        .where('id', isEqualTo: chatuser.id)
        .snapshots();
  }

  static Future<void> updateActiveStatus(bool isOnline) async {
    firestore.collection('users').doc(user.uid).update({
      'is_online': isOnline,
      'last_active': DateTime.now().microsecondsSinceEpoch.toString(),
      'push_token': me.pushToken,
    });
  }

  static Future<void> getFirebaseMsgToken() async {
    await fmessaging.requestPermission();
    await fmessaging.getToken().then((t) {
      if (t != null) {
        me.pushToken = t;
      }
    });
  }
  //----------------------------------------------- chatting Screen

  // chats(collection)---> covvoId(doc)--->messages(collection)--->message(doc)

  // getting convoId
  static String getConversationID(String id) =>
      user.uid.hashCode <= id.hashCode
          ? '${user.uid}_$id'
          : '${id}_${user.uid}';

  // for getting messages

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
    ChatUsermodel user,
  ) {
    return firestore
        .collection('chats/${getConversationID(user.id)}/messages/')
        .orderBy('sent', descending: true)
        .snapshots();
  }

  //for send msg
  static Future<void> sendMessage(
    ChatUsermodel chatUser,
    String msg,
    Type type,
  ) async {
    // msg sendinf0 time
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    //msg to send
    final Message message = Message(
      toId: chatUser.id,
      msg: msg,
      read: '',
      fromId: user.uid,
      sent: time,
      type: Type.text,
    );

    final ref = firestore.collection(
      'chats/${getConversationID(chatUser.id)}/messages/',
    );
    await ref.doc(time).set(message.toJson());
  }

  //update read status

  static Future<void> updateMessageReadStatus(Message message) async {
    firestore
        .collection('chats/${getConversationID(message.fromId)}/messages/')
        .doc(message.sent)
        .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
  }

  //getting last msg
  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(
    ChatUsermodel user,
  ) {
    return firestore
        .collection('chats/${getConversationID(user.id)}/messages/')
        .orderBy('sent', descending: true)
        .limit(1)
        .snapshots();
  }

  //sent chat image

  // delete msg

  static Future<void> deleteMessage(Message message) async {
    await firestore
        .collection('chats/${getConversationID(message.toId)}/messages/')
        .doc(message.sent)
        .delete();
  }

  // update msg

  static Future<void> UpdateMessage(Message message, String updatedMsg) async {
    await firestore
        .collection('chats/${getConversationID(message.toId)}/messages/')
        .doc(message.sent)
        .update({'msg': updatedMsg});
  }
}
