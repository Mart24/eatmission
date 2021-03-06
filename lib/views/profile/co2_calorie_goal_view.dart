import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:food_app/shared/dairy_cubit.dart';
import 'package:food_app/views/constants.dart';
import 'package:google_fonts/google_fonts.dart';

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
  double _fatsGoalPercentage = 20;

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
      _carbGoalPercentage = (carbcontroler.text == null)
          ? 0
          : double.tryParse(carbcontroler.text);
      _proteinGoalPercentage = double.tryParse(proteincontroler.text);
      _fatsGoalPercentage = double.tryParse(fatcontroler.text);
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

  // 5.0: 'Gemiddelde Nederlander: 5 kg/CO???',
  //       2.58: 'Doel voor 2030: 2.58 kg/CO???',
  //       2.1: 'Doel voor 2030 (streng): 2.1 kg/CO???',
  //       1.1: 'Doel voor 2050: 1.1 kg/CO???',

  @override
  Widget build(BuildContext context) {
    DairyCubit cubit = DairyCubit.instance(context);
    //int carbgoal = initialvalue*_carbGoalPercentage;
    //double koolgram = _groupValue * ((_carbGoalPercentage ?? '').isEmpty ? 0 : double.parse(_carbGoalPercentage));;

    return Scaffold(
      resizeToAvoidBottomInset: false, // set it to false
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                '*Let op: Als je je caloriegoal verandert: Vul dan ook opnieuw verhoudingswaarden in. Anders heb je nog je oude goals',
                style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Caloriegoal',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.info),
                    color: kPrimaryColor,
                    // tooltip: 'Increase volume by 10',
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                            _buildPopupDialogCalorie(context),
                      );
                    },
                  ),
                ],
              ),
              calorieFormField(cubit: cubit),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Verhouding koolhydraten, eiwitten en vetten',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        IconButton(
                          icon: const Icon(Icons.info),
                          color: kPrimaryColor,
                          // tooltip: 'Increase volume by 10',
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  _buildPopupDialogRatio(context),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    new Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            right: 10.0, left: 10, bottom: 20),
                        child: Form(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 244, 239, 239),
                              borderRadius: new BorderRadius.circular(10.0),
                            ),
                            child: new TextFormField(
                              style: TextStyle(color: Colors.black),
                              controller: carbcontroler,
                              keyboardType: TextInputType.number,
                              // initialValue: 30.toString(),
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(2),
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              onChanged: (carbGoal) async {
                                cubit.setCarbGoal(cubit.calGoal /
                                    4 *
                                    (_carbGoalPercentage / 100));
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    Text(
                      "Kooly",
                      textAlign: TextAlign.center,
                      style: TextStyle().copyWith(fontSize: 18.0),
                    ),
                    new Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            right: 10.0, left: 10, bottom: 20),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 244, 239, 239),
                            borderRadius: new BorderRadius.circular(10.0),
                          ),
                          child: new TextFormField(
                            style: TextStyle(color: Colors.black),
                            controller: proteincontroler,
                            keyboardType: TextInputType.number,
                            //  initialValue: 30.toString(),
                            // decoration: InputDecoration(hintText: '30'),
                            // onChanged: (newGoal) async {
                            //   cubit.setCalGoal(double.tryParse(newGoal));
                            // },
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(2),
                            ],
                            onChanged: (proteinGoal) async {
                              cubit.setProteinGoal(cubit.calGoal /
                                  4 *
                                  (_proteinGoalPercentage / 100));
                            },
                          ),
                        ),
                      ),
                    ),
                    Text(
                      "Eiwit",
                      textAlign: TextAlign.center,
                      style: TextStyle().copyWith(fontSize: 18.0),
                    ),
                    new Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            right: 10.0, left: 10, bottom: 20),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 244, 239, 239),
                            borderRadius: new BorderRadius.circular(10.0),
                          ),
                          child: new TextFormField(
                            style: TextStyle(color: Colors.black),
                            controller: fatcontroler,
                            keyboardType: TextInputType.number,
                            //  initialValue: _fatsGoalPercentage.toString() ? ,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(2),
                            ],
                            onChanged: (fatsGoal) async {
                              cubit.setFatsGoal(cubit.calGoal /
                                  9 *
                                  (_fatsGoalPercentage / 100));
                            },
                          ),
                        ),
                      ),
                    ),
                    Text(
                      "Vet",
                      textAlign: TextAlign.center,
                      style: TextStyle().copyWith(fontSize: 18.0),
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
              //Text('Koolhydraten percentage ${_carbGoalPercentage.toString()}'),
              Text('Koolhydraten totaal ${cubit.carbGoal.toStringAsFixed(0)}g'),
              //   Text('Koolhydraten hoeveel gram ${koolaantal.toString()}'),
              //Text('Eiwitten percentage ${_proteinGoalPercentage.toString()}'),
              Text('Eiwitten totaal ${cubit.proteinGoal.toStringAsFixed(0)}g'),

              //  Text('Vetten percentage ${_fatsGoalPercentage.toString()}'),
              Text('Vetten totaal ${cubit.fatsGoal.toStringAsFixed(0)}g'),

              Text(
                  'Calorie??n totaal ${((cubit.carbGoal * 4) + (cubit.proteinGoal * 4) + (cubit.fatsGoal * 9)).toStringAsFixed(0)}kcal'),

              Padding(
                padding: const EdgeInsets.only(top: 30.0, bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Jouw CO2 doel $_groupValue kg/co2 per dag',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    IconButton(
                      icon: const Icon(Icons.info),
                      color: kPrimaryColor,
                      // tooltip: 'Increase volume by 10',
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                              _buildPopupDialogCo2(context),
                        );
                      },
                    ),
                  ],
                ),
              ),

              // Padding(
              //   padding: const EdgeInsets.all(15.0),
              //   child: TextField(
              //     decoration: new InputDecoration(labelText: "Je eigen doel"),
              //     keyboardType: TextInputType.number,
//             inputFormatters: <TextInputFormatter>[
//     FilteringTextInputFormatter.digitsOnly
// ], // Only numbers can be entered
              //   ),
              // ),
              ListTile(
                title: Text('Gemiddelde Nederlander: 5 kg/CO???'),
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
                title: Text('Doel voor 2030: 2.58 kg/CO???'),
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
                title: Text('Doel voor 2030 (streng): 2.1 kg/CO???'),
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
                title: Text('Doel voor 2050: 1.1 kg/CO???'),
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
    return Padding(
      padding: const EdgeInsets.only(right: 40.0, left: 40, bottom: 20),
      child: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 244, 239, 239),
          borderRadius: new BorderRadius.circular(10.0),
        ),
        child: TextFormField(
          style: TextStyle(color: Colors.black),
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
        ),
      ),
    );
  }
}

Widget _buildPopupDialogCalorie(BuildContext context) {
  return new AlertDialog(
    scrollable: true,
    title: const Text(
      'Calorie doel',
      style: TextStyle(fontSize: 18),
    ),
    content: new Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text.rich(TextSpan(
            style: GoogleFonts.roboto(
              fontSize: 16,
            ),
            children: <TextSpan>[
              TextSpan(
                  text:
                      'Dit is je caloriegoal. Je kunt deze berekenen bij het kopje: Bereken BMR en AMR'),
            ])),
      ],
    ),
    actions: <Widget>[
      new FlatButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        //textColor: Theme.of(context).primaryColor,
        child: Text('Sluit'),
      ),
    ],
  );
}

Widget _buildPopupDialogRatio(BuildContext context) {
  return new AlertDialog(
    scrollable: true,
    title: const Text(
      'Verhouding',
      style: TextStyle(fontSize: 18),
    ),
    content: new Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text.rich(TextSpan(
            style: GoogleFonts.roboto(
              fontSize: 16,
            ),
            children: <TextSpan>[
              TextSpan(
                  text:
                      'De verhouding wat als advies wordt gegeven ligt voor koolhydraten tussen de 40 en 70 %, voor eiwitten is het advies tussen de 10 en 30 % en van vet hebben we ongeveer 25 tot 40 % nodig. De meest gebruikte verhouding is 50% koolhydraten, 30% eiwitten en 20% vet, of 40 ??? 30 ??? 30.'),
            ])),
      ],
    ),
    actions: <Widget>[
      new FlatButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        //textColor: Theme.of(context).primaryColor,
        child: Text('Sluit'),
      ),
    ],
  );
}

Widget _buildPopupDialogCo2(BuildContext context) {
  return new AlertDialog(
    scrollable: true,
    title: const Text(
      'CO2 doel',
      style: TextStyle(fontSize: 18),
    ),
    content: new Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text.rich(
          TextSpan(
            style: GoogleFonts.roboto(
              fontSize: 16,
            ),
            children: <TextSpan>[
              TextSpan(
                  text:
                      'Recente onderzoeken hebben uitgerekend dat de gemiddelde Nederlander 5.0 ?? 2.0kg CO???eq per persoon per dag eet. Mannen hebben over het algemeen een hogere voetafdruk dan vrouwen. Voor een gezond en duurzaam voedingspatroon zonder vlees, schommelde de gemiddelde CO???eq per persoon tussen de 2.3 en 3.0 kg CO???eq.\n\nOnderzoekers hebben uitgerekend dat als we ons willen houden aan de minder dan 1.5??C graden opwarming van de temperatuur op aarde (IPCC), we moeten streven in 2030  naar 2.05kg CO???eq per persoon per dag (pppd) in een strikt scenario en 2.5kg CO???eq pppd in een minder strikt scenario.\n\nEchter stellen de onderzoekers ook dat in 2050 onze CO???eq uitstoot 1,11kg kg CO???eq pppd moet bedragen. Voor meer info, zie tip&tricks'),
            ],
          ),
        ),
      ],
    ),
    actions: <Widget>[
      new FlatButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        //textColor: Theme.of(context).primaryColor,
        child: Text('Sluit'),
      ),
    ],
  );
}
