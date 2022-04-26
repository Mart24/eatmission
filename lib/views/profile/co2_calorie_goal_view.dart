import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:food_app/shared/dairy_cubit.dart';
import 'package:food_app/views/constants.dart';

class Goalgoal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BMR calculation'),
        backgroundColor: kPrimaryColor,
      ),
      body: SafeArea(
          child: Center(
        child: RadioGroup(),
      )),
    );
  }
}

class RadioGroup extends StatefulWidget {
  const RadioGroup({Key key, this.title}) : super(key: key);
  final String title;

  @override
  State<RadioGroup> createState() => _HomePage();
}

class _HomePage extends State<RadioGroup> {
  double _groupValue = 5;
  static const keyGoal = 'key-goal';
  double initialvalue = 2000;
  double _carbGoalPercentage = 50;
  double _proteinGoalPercentage = 30;
  double _fatGoalPercentage = 20;

  TextEditingController carbcontroler = TextEditingController()..text = '50';
  TextEditingController proteincontroler = TextEditingController()..text = '30';
  TextEditingController fatcontroler = TextEditingController()..text = '20';

  // void kcalvalue(double newGoal) {
  //   setState(() {
  //     initialvalue = newGoal;
  //   });
  // }

// void checkRatio(double carbvalue, double proteinvalue, double fatvalue) {
//     setState(() {
//       _groupValue1 = carbvalue;
//       _groupValue2 = proteinvalue;
//       _groupValue3 = fatvalue;
//     });
//   }

  @override
  void initState() {
    super.initState();
    carbcontroler.addListener(_setcarbGoalPercentage);
    proteincontroler.addListener(_setcarbGoalPercentage);
    fatcontroler.addListener(_setcarbGoalPercentage);
    // _portionUnitController.addListener(_setPortionUnit);
  }

  _setcarbGoalPercentage() {
    print('set budget total');
    setState(() {
      _carbGoalPercentage = double.tryParse(carbcontroler.text);
      _proteinGoalPercentage = double.tryParse(proteincontroler.text);
      _fatGoalPercentage = double.tryParse(fatcontroler.text);
    });
  }

  @override
  void dispose() {
    carbcontroler.dispose();
    proteincontroler.dispose();
    fatcontroler.dispose();

    super.dispose();
  }

  void checkRadio(double co2value) {
    setState(() {
      _groupValue = co2value;
    });
  }

  // 5.0: 'Gemiddelde Nederlander: 5 kg/CO₂',
  //       2.58: 'Doel voor 2030: 2.58 kg/CO₂',
  //       2.1: 'Doel voor 2030 (streng): 2.1 kg/CO₂',
  //       1.1: 'Doel voor 2050: 1.1 kg/CO₂',

  @override
  Widget build(BuildContext context) {
    DairyCubit cubit = DairyCubit.instance(context);
    //int carbgoal = initialvalue*_carbGoalPercentage;

    return Scaffold(
      resizeToAvoidBottomInset: false, // set it to false
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              'Caloriegoal',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            calorieFormField(cubit: cubit),
            Text('Verhouding koolhydraten, eiwitten en vetten'),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  new Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: new TextFormField(
                          controller: carbcontroler,
                          keyboardType: TextInputType.number,
                          // initialValue: 30.toString(),
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(2),
                          ]),
                    ),
                  ),
                  Text(
                    "Kooly",
                    textAlign: TextAlign.center,
                    style: TextStyle()
                        .copyWith(color: Colors.black, fontSize: 18.0),
                  ),
                  new Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: new TextFormField(
                          controller: proteincontroler,
                          keyboardType: TextInputType.number,
                          //  initialValue: 30.toString(),
                          // decoration: InputDecoration(hintText: '30'),
                          // onChanged: (newGoal) async {
                          //   cubit.setCalGoal(double.tryParse(newGoal));
                          // },
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(2),
                          ]),
                    ),
                  ),
                  Text(
                    "Eiwit",
                    textAlign: TextAlign.center,
                    style: TextStyle()
                        .copyWith(color: Colors.black, fontSize: 18.0),
                  ),
                  new Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: new TextFormField(
                        controller: fatcontroler,
                        keyboardType: TextInputType.number,
                        // initialValue: 30.toString(),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(2),
                        ],
                      ),
                    ),
                  ),
                  Text(
                    "Vet",
                    textAlign: TextAlign.center,
                    style: TextStyle()
                        .copyWith(color: Colors.black, fontSize: 18.0),
                  ),
                  // Container(
                  //   height: 60,
                  //   width: 60,
                  //   margin: const EdgeInsets.all(16.0),
                  //   decoration: BoxDecoration(
                  //     shape: BoxShape.circle,
                  //     border: Border.all(
                  //       color: Colors.pink,
                  //       width: 3.5,
                  //     ),
                  //   ),
                  //   // child: IconButton(
                  //   //   icon: Icon(
                  //   //     IconData(57669, fontFamily: 'MaterialIcons'),
                  //   //     size: 38,
                  //   //     color: Colors.red,
                  //   //   ),
                  //   // ),
                  // ),
                ],
              ),
            ),
            Text('Koolhydraten percentage ${_carbGoalPercentage.toString()}'),
            Text('Eiwitten percentage ${_proteinGoalPercentage.toString()}'),
            Text('Vetten percentage ${_fatGoalPercentage.toString()}'),
            Text('Jouw CO2 doel $_groupValue kg/co2 per dag'),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextField(
                decoration: new InputDecoration(labelText: "Je eigen doel"),
                keyboardType: TextInputType.number,
//             inputFormatters: <TextInputFormatter>[
//     FilteringTextInputFormatter.digitsOnly
// ], // Only numbers can be entered
              ),
            ),
            ListTile(
              title: Text('Gemiddelde Nederlander: 5 kg/CO₂'),
              leading: Radio(
                  value: 5.0,
                  groupValue: _groupValue,
                  onChanged: (co2value) async {
                    cubit.setSaveGoal(co2value);
                    checkRadio(co2value);
                    debugPrint('key-radio-sync-period: $co2value days');
                  }),
            ),
            ListTile(
              title: Text('Doel voor 2030: 2.58 kg/CO₂'),
              leading: Radio(
                  value: 2.58,
                  groupValue: _groupValue,
                  onChanged: (co2value) async {
                    cubit.setSaveGoal(co2value);
                    checkRadio(co2value);
                    debugPrint('key-radio-sync-period: $co2value days');
                  }),
            ),
            ListTile(
              title: Text('Doel voor 2030 (streng): 2.1 kg/CO₂'),
              leading: Radio(
                  value: 2.1,
                  groupValue: _groupValue,
                  onChanged: (co2value) async {
                    cubit.setSaveGoal(co2value);
                    checkRadio(co2value);
                    debugPrint('key-radio-sync-period: $co2value days');
                  }),
            ),
            ListTile(
              title: Text('Doel voor 2050: 1.1 kg/CO₂'),
              leading: Radio(
                  value: 1.1,
                  groupValue: _groupValue,
                  onChanged: (co2value) async {
                    cubit.setSaveGoal(co2value);
                    checkRadio(co2value);
                    debugPrint('key-radio-sync-period: $co2value days');
                  }),
            ),
          ],
        ),
      ),
    );
  }

  String numberValidator(String value) {
    if (value == null) {
      return null;
    }
    final n = num.tryParse(value);
    if (n == null) {
      return '"$value" is not a valid number';
    }
    return null;
  }
}
//   Widget buildGoalSetting(context) {
//     DairyCubit cubit = DairyCubit.instance(context);
//     double initialGoal = cubit.calGoal;
//     return TextInputSettingsTile(
//         settingKey: keyGoal,
//         title: 'Calorie Goal',
//         initialValue: initialGoal.toString(),
//         keyboardType: TextInputType.number,
//         validator: numberValidator,
//         onChange: (newGoal) async {
//           cubit.setCalGoal(double.tryParse(newGoal));
//         });
//   }

class calorieFormField extends StatelessWidget {
  const calorieFormField({
    Key key,
    @required this.cubit,
  }) : super(key: key);

  final DairyCubit cubit;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.number,
      initialValue: cubit.calGoal.toString(),
      onChanged: (newGoal) async {
        cubit.setCalGoal(double.tryParse(newGoal));
      },
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
        TextInputFormatter.withFunction((oldValue, newValue) {
          try {
            final text = newValue.text;
            if (text.isNotEmpty) double.parse(text);
            return newValue;
          } catch (e) {}
          return oldValue;
        }),
      ],
    );
  }
}