import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:food_app/Views/constants.dart';
import 'package:food_app/Widgets/custom_button.dart';
import 'package:food_app/shared/app_cubit.dart';
import 'package:food_app/shared/goal_cubit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class GoalsAddScreen extends StatefulWidget {
  const GoalsAddScreen({Key key}) : super(key: key);

  @override
  _GoalsAddScreenState createState() => _GoalsAddScreenState();
}

class _GoalsAddScreenState extends State<GoalsAddScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // final TextEditingController goalNameController= TextEditingController();
  // final TextEditingController goalValueController= TextEditingController();

  @override
  Widget build(BuildContext context) {
    GoalCubit goalCubit = GoalCubit.instance(context);

    String goalName = '';
    String goal = '';
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context).titlegoalsaddcsreen,
          ),
          backgroundColor: kPrimaryColor,
        ),
        body: Column(
          children: [
            Expanded(
              child: Container(
                margin: EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BlocConsumer<GoalCubit, GoalStates>(
                          listener: (BuildContext context, state) {},
                          listenWhen: (prevS, newS) {
                            if ((newS is DoneUploadingImageState &&
                                    prevS is StartUploadingImageState) ||
                                newS is StartUploadingImageState) {
                              return true;
                            } else
                              return false;
                          },
                          buildWhen: (prevS, newS) {
                            if ((newS is DoneUploadingImageState &&
                                    prevS is StartUploadingImageState) ||
                                newS is StartUploadingImageState) {
                              return true;
                            } else
                              return false;
                          },
                          builder: (BuildContext context, state) {
                            print('rebuild image');
                            return Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 10),
                                  width: double.infinity,
                                  height: 150,
                                  child: (goalCubit.state
                                          is StartUploadingImageState)
                                      ? Center(
                                          child: CircularProgressIndicator(),
                                        )
                                      : (goalCubit.state
                                                  is DoneUploadingImageState ||
                                              goalCubit.imageAsBytes != null)
                                          ? Image.memory(goalCubit.imageAsBytes)
                                          : Image.asset('assets/new_goal.png'),
                                ),
                                Positioned(
                                  right: 0,
                                  bottom: -15,
                                  child: TextButton.icon(
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20))),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              kPrimaryColor.withOpacity(0.7)),
                                    ),
                                    icon: Icon(
                                      Icons.image,
                                      color: Colors.white,
                                    ),
                                    label: Text(
                                      AppLocalizations.of(context)
                                          .buttonaddimage,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onPressed: () {
                                      goalCubit.pickGoalImage();
                                    },
                                  ),
                                ),
                              ],
                            );
                          }),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          AppLocalizations.of(context).title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: kPrimaryColor,
                          ),
                        ),
                      ),
                      TextFormField(
                        initialValue: goalCubit.goalName,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        onSaved: (value) {
                          goalName = value;
                          goalCubit.setGoalInfo(goalName: value);
                        },
                        onFieldSubmitted: (value) {
                          goalCubit.setGoalInfo(goalName: value);
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Row(children: [
                          Text(
                            AppLocalizations.of(context).co2goal,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: kPrimaryColor,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Icon(
                            Icons.info_outline,
                            color: kPrimaryColor,
                          ),
                          RichText(
                            text: TextSpan(
                              text: '',
                              style: TextStyle(
                                  fontSize: 16,
                                  background: Paint()..color = kPrimaryColor,
                                  color: Colors.white),
                              children: <TextSpan>[
                                TextSpan(
                                    text: 'Spaardoel voorbeelden',
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        showDialog<String>(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text('Voorbeelden'),
                                                content: RichText(
                                                  text: TextSpan(
                                                    text:
                                                        'Hier zijn wat voorbeelden van spaardoelen. Zo heeft één t-shirt een carbon footprint van ',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.black),
                                                    children: <TextSpan>[
                                                      TextSpan(
                                                        text: '7kg/CO₂-eq',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.green),
                                                        recognizer:
                                                            new TapGestureRecognizer()
                                                              ..onTap = () {
                                                                launch(
                                                                    'https://oneless.co.in/blogs/blog/carbon-footprint-of-a-t-shirt');
                                                              },
                                                      ),
                                                      TextSpan(
                                                        text:
                                                            ', één spijkerbroek ',
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      TextSpan(
                                                        text: '33,4 kg/CO₂-eq',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.green),
                                                        recognizer:
                                                            new TapGestureRecognizer()
                                                              ..onTap = () {
                                                                launch(
                                                                    'https://link.springer.com/article/10.1007/s11625-022-01131-0');
                                                              },
                                                      ),
                                                      TextSpan(
                                                        text:
                                                            ' en een enkeltje met de trein van Amsterdam naar Barcelona zo rond de ',
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      TextSpan(
                                                        text: '50 kg/CO₂-eq',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.green),
                                                        recognizer:
                                                            new TapGestureRecognizer()
                                                              ..onTap = () {
                                                                launch(
                                                                    'https://travelandclimate.org/');
                                                              },
                                                      ),
                                                      TextSpan(
                                                        text:
                                                            '. Bereken je reis zelf ',
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      TextSpan(
                                                        text: 'hier',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.green),
                                                        recognizer:
                                                            new TapGestureRecognizer()
                                                              ..onTap = () {
                                                                launch(
                                                                    'https://travelandclimate.org/');
                                                              },
                                                      ),
                                                    ],
                                                  ),
                                                ),
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
                                      },
                                    style: TextStyle(
                                        //    color: Colors.blue,
                                        )),
                                TextSpan(text: ''),
                              ],
                            ),
                          ),
                        ]),
                      ),
                      Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.38,
                            child: TextFormField(
                              initialValue: goalCubit.co2Goal.toString(),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              onSaved: (value) {
                                goal = value;
                                goalCubit.setGoalInfo(
                                    co2Goal: int.parse(value));
                              },
                              onFieldSubmitted: (value) {
                                goalCubit.setGoalInfo(
                                    co2Goal: int.parse(value));
                              },
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'kg/CO₂-eq',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: kPrimaryColor,
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(children: [
                        TextButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Theme.of(context).buttonColor),
                          ),
                          onPressed: () {
                            DatePicker.showDatePicker(
                              context,
                              showTitleActions: true,
                              theme: DatePickerTheme(),
                              currentTime:
                                  goalCubit.startDate ?? DateTime.now(),
                              minTime: DateTime(DateTime.now().year - 10),
                              maxTime: DateTime(DateTime.now().year + 10),
                              onChanged: (date) {
                                print('change $date');
                              },
                              onConfirm: (date) {
                                print('confirm $date');
                                goalCubit.setGoalInfo(startDate: date);
                              },
                              locale: LocaleType.en,
                            );
                          },
                          child: Text(
                            AppLocalizations.of(context).startdate,
                            style: TextStyle(
                                //color: Theme.of(context).primaryColor,
                                // color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        BlocConsumer<GoalCubit, GoalStates>(
                          listener: (BuildContext context, state) {},
                          builder: (BuildContext context, state) => Text(
                            '${DateFormat.yMMMMd().format(goalCubit.startDate)}',
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                //   color: Colors.black,
                                fontWeight: FontWeight.normal,
                                fontSize: 16),
                          ),
                        ),
                      ]),
                    ],
                  ),
                ),
              ),
            ),
            CustomButton(
              onPressed: () async {
                bool valid = _formKey.currentState.validate();
                if (valid) {
                  _formKey.currentState.save();
                  var d = goalCubit.startDate;

                  if (goalCubit.imageAsBytes == null) {
                    ByteData bytes =
                        await rootBundle.load('assets/new_goal.png');
                    goalCubit.imageAsBytes = bytes.buffer.asUint8List();
                  }

                  AppCubit.instance(context).insertIntoDB('goals', {
                    'userId': FirebaseAuth.instance.currentUser.uid,
                    'co2Goal': goalCubit.co2Goal,
                    'goalName': goalCubit.goalName,
                    'startDate':
                        DateTime(d.year, d.month, d.day).toIso8601String(),
                    'image': goalCubit.imageAsBytes
                  });
                  Navigator.of(context).pop();
                } else {
                  print('not valid');
                }
              },
              text: Text(AppLocalizations.of(context).buttonsavegoal),
            )
          ],
        ),
      ),
    );
  }
}
