import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:food_app/Models/ingredients.dart';
import 'package:food_app/Views/constants.dart';
import 'package:food_app/Views/display_foodintake.dart';
import 'package:food_app/Views/nutrition_details_page.dart';
import 'package:food_app/Widgets/custom_dialog_impact.dart';
import 'package:food_app/shared/app_cubit.dart';
import 'package:food_app/shared/dairy_cubit.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    print('rebuild dashboard');
    final DairyCubit cubit = DairyCubit.instance(context);

    return Scaffold(
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: () {
      //     Navigator.push(
      //         context,
      //         MaterialPageRoute(
      //           builder: (context) => NewFoodIntake(
      //             trip: newTrip,
      //           ),
      //         ));
      //   },
      //   label: const Text('Food'),
      //   icon: const Icon(Icons.add),
      //   backgroundColor: Colors.orange,
      //   focusElevation: 2,
      //   foregroundColor: Colors.white,
      // ),
      appBar: AppBar(
        title: DateNavigatorRow(cubit: cubit),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            // snap: false,
            pinned: false,
            //floating: true,
            expandedHeight: 340,
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.transparent,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(''),
              background: BlocConsumer<AppCubit, AppStates>(
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
                        final String uid =
                            FirebaseAuth.instance.currentUser.uid;
                        final DairyCubit dairyCubit =
                            DairyCubit.instance(context);
                        final DateTime now = dairyCubit.currentDate;
                        try {
                          AppCubit.instance(context).insertIntoDB(uid, {
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
                      double calGoal = cubit.calGoal;
                      double saveGoal = cubit.saveco2Goal;
                      double kCalSum = cubit.kCalSum;
                      double carbGoal = cubit.carbGoal;
                      double proteinGoal = cubit.proteinGoal;
                      double fatsGoal = cubit.fatsGoal;

                      double circularPercent = diff / calGoal;
                      if (circularPercent > 1) {
                        circularPercent = 1;
                      }
                      double diff2 = cubit.co2Sum;
                      double benzine = diff2 * (1000 / 120);
                      double douchen = diff2 * 12;
                      double charging = diff2 * 127;
                      double barPercent = diff2 / saveGoal;
                      if (barPercent > 1) {
                        barPercent = 1;
                      }

                      double carbPercent = cubit.carbs / carbGoal;
                      if (carbPercent > 1) {
                        carbPercent = 1;
                      }

                      double proteinPercent = cubit.protein / proteinGoal;
                      if (proteinPercent > 1) {
                        proteinPercent = 1;
                      }

                      double fatPercent = cubit.fats / fatsGoal;
                      if (fatPercent > 1) {
                        fatPercent = 1;
                      }

                      return SingleChildScrollView(
                        child: Column(children: [
                          CaloriesIndecator(
                              // cubit: cubit,
                              kCalSum: kCalSum,
                              calGoal: calGoal,
                              circularPercent: circularPercent,
                              diff: diff),

                          CarbsProtienFatRow(
                            cubit: cubit,
                            carbPercent: carbPercent,
                            proteinPercent: proteinPercent,
                            fatPercent: fatPercent,
                          ),

                          SizedBox(height: 10),

                          LinearCo2Indecator(
                            barPercent: barPercent,
                            cubit: cubit,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ImpactButton(
                                cubit: cubit,
                                benzine: benzine,
                                douchen: douchen,
                                charging: charging,
                              ),
                              DetailsButton(),
                            ],
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
                        ]),
                      );
                    });
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
              //Textetwork
            ),
            //FlexibleSpaceBar
          ), //SliverAppBar

          BlocConsumer<DairyCubit, DairyStates>(
            listener: (context, states) {},
            builder: (context, states) {
              DairyCubit cubit = DairyCubit.instance(context);
              print(
                  'Cubit mystream is: ${cubit.myStream == null ? 'null' : 'no null'}');
              return StreamBuilder(
                stream: cubit.myStream,
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  // if (snapshot.hasData || snapshot.connectionState == ConnectionState.active) {
                  List<Widget> breakfastList = [
                    CategoryTitle(
                      title: AppLocalizations.of(context).breakfast,
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
                      title: AppLocalizations.of(context).otherstext,
                      kcalSum: cubit.othersKcalSum,
                      co2Sum: cubit.otherssumco2Sum,
                    ),
                  ];
                  othersList.addAll(DairyCubit.instance(context)
                      .otherList
                      .map((e) => buildTripCard(context, e)));

                  return SliverList(
                      delegate: SliverChildListDelegate.fixed([
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
                      height: 150,
                    ),
                  ]));
                  // return ListView.builder(
                  //   itemCount: snapshot.data.docs.length,
                  //   itemBuilder: (BuildContext context, int index) =>
                  //       buildTripCard(context, snapshot.data.docs[index]),
                  // );
                  // } else {
                  //   return const Text("No items entered...");
                  // }
                },
              );
            },
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    // getUsersTripsStreamSnapshots(context);
    DairyCubit.instance(context).getUsersTripsStreamSnapshots();
    super.initState();
  }

  Widget buildTripCard(BuildContext context,
      QueryDocumentSnapshot<Map<String, dynamic>> document) {
    final trip = Trip.fromSnapshot(document, document.data()['amountUnit']);
    final plantType = trip.planticon();
    return Container(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DetailFoodIntakeView(trip: trip)),
          );
        },
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Flexible(
                        child: AutoSizeText(
                          trip.name,
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ),
                      // Spacer(),
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
                      Text("${trip.kcal.toStringAsFixed(0)} Kcal",
                          style: TextStyle(fontSize: 14.0)),
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
                      "${(trip.amount == null) ? "n/a" : trip.amount.toStringAsFixed(0)} ${trip.amountUnit ?? 'gram'}",
                      style: TextStyle(fontSize: 13.0),
                    ),
                    Spacer(),
                    //Icon(Icons.emoji_nature),
                    Text("${trip.co2.toStringAsFixed(1)} CO₂",
                        style: TextStyle(fontSize: 13.0)),
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

class DateNavigatorRow extends StatelessWidget {
  const DateNavigatorRow({
    Key key,
    @required this.cubit,
  }) : super(key: key);

  final DairyCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.red,
      // width: 500,
      margin: const EdgeInsets.only(top: 8.0),
      child: FittedBox(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
                onPressed: () {
                  cubit.updateCurrentDate(
                      cubit.currentDate.subtract(Duration(days: 1)));
                },
                icon: Icon(Icons.arrow_back_ios_sharp),
                splashRadius: 28,
                iconSize: 20,
                color: Theme.of(context).primaryColor
                //      color: Theme.of(context).accentColor,
                //  color: Colors.black,
                ),
            TextButton.icon(
                icon: Icon(
                  Icons.calendar_today,
                  color: Theme.of(context).primaryColor,
                  //  color: Colors.black,
                ),
                onPressed: () {
                  DatePicker.showDatePicker(
                    context,
                    showTitleActions: true,
                    theme: DatePickerTheme(),
                    currentTime: cubit.currentDate ?? DateTime.now(),
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
                label: BlocConsumer<AppCubit, AppStates>(
                  listener: (BuildContext context, state) {},
                  builder: (BuildContext context, state) {
                    return Text(
                      '${DateFormat.yMMMMd().format(cubit.currentDate)}',
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          //    color: Colors.black,
                          fontWeight: FontWeight.normal,
                          fontSize: 20),
                    );
                  },
                )),
            IconButton(
                onPressed: () {
                  cubit.updateCurrentDate(
                      cubit.currentDate.add(Duration(days: 1)));
                },
                icon: Icon(Icons.arrow_forward_ios_sharp),
                splashRadius: 28,
                iconSize: 20,
                color: Theme.of(context).primaryColor
                // color: Colors.black,
                ),
          ],
        ),
      ),
    );
  }
}

class CaloriesIndecator extends StatelessWidget {
  const CaloriesIndecator({
    Key key,
    // @required this.cubit,
    @required this.circularPercent,
    @required this.diff,
    @required this.kCalSum,
    @required this.calGoal,
  }) : super(key: key);

  // final DairyCubit cubit;
  final double circularPercent;
  final double diff;
  final double kCalSum;
  final double calGoal;

  @override
  Widget build(BuildContext context) {
    return Container(
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
              padding: const EdgeInsets.only(
                left: 10.0,
              ),
              child: Text.rich(TextSpan(
                  style: GoogleFonts.roboto(
                    fontSize: 20,
                  ),
                  children: <TextSpan>[
                    TextSpan(text: AppLocalizations.of(context).eatentext),
                    TextSpan(
                      text: '${kCalSum.toStringAsFixed(0)}',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: kPrimaryColor),
                    ),
                    TextSpan(text: ' kcal', style: TextStyle(fontSize: 12)),
                  ])),
            ),
          ),
          Expanded(
            flex: 2,
            child: CircularPercentIndicator(
              radius: 145.0,
              lineWidth: 6.5,
              animation: true,
              backgroundColor: Colors.grey[350],
              percent: circularPercent,
              center: Text(
                "${diff.toStringAsFixed(0)} Kcal",
                style: TextStyle(fontSize: 20),
              ),
              progressColor: calculateBackgroundColorCircularindicator(
                  circularPercent: circularPercent),
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
              padding: const EdgeInsets.only(right: 5.0),
              child: Text.rich(
                TextSpan(style: TextStyle(fontSize: 20), children: <TextSpan>[
                  TextSpan(text: 'Over     '),
                  TextSpan(
                    text: '${((calGoal - kCalSum).toStringAsFixed(0))}',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: kPrimaryColor),
                  ),
                  TextSpan(
                    text: ' kcal',
                    style: TextStyle(fontSize: 12),
                  ),
                ]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Color calculateBackgroundColorCircularindicator({double circularPercent}) {
  if (circularPercent < 1) {
    return kPrimaryColor;
  } else {
    return Colors.red;
  }
}

class LinearCo2Indecator extends StatelessWidget {
  const LinearCo2Indecator({
    Key key,
    @required this.barPercent,
    @required this.cubit,
  }) : super(key: key);

  final double barPercent;
  final DairyCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 14.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              new LinearPercentIndicator(
                animation: true,
                backgroundColor: Colors.grey[350],
                // backgroundColor: calculateBackgroundColor(barPercent: barPercent),
                width: 300.0,
                lineHeight: 25.0,
                percent: barPercent,
                progressColor: calculateBackgroundColor(barPercent: barPercent),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 7.0, bottom: 7.0),
          child: Padding(
            padding: const EdgeInsets.only(right: 8.0, left: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Text('Co2 ${cubit.co2Sum.toStringAsFixed(1)} kg ',
                //     style: TextStyle(fontSize: 20)),
                Text.rich(TextSpan(
                    style: TextStyle(
                      fontSize: 20,
                    ),
                    children: <TextSpan>[
                      TextSpan(text: 'CO₂ '),
                      TextSpan(
                        text: '${cubit.co2Sum.toStringAsFixed(1)}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: kPrimaryColor),
                      ),
                      TextSpan(text: ' kg/CO₂', style: TextStyle(fontSize: 12)),
                    ])),
                Text.rich(TextSpan(
                    style: TextStyle(
                      fontSize: 20,
                    ),
                    children: <TextSpan>[
                      TextSpan(text: 'Max. '),
                      TextSpan(
                        text: '${cubit.saveco2Goal.toStringAsFixed(1)}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: kPrimaryColor),
                      ),
                      TextSpan(text: ' kg/CO₂', style: TextStyle(fontSize: 12)),
                    ])),

                // Text('max 5.0 kg/Co²')
              ],
            ),
          ),
        ),
      ],
    );
  }
}

Color calculateBackgroundColor({double barPercent}) {
  if (barPercent > 0.999) {
    return Colors.redAccent;
    // } else if (barPercent > 0.516) {
    //   return Colors.orangeAccent;
  } else {
    return kPrimaryColor;
  }
}

class CarbsProtienFatRow extends StatelessWidget {
  const CarbsProtienFatRow(
      {Key key,
      @required this.cubit,
      @required this.carbPercent,
      @required this.proteinPercent,
      @required this.fatPercent})
      : super(key: key);

  final DairyCubit cubit;
  final double carbPercent;
  final double proteinPercent;
  final double fatPercent;

  @override
  Widget build(BuildContext context) {
    return Padding(
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

              Row(
                children: [
                  // Icon(
                  //   Icons.circle,
                  //   color: kPrimaryColor,
                  //   size: 12,
                  // ),
                  Text.rich(TextSpan(
                      style: TextStyle(fontSize: 16),
                      children: <TextSpan>[
                        TextSpan(
                            text: AppLocalizations.of(context).carbstext,
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        // TextSpan(
                        //   text: '${cubit.carbs.toStringAsFixed(0)}',
                        //   // style: TextStyle(
                        //   //     fontWeight: FontWeight.bold, color: kPrimaryColor),
                        // ),
                        // TextSpan(text: 'g', style: TextStyle(fontSize: 14)),
                      ])),
                  // Text(
                  //   ' Carbs ${cubit.carbs.toStringAsFixed(0)}g',
                  // ),
                ],
              ),
              Row(
                children: [
                  new LinearPercentIndicator(
                    width: 100.0,
                    lineHeight: 8.0,
                    percent: carbPercent,
                    progressColor: Colors.red,
                  ),
                ],
              ),
              Row(
                children: [
                  //    Text('${cubit.carbs.toStringAsFixed(0)}g over'),
                  Text(
                      '${(cubit.carbGoal - cubit.carbs).toStringAsFixed(0)}g over'),
                ],
              ),
            ],
          ),
          Column(
            children: [
              // new LinearPercentIndicator(
              //   width: 100.0,
              //   lineHeight: 8.0,
              //   percent: 0.2,
              //   progressColor: Colors.red,
              // ),

              Row(
                children: [
                  // Icon(
                  //   Icons.circle,
                  //   color: kPrimaryColor,
                  //   size: 12,
                  // ),
                  Text.rich(TextSpan(
                      style: TextStyle(fontSize: 16),
                      children: <TextSpan>[
                        TextSpan(
                            text: AppLocalizations.of(context).proteintext,
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        // TextSpan(
                        //   text: '${cubit.carbs.toStringAsFixed(0)}',
                        //   // style: TextStyle(
                        //   //     fontWeight: FontWeight.bold, color: kPrimaryColor),
                        // ),
                        // TextSpan(text: 'g', style: TextStyle(fontSize: 14)),
                      ])),
                  // Text(
                  //   ' Carbs ${cubit.carbs.toStringAsFixed(0)}g',
                  // ),
                ],
              ),
              Row(
                children: [
                  new LinearPercentIndicator(
                    width: 100.0,
                    lineHeight: 8.0,
                    percent: proteinPercent,
                    progressColor: Colors.yellow,
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                      '${(cubit.proteinGoal - cubit.protein).toStringAsFixed(0)}g over'),
                ],
              ),
            ],
          ),
          Column(
            children: [
              // new LinearPercentIndicator(
              //   width: 100.0,
              //   lineHeight: 8.0,
              //   percent: 0.2,
              //   progressColor: Colors.red,
              // ),

              Row(
                children: [
                  // Icon(
                  //   Icons.circle,
                  //   color: kPrimaryColor,
                  //   size: 12,
                  // ),
                  Text.rich(TextSpan(
                      style: TextStyle(fontSize: 16),
                      children: <TextSpan>[
                        TextSpan(
                            text: AppLocalizations.of(context).fatstext,
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        // TextSpan(
                        //   text: '${cubit.carbs.toStringAsFixed(0)}',
                        //   // style: TextStyle(
                        //   //     fontWeight: FontWeight.bold, color: kPrimaryColor),
                        // ),
                        // TextSpan(text: 'g', style: TextStyle(fontSize: 14)),
                      ])),
                  // Text(
                  //   ' Carbs ${cubit.carbs.toStringAsFixed(0)}g',
                  // ),
                ],
              ),
              Row(
                children: [
                  new LinearPercentIndicator(
                    width: 100.0,
                    lineHeight: 8.0,
                    percent: fatPercent,
                    progressColor: Colors.blue,
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                      '${(cubit.fatsGoal - cubit.fats).toStringAsFixed(0)}g over'),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DetailsButton extends StatelessWidget {
  const DetailsButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        DairyCubit.instance(context).calcPercents();
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => NutritionalDetailsPage()));
      },
      child: Text(
        "Details",
        style: TextStyle(fontSize: 20, color: kPrimaryColor),
      ),
    );
  }
}

class ImpactButton extends StatelessWidget {
  const ImpactButton({
    Key key,
    @required this.cubit,
    @required this.benzine,
    @required this.douchen,
    @required this.charging,
  }) : super(key: key);

  final DairyCubit cubit;
  final double benzine;
  final double douchen;
  final double charging;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return CustomDialogBox(
                title: "Jouw klimaat impact",
                descriptions:
                    "Jouw klimaat impact is ${cubit.co2Sum.toStringAsFixed(1)} kg/CO₂. Dat staat gelijk aan ${benzine.toStringAsFixed(1)} km autorijden, ${douchen.toStringAsFixed(0)} minuten douchen of ${charging.toStringAsFixed(0)} keer je mobiel opladen",
                text: "Sluit",
              );
            });
      },
      child: Text(
        "Impact",
        style: TextStyle(fontSize: 20, color: kPrimaryColor),
      ),
    );
  }
}

class CategoryTitle extends StatelessWidget {
  const CategoryTitle({
    Key key,
    // @required this.cubit,
    @required this.title,
    @required this.kcalSum,
    @required this.co2Sum,
  }) : super(key: key);

  // final DairyCubit cubit;
  final String title;
  final double kcalSum;
  final double co2Sum;

  @override
  Widget build(BuildContext context) {
    String energy = '${kcalSum.toStringAsFixed(0)} kCal';
    String climate = '${co2Sum.toStringAsFixed(1)} kg/CO₂';
    return Container(
      height: 50,
      margin: EdgeInsets.all(5),
      child: Card(
        color: kPrimaryColor,
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
