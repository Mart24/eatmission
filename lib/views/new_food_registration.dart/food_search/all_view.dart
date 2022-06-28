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

class AllView extends StatefulWidget {
  AllView({Key key}) : super(key: key);

  @override
  State<AllView> createState() => _AllViewState();
}

class _AllViewState extends State<AllView> {
  final dbService = DatabaseGService();
  String keyword;
  Trip trip = Trip.empty();
  String scanResult;
  FocusNode myFocusNode = new FocusNode();

  @override
  Widget build(BuildContext context) {
    SearchCubit searchCubit = SearchCubit.instance(context);
    RecentCubit recentCubit = RecentCubit.instance(context);

    return BlocConsumer<SearchCubit, SearchStates>(
      listener: (context, state) {
        if (state is ScanValidResultReturned) {
          print('SearchValidResultReturned');
          print(searchCubit.scanResult);

          searchCubit.searchOnDb();
        } else if (state is SearchResultFound) {
          print('SearchResultFound');
          print(searchCubit.scanResult);
          print("trip:\n" + state.trip.toJson().toString());
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (BuildContext context) {
            return FoodDate(
              trip: state.trip,
            );
          }));
        } else if (state is SearchResultNotFound) {
          print('SearchResultNotFound');
          print(searchCubit.scanResult);

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
      },
      builder: (context, state) {
        return SafeArea(
          child: GestureDetector(
            onTap: () {
              print('Clicked outside');
              FocusScope.of(context).unfocus();
            },
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  //     Text(scanResult == null ? 'Scan a code!' : 'Scan Result : $scanResult'),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      focusNode: myFocusNode,
                      cursorColor: kPrimaryColor,
                      autofocus: true,
                      decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: kPrimaryColor, width: 2.0),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          border: OutlineInputBorder(),
                          labelText: AppLocalizations.of(context).typesomething,
                          labelStyle: TextStyle(
                              color: myFocusNode.hasFocus
                                  ? kPrimaryColor
                                  : kPrimaryColor)),
                      onChanged: (value) {
                        keyword = value;
                        setState(() {});
                      },
                    ),
                  ),
                  Expanded(
                    child: FutureBuilder<List<FooddataSQLJSON>>(
                      future: dbService.searchGFooddata(keyword),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData)
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        return ListView.builder(
                            keyboardDismissBehavior:
                                ScrollViewKeyboardDismissBehavior.onDrag,
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(snapshot.data[index].foodname),
                                subtitle:
                                    Text('${snapshot.data[index].category}'),
                                // Text(snapshot.data[index].productid.toString()),
                                trailing: Text(
                                    '${snapshot.data[index].kcal.toString()} Kcal'),
                                onTap: () {
                                  trip.name = snapshot.data[index].foodname;
                                  trip.productid =
                                      snapshot.data[index].productid;
                                  trip.id = snapshot.data[index].productid;
                                  trip.documentId =
                                      snapshot.data[index].productid.toString();
                                  searchCubit.searchByIdOnDb(
                                      snapshot.data[index].productid);
                                  // push the amount value to the summary page
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //       builder: (context) =>
                                  //           FoodDate(trip: trip)),
                                  // );
                                },
                              );
                            });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
