import 'package:cricket_team_creator/UI/login_screen.dart';
import 'package:cricket_team_creator/model/player.dart';
import 'package:cricket_team_creator/services/database_functions.dart';
import 'package:cricket_team_creator/widgets/custom_expandableListTile.dart';
import 'package:cricket_team_creator/widgets/custom_icon_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CaptainDashboard extends StatefulWidget {
  static final String id = "Captain Dashboard";
  @override
  _CaptainDashboardState createState() => _CaptainDashboardState();
}

class _CaptainDashboardState extends State<CaptainDashboard> {
  String name;
  String type;
  int age;
  int totalRuns;
  double strikeRate;
  int wickets;
  double economy;
  String email;
  Future<void> addPlayer(BuildContext context) async {
    return showDialog(
      context: context,
      child: AlertDialog(
        title: Text("Add New Player"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: "Player Name",
                ),
                onChanged: (val) {
                  name = val;
                },
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: "Player mail",
                ),
                onChanged: (val) {
                  email = val;
                },
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: "Type",
                ),
                onChanged: (val) {
                  type = val;
                },
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: "Age",
                ),
                onChanged: (val) {
                  age = int.tryParse(val);
                },
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: "Total Runs",
                ),
                onChanged: (val) {
                  totalRuns = int.tryParse(val);
                },
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: "Strike Rate",
                ),
                onChanged: (val) {
                  strikeRate = double.tryParse(val);
                },
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: "Wickets",
                ),
                onChanged: (val) {
                  wickets = int.tryParse(val);
                },
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: "Economy",
                ),
                onChanged: (val) {
                  economy = double.tryParse(val);
                },
              ),
            ],
          ),
        ),
        actions: [
          FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Cancel"),
          ),
          FlatButton(
            onPressed: () async {
              Player player = Player(
                  email: email,
                  isCaptain: false,
                  name: name,
                  type: type,
                  age: age,
                  totalRuns: totalRuns,
                  strikeRate: strikeRate,
                  wickets: wickets,
                  economy: economy);
              await DatabaseService().addPlayer(player);
              Navigator.pop(context);
            },
            child: Text("Add"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          floatingActionButton: Builder(builder: (context) {
            return FloatingActionButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text("Signed Out"),
                ));
                Navigator.pop(context);
                Navigator.pushNamed(context, LoginScreen.id);
              },
              child: Icon(Icons.exit_to_app),
            );
          }),
          backgroundColor: Colors.transparent,
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Cricket Manager",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Builder(builder: (context) {
                    return InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () async {
                        await addPlayer(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.add),
                            Text("Add Player"),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
              StreamBuilder<List<Player>>(
                  stream: DatabaseService().playerStream(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting ||
                        snapshot.connectionState == ConnectionState.none ||
                        !snapshot.hasData) {
                      return Expanded(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    return Expanded(
                      child: ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return CustomExpandableListTile(
                            parentContext: context,
                            player: snapshot.data[index],
                          );
                        },
                      ),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
