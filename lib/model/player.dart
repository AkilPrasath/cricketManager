import 'package:flutter/material.dart';

class Player {
  bool isCaptain;
  String name;
  String type;
  int age;
  int totalRuns;
  double strikeRate;
  int wickets;
  double economy;
  String email;
  Player(
      {@required this.isCaptain,
      @required this.name,
      @required this.type,
      @required this.age,
      @required this.totalRuns,
      @required this.strikeRate,
      @required this.wickets,
      @required this.economy,
      @required this.email});

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      email: json["email"],
      isCaptain: json["isCaptain"],
      name: json["name"],
      type: json["type"],
      age: json["age"],
      totalRuns: json["totalRuns"],
      strikeRate: json["strikeRate"],
      wickets: json["wickets"],
      economy: json["economy"],
    );
  }
}
