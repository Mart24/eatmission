import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_app/shared/dairy_cubit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

import 'constants.dart';

class NutritionalDetailsPage extends StatelessWidget {
  const NutritionalDetailsPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String Koolhydratentotaal = AppLocalizations.of(context).carbsfulltext;
    String Vettentotaal = AppLocalizations.of(context).fatsfulltext;
    String Eiwittentotaal = AppLocalizations.of(context).proteinfulltext;
    String Calories = AppLocalizations.of(context).calories;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).fooddetailstext),
        backgroundColor: kPrimaryColor,
      ),
      body: BlocConsumer<DairyCubit, DairyStates>(
        listener: (BuildContext context, DairyStates states) {},
        builder: (BuildContext context, DairyStates states) {
          DairyCubit cubit = DairyCubit.instance(context);
          double calGoal = cubit.calGoal;
          print(cubit.proteinPercent);

          return CustomScrollView(
            slivers: <Widget>[
              // Text(
              //   "${foodDocument['name']}",
              //   style: new TextStyle(fontSize: 24.0),
              // ),

              SliverAppBar(
                automaticallyImplyLeading: false,
                expandedHeight: 200,
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
                            '${cubit.carbsPercent.toStringAsFixed(0)}% ${Koolhydratentotaal}':
                                cubit.carbsPercent,
                            '${cubit.proteinPercent.toStringAsFixed(0)}% ${Eiwittentotaal}':
                                cubit.proteinPercent,
                            '${cubit.fatPercent.toStringAsFixed(0)}% ${Vettentotaal}':
                                cubit.fatPercent,
                          },
                          centerText:
                              '${cubit.kCalSum.toStringAsFixed(0)} ${Calories}',
                          chartType: ChartType.ring,
                        ),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                child: Text(
                                  AppLocalizations.of(context).nutritiontext,
                                  style: TextStyle(
                                    color: kPrimaryColor,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onPressed: null,
                              ),
                              IconButton(
                                icon: const Icon(Icons.info),
                                color: kPrimaryColor,
                                // tooltip: 'Increase volume by 10',
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        _buildPopupDialog(context),
                                  );
                                },
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
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Container(
                        child: Column(
                          children: [
                            Container(
                              child: Table(
                                columnWidths: {
                                  0: FractionColumnWidth(0.52),
                                  1: FractionColumnWidth(0.22),
                                  2: FractionColumnWidth(0.12),
                                  3: FractionColumnWidth(0.15)
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
                                        AppLocalizations.of(context).typetext,
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Text(
                                      AppLocalizations.of(context).howmuchtext,
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      '%',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      AppLocalizations.of(context).advicetext,
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ]),
                                  TableRow(children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5.0),
                                      child: Text(
                                        AppLocalizations.of(context).energy,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Text(
                                      '${cubit.kCalSum.toStringAsFixed(0)}kcal',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      '${(100 - ((calGoal - cubit.kCalSum) / calGoal) * 100).toStringAsFixed(0)}%',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      '',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ]),
                                  TableRow(children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5.0),
                                      child: Text(
                                        AppLocalizations.of(context)
                                            .totallproteintext,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Text(
                                      '${cubit.protein.toStringAsFixed(0)}g',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      '${cubit.proteinPercent.toStringAsFixed(0)}%',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      '',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ]),
                                  TableRow(children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10.0),
                                      child: Text(
                                        AppLocalizations.of(context)
                                            .proteinplanttext,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Text(
                                      '${cubit.proteinplant.toStringAsFixed(0)}g',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      '${cubit.proteinPlantPercent.toStringAsFixed(0)}%',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      '',
                                      style: TextStyle(fontSize: 16),
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
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Text(
                                      '${cubit.proteinanimal.toStringAsFixed(0)}g',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      '${cubit.proteinAnimalPercent.toStringAsFixed(0)}%',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      '',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ]),
                                  TableRow(children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5.0),
                                      child: Text(
                                        AppLocalizations.of(context)
                                            .totalfattext,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Text(
                                      '${cubit.fats}g',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      '${cubit.fatPercent.toStringAsFixed(0)}%',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      '',
                                      style: TextStyle(fontSize: 16),
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
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Text(
                                      '${cubit.saturatedFat}g',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      '${cubit.saturatedFatPercent.toStringAsFixed(0)}%',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      '10%',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.red),
                                    ),
                                  ]),
                                  TableRow(children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5.0),
                                      child: Text(
                                        AppLocalizations.of(context)
                                            .totalcarbstext,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Text(
                                      '${cubit.carbs.toStringAsFixed(0)}g',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      '${cubit.carbsPercent.toStringAsFixed(0)}%',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      '',
                                      style: TextStyle(fontSize: 16),
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
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Text(
                                      '${cubit.sugars.toStringAsFixed(0)}g',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      '${cubit.sugarsPercent.toStringAsFixed(0)}%',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      '60g',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.red),
                                    )
                                  ]),
                                  TableRow(children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5.0),
                                      child: Text(
                                        AppLocalizations.of(context)
                                            .dotsfiberstext,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Text(
                                      '${cubit.dietaryFiber}g',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      '${cubit.dietaryFiberPercent.toStringAsFixed(0)}%',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      '30-40g',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.green),
                                    ),
                                  ]),
                                  TableRow(children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5.0),
                                      child: Text(
                                        AppLocalizations.of(context).salttext,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Text(
                                      '${cubit.salt}g',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      '',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      '6g',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.red),
                                    ),
                                  ]),
                                ],
                              ),
                            ),
                          ],
                        ),
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
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Container(
                        child: Column(
                          children: [
                            Container(
                              child: Table(
                                columnWidths: {
                                  0: FractionColumnWidth(0.52),
                                  1: FractionColumnWidth(0.22),
                                  2: FractionColumnWidth(0.07),
                                  3: FractionColumnWidth(0.19)
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
                                        AppLocalizations.of(context).typetext,
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Text(
                                      AppLocalizations.of(context).howmuchtext,
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      '',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    // Text(
                                    //   AppLocalizations.of(context).advicetext,
                                    //   style: TextStyle(fontSize: 16),
                                    // ),

                                    Column(
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.info),
                                          color: kPrimaryColor,
                                          // tooltip: 'Increase volume by 10',
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  _buildPopupDialog(context),
                                            );
                                          },
                                        ),
                                        // RichText(
                                        //   text: TextSpan(
                                        //     text: '',
                                        //     style: TextStyle(
                                        //         background: Paint()
                                        //           ..color = kPrimaryColor,
                                        //         fontSize: 16,
                                        //         color: Colors.white),
                                        //     children: <TextSpan>[
                                        //       TextSpan(
                                        //           text: AppLocalizations.of(
                                        //                   context)
                                        //               .advicetext,
                                        //           recognizer:
                                        //               TapGestureRecognizer()
                                        //                 ..onTap = () {
                                        //                   showDialog<String>(
                                        //                       context: context,
                                        //                       builder:
                                        //                           (BuildContext
                                        //                               context) {
                                        //                         return AlertDialog(
                                        //                           title: Text(AppLocalizations.of(
                                        //                                   context)
                                        //                               .advicetext),
                                        //                           content: Text.rich(
                                        //                               TextSpan(
                                        //                                   style: GoogleFonts
                                        //                                       .roboto(
                                        //                                     fontSize:
                                        //                                         16,
                                        //                                   ),
                                        //                                   children: <
                                        //                                       TextSpan>[
                                        //                                 TextSpan(
                                        //                                     text:
                                        //                                         'Let op: Dit zijn richtlijnen. Met een gevarieerd dieet krijg je de juiste voedingsstoffen binnen. '),
                                        //                                 TextSpan(
                                        //                                   text:
                                        //                                       'Rood',
                                        //                                   style: TextStyle(
                                        //                                       fontWeight: FontWeight.bold,
                                        //                                       color: Colors.red),
                                        //                                 ),
                                        //                                 TextSpan(
                                        //                                     text:
                                        //                                         ' is het maximale en ',
                                        //                                     style:
                                        //                                         TextStyle(fontSize: 16)),
                                        //                                 TextSpan(
                                        //                                   text:
                                        //                                       'Groen',
                                        //                                   style: TextStyle(
                                        //                                       fontWeight: FontWeight.bold,
                                        //                                       color: Colors.green),
                                        //                                 ),
                                        //                                 TextSpan(
                                        //                                     text:
                                        //                                         ' staat voor de minimale consumptie per dag. Voor meer informatie, kijk op de website voedingscentrum.nl',
                                        //                                     style:
                                        //                                         TextStyle(fontSize: 16)),
                                        //                               ])),
                                        //                           actions: <
                                        //                               Widget>[
                                        //                             TextButton(
                                        //                               onPressed: () => Navigator.pop(
                                        //                                   context,
                                        //                                   'OK'),
                                        //                               child: const Text(
                                        //                                   'OK'),
                                        //                             ),
                                        //                           ],
                                        //                         );
                                        //                       });
                                        //                 },
                                        //           style: TextStyle(
                                        //               //    color: Colors.blue,
                                        //               )),
                                        //       TextSpan(text: ''),
                                        //     ],
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                  ]),
                                  TableRow(children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5.0),
                                      child:
                                          //
                                          RichText(
                                        text: TextSpan(
                                          text: '',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context)
                                                  .primaryColor),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: 'Alcohol',
                                                recognizer:
                                                    TapGestureRecognizer()
                                                      ..onTap = () {
                                                        showDialog<String>(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return AlertDialog(
                                                                title: Text(
                                                                    ' Alcohol'),
                                                                content:
                                                                    RichText(
                                                                  text:
                                                                      TextSpan(
                                                                    text:
                                                                        'Het advies is om geen alcohol te drinken, of in ieder geval niet meer dan 1 glas per dag. Dit advies is hetzelfde voor mannen en vrouwen.',
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                    ),
                                                                    children: <
                                                                        TextSpan>[
                                                                      TextSpan(
                                                                        text:
                                                                            ' Meer informatie',
                                                                        style: new TextStyle(
                                                                            color:
                                                                                Colors.blue),
                                                                        recognizer:
                                                                            new TapGestureRecognizer()
                                                                              ..onTap = () {
                                                                                launch('https://www.voedingscentrum.nl/encyclopedie/alcohol.aspx');
                                                                              },
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                actions: <
                                                                    Widget>[
                                                                  TextButton(
                                                                    onPressed: () =>
                                                                        Navigator.pop(
                                                                            context,
                                                                            'OK'),
                                                                    child: const Text(
                                                                        'OK',
                                                                        style: TextStyle(
                                                                            color:
                                                                                kPrimaryColor)),
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

                                      // ),
                                    ),
                                    Text(
                                      '${cubit.alcohol}g',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      '',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      '',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.green),
                                    ),
                                  ]),
                                  TableRow(children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5.0),
                                      child:
                                          //
                                          RichText(
                                        text: TextSpan(
                                          text: '',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context)
                                                  .primaryColor),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: 'Calcium',
                                                recognizer:
                                                    TapGestureRecognizer()
                                                      ..onTap = () {
                                                        showDialog<String>(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return AlertDialog(
                                                                title: Text(
                                                                    ' Calcium'),
                                                                content:
                                                                    RichText(
                                                                  text:
                                                                      TextSpan(
                                                                    text:
                                                                        'Calcium is een mineraal dat je nodig hebt voor de opbouw en het onderhoud van de botten en het gebit. Calcium helpt tegen botontkalking op latere leeftijd en is nodig voor een goede werking van de zenuwen en spieren, de bloedstolling en het transport van andere mineralen in het lichaam.',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            16,
                                                                        color: Theme.of(context)
                                                                            .primaryColor),
                                                                    children: <
                                                                        TextSpan>[
                                                                      TextSpan(
                                                                        text:
                                                                            ' Meer informatie',
                                                                        style: new TextStyle(
                                                                            color:
                                                                                Colors.blue),
                                                                        recognizer:
                                                                            new TapGestureRecognizer()
                                                                              ..onTap = () {
                                                                                launch('https://www.voedingscentrum.nl/encyclopedie/calcium.aspx');
                                                                              },
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                actions: <
                                                                    Widget>[
                                                                  TextButton(
                                                                    onPressed: () =>
                                                                        Navigator.pop(
                                                                            context,
                                                                            'OK'),
                                                                    child: const Text(
                                                                        'OK',
                                                                        style: TextStyle(
                                                                            color:
                                                                                kPrimaryColor)),
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

                                      // ),
                                    ),
                                    Text(
                                      '${cubit.calcium.toStringAsFixed(0)} mg',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      '',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      '950 mg',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.green),
                                    ),
                                  ]),
                                  TableRow(children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5.0),
                                      child:
                                          //
                                          RichText(
                                        text: TextSpan(
                                          text: '',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context)
                                                  .primaryColor),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: 'Foliumzuur',
                                                recognizer:
                                                    TapGestureRecognizer()
                                                      ..onTap = () {
                                                        showDialog<String>(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return AlertDialog(
                                                                title: Text(
                                                                    ' Foliumzuur'),
                                                                content:
                                                                    RichText(
                                                                  text:
                                                                      TextSpan(
                                                                    text:
                                                                        'Foliumzuur (vitamine B11) is nodig voor de groei en goede werking van het lichaam en voor de aanmaak van witte en rode bloedcellen. Foliumzuur is ook belangrijk voor de vroege ontwikkeling van het ongeboren kind.',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            16,
                                                                        color: Theme.of(context)
                                                                            .primaryColor),
                                                                    children: <
                                                                        TextSpan>[
                                                                      TextSpan(
                                                                        text:
                                                                            ' Meer informatie',
                                                                        style: new TextStyle(
                                                                            color:
                                                                                Colors.blue),
                                                                        recognizer:
                                                                            new TapGestureRecognizer()
                                                                              ..onTap = () {
                                                                                launch('https://www.voedingscentrum.nl/encyclopedie/foliumzuur.aspx');
                                                                              },
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                actions: <
                                                                    Widget>[
                                                                  TextButton(
                                                                    onPressed: () =>
                                                                        Navigator.pop(
                                                                            context,
                                                                            'OK'),
                                                                    child: const Text(
                                                                        'OK',
                                                                        style: TextStyle(
                                                                            color:
                                                                                kPrimaryColor)),
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

                                      // ),
                                    ),
                                    Text(
                                      '${cubit.foliumzuur.toStringAsFixed(0)} mg',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      '',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      '300 mg',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.green),
                                    ),
                                  ]),
                                  TableRow(children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5.0),
                                      child:
                                          //
                                          RichText(
                                        text: TextSpan(
                                          text: '',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context)
                                                  .primaryColor),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: 'Fosfor',
                                                recognizer:
                                                    TapGestureRecognizer()
                                                      ..onTap = () {
                                                        showDialog<String>(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return AlertDialog(
                                                                title: Text(
                                                                    ' Fosfor'),
                                                                content:
                                                                    RichText(
                                                                  text:
                                                                      TextSpan(
                                                                    text:
                                                                        'Fosfor',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            16,
                                                                        color: Theme.of(context)
                                                                            .primaryColor),
                                                                    children: <
                                                                        TextSpan>[
                                                                      TextSpan(
                                                                        text:
                                                                            ' Meer informatie',
                                                                        style: new TextStyle(
                                                                            color:
                                                                                Colors.blue),
                                                                        recognizer:
                                                                            new TapGestureRecognizer()
                                                                              ..onTap = () {
                                                                                launch('https://www.voedingscentrum.nl/encyclopedie/fosfor.aspx');
                                                                              },
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                actions: <
                                                                    Widget>[
                                                                  TextButton(
                                                                    onPressed: () =>
                                                                        Navigator.pop(
                                                                            context,
                                                                            'OK'),
                                                                    child: const Text(
                                                                        'OK',
                                                                        style: TextStyle(
                                                                            color:
                                                                                kPrimaryColor)),
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

                                      // ),
                                    ),
                                    Text(
                                      '${cubit.fosfor.toStringAsFixed(0)} µg',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      '',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      '550 µg',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.green),
                                    ),
                                  ]),
                                  TableRow(children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5.0),
                                      child:
                                          //
                                          RichText(
                                        text: TextSpan(
                                          text: '',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context)
                                                  .primaryColor),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: 'IJzer',
                                                recognizer:
                                                    TapGestureRecognizer()
                                                      ..onTap = () {
                                                        showDialog<String>(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return AlertDialog(
                                                                title: Text(
                                                                    ' IJZer'),
                                                                content:
                                                                    RichText(
                                                                  text:
                                                                      TextSpan(
                                                                    text:
                                                                        'IJzer',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            16,
                                                                        color: Theme.of(context)
                                                                            .primaryColor),
                                                                    children: <
                                                                        TextSpan>[
                                                                      TextSpan(
                                                                        text:
                                                                            ' Meer informatie',
                                                                        style: new TextStyle(
                                                                            color:
                                                                                Colors.blue),
                                                                        recognizer:
                                                                            new TapGestureRecognizer()
                                                                              ..onTap = () {
                                                                                launch('https://www.voedingscentrum.nl/encyclopedie/ijzer.aspx');
                                                                              },
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                actions: <
                                                                    Widget>[
                                                                  TextButton(
                                                                    onPressed: () =>
                                                                        Navigator.pop(
                                                                            context,
                                                                            'OK'),
                                                                    child: const Text(
                                                                        'OK',
                                                                        style: TextStyle(
                                                                            color:
                                                                                kPrimaryColor)),
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

                                      // ),
                                    ),
                                    Text(
                                      '${cubit.iron.toStringAsFixed(0)} mg',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      '',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      '11-16mg',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.green),
                                    ),
                                  ]),
                                  TableRow(children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5.0),
                                      child:
                                          //
                                          RichText(
                                        text: TextSpan(
                                          text: '',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context)
                                                  .primaryColor),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: 'Jodium',
                                                recognizer:
                                                    TapGestureRecognizer()
                                                      ..onTap = () {
                                                        showDialog<String>(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return AlertDialog(
                                                                title: Text(
                                                                    ' Jodium'),
                                                                content:
                                                                    RichText(
                                                                  text:
                                                                      TextSpan(
                                                                    text:
                                                                        'Jodium',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            16,
                                                                        color: Theme.of(context)
                                                                            .primaryColor),
                                                                    children: <
                                                                        TextSpan>[
                                                                      TextSpan(
                                                                        text:
                                                                            ' Meer informatie',
                                                                        style: new TextStyle(
                                                                            color:
                                                                                Colors.blue),
                                                                        recognizer:
                                                                            new TapGestureRecognizer()
                                                                              ..onTap = () {
                                                                                launch('https://www.voedingscentrum.nl/encyclopedie/Jodium.aspx');
                                                                              },
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                actions: <
                                                                    Widget>[
                                                                  TextButton(
                                                                    onPressed: () =>
                                                                        Navigator.pop(
                                                                            context,
                                                                            'OK'),
                                                                    child: const Text(
                                                                        'OK',
                                                                        style: TextStyle(
                                                                            color:
                                                                                kPrimaryColor)),
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

                                      // ),
                                    ),
                                    Text(
                                      '${cubit.jodium.toStringAsFixed(0)} µg',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      '',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      '150 µg',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.green),
                                    ),
                                  ]),
                                  TableRow(children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5.0),
                                      child:
                                          //
                                          RichText(
                                        text: TextSpan(
                                          text: '',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context)
                                                  .primaryColor),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: 'Kalium',
                                                recognizer:
                                                    TapGestureRecognizer()
                                                      ..onTap = () {
                                                        showDialog<String>(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return AlertDialog(
                                                                title: Text(
                                                                    ' Kalium'),
                                                                content:
                                                                    RichText(
                                                                  text:
                                                                      TextSpan(
                                                                    text:
                                                                        'Kalium',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            16,
                                                                        color: Theme.of(context)
                                                                            .primaryColor),
                                                                    children: <
                                                                        TextSpan>[
                                                                      TextSpan(
                                                                        text:
                                                                            ' Meer informatie',
                                                                        style: new TextStyle(
                                                                            color:
                                                                                Colors.blue),
                                                                        recognizer:
                                                                            new TapGestureRecognizer()
                                                                              ..onTap = () {
                                                                                launch('https://www.voedingscentrum.nl/encyclopedie/kalium.aspx');
                                                                              },
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                actions: <
                                                                    Widget>[
                                                                  TextButton(
                                                                    onPressed: () =>
                                                                        Navigator.pop(
                                                                            context,
                                                                            'OK'),
                                                                    child: const Text(
                                                                        'OK',
                                                                        style: TextStyle(
                                                                            color:
                                                                                kPrimaryColor)),
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

                                      // ),
                                    ),
                                    Text(
                                      '${cubit.kalium.toStringAsFixed(0)} mg',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      '',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      '3500 mg',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.green),
                                    ),
                                  ]),
                                  TableRow(children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5.0),
                                      child:
                                          //
                                          RichText(
                                        text: TextSpan(
                                          text: '',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context)
                                                  .primaryColor),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: 'Magnesium',
                                                recognizer:
                                                    TapGestureRecognizer()
                                                      ..onTap = () {
                                                        showDialog<String>(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return AlertDialog(
                                                                title: Text(
                                                                    ' Magnesium'),
                                                                content:
                                                                    RichText(
                                                                  text:
                                                                      TextSpan(
                                                                    text:
                                                                        'Magnesium',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            16,
                                                                        color: Theme.of(context)
                                                                            .primaryColor),
                                                                    children: <
                                                                        TextSpan>[
                                                                      TextSpan(
                                                                        text:
                                                                            ' Meer informatie',
                                                                        style: new TextStyle(
                                                                            color:
                                                                                Colors.blue),
                                                                        recognizer:
                                                                            new TapGestureRecognizer()
                                                                              ..onTap = () {
                                                                                launch('https://www.voedingscentrum.nl/encyclopedie/magnesium.aspx');
                                                                              },
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                actions: <
                                                                    Widget>[
                                                                  TextButton(
                                                                    onPressed: () =>
                                                                        Navigator.pop(
                                                                            context,
                                                                            'OK'),
                                                                    child: const Text(
                                                                        'OK',
                                                                        style: TextStyle(
                                                                            color:
                                                                                kPrimaryColor)),
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

                                      // ),
                                    ),
                                    Text(
                                      '${cubit.magnesium.toStringAsFixed(0)}mg',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      '',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      '350 mg',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.green),
                                    ),
                                  ]),
                                  TableRow(children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5.0),
                                      child:
                                          //
                                          RichText(
                                        text: TextSpan(
                                          text: '',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context)
                                                  .primaryColor),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: 'Natrium',
                                                recognizer:
                                                    TapGestureRecognizer()
                                                      ..onTap = () {
                                                        showDialog<String>(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return AlertDialog(
                                                                title: Text(
                                                                    ' Natrium'),
                                                                content:
                                                                    RichText(
                                                                  text:
                                                                      TextSpan(
                                                                    text:
                                                                        'Natrium',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            16,
                                                                        color: Theme.of(context)
                                                                            .primaryColor),
                                                                    children: <
                                                                        TextSpan>[
                                                                      TextSpan(
                                                                        text:
                                                                            ' Meer informatie',
                                                                        style: new TextStyle(
                                                                            color:
                                                                                Colors.blue),
                                                                        recognizer:
                                                                            new TapGestureRecognizer()
                                                                              ..onTap = () {
                                                                                launch('https://www.voedingscentrum.nl/encyclopedie/zout-en-natrium.aspx');
                                                                              },
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                actions: <
                                                                    Widget>[
                                                                  TextButton(
                                                                    onPressed: () =>
                                                                        Navigator.pop(
                                                                            context,
                                                                            'OK'),
                                                                    child: const Text(
                                                                        'OK',
                                                                        style: TextStyle(
                                                                            color:
                                                                                kPrimaryColor)),
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

                                      // ),
                                    ),
                                    Text(
                                      '${cubit.natrium.toStringAsFixed(0)}mg',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      '',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      '1500 mg',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.green),
                                    ),
                                  ]),
                                  TableRow(children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5.0),
                                      child:
                                          //
                                          RichText(
                                        text: TextSpan(
                                          text: '',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context)
                                                  .primaryColor),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: 'Niacine',
                                                recognizer:
                                                    TapGestureRecognizer()
                                                      ..onTap = () {
                                                        showDialog<String>(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return AlertDialog(
                                                                title: Text(
                                                                    ' Niacine'),
                                                                content:
                                                                    RichText(
                                                                  text:
                                                                      TextSpan(
                                                                    text:
                                                                        'Niacine',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            16,
                                                                        color: Theme.of(context)
                                                                            .primaryColor),
                                                                    children: <
                                                                        TextSpan>[
                                                                      TextSpan(
                                                                        text:
                                                                            ' Meer informatie',
                                                                        style: new TextStyle(
                                                                            color:
                                                                                Colors.blue),
                                                                        recognizer:
                                                                            new TapGestureRecognizer()
                                                                              ..onTap = () {
                                                                                launch('https://www.voedingscentrum.nl/encyclopedie/niacine.aspx');
                                                                              },
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                actions: <
                                                                    Widget>[
                                                                  TextButton(
                                                                    onPressed: () =>
                                                                        Navigator.pop(
                                                                            context,
                                                                            'OK'),
                                                                    child: const Text(
                                                                        'OK',
                                                                        style: TextStyle(
                                                                            color:
                                                                                kPrimaryColor)),
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

                                      // ),
                                    ),
                                    Text(
                                      '${cubit.niacine.toStringAsFixed(0)}mg',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      '',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      '',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.green),
                                    ),
                                  ]),
                                  TableRow(children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5.0),
                                      child:
                                          //
                                          RichText(
                                        text: TextSpan(
                                          text: '',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context)
                                                  .primaryColor),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: 'Selenium',
                                                recognizer:
                                                    TapGestureRecognizer()
                                                      ..onTap = () {
                                                        showDialog<String>(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return AlertDialog(
                                                                title: Text(
                                                                    ' Selenium'),
                                                                content:
                                                                    RichText(
                                                                  text:
                                                                      TextSpan(
                                                                    text:
                                                                        'Selenium',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            16,
                                                                        color: Theme.of(context)
                                                                            .primaryColor),
                                                                    children: <
                                                                        TextSpan>[
                                                                      TextSpan(
                                                                        text:
                                                                            ' Meer informatie',
                                                                        style: new TextStyle(
                                                                            color:
                                                                                Colors.blue),
                                                                        recognizer:
                                                                            new TapGestureRecognizer()
                                                                              ..onTap = () {
                                                                                launch('https://www.voedingscentrum.nl/encyclopedie/seleen.aspx');
                                                                              },
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                actions: <
                                                                    Widget>[
                                                                  TextButton(
                                                                    onPressed: () =>
                                                                        Navigator.pop(
                                                                            context,
                                                                            'OK'),
                                                                    child: const Text(
                                                                        'OK',
                                                                        style: TextStyle(
                                                                            color:
                                                                                kPrimaryColor)),
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

                                      // ),
                                    ),
                                    Text(
                                      '${cubit.selenium.toStringAsFixed(0)} mg',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      '',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      '70 mg',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.green),
                                    ),
                                  ]),
                                  TableRow(children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5.0),
                                      child:
                                          //
                                          RichText(
                                        text: TextSpan(
                                          text: '',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context)
                                                  .primaryColor),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: 'VitA',
                                                recognizer:
                                                    TapGestureRecognizer()
                                                      ..onTap = () {
                                                        showDialog<String>(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return AlertDialog(
                                                                title: Text(
                                                                    ' Vitamine A'),
                                                                content:
                                                                    //Text(
                                                                    //     "Vitamine A zit in dierlijke producten, zoals vlees en vleeswaren, zuivelproducten, vis en eidooier. Daarnaast zit het als toevoeging in margarine, halvarine en bak- en braadproducten."),
                                                                    RichText(
                                                                  text:
                                                                      TextSpan(
                                                                    text:
                                                                        'Om gezond te blijven is de dagelijkse aanbeveling van vitamine A voor een volwassen man 800 microgram en voor een volwassen vrouw 680 microgram.',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            16,
                                                                        color: Theme.of(context)
                                                                            .primaryColor),
                                                                    children: <
                                                                        TextSpan>[
                                                                      TextSpan(
                                                                        text:
                                                                            ' Meer informatie',
                                                                        style: new TextStyle(
                                                                            color:
                                                                                Colors.blue),
                                                                        recognizer:
                                                                            new TapGestureRecognizer()
                                                                              ..onTap = () {
                                                                                launch('https://www.voedingscentrum.nl/encyclopedie/vitamine-a.aspx');
                                                                              },
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                actions: <
                                                                    Widget>[
                                                                  TextButton(
                                                                    onPressed: () =>
                                                                        Navigator.pop(
                                                                            context,
                                                                            'OK'),
                                                                    child: const Text(
                                                                        'OK',
                                                                        style: TextStyle(
                                                                            color:
                                                                                kPrimaryColor)),
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
                                    ),
                                    Text(
                                      '${cubit.vitA} µg',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      '',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      '800µg',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.green),
                                    ),
                                  ]),
                                  TableRow(children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5.0),
                                      child:
                                          //
                                          RichText(
                                        text: TextSpan(
                                          text: '',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context)
                                                  .primaryColor),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: 'Vit B1',
                                                recognizer:
                                                    TapGestureRecognizer()
                                                      ..onTap = () {
                                                        showDialog<String>(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return AlertDialog(
                                                                title: Text(
                                                                    ' Vitamine B1'),
                                                                content:
                                                                    //Text(
                                                                    //     "Vitamine A zit in dierlijke producten, zoals vlees en vleeswaren, zuivelproducten, vis en eidooier. Daarnaast zit het als toevoeging in margarine, halvarine en bak- en braadproducten."),
                                                                    RichText(
                                                                  text:
                                                                      TextSpan(
                                                                    text:
                                                                        'Vitamine B1',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            16,
                                                                        color: Theme.of(context)
                                                                            .primaryColor),
                                                                    children: <
                                                                        TextSpan>[
                                                                      TextSpan(
                                                                        text:
                                                                            ' Meer informatie',
                                                                        style: new TextStyle(
                                                                            color:
                                                                                Colors.blue),
                                                                        recognizer:
                                                                            new TapGestureRecognizer()
                                                                              ..onTap = () {
                                                                                launch('https://www.voedingscentrum.nl/encyclopedie/vitamine-B1.aspx');
                                                                              },
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                actions: <
                                                                    Widget>[
                                                                  TextButton(
                                                                    onPressed: () =>
                                                                        Navigator.pop(
                                                                            context,
                                                                            'OK'),
                                                                    child: const Text(
                                                                        'OK',
                                                                        style: TextStyle(
                                                                            color:
                                                                                kPrimaryColor)),
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
                                    ),
                                    Text(
                                      '${cubit.vitB1} mg',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      '',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      '${((cubit.kCalSum * 0.0041868) * 0.1).toStringAsFixed(1)} mg',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.green),
                                    ),
                                  ]),
                                  TableRow(children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5.0),
                                      child:
                                          //
                                          RichText(
                                        text: TextSpan(
                                          text: '',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context)
                                                  .primaryColor),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: 'Vitamine B12',
                                                recognizer:
                                                    TapGestureRecognizer()
                                                      ..onTap = () {
                                                        showDialog<String>(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return AlertDialog(
                                                                title: Text(
                                                                    ' Vitamine B12'),
                                                                content:
                                                                    RichText(
                                                                  text:
                                                                      TextSpan(
                                                                    text:
                                                                        'Vitamine B12',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            16,
                                                                        color: Theme.of(context)
                                                                            .primaryColor),
                                                                    children: <
                                                                        TextSpan>[
                                                                      TextSpan(
                                                                        text:
                                                                            ' Meer informatie',
                                                                        style: new TextStyle(
                                                                            color:
                                                                                Colors.blue),
                                                                        recognizer:
                                                                            new TapGestureRecognizer()
                                                                              ..onTap = () {
                                                                                launch('https://www.voedingscentrum.nl/encyclopedie/vitamine-b12.aspx');
                                                                              },
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                actions: <
                                                                    Widget>[
                                                                  TextButton(
                                                                    onPressed: () =>
                                                                        Navigator.pop(
                                                                            context,
                                                                            'OK'),
                                                                    child: const Text(
                                                                        'OK',
                                                                        style: TextStyle(
                                                                            color:
                                                                                kPrimaryColor)),
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

                                      // ),
                                    ),
                                    Text(
                                      '${cubit.vitB12.toStringAsFixed(1)} µg',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      '',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      '2.8 µg',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.green),
                                    ),
                                  ]),
                                  TableRow(children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5.0),
                                      child:
                                          //
                                          RichText(
                                        text: TextSpan(
                                          text: '',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context)
                                                  .primaryColor),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: 'Vitamine B2',
                                                recognizer:
                                                    TapGestureRecognizer()
                                                      ..onTap = () {
                                                        showDialog<String>(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return AlertDialog(
                                                                title: Text(
                                                                    ' Vitamine B2'),
                                                                content:
                                                                    RichText(
                                                                  text:
                                                                      TextSpan(
                                                                    text:
                                                                        'Vitamine B2',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            16,
                                                                        color: Theme.of(context)
                                                                            .primaryColor),
                                                                    children: <
                                                                        TextSpan>[
                                                                      TextSpan(
                                                                        text:
                                                                            ' Meer informatie',
                                                                        style: new TextStyle(
                                                                            color:
                                                                                Colors.blue),
                                                                        recognizer:
                                                                            new TapGestureRecognizer()
                                                                              ..onTap = () {
                                                                                launch('https://www.voedingscentrum.nl/encyclopedie/vitamine-b2.aspx');
                                                                              },
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                actions: <
                                                                    Widget>[
                                                                  TextButton(
                                                                    onPressed: () =>
                                                                        Navigator.pop(
                                                                            context,
                                                                            'OK'),
                                                                    child: const Text(
                                                                        'OK',
                                                                        style: TextStyle(
                                                                            color:
                                                                                kPrimaryColor)),
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

                                      // ),
                                    ),
                                    Text(
                                      '${cubit.vitB2.toStringAsFixed(1)} mg',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      '',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      '1.6 mg',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.green),
                                    ),
                                  ]),
                                  TableRow(children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5.0),
                                      child:
                                          //
                                          RichText(
                                        text: TextSpan(
                                          text: '',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context)
                                                  .primaryColor),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: 'Vitamine B6',
                                                recognizer:
                                                    TapGestureRecognizer()
                                                      ..onTap = () {
                                                        showDialog<String>(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return AlertDialog(
                                                                title: Text(
                                                                    ' Vitamine B6'),
                                                                content:
                                                                    RichText(
                                                                  text:
                                                                      TextSpan(
                                                                    text:
                                                                        'Vitamine B6',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            16,
                                                                        color: Theme.of(context)
                                                                            .primaryColor),
                                                                    children: <
                                                                        TextSpan>[
                                                                      TextSpan(
                                                                        text:
                                                                            ' Meer informatie',
                                                                        style: new TextStyle(
                                                                            color:
                                                                                Colors.blue),
                                                                        recognizer:
                                                                            new TapGestureRecognizer()
                                                                              ..onTap = () {
                                                                                launch('https://www.voedingscentrum.nl/encyclopedie/vitamine-b6.aspx');
                                                                              },
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                actions: <
                                                                    Widget>[
                                                                  TextButton(
                                                                    onPressed: () =>
                                                                        Navigator.pop(
                                                                            context,
                                                                            'OK'),
                                                                    child:
                                                                        const Text(
                                                                      'OK',
                                                                      style: TextStyle(
                                                                          color:
                                                                              kPrimaryColor),
                                                                    ),
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

                                      // ),
                                    ),
                                    Text(
                                      '${cubit.vitB6.toStringAsFixed(1)} mg',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      '',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      '1.5 mg',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.green),
                                    ),
                                  ]),
                                  TableRow(children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5.0),
                                      child:
                                          //
                                          RichText(
                                        text: TextSpan(
                                          text: '',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context)
                                                  .primaryColor),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: 'Vit D',
                                                recognizer:
                                                    TapGestureRecognizer()
                                                      ..onTap = () {
                                                        showDialog<String>(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return AlertDialog(
                                                                title: Text(
                                                                    ' Vitamine D'),
                                                                content:
                                                                    //Text(
                                                                    //     "Vitamine A zit in dierlijke producten, zoals vlees en vleeswaren, zuivelproducten, vis en eidooier. Daarnaast zit het als toevoeging in margarine, halvarine en bak- en braadproducten."),
                                                                    RichText(
                                                                  text:
                                                                      TextSpan(
                                                                    text:
                                                                        'Vitamine D is een vetoplosbare vitamine. Vitamine D is een van de weinige vitamines die het lichaam zelf kan maken. Onder invloed van zonlicht wordt in de huid vitamine D gevormd. Daarnaast levert de voeding vitamine D.',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            16,
                                                                        color: Theme.of(context)
                                                                            .primaryColor),
                                                                    children: <
                                                                        TextSpan>[
                                                                      TextSpan(
                                                                        text:
                                                                            ' Meer informatie',
                                                                        style: new TextStyle(
                                                                            color:
                                                                                Colors.blue),
                                                                        recognizer:
                                                                            new TapGestureRecognizer()
                                                                              ..onTap = () {
                                                                                launch('https://www.voedingscentrum.nl/encyclopedie/vitamine-d.aspx');
                                                                              },
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                actions: <
                                                                    Widget>[
                                                                  TextButton(
                                                                    onPressed: () =>
                                                                        Navigator.pop(
                                                                            context,
                                                                            'OK'),
                                                                    child: const Text(
                                                                        'OK',
                                                                        style: TextStyle(
                                                                            color:
                                                                                kPrimaryColor)),
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
                                    ),
                                    Text(
                                      '${cubit.vitD} µg',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      '',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      '10 µg',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.green),
                                    ),
                                  ]),
                                  TableRow(children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5.0),
                                      child:
                                          //
                                          RichText(
                                        text: TextSpan(
                                          text: '',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context)
                                                  .primaryColor),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: 'Water',
                                                recognizer:
                                                    TapGestureRecognizer()
                                                      ..onTap = () {
                                                        showDialog<String>(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return AlertDialog(
                                                                title: Text(
                                                                    ' Water'),
                                                                content:
                                                                    RichText(
                                                                  text:
                                                                      TextSpan(
                                                                    text:
                                                                        'Water',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            16,
                                                                        color: Theme.of(context)
                                                                            .primaryColor),
                                                                    children: <
                                                                        TextSpan>[
                                                                      TextSpan(
                                                                        text:
                                                                            ' Meer informatie',
                                                                        style: new TextStyle(
                                                                            color:
                                                                                Colors.blue),
                                                                        recognizer:
                                                                            new TapGestureRecognizer()
                                                                              ..onTap = () {
                                                                                launch('https://www.voedingscentrum.nl/encyclopedie/water.aspx');
                                                                              },
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                actions: <
                                                                    Widget>[
                                                                  TextButton(
                                                                    onPressed: () =>
                                                                        Navigator.pop(
                                                                            context,
                                                                            'OK'),
                                                                    child: const Text(
                                                                        'OK',
                                                                        style: TextStyle(
                                                                            color:
                                                                                kPrimaryColor)),
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

                                      // ),
                                    ),
                                    Text(
                                      '${cubit.water.toStringAsFixed(0)} g',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      '',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      '1,5-2L',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.green),
                                    ),
                                  ]),
                                  TableRow(children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5.0),
                                      child:
                                          //
                                          RichText(
                                        text: TextSpan(
                                          text: '',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context)
                                                  .primaryColor),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: 'Zink',
                                                recognizer:
                                                    TapGestureRecognizer()
                                                      ..onTap = () {
                                                        showDialog<String>(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return AlertDialog(
                                                                title: Text(
                                                                    ' Zink'),
                                                                content:
                                                                    RichText(
                                                                  text:
                                                                      TextSpan(
                                                                    text:
                                                                        'Zink',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            16,
                                                                        color: Theme.of(context)
                                                                            .primaryColor),
                                                                    children: <
                                                                        TextSpan>[
                                                                      TextSpan(
                                                                        text:
                                                                            ' Meer informatie',
                                                                        style: new TextStyle(
                                                                            color:
                                                                                Colors.blue),
                                                                        recognizer:
                                                                            new TapGestureRecognizer()
                                                                              ..onTap = () {
                                                                                launch('https://www.voedingscentrum.nl/encyclopedie/zink.aspx');
                                                                              },
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                actions: <
                                                                    Widget>[
                                                                  TextButton(
                                                                    onPressed: () =>
                                                                        Navigator.pop(
                                                                            context,
                                                                            'OK'),
                                                                    child: const Text(
                                                                        'OK',
                                                                        style: TextStyle(
                                                                            color:
                                                                                kPrimaryColor)),
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

                                      // ),
                                    ),
                                    Text(
                                      '${cubit.zink.toStringAsFixed(1)} mg',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      '',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      '7-9 mg',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.green),
                                    ),
                                  ]),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

Widget _buildPopupDialog(BuildContext context) {
  return new AlertDialog(
    title: const Text(
      'Richtlijn Voedingscentrum',
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
                      'Let op: Dit zijn richtlijnen. Met een gevarieerd dieet krijg je de juiste voedingsstoffen binnen. '),
              TextSpan(
                text: 'Rood',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
              ),
              TextSpan(
                  text: ' is het maximale en ', style: TextStyle(fontSize: 16)),
              TextSpan(
                text: 'Groen',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
              ),
              TextSpan(
                  text:
                      ' staat voor de minimale consumptie per dag. Voor meer informatie, kijk op de website voedingscentrum.nl',
                  style: TextStyle(fontSize: 16)),
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
