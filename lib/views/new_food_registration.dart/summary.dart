import 'package:flutter/material.dart';
import 'package:food_app/Models/ingredients.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_app/Widgets/Provider_Auth.dart';
import '../constants.dart';

// Step 3: the users gets an overview of the food eaten

class NewFoodSummaryView extends StatelessWidget {
  final db = FirebaseFirestore.instance;

  final Trip trip;
  NewFoodSummaryView({Key key, @required this.trip}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          title: Text('Food Summary'),
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                "Overview of intake",
                style: TextStyle(fontSize: 20.0),
              ),
            ),
            Text("food ${trip.name} "),
            Text(" ${trip.kcal.toStringAsFixed(2)} calories"),
            Text(" ${trip.carbs.toStringAsFixed(2)} carbs"),
            Text(" ${trip.fat.toStringAsFixed(2)} fat"),
            Text(" ${trip.protein.toStringAsFixed(2)} protein"),
            Text(
                "eaten amount ${trip.amount.toString()} ${trip.amountUnit.toString()}"),
            Text(
                "Food intake data ${trip.eatDate.day}-${trip.eatDate.month}-${trip.eatDate.year}"),
            Text("Categorie: ${trip.categorie}"),
            RaisedButton(
              child: Text("Continue"),
              color: kPrimaryColor,
              onPressed: () async {
                // save data to firebase
                final uid = await Provider.of(context).auth.getCurrentUID();
                await db
                    .collection("userData")
                    .doc(uid)
                    .collection("food_intake")
                    .add(trip.toJson());
                //sends user back to the dashboard page
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
          ],
        )));
  }
}
