// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey.shade700,
        appBar: AppBar(
          title: Text(
            'theanthonyduong',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
          backgroundColor: Colors.red.shade900,
        ),
        body: Column(
          children: <Widget>[
            Container(
              // child: Align(alignment: Alignment.centerLeft),
              width: 350,
              height: 145,
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              margin: EdgeInsets.fromLTRB(25, 40, 25, 10),
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              child: Column(
                children: <Widget>[
                  Text('\t\t\t\t\t\t\t\t\t\t\tAnthony Duong',
                      style: TextStyle(fontSize: 25)),
                  Text('\nHeight: 5ft 8in \nWeight: 168 lbs \nSex: Male'),
                ],
              ),
            ),
            Container(
              width: 350,
              height: 145,
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              margin: EdgeInsets.fromLTRB(25, 30, 25, 10),
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              child: Column(
                children: <Widget>[
                  Text('Favorite Group',
                      style: TextStyle(
                          fontSize: 30, decoration: TextDecoration.underline)),
                  Text('\nGoobs', style: TextStyle(fontSize: 15)),
                ],
              ),
            ),
            Container(
              width: 350,
              height: 165,
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              margin: EdgeInsets.fromLTRB(25, 30, 25, 10),
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              child: Column(
                children: <Widget>[
                  Text(
                    'Max Calculations',
                    style: TextStyle(
                        fontSize: 30, decoration: TextDecoration.underline),
                  ),
                  Text(
                      '\nBenchpress: 105 lbs \nSquat: 135 lbs \nDeadlift: 185 lbs \n415/1000 lbs'),
                ],
              ),
            ),
          ],
        ),
        endDrawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            // backgroundColor: Colors.grey,
            children: <Widget>[
              SizedBox(
                height: 127,
                child: DrawerHeader(
                  // child: CircleAvatar(),
                  child: Text(
                    'theanthonyduong',
                    style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
                  ),
                  decoration: BoxDecoration(color: Colors.red.shade900),
                ),
              ),
              ListTile(
                leading: Icon(Icons.settings, size: 40),
                title: Text('Settings', style: TextStyle(fontSize: 25)),
                onTap: () {},
              ),
              Spacer(),
              ListTile(
                leading: Icon(Icons.highlight_remove, size: 40),
                title: Text('Sign out', style: TextStyle(fontSize: 25)),
                onTap: () {},
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.red.shade900,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(icon: Icon(Icons.fitness_center), onPressed: () {}),
              IconButton(icon: Icon(Icons.local_dining), onPressed: () {}),
              IconButton(icon: Icon(Icons.group_outlined), onPressed: () {}),
              IconButton(icon: Icon(Icons.person_rounded), onPressed: null),
            ],
          ),
        ),
      ),
    );
  }
}