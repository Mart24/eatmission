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
import 'package:food_app/shared/fav_cubit.dart';
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
    // _portionUnitController.addListener(_setPortionUnit);
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
          title: Text(widget.trip.name),
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
            IconButton(onPressed: () {}, icon: Icon(Icons.save)),

            //   onPressed: () => Utils.openEmail(
            //     toEmail: 'martijnformer24@gmail.com',
            //     subject:
            //         'Melding van product: ${widget.trip.name}: ${widget.trip.id}',
            //     body: 'I have a question or suggestion for this product',
            //   ),
            //   child: Text(AppLocalizations.of(context).reporttext),
            // ),
          ],
        ),
        body: Center(
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('fdd')
                  .doc(widget.trip.id.toString())
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Text("Loading...");
                var foodDocument = snapshot.data;

                final nutriscoreType = widget.trip.nutriscoreimage();
                final ecoscoreType = widget.trip.ecoscoreimage();
                //nutriscore
                String nutriscore = foodDocument['nutriscore'];
                //ecoscore
                String ecoscore = foodDocument['ecoscore'];
                // Plantbase string
                String plantbased = foodDocument['plantbased'];
                // Calorieën double
                double kcal = ((foodDocument['kcal'].toDouble()) *
                    ((double.tryParse(_sizeController.text) ?? 100)) *
                    ((double.tryParse(_portionController.text) ?? 1)) *
                    0.01.toDouble());
                // Calorieën CO2
                double co2 = ((foodDocument['co2'].toDouble()) *
                    ((double.tryParse(_sizeController.text) ?? 100)) *
                    ((double.tryParse(_portionController.text) ?? 1)) *
                    0.01.toDouble());
                // Calorieën Koolhydraten
                double koolhy = ((foodDocument['carbs'].toDouble()) *
                    ((double.tryParse(_sizeController.text) ?? 100)) *
                    ((double.tryParse(_portionController.text) ?? 1)) *
                    0.01.toDouble());
                // Calorieën Eiwitten
                double protein = ((foodDocument['proteins'].toDouble()) *
                    ((double.tryParse(_sizeController.text) ?? 100)) *
                    ((double.tryParse(_portionController.text) ?? 1)) *
                    0.01.toDouble());
                double proteinplant =
                    ((foodDocument['proteinsplant'].toDouble()) *
                        ((double.tryParse(_sizeController.text) ?? 100)) *
                        ((double.tryParse(_portionController.text) ?? 1)) *
                        0.01.toDouble());
                double proteinanimal =
                    ((foodDocument['proteinsanimal'].toDouble()) *
                        ((double.tryParse(_sizeController.text) ?? 100)) *
                        ((double.tryParse(_portionController.text) ?? 1)) *
                        0.01.toDouble());
                // Calorieën Vetten
                double fat = ((foodDocument['fat'].toDouble()) *
                    ((double.tryParse(_sizeController.text) ?? 100)) *
                    ((double.tryParse(_portionController.text) ?? 1)) *
                    0.01.toDouble());
                double saturatedfat =
                    ((foodDocument['saturatedfat'].toDouble()) *
                        ((double.tryParse(_sizeController.text) ?? 100)) *
                        ((double.tryParse(_portionController.text) ?? 1)) *
                        0.01.toDouble());
                double sugars = ((foodDocument['sugars'].toDouble()) *
                    ((double.tryParse(_sizeController.text) ?? 100)) *
                    ((double.tryParse(_portionController.text) ?? 1)) *
                    0.01.toDouble());
                double dietaryfiber =
                    ((foodDocument['dietaryfiber'].toDouble()) *
                        ((double.tryParse(_sizeController.text) ?? 100)) *
                        ((double.tryParse(_portionController.text) ?? 1)) *
                        0.01.toDouble());
                // double salt = ((foodDocument['salt'].toDouble()) *
                //     ((double.tryParse(_budgetController.text) ?? 100)) *
                //     0.01.toDouble());
                // double alcohol = ((foodDocument['alcohol'].toDouble()) *
                //     ((double.tryParse(_budgetController.text) ?? 100)) *
                //     0.01.toDouble());
                // double natrium = ((foodDocument['natrium'].toDouble()) *
                //     ((double.tryParse(_budgetController.text) ?? 100)) *
                //     0.01.toDouble());
                // double kalium = ((foodDocument['kalium'].toDouble()) *
                //     ((double.tryParse(_budgetController.text) ?? 100)) *
                //     0.01.toDouble());
                // double calcium = ((foodDocument['calcium'].toDouble()) *
                //     ((double.tryParse(_budgetController.text) ?? 100)) *
                //     0.01.toDouble());
                // double magnesium = ((foodDocument['magnesium'].toDouble()) *
                //     ((double.tryParse(_budgetController.text) ?? 100)) *
                //     0.01.toDouble());
                // double iron = ((foodDocument['iron'].toDouble()) *
                //     ((double.tryParse(_budgetController.text) ?? 100)) *
                //     0.01.toDouble());
                // double selenium = ((foodDocument['selenium'].toDouble()) *
                //     ((double.tryParse(_budgetController.text) ?? 100)) *
                //     0.01.toDouble());
                // double zink = ((foodDocument['selenium'].toDouble()) *
                //     ((double.tryParse(_budgetController.text) ?? 100)) *
                //     0.01.toDouble());
                // double vitA = ((foodDocument['selenium'].toDouble()) *
                //     ((double.tryParse(_budgetController.text) ?? 100)) *
                //     0.01.toDouble());
                // double vitB = ((foodDocument['selenium'].toDouble()) *
                //     ((double.tryParse(_budgetController.text) ?? 100)) *
                //     0.01.toDouble());
                // double vitC = ((foodDocument['selenium'].toDouble()) *
                //     ((double.tryParse(_budgetController.text) ?? 100)) *
                //     0.01.toDouble());
                // double vitE = ((foodDocument['selenium'].toDouble()) *
                //     ((double.tryParse(_budgetController.text) ?? 100)) *
                //     0.01.toDouble());
                // double vitB1 = ((foodDocument['selenium'].toDouble()) *
                //     ((double.tryParse(_budgetController.text) ?? 100)) *
                //     0.01.toDouble());
                // double vitB2 = ((foodDocument['selenium'].toDouble()) *
                //     ((double.tryParse(_budgetController.text) ?? 100)) *
                //     0.01.toDouble());
                // double vitB6 = ((foodDocument['selenium'].toDouble()) *
                //     ((double.tryParse(_budgetController.text) ?? 100)) *
                //     0.01.toDouble());
                // double vitB12 = ((foodDocument['selenium'].toDouble()) *
                //     ((double.tryParse(_budgetController.text) ?? 100)) *
                //     0.01.toDouble());
                // double foliumzuur = ((foodDocument['selenium'].toDouble()) *
                //     ((double.tryParse(_budgetController.text) ?? 100)) *
                //     0.01.toDouble());
                // double niacine = ((foodDocument['selenium'].toDouble()) *
                //     ((double.tryParse(_budgetController.text) ?? 100)) *
                //     0.01.toDouble());
                // double jodium = ((foodDocument['selenium'].toDouble()) *
                //     ((double.tryParse(_budgetController.text) ?? 100)) *
                //     0.01.toDouble());
                // double fosfor = ((foodDocument['selenium'].toDouble()) *
                //     ((double.tryParse(_budgetController.text) ?? 100)) *
                //     0.01.toDouble());

                Map<String, double> dataMap = {
                  "Carbs": kcal,
                  "Protein": 2,
                  "Fats": 2,
                };

                return Container(
                  child: Column(children: <Widget>[
                    Text(
                      "${foodDocument['name']}",
                      style: new TextStyle(fontSize: 24.0),
                    ),

                    PieChart(
                      chartRadius: 125.0,
                      ringStrokeWidth: 10,
                      chartLegendSpacing: 25,
                      initialAngleInDegree: 270,
                      // legendOptions: LegendOptions(),
                      chartValuesOptions: ChartValuesOptions(
                        decimalPlaces: 0,
                        showChartValues: true,
                        showChartValuesInPercentage: true,
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
                        "${koolhy.toStringAsFixed(0)}g ${Koolhydratentotaal}":
                            koolhy,
                        "${protein.toStringAsFixed(0)}g ${Eiwittentotaal}":
                            protein,
                        "${fat.toStringAsFixed(0)}g ${Vettentotaal}": fat,
                      },
                      centerText: "${kcal.toStringAsFixed(0)} ${Calories}",
                      chartType: ChartType.ring,
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
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
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          RaisedButton(
                            child: Text(
                                "${DateFormat('dd/MM/yyyy').format(_eattime).toString()}"),
                            onPressed: () => _selectDate(context),
                            // await displayDateRangePicker(context);
                            //   },
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.only(left: 8.0),
                          //   child: Text(
                          //       "Datum: ${DateFormat('dd/MM/yyyy').format(_eattime).toString()}"),
                          // ),

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
                          RaisedButton(
                            child: Text(AppLocalizations.of(context).savetext),
                            onPressed: () {
                              //  widget.trip.startDate = _startDate;
                              // widget.trip.endDate = _endDate;
                              widget.trip.kcal = kcal;
                              widget.trip.co2 = co2;
                              widget.trip.carbs = koolhy;
                              widget.trip.protein = protein;
                              widget.trip.proteinplant = proteinplant;
                              widget.trip.proteinanimal = proteinanimal;
                              widget.trip.fat = fat;
                              widget.trip.sugars = sugars;
                              widget.trip.dietaryfiber = dietaryfiber;

                              widget.trip.saturatedfat = saturatedfat;
                              widget.trip.eatDate = _eattime;
                              widget.trip.amount = (_sizeController.text == "")
                                  ? 0
                                  : double.parse(_sizeController.text);
                              widget.trip.categorie = categoryChoice;
                              widget.trip.plantbased = plantbased;
                              widget.trip.nutriscore = nutriscore;
                              widget.trip.ecoscore = ecoscore;
                              widget.trip.amountUnit =
                                  _portionUnitController.text;
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        NewFoodSummaryView(trip: widget.trip)),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //   children: [
                    //     Container(
                    //       child: nutriscoreType[nutriscore],
                    //       width: 100,
                    //     ),
                    //     Container(
                    //       alignment: Alignment.center,
                    //       child: ecoscoreType[ecoscore],
                    //       width: 100,
                    //     ),
                    //   ],
                    // ),

                    TextButton(
                      child: Text(
                        AppLocalizations.of(context).macronutrients,
                        style: TextStyle(
                          color: kPrimaryColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: null,
                    ),

                    Expanded(
                      child: SingleChildScrollView(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          child: Table(
                            columnWidths: {
                              0: FractionColumnWidth(0.40),
                              1: FractionColumnWidth(0.45),
                            },
                            textBaseline: TextBaseline.alphabetic,
                            defaultVerticalAlignment:
                                TableCellVerticalAlignment.middle,
                            children: [
                              TableRow(children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0),
                                  child: Text(
                                    AppLocalizations.of(context).energy,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Text(
                                  "${kcal.toStringAsFixed(1)} kcal",
                                  style: TextStyle(fontSize: 18),
                                ),
                              ]),
                              TableRow(children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0),
                                  child: Text(
                                    'Co²',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Text(
                                  "${co2.toStringAsFixed(1)} kg/co²",
                                  style: TextStyle(fontSize: 18),
                                ),
                              ]),
                              TableRow(children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0),
                                  child: Text(
                                    AppLocalizations.of(context).carbsfulltext,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Text(
                                  "${koolhy.toStringAsFixed(1)} g",
                                  style: TextStyle(fontSize: 18),
                                ),
                              ]),
                              //Proteins
                              TableRow(children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0),
                                  child: Text(
                                    AppLocalizations.of(context)
                                        .proteinfulltext,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Text(
                                  "${protein.toStringAsFixed(1)} g",
                                  style: TextStyle(fontSize: 18),
                                ),
                              ]),
                              //Proteins Plant
                              TableRow(children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0),
                                  child: Text(
                                    AppLocalizations.of(context)
                                        .proteinplanttext,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Text(
                                  "${proteinplant.toStringAsFixed(1)} g",
                                  style: TextStyle(fontSize: 18),
                                ),
                              ]),
                              //Proteins Animal
                              TableRow(children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0),
                                  child: Text(
                                    AppLocalizations.of(context)
                                        .proteinanimaltext,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Text(
                                  "${proteinanimal.toStringAsFixed(1)} g",
                                  style: TextStyle(fontSize: 18),
                                ),
                              ]),
                              TableRow(children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0),
                                  child: Text(
                                    AppLocalizations.of(context).fatstext,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Text(
                                  "${fat.toStringAsFixed(1)} g",
                                  style: TextStyle(fontSize: 18),
                                ),
                              ]),
                              TableRow(children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0),
                                  child: Text(
                                    AppLocalizations.of(context).saturatedfats,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Text(
                                  "${saturatedfat.toStringAsFixed(1)} g",
                                  style: TextStyle(fontSize: 18),
                                ),
                              ]),
                              TableRow(children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0),
                                  child: Text(
                                    AppLocalizations.of(context).sugartext,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Text(
                                  "${sugars.toStringAsFixed(1)} g",
                                  style: TextStyle(fontSize: 18),
                                ),
                              ]),
                              TableRow(children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0),
                                  child: Text(
                                    AppLocalizations.of(context).fiberstext,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Text(
                                  "${dietaryfiber.toStringAsFixed(1)} g",
                                  style: TextStyle(fontSize: 18),
                                ),
                              ]),
                              // TableRow(children: [
                              //   Padding(
                              //     padding:
                              //         const EdgeInsets.symmetric(vertical: 10.0),
                              //     child: Text(
                              //       'Plantbased',
                              //       style: TextStyle(
                              //           fontSize: 18,
                              //           fontWeight: FontWeight.bold),
                              //     ),
                              //   ),
                              //   Text(
                              //     "$plantbased",
                              //     style: TextStyle(fontSize: 18),
                              //   ),
                              // ]),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Text(
                    //       "Calories ${kcal.toStringAsFixed(1)}",
                    //       style: new TextStyle(fontSize: 16.0),
                    //     ),
                    //     Text(
                    //       "Co2 ${co2.toStringAsFixed(2)}",
                    //       style: new TextStyle(fontSize: 16.0),
                    //     ),
                    //     Text(
                    //       "Carbs ${koolhy.toStringAsFixed(1)}",
                    //       style: new TextStyle(fontSize: 16.0),
                    //     ),
                    //     Text(
                    //       "Protein ${protein.toStringAsFixed(1)}",
                    //       style: new TextStyle(fontSize: 16.0),
                    //     ),
                    //   ],
                    // ),

                    // Text(
                    //   "Fat ${fat.toStringAsFixed(1)}",
                    //   style: new TextStyle(fontSize: 16.0),
                    // ),
                    // Text(
                    //   "Saturatedfat ${saturatedfat.toStringAsFixed(1)}",
                    //   style: new TextStyle(fontSize: 16.0),
                    // ),
                    // Text(
                    //   "Sugars ${sugars.toStringAsFixed(1)}",
                    //   style: new TextStyle(fontSize: 16.0),
                    // ),
                    // Text(
                    //   "Dietary Fiver ${dietaryfiber.toStringAsFixed(1)}",
                    //   style: new TextStyle(fontSize: 16.0),
                    // ),
                    // Text(
                    //   "plantbased $plantbased",
                    //   style: new TextStyle(fontSize: 16.0),
                    // ),
                    // Text(
                    //   "nutriscore $nutriscore",
                    //   style: new TextStyle(fontSize: 16.0),
                    // ),

                    // VANAFFFF HIERRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRBOVEN IS GOED
                    // ImageIcon(nutriscore.containsKey(trip.plantbased)
                    //                              ? nutriscoreimage[trip.plantbased]
                    //                              : nutriscoreimage["n"],)
                    // child: (plantType.containsKey(trip.plantbased))
                    //           ? plantType[trip.plantbased]
                    //           : plantType["n"],

                    // Text(
                    //   "salt ${salt.toStringAsFixed(1)}",
                    //   style: new TextStyle(fontSize: 16.0),
                    // ),
                    // Text(
                    //   "alcohol ${alcohol.toStringAsFixed(1)}",
                    //   style: new TextStyle(fontSize: 16.0),
                    // ),
                    // Text(
                    //   "natrium ${natrium.toStringAsFixed(1)}",
                    //   style: new TextStyle(fontSize: 16.0),
                    // ),
                    // Text(
                    //   "kalium ${kalium.toStringAsFixed(1)}",
                    //   style: new TextStyle(fontSize: 16.0),
                    // ),
                    // Text(
                    //   "calcium ${calcium.toStringAsFixed(1)}",
                    //   style: new TextStyle(fontSize: 16.0),
                    // ),
                    // Text(
                    //   "magnesium ${magnesium.toStringAsFixed(1)}",
                    //   style: new TextStyle(fontSize: 16.0),
                    // ),
                    // Text(
                    //   "iron ${iron.toStringAsFixed(1)}",
                    //   style: new TextStyle(fontSize: 16.0),
                    // ),
                    // Text(
                    //   "selenium ${selenium.toStringAsFixed(1)}",
                    //   style: new TextStyle(fontSize: 16.0),
                    // ),
                    // Text(
                    //   "zink ${zink.toStringAsFixed(1)}",
                    //   style: new TextStyle(fontSize: 16.0),
                    // ),
                    // Text(
                    //   "vitA ${vitA.toStringAsFixed(1)}",
                    //   style: new TextStyle(fontSize: 16.0),
                    // ),
                    // Text(
                    //   "vitB ${vitB.toStringAsFixed(1)}",
                    //   style: new TextStyle(fontSize: 16.0),
                    // ),
                    // Text(
                    //   "vitC ${vitC.toStringAsFixed(1)}",
                    //   style: new TextStyle(fontSize: 16.0),
                    // ),
                    // Text(
                    //   "vitE ${vitE.toStringAsFixed(1)}",
                    //   style: new TextStyle(fontSize: 16.0),
                    // ),
                    // Text(
                    //   "vitB1 ${vitB1.toStringAsFixed(1)}",
                    //   style: new TextStyle(fontSize: 16.0),
                    // ),
                    // Text(
                    //   "vitB2 ${vitB2.toStringAsFixed(1)}",
                    //   style: new TextStyle(fontSize: 16.0),
                    // ),
                    // Text(
                    //   "vitB6 ${vitB6.toStringAsFixed(1)}",
                    //   style: new TextStyle(fontSize: 16.0),
                    // ),
                    // Text(
                    //   "vitB12 ${vitB12.toStringAsFixed(1)}",
                    //   style: new TextStyle(fontSize: 16.0),
                    // ),
                    // Text(
                    //   "vitB6 ${vitB6.toStringAsFixed(1)}",
                    //   style: new TextStyle(fontSize: 16.0),
                    // ),
                    // Text(
                    //   "foliumzuur ${foliumzuur.toStringAsFixed(1)}",
                    //   style: new TextStyle(fontSize: 16.0),
                    // ),
                    // Text(
                    //   "niacine ${niacine.toStringAsFixed(1)}",
                    //   style: new TextStyle(fontSize: 16.0),
                    // ),
                    // Text(
                    //   "jodium ${jodium.toStringAsFixed(1)}",
                    //   style: new TextStyle(fontSize: 16.0),
                    // ),
                    // Text(
                    //   "fosfor ${fosfor.toStringAsFixed(1)}",
                    //   style: new TextStyle(fontSize: 16.0),
                    // ),
                  ]),
                );
              }),
        ),
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

  final ValueNotifier<String> currentValue = ValueNotifier('gram');

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

              return ValueListenableBuilder<String>(
                  valueListenable: currentValue,
                  builder:
                      (BuildContext context, String hasError, Widget child) {
                    return DropdownButtonFormField(
                      // value: _portionController.value.text,
                      value: currentValue.value,
                      isExpanded: true,
                      items: itemsWidgets,
                      onChanged: (s) {
                        print(s);
                        _portionController.value =
                            TextEditingValue(text: itemsData[s].toString());
                        _portionUnitController.value =
                            TextEditingValue(text: s);
                        currentValue.value = s;
                      },
                    );
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
