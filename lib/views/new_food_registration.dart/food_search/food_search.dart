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
