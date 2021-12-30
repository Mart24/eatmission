import 'package:flutter/material.dart';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:eatmission/models/ingredients.dart';
// import 'package:food_app/Views/display_foodintake.dart';
// import 'package:food_app/Views/nutrition_details_page.dart';
import 'package:eatmission/shared/app_cubit.dart';
import 'package:eatmission/shared/dairy_cubit.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'new_food_registration.dart/food_search.dart';

class Profiel extends StatefulWidget {
  @override
  _ProfielState createState() => _ProfielState();
}

class _ProfielState extends State<Profiel> {
  final newTrip = Trip(
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      // null,
      // null,
      // null,
      // null,
      // null,
      // null,
      // null,
      // null,
      // null,
      // null,
      null);

  @override
  Widget build(BuildContext context) {
    print('rebuild dashboard');
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //       builder: (context) => NewFoodIntake(
          //         trip: newTrip,
          //       ),
          //     ));
        },
        label: const Text('Food'),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.orange,
        focusElevation: 2,
        foregroundColor: Colors.white,
      ),
      body: Container(
        margin: EdgeInsets.only(top: 15),
        child: Column(
          children: <Widget>[
            BlocConsumer<AppCubit, AppStates>(
              listener: (BuildContext context, state) {},
              builder: (BuildContext context, state) {
                if (AppCubit.instance(context).database != null) {
                  return BlocConsumer<DairyCubit, DairyStates>(
                      listener: (BuildContext context, DairyStates states) {
                        if (states is CurrentDateUpdated) {
                          print('current date updated');
                        } else if (states is GetUserTripsListState) {
                          DairyCubit.instance(context).sumAll();
                        } else if (states is SumBasicUpdated) {
                          final User? uid = FirebaseAuth.instance.currentUser;
                          final DairyCubit dairyCubit =
                          DairyCubit.instance(context);
                          final DateTime now = dairyCubit.currentDate;
                          try {
                            AppCubit.instance(context).insertIntoDB(uid.toString(), {
                              'date': DateTime(now.year, now.month, now.day)
                                  .toIso8601String(),
                              'calories': dairyCubit.kCalSum,
                              'co2': dairyCubit.co2Sum
                            });
                          } catch (e) {
                            print(e);
                          }
                        }
                      }, builder: (BuildContext context, DairyStates states) {
                    DairyCubit cubit = DairyCubit.instance(context);
                    double diff = cubit.kCalSum;
                    double circularPercent = diff / 2000.0;
                    if (circularPercent > 1) {
                      circularPercent = 1;
                    }
                    double diff2 = cubit.co2Sum;
                    double barPercent = diff2 / 5.0;
                    if (barPercent > 1) {
                      barPercent = 1;
                    }
                    return Column(children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () {
                                cubit.updateCurrentDate(cubit.currentDate
                                    .subtract(Duration(days: 1)));
                              },
                              icon: Icon(Icons.arrow_back_ios_sharp),
                              splashRadius: 28,
                              iconSize: 20,
                              //      color: Theme.of(context).accentColor,
                              color: Colors.black,
                            ),
                            TextButton.icon(
                                icon: Icon(
                                  Icons.calendar_today,
                                  color: Colors.black,
                                ),
                                onPressed: () {
                                  DatePicker.showDatePicker(
                                    context,
                                    showTitleActions: true,
                                    theme: DatePickerTheme(),
                                    currentTime:
                                    cubit.currentDate ?? DateTime.now(),
                                    minTime: DateTime(DateTime.now().year - 20),
                                    maxTime: DateTime(DateTime.now().year + 20),
                                    onChanged: (date) {
                                      print('change $date');
                                    },
                                    onConfirm: (date) {
                                      print('confirm $date');
                                      cubit.updateCurrentDate(date);
                                    },
                                    locale: LocaleType.en,
                                  );
                                },
                                label: Text(
                                  '${DateFormat.yMMMMd().format(cubit.currentDate)}',
                                  style: TextStyle(
                                    // color: Theme.of(context).accentColor,
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 20),
                                )),
                            IconButton(
                              onPressed: () {
                                cubit.updateCurrentDate(
                                    cubit.currentDate.add(Duration(days: 1)));
                              },
                              icon: Icon(Icons.arrow_forward_ios_sharp),
                              splashRadius: 28,
                              iconSize: 20,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              // child: Text(
                              //   'Eaten ${cubit.kCalSum.toStringAsFixed(0)} ',
                              //   style: TextStyle(
                              //       color: Colors.black, fontWeight: FontWeight.normal),
                              //   maxLines: 2,
                              //   textAlign: TextAlign.center,
                              // ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 15.0),
                                child: RichText(
                                    text: TextSpan(
                                        style: GoogleFonts.roboto(
                                            fontSize: 20, color: Colors.black),
                                        children: <TextSpan>[
                                          TextSpan(text: 'Eaten '),
                                          TextSpan(
                                            text:
                                            '${cubit.kCalSum.toStringAsFixed(0)}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.green),
                                          ),
                                          TextSpan(
                                              text: ' kcal',
                                              style: TextStyle(fontSize: 12)),
                                        ])),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: CircularPercentIndicator(
                                radius: 165.0,
                                lineWidth: 7.5,
                                animation: true,
                                backgroundColor: Colors.grey,
                                percent: circularPercent,
                                center: Text(
                                  "${diff.toStringAsFixed(0)} Kcal",
                                  style: TextStyle(fontSize: 20),
                                ),
                                progressColor: Colors.green,
                                circularStrokeCap: CircularStrokeCap.round,
                              ),
                            ),
                            Expanded(
                              // child: Text(
                              //   'Eaten ${cubit.kCalSum.toStringAsFixed(0)} ',
                              //   style: TextStyle(
                              //       color: Colors.black, fontWeight: FontWeight.normal),
                              //   maxLines: 2,
                              //   textAlign: TextAlign.center,
                              // ),
                              child: Padding(
                                padding: const EdgeInsets.only(right: 15.0),
                                child: RichText(
                                    text: TextSpan(
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.black),
                                        children: <TextSpan>[
                                          TextSpan(text: 'Burned'),
                                          TextSpan(
                                            text: '...',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.green),
                                          ),
                                          TextSpan(
                                              text: ' kcal',
                                              style: TextStyle(fontSize: 12)),
                                        ])),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 7.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                // new LinearPercentIndicator(
                                //   width: 100.0,
                                //   lineHeight: 8.0,
                                //   percent: 0.2,
                                //   progressColor: Colors.red,
                                // ),
                                Text(
                                    'Carbs ${cubit.carbs.toStringAsFixed(0)}g'),
                              ],
                            ),
                            Column(
                              children: [
                                // new LinearPercentIndicator(
                                //   width: 100.0,
                                //   lineHeight: 8.0,
                                //   percent: 0.7,
                                //   progressColor: Colors.yellow,
                                // ),
                                Text(
                                    'Protein ${cubit.protein.toStringAsFixed(0)}g'),
                              ],
                            ),
                            Column(
                              children: [
                                // new LinearPercentIndicator(
                                //   width: 100.0,
                                //   lineHeight: 8.0,
                                //   percent: 0.3,
                                //   progressColor: Colors.blue,
                                // ),
                                Text(' Fat ${cubit.fats.toStringAsFixed(0)}g'),
                              ],
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          LinearPercentIndicator(
                            animation: true,
                            backgroundColor: Colors.grey[350],
                            width: 300.0,
                            lineHeight: 25.0,
                            percent: barPercent,
                            progressColor: Colors.green,
                          ),
                        ],
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 7.0, bottom: 7.0),
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Text('Co2 ${cubit.co2Sum.toStringAsFixed(1)} kg ',
                              //     style: TextStyle(fontSize: 20)),
                              RichText(
                                  text: TextSpan(
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.black),
                                      children: <TextSpan>[
                                        TextSpan(text: 'Co2 '),
                                        TextSpan(
                                          text:
                                          '${cubit.co2Sum.toStringAsFixed(1)}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green),
                                        ),
                                        TextSpan(
                                            text: 'kg',
                                            style: TextStyle(fontSize: 12)),
                                      ])),

                              Text('max 5.0 kg')
                            ],
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // DairyCubit.instance(context).calcPercents();
                          // Navigator.of(context).push(MaterialPageRoute(
                          //     builder: (context) => NutritionalDetailsPage()));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "Details",
                              style:
                              TextStyle(fontSize: 20, color: Colors.green),
                            ),
                          ],
                        ),
                      ),
                      // Expanded(
                      //   child: Builder(
                      //     builder: (context) {
                      //       if (cubit.tripsList.isNotEmpty) {
                      //         return ListView.builder(
                      //           itemCount: cubit.tripsList.length,
                      //           itemBuilder: (BuildContext context, int index) =>
                      //               buildTripCard(context, cubit.tripsList[index]),
                      //         );
                      //       }
                      //       return const Text("No items entered...");
                      //     },
                      //   ),
                      // ),
                    ]);
                  });
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
            BlocConsumer<DairyCubit, DairyStates>(
              listener: (context, states) {},
              builder: (context, states) {
                DairyCubit cubit = DairyCubit.instance(context);
                print(
                    'Cubit mystream is: ${cubit.myStream == null ? 'null' : 'no null'}');
                return Expanded(
                  child: StreamBuilder(
                    stream: cubit.myStream,
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      // if (snapshot.hasData || snapshot.connectionState == ConnectionState.active) {
                      List<Widget> breakfastList = [
                        CategoryTitle(
                          title: 'Breakfast',
                          kcalSum: cubit.breakfastKcalSum,
                          co2Sum: cubit.breakfastsumco2Sum,
                        ),
                      ];
                      breakfastList.addAll(DairyCubit.instance(context)
                          .breakfastList
                          .map((e) => buildTripCard(context, e)));

                      List<Widget> lunchList = [
                        CategoryTitle(
                          title: 'Lunch',
                          kcalSum: cubit.lunchKcalSum,
                          co2Sum: cubit.lunchsumco2Sum,
                        ),
                      ];
                      lunchList.addAll(DairyCubit.instance(context)
                          .lunchList
                          .map((e) => buildTripCard(context, e)));

                      List<Widget> dinerList = [
                        CategoryTitle(
                          title: 'Diner',
                          kcalSum: cubit.dinerKcalSum,
                          co2Sum: cubit.dinersumco2Sum,
                        ),
                      ];
                      dinerList.addAll(DairyCubit.instance(context)
                          .dinerList
                          .map((e) => buildTripCard(context, e)));

                      List<Widget> snacksList = [
                        CategoryTitle(
                          title: 'Snacks',
                          kcalSum: cubit.snacksKcalSum,
                          co2Sum: cubit.snackssumco2Sum,
                        ),
                      ];
                      snacksList.addAll(DairyCubit.instance(context)
                          .snacksList
                          .map((e) => buildTripCard(context, e)));

                      List<Widget> othersList = [
                        CategoryTitle(
                          title: 'Others',
                          kcalSum: cubit.othersKcalSum,
                          co2Sum: cubit.otherssumco2Sum,
                        ),
                      ];
                      othersList.addAll(DairyCubit.instance(context)
                          .otherList
                          .map((e) => buildTripCard(context, e)));

                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            Column(
                              children: breakfastList,
                            ),
                            Column(
                              children: lunchList,
                            ),
                            Column(
                              children: dinerList,
                            ),
                            Column(
                              children: snacksList,
                            ),
                            Column(
                              children: othersList,
                            ),
                            SizedBox(
                              height: 58,
                            ),
                          ],
                        ),
                      );

                      // return ListView.builder(
                      //   itemCount: snapshot.data.docs.length,
                      //   itemBuilder: (BuildContext context, int index) =>
                      //       buildTripCard(context, snapshot.data.docs[index]),
                      // );
                      // } else {
                      //   return const Text("No items entered...");
                      // }
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    // getUsersTripsStreamSnapshots(context);
    DairyCubit.instance(context).getUsersTripsStreamSnapshots();
    super.initState();
  }

  Widget buildTripCard(BuildContext context, DocumentSnapshot document) {
    final trip = Trip.fromSnapshot(document);
    final plantType = trip.planticon();
    return Container(
      child: InkWell(
        onTap: () {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //       builder: (context) => DetailFoodIntakeView(trip: trip)),
          // );
        },
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                  child: Row(
                    children: <Widget>[
                      AutoSizeText(
                        trip.name!,
                        // style: new TextStyle(fontSize: 20.0),
                      ),
                      Spacer(),
                      Tooltip(
                        message: 'plantaardig',
                        child: (plantType.containsKey(trip.plantbased))
                            ? plantType[trip.plantbased]
                            : plantType["n"],
                      ),
                      // Tooltip(
                      //   message: 'plantaardig',
                      //   child: ImageIcon(
                      //     AssetImage("assets/icons/leaf_icon.png"),
                      //     color: kPrimaryColor,
                      //   ),
                      // ),
                      Text("${trip.kcal?.toStringAsFixed(0)} Kcal"),
                    ],
                  ),
                ),
                // Row(children: <Widget>[
                //   // Text(
                //   //     "${DateFormat('dd/MM/yyyy').format(trip['eatDate'].toDate()).toString()}" ??
                //   //         null),
                // ]),
                Row(
                  children: <Widget>[
                    Text(
                      "${(trip.amount == null) ? "n/a" : trip.amount?.toStringAsFixed(0)} gram",
                      style: new TextStyle(fontSize: 15.0),
                    ),
                    Spacer(),
                    //Icon(Icons.emoji_nature),
                    Text("${trip.co2?.toStringAsFixed(1)} co2"),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CategoryTitle extends StatelessWidget {
  const CategoryTitle({
     Key? key,
    // @required this.cubit,
    required this.title,
    required this.kcalSum,
    required this.co2Sum,
  }) : super(key: key);

  // final DairyCubit cubit;
  final String title;
  final double kcalSum;
  final double co2Sum;

  @override
  Widget build(BuildContext context) {
    String energy = '${kcalSum.toStringAsFixed(0)} kCal';
    String climate = '${co2Sum.toStringAsFixed(1)} kg/Co²';
    return Container(
      height: 50,
      margin: EdgeInsets.all(5),
      child: Card(
        color: Colors.green,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              energy,
              style: TextStyle(color: Colors.white),
            ),
            Text(
              climate,
              style: TextStyle(color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}

// Expanded(
//   child: StreamBuilder(
//     stream: getUsersTripsStreamSnapshots(context ),
//     builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//       if (snapshot.hasData) {
//         foods = [];
//         foods = snapshot.data.docs;
//         print(foods);
//         DairyCubit.instance(context).sumAll();
//         final allData = snapshot.data.docs.map((doc) {
//           return doc.data();
//         }).toList();
//         print(allData);
//         //print('EatDate: ${foods[0].data()['eatDate'].toDate()}');
//
//         return ListView.builder(
//           itemCount: snapshot.data.docs.length,
//           itemBuilder: (BuildContext context, int index) =>
//               buildTripCard(context, snapshot.data.docs[index]),
//         );
//       }
//       return const Text("Loading...");
//     },
//   ),
// ),


// class Profiel extends StatelessWidget {
//   @override
// Widget build(BuildContext context) {
//   return Container(
//     color: Colors.green,
//   );
// }
// }