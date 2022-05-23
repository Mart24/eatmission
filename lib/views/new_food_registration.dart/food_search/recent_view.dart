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
import 'package:food_app/shared/recent_cubit.dart';
import 'package:food_app/shared/search_cubit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RecentView extends StatefulWidget {
  RecentView({Key key}) : super(key: key);

  @override
  State<RecentView> createState() => _RecentViewState();
}

class _RecentViewState extends State<RecentView> {
  final dbService = DatabaseGService();
  String keyword;
  Trip trip = Trip.empty();
  String scanResult;

  @override
  Widget build(BuildContext context) {
    RecentCubit recentCubit = RecentCubit.instance(context);

    return BlocConsumer<RecentCubit, RecentState>(listener: (context, state) {
      if (state is RecentResultFound) {
        print('RecentResultFound');
        print(recentCubit.tripsList);
      } else if (state is SearchResultNotFound) {
        print('favResultNotFound');
        print(recentCubit.tripsList);

        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('This Product is not found currently'),
                content: Text(
                    'we work hard to include all the product in our database, please search for a similar product or send us an email'),
                actions: [
                  RoundedButton(
                    color: Colors.green,
                    text: 'OK',
                  )
                ],
              );
            });
      } else {
        print('___^----^___');
      }
    }, builder: (context, state) {
      if (state is RecentResultFound) {
        return FutureBuilder<List<FooddataSQLJSON>>(
                      future: dbService.getGFooddata(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData)
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        return ListView.builder(
                            keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.onDrag,
                            itemCount: state.tripsList.length,
                            itemBuilder: (context, index) {
                              List<Trip> tripsList = state.tripsList;
                              FooddataSQLJSON tripFromLocalDB = snapshot.data.where((element) => element.productid == state.tripsList[index].id).first;
                              return ListTile(
                                title: Text(tripFromLocalDB.foodname),
                                subtitle: Text(
                                    '${tripFromLocalDB.category}, ${tripFromLocalDB.brand}'),
                                // Text(snapshot.data[index].productid.toString()),
                                trailing: IconButton(
                                    onPressed: () {
                                      recentCubit.deleteRecentTrip(tripsList[index]);
                                    },
                                    icon: Icon(Icons.delete)),
                                onTap: () {
                                  // push the amount value to the summary page
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => FoodDate(trip: tripsList[index])),
                                  );
                                },
                              );
                            });
                      }
                  );
      } else {
        return Center(
          child: CircularProgressIndicator(),
        );
      }
    });
  }
}
