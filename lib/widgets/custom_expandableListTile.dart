import 'package:cricket_team_creator/model/player.dart';
import 'package:cricket_team_creator/services/database_functions.dart';
import 'package:cricket_team_creator/widgets/custom_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomExpandableListTile extends StatelessWidget {
  CustomExpandableListTile({
    @required this.parentContext,
    this.player,
    Key key,
  }) : super(key: key);
  final BuildContext parentContext;
  Player player;
  TextStyle _headingStyle() {
    return GoogleFonts.workSans(
      fontWeight: FontWeight.w700,
      color: Colors.grey[850],
    );
  }

  Future<bool> deleteDialog(context) async {
    return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Confirm Delete"),
          content: Text("Do you want to delete this bank from your favorites?"),
          actions: [
            FlatButton(
              child: Text("No, I've changed my mind"),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
            FlatButton(
              key: Key("confirm_remove_favourite_button"),
              child: Text("Yes, Delete anyways"),
              onPressed: () async {},
            ),
          ],
          actionsPadding: EdgeInsets.all(0),
          contentPadding: EdgeInsets.only(left: 24, right: 18, top: 16),
          buttonPadding: EdgeInsets.all(8),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
      child: Card(
        child: ExpansionTile(
          backgroundColor: Colors.white70,
          leading: CircleAvatar(
            child: Text("${player.name.substring(0, 1)}"),
          ),
          title: Text("${player.name}"),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              "${player.type}",
              style: TextStyle(
                fontSize: 13,
              ),
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text("Age   "),
                        Text("${player.age}"),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text("Email   "),
                        Text("${player.email}"),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text("Total Runs   "),
                        Text("${player.totalRuns}"),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text("Strike Rate   "),
                        Text("${player.strikeRate}"),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text("Wickets   "),
                        Text("${player.wickets}"),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text("Economy   "),
                        Text("${player.economy}"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
