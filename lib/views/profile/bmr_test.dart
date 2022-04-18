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
  List<String> dropdownGender = ["Female", "Male"];
  List<String> dropdownEquation = ["Mifflin-St Jeor", "Harris-Benedict"];
  List<String> dropdownActivity = [
    "I am inactive (PAL 1,2)",
    "I am lightly active (PAL 1,375)",
    "I am moderately active (PAL 1,5)",
    "I am very active (PAL 1,7)",
    "I am super active (PAL 1,9)"
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
          title: Text('BMR calculation'),
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
                    iconEnabledColor: Colors.black,
                    elevation: 20,
                    style: TextStyle(color: Colors.black),
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
                    hint: new Text("Equation method"),
                    icon: Icon(Icons.arrow_drop_down_circle),
                    iconSize: 15,
                    iconEnabledColor: Colors.black,
                    elevation: 20,
                    style: TextStyle(color: Colors.orange),
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
                    labelText: 'Age',
                    contentPadding: const EdgeInsets.symmetric(horizontal: 0.0),
                  ),
                  keyboardType: TextInputType.numberWithOptions(),
                  controller: _ageController,
                ),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Height (cm)',
                  ),
                  keyboardType: TextInputType.numberWithOptions(),
                  controller: _heightController,
                ),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Weight (kg)',
                  ),
                  keyboardType: TextInputType.numberWithOptions(),
                  controller: _weightController,
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: new DropdownButton(
                    value: selected2,
                    items: dropdownActivityList,
                    hint: new Text("Level of Activeness"),
                    icon: Icon(Icons.arrow_drop_down_circle),
                    iconSize: 15,
                    iconEnabledColor: Colors.black,
                    elevation: 20,
                    style: TextStyle(color: Colors.orange),
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
                  child: Text('Calculate BMR'),
                  color: kPrimaryColor,
                  textColor: Colors.black,
                  elevation: 5,
                  onPressed: _onPress,
                ),
                Text("Your results are as follows:"),
                SizedBox(
                  height: 8,
                ),
                Text(
                  "Your BMR is $bmrTotal",
                ),
                SizedBox(
                  height: 8,
                ),
                Text("Recommended Calorie intake is $calories"),
                SizedBox(
                  height: 8,
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

      if (genderController == "Male") {
        if (equationController == "Mifflin-St Jeor") {
          bmrDouble = (10 * weight) + (6.25 * height) - (5 * age) + 5;
        } else if (equationController == "Harris-Benedict") {
          bmrDouble =
              66.47 + (13.75 * weight) + (5.003 * height) - (6.755 * age);
        }
      } else if (genderController == "Female") {
        if (equationController == "Mifflin-St Jeor") {
          bmrDouble = (10 * weight) + (6.25 * height) - (5 * age) - 161;
        } else if (equationController == "Harris-Benedict") {
          bmrDouble =
              655.1 + (9.563 * weight) + (1.85 * height) - (4.676 * age);
        }
      }
      bmrTotal = (bmrDouble.round());
      if (activityController == "I am inactive (PAL 1,2)") {
        caloriesDouble = (bmrTotal * 1.2);
      } else if (activityController == "I am lightly active (PAL 1,375)") {
        caloriesDouble = (bmrTotal * 1.375);
      } else if (activityController == "I am moderately active (PAL 1,5)") {
        caloriesDouble = (bmrTotal * 1.55);
      } else if (activityController == "I am very active (PAL 1,7)") {
        caloriesDouble = (bmrTotal * 1.725);
      } else if (activityController == "I am super active (PAL 1,9)") {
        caloriesDouble = (bmrTotal * 1.9);
      }
      calories = (caloriesDouble.round());
    });
  }
}
