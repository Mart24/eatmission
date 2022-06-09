import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_app/Models/fooddata_json.dart';
import 'package:food_app/Models/ingredients.dart';
import 'package:food_app/Views/constants.dart';
import 'package:food_app/Views/new_food_registration.dart/summary.dart';
import 'package:food_app/Views/profile/utils.dart';
import 'package:food_app/Widgets/Provider_Auth.dart';
import 'package:food_app/shared/amount_cubit.dart';
import 'package:food_app/shared/fav_cubit.dart';
import 'package:food_app/shared/recent_cubit.dart';
import 'package:food_app/views/goals/log_cubit.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pie_chart/pie_chart.dart';

// Step 2: The user chooses the amount he or she have eaten
// The fooddata changes due to the budgetcontroller
// When the users clicks on save, the data goes to the summary view.

class FoodDate extends StatefulWidget {
  final Trip trip;

  FoodDate({Key key, @required this.trip}) : super(key: key);

  @override
  _FoodDateState createState() => _FoodDateState();
}

class _FoodDateState extends State<FoodDate> {
  DateTime _startDate = DateTime.now();
  DateTime _eattime = DateTime.now();
  DateTime _endDate = DateTime.now().add(Duration(days: 7));
  int _budgetTotal = 100;
  final db = FirebaseFirestore.instance;
  String categoryChoice = "Breakfast";
  List categoryItem = ["Breakfast", "Lunch", "Diner", "Snacks", "Other"];
  String _portion = 'gram';
  String _portionUnit = 'gram';

  Future<void> _selectDate(BuildContext context) async {
    final DateTime pickedDate = await showDatePicker(
        context: context,
        initialDate: _eattime,
        firstDate: DateTime(2015),
        lastDate: DateTime(2050));
    if (pickedDate != null && pickedDate != _eattime)
      setState(() {
        _eattime = pickedDate;
      });
  }

  Stream<QuerySnapshot> getUsersTripsStreamSnapshots(
      BuildContext context) async* {
    DocumentSnapshot fooddata = await FirebaseFirestore.instance
        .collection('fdd')
        .doc(widget.trip.id.toString())
        .get();
  }

  TextEditingController _sizeController = TextEditingController()..text = '100';
  TextEditingController _portionController = TextEditingController()
    ..text = '1';
  TextEditingController _portionUnitController = TextEditingController()
    ..text = 'gram';

  @override
  void initState() {
    super.initState();
    _sizeController.addListener(_setBudgetTotal);
    _portionController.addListener(_setPortionTotal);
    _portionUnitController.addListener(_setPortionUnit);
  }

  _setBudgetTotal() {
    print('set budget total');
    setState(() {
      _budgetTotal = int.tryParse(_sizeController.text);
    });
  }

  _setPortionTotal() {
    print('set portion total:  ${_portionController.text}g');
    if (_portionController.text == '1') {
      // selected gram unit
      _sizeController.value = TextEditingValue(text: '100');
      setState(() {
        _budgetTotal = 100;
      });
    } else {
      // selected anything except the gram
      _sizeController.value = TextEditingValue(text: '1');
      setState(() {
        _budgetTotal = 1;
      });
    }
    setState(() {
      _portion = (_portionController.text);
    });
  }

  _setPortionUnit() {
    print('set portion unit ');
    setState(() {
      _portionUnit = (_portionUnitController.text);
    });
  }

  @override
  void dispose() {
    _portionUnitController.dispose();
    _portionController.dispose();
    _sizeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String Koolhydratentotaal = AppLocalizations.of(context).carbsfulltext;
    String Vettentotaal = AppLocalizations.of(context).fatsfulltext;
    String Eiwittentotaal = AppLocalizations.of(context).proteinfulltext;
    String Calories = AppLocalizations.of(context).calories;
    String Ontbijt = AppLocalizations.of(context).breakfast;
    FavCubit favCubit = FavCubit.instance(context);

    RecentCubit recentCubit = RecentCubit.instance(context);
    recentCubit.addRecentTrip(widget.trip);

    double size = ((double.tryParse(_sizeController.text) ?? 100));
    double portion = ((double.tryParse(_portionController.text) ?? 1));
    // String unit = _portionUnitController.value.text;

    return GestureDetector(
      onTap: () {
        // call this method here to hide soft keyboard
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          // title: Text(AppLocalizations.of(context).chooseamountstext),
          title: Text(
            widget.trip.name,
            style: TextStyle(
              // color: kPrimaryColor,
              fontSize: 14,
              // fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            // GestureDetector(
            //   child: FooddataSQLJSON.isFavorite
            //       ? Icon(Icons.favorite, color: Colors.red)
            //       : Icon(Icons.favorite, color: Colors.grey),
            //   onTap: () {
            //     if (FooddataSQLJSON.isFavorite) {
            //       databaseController.deleteMovie(FooddataSQLJSON.productid);
            //       _movie.favorite = false;
            //       if (mounted) {
            //         setState(() {});
            //       }
            //     } else {
            //       databaseController.insertMovie(_movie);
            //       _movie.favorite = true;
            //       if (mounted) {
            //         setState(() {});
            //       }
            //     }
            //   },
            // ),
            IconButton(
                onPressed: () => Utils.openEmail(
                      toEmail: 'martijnformer24@gmail.com',
                      subject:
                          'Melding van product: ${widget.trip.name}: ${widget.trip.id}',
                      body: 'I have a question or suggestion for this product',
                    ),
                icon: Icon(Icons.message)),
            BlocConsumer<FavCubit, FavState>(
              listener: (BuildContext context, state) {},
              builder: (BuildContext context, state) {
                return IconButton(
                    onPressed: () {
                      favCubit.contains(widget.trip)
                          ? favCubit.deleteFavTrip(widget.trip)
                          : favCubit.addFavTrip(widget.trip);
                    },
                    icon: favCubit.contains(widget.trip)
                        ? Icon(Icons.favorite)
                        : Icon(Icons.favorite_outline));
              },
            ),
            IconButton(
              onPressed: () async {
                final uid = await Provider.of(context).auth.getCurrentUID();
                await db
                    .collection("userData")
                    .doc(uid)
                    .collection("food_intake")
                    .add(widget.trip.toJson());
                //sends user back to the dashboard page
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              icon: Icon(Icons.save),
            ),
          ],
        ),
        body: FutureBuilder<Map<String, dynamic>>(
            future: AmountCubit.instance(context).getFood(
                widget.trip,
                size,
                portion,
                _eattime,
                categoryChoice,
                _portionUnitController.value.text),
            builder: (BuildContext context,
                AsyncSnapshot<Map<String, dynamic>> futureSnapshot) {
              if (futureSnapshot.hasData) {
                var foodDocument = futureSnapshot.data["foodDocument"];
                Trip trip = futureSnapshot.data["trip"];
                double co2RecommendationPercentage = 0;
                if (trip.recomco2 != null) {
                  co2RecommendationPercentage =
                      ((trip.recomco2 - trip.co2) / trip.recomco2) * 100;
                }
                Map<String, double> dataMap = {
                  "Carbs": trip.kcal,
                  "Protein": 2,
                  "Fats": 2,
                };

                return CustomScrollView(
                  slivers: <Widget>[
                    // Text(
                    //   "${foodDocument['name']}",
                    //   style: new TextStyle(fontSize: 24.0),
                    // ),

                    SliverAppBar(
                      automaticallyImplyLeading: false,
                      expandedHeight: 350,
                      floating: false,
                      elevation: 0,
                      backgroundColor: Colors.transparent,

                      //   backgroundColor: Colors.white,
                      flexibleSpace: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.all(15),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              PieChart(
                                chartRadius: 125.0,
                                ringStrokeWidth: 10,
                                chartLegendSpacing: 25,
                                initialAngleInDegree: 270,
                                // legendOptions: LegendOptions(),
                                chartValuesOptions: ChartValuesOptions(
                                  decimalPlaces: 0,
                                  showChartValues: false,
                                  showChartValuesInPercentage: false,
                                  showChartValuesOutside: false,
                                  chartValueBackgroundColor: Colors.white,
                                ),
                                colorList: [
                                  Colors.green[200],
                                  Colors.teal[200],
                                  Colors.red[200]
                                ],
                                animationDuration: Duration(seconds: 1),
                                dataMap: {
                                  "${trip.carbs.toStringAsFixed(0)}g ${Koolhydratentotaal}":
                                      trip.carbs,
                                  "${trip.protein.toStringAsFixed(0)}g ${Eiwittentotaal}":
                                      trip.protein,
                                  "${trip.fat.toStringAsFixed(0)}g ${Vettentotaal}":
                                      trip.fat,
                                },
                                centerText:
                                    "${trip.kcal.toStringAsFixed(0)} ${Calories}",
                                chartType: ChartType.ring,
                              ),

                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 16.0, right: 16.0),
                                child: InputBar(
                                  sizeController: _sizeController,
                                  portionController: _portionController,
                                  portionUnitController: _portionUnitController,
                                  id: widget.trip.id.toString(),
                                ),
                              ),
                              // Spacer(),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton(
                                      child: Text(
                                          "${DateFormat('dd/MM/yyyy').format(_eattime).toString()}"),
                                      onPressed: () => _selectDate(context),
                                    ),
                                    DropdownButton(
                                      hint: Text(Ontbijt),
                                      value: categoryChoice,
                                      onChanged: (newValue) {
                                        setState(() {
                                          categoryChoice = newValue;
                                        });
                                        print(categoryChoice);
                                      },
                                      items: categoryItem.map((valueItem) {
                                        return DropdownMenuItem(
                                          value: valueItem,
                                          child: Text(valueItem),
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text.rich(TextSpan(
                                        style: TextStyle(
                                          fontSize: 20,
                                        ),
                                        children: <TextSpan>[
                                          TextSpan(text: 'CO₂ '),
                                          TextSpan(
                                            text:
                                                '${trip.co2.toStringAsFixed(1)}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: kPrimaryColor),
                                          ),
                                          TextSpan(
                                              text: ' kg/CO₂-eq',
                                              style: TextStyle(fontSize: 12)),
                                        ])),
                                    ElevatedButton(
                                      child: Text("Recommendation"),
                                      onPressed: () {
                                        _showToast(context);
                                        LogCubit logCubit =
                                            LogCubit.instance(context);
                                        logCubit
                                            .addLog("button recommendation");

                                        showDialog<String>(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text(trip.name +
                                                    ' recommendation'),
                                                content: co2RecommendationPercentage ==
                                                        0
                                                    ? Text(
                                                        "No recommendation Found.")
                                                    : Text("Recommendation: " +
                                                        trip.recommendation +
                                                        " ,You 'll save: " +
                                                        co2RecommendationPercentage
                                                            .toString() +
                                                        " % kg-Co2-eq"),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                            context, 'OK'),
                                                    child: const Text('OK'),
                                                  ),
                                                ],
                                              );
                                            });
                                        print("log recommendation");
                                      },
                                      style: ElevatedButton.styleFrom(
                                          primary: Colors.purple,
                                          textStyle: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SliverAppBar(
                      automaticallyImplyLeading: false,
                      pinned: true,
                      elevation: 0,
                      flexibleSpace: Container(
                        alignment: Alignment.center,
                        height: kToolbarHeight,
                        color: kPrimaryColor,
                        child: Text(
                          'Macronutriënten',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          Container(
                            child: Column(
                              children: [
                                Container(
                                  child: Table(
                                    columnWidths: {
                                      0: FractionColumnWidth(0.50),
                                      1: FractionColumnWidth(0.30),
                                    },
                                    textBaseline: TextBaseline.alphabetic,
                                    defaultVerticalAlignment:
                                        TableCellVerticalAlignment.middle,
                                    children: [
                                      TableRow(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 1.0),
                                            child: Text(
                                              AppLocalizations.of(context)
                                                  .howmuchtext,
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Text(
                                            '${(trip.amount == null) ? "n/a" : widget.trip.amount.toStringAsFixed(0)} ${widget.trip.amountUnit ?? 'g'}',
                                            style: TextStyle(fontSize: 18),
                                          ),
                                        ],
                                      ),
                                      TableRow(children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5.0),
                                          child: Text(
                                            AppLocalizations.of(context).energy,
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Text(
                                          '${trip.kcal.toStringAsFixed(0)} kcal',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ]),
                                      // TableRow(children: [
                                      //   Padding(
                                      //     padding:
                                      //         const EdgeInsets.symmetric(vertical: 5.0),
                                      //     child: Text(
                                      //       'CO₂',
                                      //       style: TextStyle(
                                      //           fontSize: 18,
                                      //           fontWeight: FontWeight.bold),
                                      //     ),
                                      //   ),
                                      //   Text(
                                      //     '${widget.trip.co2.toStringAsFixed(2)} kg/CO₂',
                                      //     style: TextStyle(fontSize: 18),
                                      //   ),
                                      // ]),
                                      TableRow(children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5.0),
                                          child: Text(
                                            AppLocalizations.of(context)
                                                .proteinfulltext,
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Text(
                                          '${trip.protein.toStringAsFixed(0)} g',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ]),
                                      TableRow(children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5.0),
                                          child: Text(
                                            AppLocalizations.of(context)
                                                .proteinplanttext,
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Text(
                                          '${trip.proteinplant.toStringAsFixed(0)} g',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ]),
                                      TableRow(children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5.0),
                                          child: Text(
                                            AppLocalizations.of(context)
                                                .proteinanimaltext,
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Text(
                                          '${trip.proteinanimal.toStringAsFixed(0)} g',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ]),
                                      TableRow(children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5.0),
                                          child: Text(
                                            AppLocalizations.of(context)
                                                .fatsfulltext,
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Text(
                                          '${trip.fat.toStringAsFixed(0)} g',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ]),
                                      TableRow(children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5.0),
                                          child: Text(
                                            AppLocalizations.of(context)
                                                .dotssaturatedstext,
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Text(
                                          '${trip.saturatedfat.toStringAsFixed(0)} g',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ]),
                                      TableRow(children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5.0),
                                          child: Text(
                                            AppLocalizations.of(context)
                                                .carbsfulltext,
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Text(
                                          '${trip.carbs.toStringAsFixed(0)} g',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ]),
                                      TableRow(children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5.0),
                                          child: Text(
                                            AppLocalizations.of(context)
                                                .dotsfiberstext,
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Text(
                                          '${trip.dietaryfiber.toStringAsFixed(0)} g',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ]),
                                      TableRow(children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5.0),
                                          child: Text(
                                            AppLocalizations.of(context)
                                                .dotssugarsstext,
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Text(
                                          '${widget.trip.sugars.toStringAsFixed(0)} g',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ]),
                                      TableRow(children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5.0),
                                          child: Text(
                                            AppLocalizations.of(context)
                                                .starttext,
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Text(
                                          '${widget.trip.salt.toStringAsFixed(1)} g',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ]),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SliverAppBar(
                      automaticallyImplyLeading: false,
                      pinned: true,
                      elevation: 0,
                      flexibleSpace: Container(
                        alignment: Alignment.center,
                        height: kToolbarHeight,
                        color: kPrimaryColor,
                        child: Text(
                          'Micronutriënten',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          Container(
                            child: Column(
                              children: [
                                Container(
                                  child: Table(
                                    columnWidths: {
                                      0: FractionColumnWidth(0.50),
                                      1: FractionColumnWidth(0.30),
                                    },
                                    textBaseline: TextBaseline.alphabetic,
                                    defaultVerticalAlignment:
                                        TableCellVerticalAlignment.middle,
                                    children: [
                                      TableRow(children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5.0),
                                          child: Text(
                                            'Vitamine A',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Text(
                                          '${trip.vitA.toStringAsFixed(0)} µg',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ]),
                                      TableRow(children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5.0),
                                          child: Text(
                                            'Vitamine B1',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Text(
                                          '${trip.vitB1.toStringAsFixed(0)} mg',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ]),
                                      TableRow(children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5.0),
                                          child: Text(
                                            'Vitamine B2',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Text(
                                          '${trip.vitB2.toStringAsFixed(0)} mg',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ]),
                                      TableRow(children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5.0),
                                          child: Text(
                                            'Vitamine B6',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Text(
                                          '${trip.vitB6.toStringAsFixed(0)} mg',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ]),
                                      TableRow(children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5.0),
                                          child: Text(
                                            'Vitamine B12',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Text(
                                          '${trip.vitB12.toStringAsFixed(0)} µg',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ]),
                                      TableRow(children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5.0),
                                          child: Text(
                                            'Vitamine C',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Text(
                                          '${trip.vitC.toStringAsFixed(0)} mg',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ]),
                                      TableRow(children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5.0),
                                          child: Text(
                                            'Vitamine D',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Text(
                                          '${trip.vitD.toStringAsFixed(0)} µg',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ]),
                                      TableRow(children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5.0),
                                          child: Text(
                                            'Vitamine E',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Text(
                                          '${trip.vitE.toStringAsFixed(0)} mg',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ]),
                                      TableRow(children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5.0),
                                          child: Text(
                                            'Zink',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Text(
                                          '${trip.zink.toStringAsFixed(0)} mg',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ]),
                                      TableRow(children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5.0),
                                          child: Text(
                                            'Calcium',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Text(
                                          '${trip.calcium.toStringAsFixed(0)} mg',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ]),
                                      TableRow(children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5.0),
                                          child: Text(
                                            AppLocalizations.of(context)
                                                .intaketext,
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Text(
                                          '${trip.iron.toStringAsFixed(0)} mg',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ]),
                                      TableRow(children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5.0),
                                          child: Text(
                                            'Kalium',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Text(
                                          '${trip.kalium.toStringAsFixed(0)} mg',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ]),
                                      TableRow(children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5.0),
                                          child: Text(
                                            'Magnesium',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Text(
                                          '${trip.magnesium.toStringAsFixed(0)} mg',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ]),
                                      TableRow(children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5.0),
                                          child: Text(
                                            'Niacine',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Text(
                                          '${trip.niacine.toStringAsFixed(0)} mg',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ]),
                                      TableRow(children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5.0),
                                          child: Text(
                                            'Natrium',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Text(
                                          '${trip.natrium.toStringAsFixed(0)} mg',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ]),
                                      TableRow(children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5.0),
                                          child: Text(
                                            'Jodium',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        //'${(trip.amount == null) ? "n/a" : widget.trip.amount.toStringAsFixed(0)} ${widget.trip.amountUnit ?? 'g'}'
                                        Text(
                                          '${trip.jodium.toStringAsFixed(0)} µg',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ]),
                                      TableRow(children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5.0),
                                          child: Text(
                                            'Alcohol',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Text(
                                          '${trip.alcohol.toStringAsFixed(0)} g',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ]),
                                      TableRow(children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5.0),
                                          child: Text(
                                            'Water',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Text(
                                          '${trip.water.toStringAsFixed(0)} g',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ]),
                                      TableRow(children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5.0),
                                          child: Text(
                                            'Fosfor',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Text(
                                          '${trip.fosfor.toStringAsFixed(0)} mg',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ]),
                                      TableRow(children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5.0),
                                          child: Text(
                                            'Foliumzuur',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Text(
                                          '${trip.foliumzuur.toStringAsFixed(0)} µg',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ]),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // SliverGrid.count(
                    //   crossAxisCount: 2,
                    //   children: List.generate(5, (index) {
                    //     return Card(
                    //       color: Colors.white,
                    //     );
                    //   }),
                    // ), // SliverGrid.count(
                  ],
                );
              } else if (futureSnapshot.hasError) {
                return Icon(Icons.error_outline);
              } else {
                return CircularProgressIndicator();
              }
            }),
      ),
    );
  }

  void _showToast(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: const Text('Show recommendation'),
        action: SnackBarAction(
            label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }
}

class InputBar extends StatelessWidget {
  InputBar({
    Key key,
    @required TextEditingController sizeController,
    @required TextEditingController portionController,
    @required TextEditingController portionUnitController,
    @required this.id,
  })  : _sizeController = sizeController,
        _portionController = portionController,
        _portionUnitController = portionUnitController,
        super(key: key);

  final TextEditingController _sizeController;
  final TextEditingController _portionController;

  final TextEditingController _portionUnitController;
  final String id;

  final ValueNotifier<String> currentValue = ValueNotifier<String>('gram');

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
        flex: 3,
        child: TextFormField(
          controller: _sizeController,
          // maxLines: 1,
          // maxLength: 4,
          decoration: InputDecoration(
            // prefixIcon: Icon(Icons.linear_scale),
            prefixIcon: Container(
              width: 30,
              // height: 30,
              // color: Colors.red,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'size',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                  // textAlign: TextAlign.center,
                ),
              ),
            ),
            // helperText: AppLocalizations.of(context).howmanygramstext,
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          autofocus: true,
        ),
      ),
      Spacer(
        flex: 1,
      ),
      Expanded(
        flex: 3,
        child: FutureBuilder(
          future: FirebaseFirestore.instance.collection('fdd').doc(id).get(),
          builder: (context, AsyncSnapshot<DocumentSnapshot> snap) {
            if (snap.hasData) {
              Map<String, num> itemsData = {
                "gram": 1,
              };
              for (int i = 1; i <= 4; i++) {
                if (snap.data["portionsize$i"] != null &&
                    snap.data["portionsize$i"] != '') {
                  itemsData.putIfAbsent(
                      snap.data["portionsize$i"], () => snap.data["sizep$i"]);
                }
              }

              print(itemsData.keys);
              print(itemsData.values);
              List<DropdownMenuItem<String>> itemsWidgets =
                  itemsData.keys.map((e) {
                return DropdownMenuItem<String>(
                  child: Container(
                      // width: 80,
                      child: Text(
                    e + ' (' + itemsData[e].toString() + 'g)',
                    maxLines: 2,
                    softWrap: true,
                    overflow: TextOverflow.fade,
                  )),
                  value: e,
                );
              }).toList();
              return DropdownButtonFormField(
                  // value: _portionController.value.text,
                  value: currentValue.value,
                  isExpanded: true,
                  items: itemsWidgets,
                  onChanged: (s) {
                    print(s);
                    _portionController.value =
                        TextEditingValue(text: itemsData[s].toString());
                    _portionUnitController.value = TextEditingValue(text: s);
                    currentValue.value = s;
                  });
            } else {
              return DropdownButtonFormField(
                // value: 'gram',
                items: [
                  DropdownMenuItem(
                    child: Text('Gram'),
                    value: 'gram',
                  )
                ],
              );
            }
          },
        ),
      ),
    ]);
  }
}
