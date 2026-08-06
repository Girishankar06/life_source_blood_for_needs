import 'package:bloodbank/screens/needer_form.dart';
import 'package:bloodbank/screens/profile_form.dart';
import 'package:bloodbank/screens/profile_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import '../model/neederid.dart';
import 'navbar.dart';
import 'needer_list.dart';

class testHome extends StatefulWidget {
  String email;
  testHome({required this.email});

  @override
  _testHomestate createState() => _testHomestate(email);
}

class _testHomestate extends State<testHome> {
  String email;
  _testHomestate(this.email);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: NestedScrollView(
            floatHeaderSlivers: true,
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
                  SliverAppBar(
                    title: Text('LifeSource'),
                    centerTitle: true,
                    floating: true,
                    snap: true,
                    actions: [],
                    backgroundColor: Color.fromRGBO(196, 15, 15, 1),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(200))),
                    bottom: PreferredSize(
                      preferredSize: Size.fromHeight(200),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
                              child: Text(
                                "Give the Gift",
                                style: TextStyle(
                                    fontSize: 25,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              )),
                          Padding(
                              padding: EdgeInsets.fromLTRB(110, 0, 0, 15),
                              child: Text(
                                "Of",
                                style: TextStyle(
                                    fontSize: 25,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              )),
                          Padding(
                              padding: EdgeInsets.fromLTRB(110, 0, 0, 0),
                              child: Text(
                                "Life to Others",
                                style: TextStyle(
                                    fontSize: 25,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              )),
                          SizedBox(
                            height: 50,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
            body: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                      height: 17,
                      child: Marquee(
                        text: 'Life Source helps life',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.red),
                        scrollAxis: Axis.horizontal,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        blankSpace: 20.0,
                        velocity: 100.0,
                        pauseAfterRound: Duration(seconds: 1),
                        startPadding: 10.0,
                        accelerationDuration: Duration(seconds: 1),
                        accelerationCurve: Curves.linear,
                        decelerationDuration: Duration(milliseconds: 500),
                        decelerationCurve: Curves.easeOut,
                      )),
                  Text(
                    "Donar's List : ",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 255, 0, 0),
                        height: 2,
                        fontSize: 25),
                  ),
                  SizedBox(height: 10),
                  SingleChildScrollView(
                      child: SizedBox(
                          height: 300,
                          child: StreamBuilder(
                            stream: readUsers(),
                            builder: (context,
                                AsyncSnapshot<List<Neederid>> snapshot) {
                              if (snapshot.hasError) {
                                return Text('Something went wrong');
                              } else if (snapshot.hasData) {
                                final users = snapshot.data!;
                                return ListView(
                                  children: users.map(builduser).toList(),
                                );
                              } else {
                                return Center(
                                    child: CircularProgressIndicator());
                              }
                            },
                          ))),
                ],
              ),
            )));
  }

  Widget builduser(Neederid user) => Card(
      margin: EdgeInsets.fromLTRB(10, 0, 10, 19),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: Colors.blue,
      child: ListTile(
          leading: CircleAvatar(
            child: Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                Text(user.bloodtype),
                Text(user.antigen)
              ],
            ),
          ),
          title: Text(user.name),
          subtitle: Row(
            children: [
              Text('Age : '),
              Text(user.age),
              Text('   Phone : '),
              Text(user.phone)
            ],
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            size: 30,
            color: Colors.white,
          ),
          textColor: Colors.white,
          onTap: () {
            showDialog(
                context: context,
                builder: (context) => CupertinoAlertDialog(
                      title: Text('Details'),
                      content: Column(
                        children: [
                          Row(
                            children: [Text('Name : '), Text(user.name)],
                          ),
                          Row(
                            children: [
                              Text('Blood Group : '),
                              Text(user.bloodtype)
                            ],
                          ),
                          Row(
                            children: [Text('Antigen : '), Text(user.antigen)],
                          ),
                          Row(
                            children: [Text('Age : '), Text(user.age)],
                          ),
                          Row(
                            children: [Text('email : '), Text(user.email)],
                          ),
                          Row(
                            children: [Text('city : '), Text(user.add2)],
                          ),
                          Row(
                            children: [Text('state : '), Text(user.state)],
                          ),
                          Row(
                            children: [Text('country : '), Text(user.country)],
                          ),
                          Row(
                            children: [Text('phone : '), Text(user.phone)],
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              print('yes');
                            },
                            child: Text('Approve'))
                      ],
                    ));
          }));

  Stream<List<Neederid>> readUsers() => FirebaseFirestore.instance
      .collection('donar')
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map<Neederid>((doc) => Neederid.fromJson(doc.data()))
          .toList());
}
