import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firstapp/models/user.dart';
import 'package:firstapp/services/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class AddFriends extends StatefulWidget {
  @override
  _AddFriends createState() => _AddFriends();
}

class _AddFriends extends State<AddFriends> {
  User? user = FirebaseAuth.instance.currentUser;
  final uid = FirebaseAuth.instance.currentUser!.uid;
  List<DocumentSnapshot> searchedUsers = [];
  bool gotUsers = false;
  int searchedUsersCount = 0;
  String search = '';
  bool submitSearch = false;

  @override
  void initState() {
    updateSearchList();
    super.initState();
  }

  void updateSearchList() async {
    if (search.isEmpty == false) {
      searchedUsers =
          await UserService(uid: uid).queryByUsername(search.toLowerCase());
      searchedUsersCount = searchedUsers.length;
      gotUsers = true;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('Add A Friend', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      backgroundColor: Colors.white,
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (OverscrollIndicatorNotification overScroll) {
          overScroll.disallowGlow();
          return false;
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: 50,
                  child: Card(
                    elevation: 0,
                    color: Colors.grey.shade100,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: 250,
                            child: TextFormField(
                              onChanged: (text) {
                                setState(() {
                                  search = text;
                                  submitSearch = false;
                                });
                              },
                              decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.only(
                                      top: 8, bottom: 8, left: 8),
                                  border: InputBorder.none,
                                  filled: false,
                                  labelText: 'Search for a username',
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.never),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 40,
                          height: 40,
                          child: GestureDetector(
                              onTap: () {
                                if (search.isEmpty) {
                                  setState(() {
                                    submitSearch = false;
                                    gotUsers = false;
                                  });
                                } else {
                                  setState(() {
                                    gotUsers = false;
                                    submitSearch = true;
                                  });
                                }
                                updateSearchList();
                              },
                              child: Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.red),
                                  child: Center(
                                      child: Icon(CupertinoIcons.search,
                                          color: Colors.white)))),
                        )
                      ],
                    ),
                  ),
                ),
                gotUsers == false
                    ? submitSearch == false
                        ? SizedBox()
                        : Container(
                            color: Colors.white,
                            child: Center(child: CircularProgressIndicator()))
                    : Container(
                        height: 200,
                        child: ListView.separated(
                          separatorBuilder: (context, _) => SizedBox(width: 12),
                          itemBuilder: (context, index) {
                            return listUsers(userid: searchedUsers[index].id);
                          },
                          itemCount: searchedUsersCount,
                        ),
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class listUsers extends StatefulWidget {
  String userid;
  listUsers({required this.userid});
  @override
  _listUsers createState() => _listUsers(userid: userid);
}

class _listUsers extends State<listUsers> {
  String userid;
  _listUsers({required this.userid});
  final uid = FirebaseAuth.instance.currentUser!.uid;
  bool inviteSent = false;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserModel?>(
      stream: UserService(uid: userid).getUserInfo(userid),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          UserModel? userData = snapshot.data;
          return GestureDetector(
              onTap: () {},
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(userData!.profileImageUrl),
                ),
                title: Text(userData.firstName! + " " + userData.lastName!),
                subtitle: Text(userData.username!),
                trailing: SizedBox(
                  width: 30,
                  height: 30,
                  child: inviteSent == false
                      ? GestureDetector(
                          onTap: () {
                            UserService(uid: uid).sendFriendRequest(userid);
                            setState(() {
                              inviteSent = true;
                            });
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.red),
                              child: Center(
                                  child: Icon(CupertinoIcons.add,
                                      size: 18, color: Colors.white))))
                      : GestureDetector(
                          onTap: null,
                          child: Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.transparent),
                              child: Center(
                                  child: Icon(CupertinoIcons.check_mark,
                                      size: 18, color: Colors.green)))),
                ),
              ));
        } else {
          return Container(
              color: Colors.white,
              child: Center(child: CircularProgressIndicator()));
        }
      },
    );
  }
}
