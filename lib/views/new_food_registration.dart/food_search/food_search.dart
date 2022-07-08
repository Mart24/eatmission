import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_app/Models/fooddata_json.dart';
import 'package:food_app/Models/ingredients.dart';
import 'package:food_app/Views/constants.dart';
import 'package:food_app/Views/new_food_registration.dart/food_amount.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:food_app/Services/groente_service_json_.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:food_app/Widgets/rounded_button.dart';
import 'package:food_app/shared/search_cubit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:food_app/views/new_food_registration.dart/food_search/all_view.dart';
import 'package:food_app/views/new_food_registration.dart/food_search/fav_view.dart';
import 'package:food_app/views/new_food_registration.dart/food_search/recent_view.dart';
import 'package:google_fonts/google_fonts.dart';

// Step 1: his is the class for a new Food intake by the user
// The data is clicked on then sended to food_amount.dart and then send to summary.dart
// The item is caled Trip, because I used a trip database in this app. Renames breakes everything, so I let it be trips.
// Trip can be seen as Food.

class NewFoodIntake extends StatefulWidget {
  NewFoodIntake({Key key}) : super(key: key);

  @override
  _NewFoodIntakeState createState() => _NewFoodIntakeState();
}

class _NewFoodIntakeState extends State<NewFoodIntake> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          appBar: AppBar(
            systemOverlayStyle: SystemUiOverlayStyle.light,

            title: Text(AppLocalizations.of(context).searchyourproductstext),
            backgroundColor: kPrimaryColor,
            // actions: [
            //   IconButton(
            //       icon: Icon(Icons.camera_alt_outlined),
            //       onPressed: searchCubit.scanBarcode)
            // ],
            actions: [
              IconButton(
                constraints: BoxConstraints.expand(width: 90),
                icon: Text('Niet gevonden?', textAlign: TextAlign.center),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        _buildPopupDialog(context),
                  );
                },
              ),
            ],
            // //       onPressed: searchCubit.scanBarcode)],
            bottom: TabBar(
              indicatorColor: Colors.white,
              tabs: [
                Tab(
                  height: 45,
                  iconMargin: EdgeInsets.only(bottom: 4),
                  icon: Icon(
                    Icons.fastfood_outlined,
                    size: 18,
                    color: Colors.white,
                  ),
                  child: Text(
                    (AppLocalizations.of(context).all),
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ),
                Tab(
                  height: 45,
                  iconMargin: EdgeInsets.only(bottom: 4),
                  icon: Icon(
                    Icons.favorite_outline,
                    size: 18,
                    color: Colors.white,
                  ),
                  child: Text(
                    (AppLocalizations.of(context).favorites),
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ),
                Tab(
                  height: 45,
                  iconMargin: EdgeInsets.only(bottom: 4),
                  icon: Icon(
                    Icons.search,
                    size: 18,
                    color: Colors.white,
                  ),
                  child: Text(
                    (AppLocalizations.of(context).recent),
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          body: TabBarView(children: [
            AllView(),
            FavView(),
            RecentView(),
          ])),
    );
  }
}

Widget _buildPopupDialog(BuildContext context) {
  return new AlertDialog(
    scrollable: true,
    title: const Text(
      'Product niet gevonden?',
      style: TextStyle(fontSize: 18),
    ),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text.rich(TextSpan(
            style: GoogleFonts.roboto(
              fontSize: 16,
            ),
            children: <TextSpan>[
              TextSpan(
                  text:
                      'De database in deze app bestaat ongeveer 2100 producten. Helaas zijn zit hier geen specifieke productinformatie bij van ieder product in de supermarkt. Probeer hier omheen te werken.\n\nDrink je bijvoorbeeld een glas Cola? Zoek dan op "Frisdrank".\n\nHet kan ook helpen om een spatie achter het zoekwoord te plaatsen. Voorbeeld: "ei (spatie)", zorgt voor betere resulaten voor een ei.\n\nZie je de letter m? dat betekent met. De letter z staat voor zonder'),
              // TextSpan(
              //   text: 'Rood',
              //   style:
              //       TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
              // ),
              // TextSpan(
              //     text: ' is het maximale en ', style: TextStyle(fontSize: 16)),
              // TextSpan(
              //   text: 'Groen',
              //   style:
              //       TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
              // ),
              // TextSpan(
              //     text:
              //         ' staat voor de minimale consumptie per dag. Voor meer informatie, kijk op de website voedingscentrum.nl',
              //     style: TextStyle(fontSize: 16)),
            ])),
      ],
    ),
    actions: <Widget>[
      new FlatButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        //textColor: Theme.of(context).primaryColor,
        child: Text('Sluit'),
      ),
    ],
  );
}
