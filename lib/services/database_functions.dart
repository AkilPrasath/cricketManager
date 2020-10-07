import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cricket_team_creator/model/player.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

enum SignInResult { captain, player, userNotFound, wrongPassword }

class DatabaseService {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _database = FirebaseFirestore.instance;
  Future<SignInResult> login(String email, String password) async {
    try {
      UserCredential userCred = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (userCred.user.email == "captain@gmail.com") {
        return SignInResult.captain;
      } else {
        return SignInResult.player;
      }
    } catch (exception) {
      if (exception.code == 'user-not-found') {
        return SignInResult.userNotFound;
      } else if (exception.code == 'wrong-password') {
        return SignInResult.wrongPassword;
      }
    }
  }

  getPlayerDetails() async {
    Query query = _database.collection("players");
    QuerySnapshot result = await query.get();
    List<QueryDocumentSnapshot> hasCaptainList = result.docs.where((doc) {
      if (doc.data()["isCaptain"] == true) {
        return true;
      }
      return false;
    }).toList();
    if (hasCaptainList.isEmpty) {
      await _database.collection("players").doc("Captain").set({
        "isCaptain": true,
        "name": "Captain",
        "type": "Batsman",
        "age": 20,
        "totalRuns": 200,
        "strikeRate": 400.0,
        "wickets": -1,
        "economy": 4.5,
        "email": "captain@gmail.com",
      });
      getPlayerDetails();
    } else {}
  }

  Stream<List<Player>> playerStream() {
    return _database.collection("players").snapshots().map((snapshot) {
      return snapshot.docs.map(
        (document) {
          print(document.data());
          Player player = Player.fromJson(
            document.data(),
          );
          return player;
        },
      ).toList();
    });
  }

  addPlayer(Player player) async {
    await _database.collection("players").doc(player.name.toString()).set({
      "isCaptain": false,
      "name": player.name,
      "type": player.type,
      "age": player.age,
      "totalRuns": player.totalRuns,
      "strikeRate": player.strikeRate,
      "wickets": player.wickets,
      "economy": player.economy,
    });
    try {
      _auth.createUserWithEmailAndPassword(
          email: player.email, password: player.email);
    } catch (exception) {
      print(exception.toString());
    }
  }
}
