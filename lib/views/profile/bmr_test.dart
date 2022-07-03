import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:food_app/Views/constants.dart';

class BMRcalculation extends StatefulWidget {
  @override
  _BMRcalculationState createState() => _BMRcalculationState();
}

class _BMRcalculationState extends State<BMRcalculation> {
  List<DropdownMenuItem<String>> dropdownGenderList = [];
  List<DropdownMenuItem<String>> dropdownEquationList = [];
  List<DropdownMenuItem<String>> dropdownActivityList = [];
  List<String> dropdownGender = ["Vrouw", "Man"];
  List<String> dropdownEquation = ["Mifflin-St Jeor", "Harris-Benedict"];
  List<String> dropdownActivity = [
    "Inactief (kantoorbaan en sport niet of zeer nauwelijks) (PAL 1,2)",
    "Licht actief (kantoorbaan, maar sport wel licht 1-3 x per week) (Pal 1,375) ",
    "Gemiddeld actief (kantoorbaan, maar sport wel 3-5 x per week) (PAL 1,5)",
    "Actief (staand werk, sport 4-7 x per week) (PAL 1,7)",
    "Zeer actief (staand / zwaar werk, sport meerdere keren per dag) (PAL 1,9)"

//  } else if (activityController ==
//           "Licht actief (kantoorbaan, maar sport wel licht 1-3 x per week) (Pal 1,375) ") {
//         caloriesDouble = (bmrTotal * 1.375);
//       } else if (activityController ==
//           "Gemiddeld actief (kantoorbaan, maar sport wel 3-5 x per week) (PAL 1,5)") {
//         caloriesDouble = (bmrTotal * 1.55);
//       } else if (activityController ==
//           "Actief (staand werk, sport 4-7 x per week) (PAL 1,7)") {
//         caloriesDouble = (bmrTotal * 1.725);
//       } else if (activityController ==
//           "Zeer actief (staand / zwaar werk, sport meerdere keren per dag) (PAL 1,9)") {
//         caloriesDouble = (bmrTotal * 1.9);
//       }
  ];
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  String selected,
      selected1,
      selected2,
      genderController,
      equationController,
      activityController;
  int age = 0, height = 0, weight = 0, bmrTotal = 0, calories = 0;
  double bmrDouble = 0.0, caloriesDouble;

  @override
  Widget build(BuildContext context) {
    loadGender();
    loadEquation();
    loadActivity();
    return Scaffold(
        appBar: AppBar(
          title: Text('BMR en AMR berekenen'),
          backgroundColor: kPrimaryColor,
        ),
        body: SingleChildScrollView(
            padding: EdgeInsets.all(50.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Image.asset(
                //   'assets/img1.jpg',
                //   scale: 1,
                // ),
                SizedBox(
                  height: 10,
                ),
                // GestureDetector(
                //     onTap: _onClick,
                //     child: Text('Unfamiliar with the Metric system?',
                //         style: TextStyle(fontSize: 16))),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: new DropdownButton(
                    value: selected,
                    items: dropdownGenderList,
                    hint: new Text("Geslacht"),
                    icon: Icon(Icons.arrow_drop_down_circle),
                    iconSize: 15,
                    // iconEnabledColor: Colors.black,
                    elevation: 20,
                    //  style: TextStyle(color: Colors.black),
                    underline: Container(
                      height: 2,
                      color: kPrimaryColor,
                    ),
                    onChanged: (genderValue) {
                      selected = genderValue;
                      setState(() {
                        genderController = genderValue;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: new DropdownButton(
                    value: selected1,
                    items: dropdownEquationList,
                    hint: new Text("Reken methode"),
                    icon: Icon(Icons.arrow_drop_down_circle),
                    iconSize: 15,
                    //   iconEnabledColor: Colors.black,
                    elevation: 20,
                    //   style: TextStyle(color: Colors.orange),
                    underline: Container(
                      height: 2,
                      color: kPrimaryColor,
                    ),
                    onChanged: (equationChoice) {
                      selected1 = equationChoice;
                      setState(() {
                        equationController = equationChoice;
                      });
                    },
                  ),
                ),
                TextField(
                  style: new TextStyle(
                      fontSize: 15.0, height: 1.5, color: Colors.black),
                  decoration: InputDecoration(
                    labelText: 'Leeftijd',
                    contentPadding: const EdgeInsets.symmetric(horizontal: 0.0),
                  ),
                  keyboardType: TextInputType.numberWithOptions(),
                  controller: _ageController,
                ),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Lengte (cm)',
                  ),
                  keyboardType: TextInputType.numberWithOptions(),
                  controller: _heightController,
                ),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Gewicht (kg)',
                  ),
                  keyboardType: TextInputType.numberWithOptions(),
                  controller: _weightController,
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: new DropdownButton(
                    isExpanded: true,
                    value: selected2,
                    items: dropdownActivityList,
                    hint: new Text("Hoe actief ben je?"),
                    icon: Icon(Icons.arrow_drop_down_circle),
                    iconSize: 15,
                    iconEnabledColor: Colors.black,
                    elevation: 20,
                    // style: TextStyle(color: Colors.orange),
                    underline: Container(
                      height: 2,
                      color: kPrimaryColor,
                    ),
                    onChanged: (activityChoice) {
                      selected2 = activityChoice;
                      setState(() {
                        activityController = activityChoice;
                      });
                    },
                  ),
                ),
                MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  minWidth: 300,
                  height: 30,
                  child: Text('Bereken BMR'),
                  color: kPrimaryColor,
                  textColor: Colors.black,
                  elevation: 5,
                  onPressed: _onPress,
                ),
                Text("Je resultaten zijn als volgt:"),
                SizedBox(
                  height: 8,
                ),
                Text(
                  "Je BMR is $bmrTotal",
                ),
                SizedBox(
                  height: 8,
                ),
                Text("Je aanbeveling voor calorieën is $calories"),
                SizedBox(
                  height: 8,
                ),

                RichText(
                  text: TextSpan(
                    text: '',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor),
                    children: <TextSpan>[
                      TextSpan(
                          text: 'Wat is BMR en AMR?',
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(' Wat is BMR?'),
                                      content: RichText(
                                        text: TextSpan(
                                          text:
                                              'BMR (Basic Metabolic Rate) geeft het minimale aantal calorieën aan wat het lichaam iedere dag nodig heeft voor de stofwisseling om goed te functioneren in rust. De AMR (Active Metabolic Rate) is uw BMR plus het aantal calorieën dat iedere dag nodig is voor basisbeweging en andere activiteiten. Omdat de AMR afhangt van uw dagelijkse activiteit, zal deze hoger zijn wanneer u meer beweegt. De uitkomsten zjin een resultaat van gemiddelden en niet precies op de persoon berekend.\n\nBeschouw de uitkomst als een indicatie.Wil je het nauwkeurig laten berekenen raadpleeg dan je huisarts of andere deskundigen.',
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Theme.of(context)
                                                  .primaryColor),
                                        ),
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, 'OK'),
                                          child: const Text('OK',
                                              style: TextStyle(
                                                  color: kPrimaryColor)),
                                        ),
                                      ],
                                    );
                                  });
                            },
                          style: TextStyle(
                              //    color: Colors.blue,
                              )),
                      TextSpan(text: ''),
                    ],
                  ),
                ),
              ],
            )));
  }

  void loadGender() {
    dropdownGenderList = [];
    dropdownGenderList = dropdownGender
        .map((values) => new DropdownMenuItem<String>(
              child: new Text(values),
              value: values,
            ))
        .toList();
  }

  void loadEquation() {
    dropdownEquationList = [];
    dropdownEquationList = dropdownEquation
        .map((values) => new DropdownMenuItem<String>(
              child: new Text(values),
              value: values,
            ))
        .toList();
  }

  void loadActivity() {
    dropdownActivityList = [];
    dropdownActivityList = dropdownActivity
        .map((values) => new DropdownMenuItem<String>(
              child: new Text(values),
              value: values,
            ))
        .toList();
  }

  void _onPress() {
    setState(() {
      age = int.parse(_ageController.text);
      height = int.parse(_heightController.text);
      weight = int.parse(_weightController.text);

      if (genderController == "Man") {
        if (equationController == "Mifflin-St Jeor") {
          bmrDouble = (10 * weight) + (6.25 * height) - (5 * age) + 5;
        } else if (equationController == "Harris-Benedict") {
          bmrDouble =
              66.47 + (13.75 * weight) + (5.003 * height) - (6.755 * age);
        }
      } else if (genderController == "Vrouw") {
        if (equationController == "Mifflin-St Jeor") {
          bmrDouble = (10 * weight) + (6.25 * height) - (5 * age) - 161;
        } else if (equationController == "Harris-Benedict") {
          bmrDouble =
              655.1 + (9.563 * weight) + (1.85 * height) - (4.676 * age);
        }
      }
      bmrTotal = (bmrDouble.round());
      if (activityController ==
          "Inactief (kantoorbaan en sport niet of zeer nauwelijks) (PAL 1,2)") {
        caloriesDouble = (bmrTotal * 1.2);
      } else if (activityController ==
          "Licht actief (kantoorbaan, maar sport wel licht 1-3 x per week) (Pal 1,375) ") {
        caloriesDouble = (bmrTotal * 1.375);
      } else if (activityController ==
          "Gemiddeld actief (kantoorbaan, maar sport wel 3-5 x per week) (PAL 1,5)") {
        caloriesDouble = (bmrTotal * 1.55);
      } else if (activityController ==
          "Actief (staand werk, sport 4-7 x per week) (PAL 1,7)") {
        caloriesDouble = (bmrTotal * 1.725);
      } else if (activityController ==
          "Zeer actief (staand / zwaar werk, sport meerdere keren per dag) (PAL 1,9)") {
        caloriesDouble = (bmrTotal * 1.9);
      }
      calories = (caloriesDouble.round());
    });
  }
}
