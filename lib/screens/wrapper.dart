import 'package:firstapp/start_app.dart';
import 'package:firstapp/models/user.dart';
import 'package:firstapp/screens/all.dart';
import 'package:firstapp/screens/create_account.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel>(context);

    if (user == null) {
      return Login();
    }

    return startApp();
  }
}