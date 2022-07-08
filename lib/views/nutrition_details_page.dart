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
  static bool _customTileExpanded = false;

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
                                                text:
                                                    AppLocalizations.of(context)
                                                        .totallproteintext,
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
                                                                    'Eiwitten'),
                                                                content:
                                                                    RichText(
                                                                  text:
                                                                      TextSpan(
                                                                    text:
                                                                        'Eiwit is een voedingsstof en een bouwstof. Er zijn dierlijke en plantaardige eiwitten. Dierlijke eiwitten zitten vooral in vlees, vis, melk, kaas en eieren. Plantaardige eiwitten zitten vooral in brood, graanproducten, peulvruchten en noten.\n\nVolwassen personen hebben gemiddeld elke dag 0,83 gram eiwit per kilo lichaamsgewicht nodig. Sommige groepen hebben wat meer nodig. Dat zijn vegetariërs, veganisten, kinderen, zwangere vrouwen en vrouwen die borstvoeding geven. Ook mensen met bepaalde aandoeningen of wonden en kracht- en duursporters hebben iets meer nodig.',
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
                                                                                launch('https://www.voedingscentrum.nl/encyclopedie/eiwitten.aspx');
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
                                                text:
                                                    AppLocalizations.of(context)
                                                        .totalfattext,
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
                                                                    'Vetten'),
                                                                content:
                                                                    RichText(
                                                                  text:
                                                                      TextSpan(
                                                                    text:
                                                                        'Vet is een bron van energie, vitamine A, vitamine D, vitamine E en essentiële vetzuren. Er bestaat onverzadigd en verzadigd vet. Vet in voedingsmiddelen bestaat altijd uit een combinatie van beide. Het vervangen van verzadigd vet door onverzadigd vet verlaagt het LDL-cholesterol. Een te hoog LDL-cholesterol is niet goed voor de bloedvaten en kan leiden tot hart- en vaatziekten.\n\nOm de kans op hart- en vaatziekten te verlagen, is het dus van belang producten met veel verzadigd vet te vervangen door producten met veel onverzadigd vet.',
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
                                                                                launch('https://www.voedingscentrum.nl/encyclopedie/vetten.aspx');
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
                                                text:
                                                    AppLocalizations.of(context)
                                                        .dotssaturatedstext,
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
                                                                    'Verzadigde vetten'),
                                                                content:
                                                                    RichText(
                                                                  text:
                                                                      TextSpan(
                                                                    text:
                                                                        'Verzadigd vet zit veel in dierlijke producten, zoals vet vlees en volle melkproducten en volvette kaas. Ook zit er veel verzadigd vet in koek, gebak en snacks.Verzadigd vet verhoogt het LDL-cholesterol van het bloed. Een te hoog LDL-cholesterol is niet goed voor de bloedvaten.\n\nIn Nederland en in de meeste andere landen wordt aangeraden om te zorgen dat niet meer dan 10% van de calorieën die je op een dag nodig hebt van verzadigd vet komt.',
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
                                                                                launch('https://www.voedingscentrum.nl/encyclopedie/verzadigd-vet.aspxx');
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
                                                text:
                                                    AppLocalizations.of(context)
                                                        .totalcarbstext,
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
                                                                    'Koolhydraten'),
                                                                content:
                                                                    RichText(
                                                                  text:
                                                                      TextSpan(
                                                                    text:
                                                                        'Suikers, zetmeel en vezels zijn vormen van koolhydraten in onze voeding. Suikers en zetmeel zijn koolhydraten die een belangrijke bron van energie zijn voor het lichaam. De Gezondheidsraad adviseert dat wie gezond wil eten, minimaal 40% van zijn energie uit koolhydraten haalt.\n\nKoolhydraten kunnen het beste gegeten worden door voedingsmiddelen te eten waarvan is aangetoond dat ze gezondheidswinst leveren of andere goede voedingsstoffen bevatten. Dit zijn volkoren graanproducten zoals volkorenbrood en volkoren pasta, aardappels, peulvruchten, groente en fruit. Producten met koolhydraten die niet in de Schijf van Vijf staan, zoals frisdrank, koek en snoep, kunnen beter in beperkte mate worden genomen.',
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
                                                                                launch('https://www.voedingscentrum.nl/encyclopedie/koolhydraten.aspxx');
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
                                                text:
                                                    AppLocalizations.of(context)
                                                        .dotssugarsstext,
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
                                                                    'Suikers'),
                                                                content:
                                                                    RichText(
                                                                  text:
                                                                      TextSpan(
                                                                    text:
                                                                        'De meeste suikers bestaan uit glucose, fructose of een mengsel daarvan. Dit geldt voor alle soorten suiker, stropen, honing, en siropen. Het lichaam maakt geen onderscheid tussen van nature aanwezige of toegevoegde suiker en verwerkt het op dezelfde manier.\n\nHet drinken van suikerhoudende dranken vergroot de kans op overgewicht. Dit komt waarschijnlijk doordat de calorieën die je in vloeibare vorm binnenkrijgt, niet makkelijk worden waargenomen door het lichaam. Hierdoor voel je je minder snel verzadigd (vol) na het drinken dan na het eten van een voedingsmiddel.\n\nDe aanbeveling van het WHO zegt dat je minder dan 10% van de calorieën op een dag uit suikers moet halen. Voor jou is het uitgerekend met je huidige calorie doel op: "${(calGoal).toStringAsFixed(0)}" calorieën. Dat komt neer op ${(((calGoal / 4) / 10)).toStringAsFixed(0)}g.',
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
                                                                                launch('https://www.voedingscentrum.nl/encyclopedie/suiker.aspxx');
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
                                      '${cubit.sugars.toStringAsFixed(0)}g',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      '${cubit.sugarsPercent.toStringAsFixed(0)}%',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      '${(((calGoal / 4) / 10)).toStringAsFixed(0)}',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.red),
                                    )
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
                                                text:
                                                    AppLocalizations.of(context)
                                                        .dotsfiberstext,
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
                                                                    'Suikers'),
                                                                content:
                                                                    RichText(
                                                                  text:
                                                                      TextSpan(
                                                                    text:
                                                                        'Voedingsvezels (vezels) zijn belangrijk voor de gezondheid. Ze dragen bij aan een goede spijsvertering, een verzadigd gevoel na het eten en verminderen het risico op hart- en vaatziekten, diabetes type 2 en darmkanker.\n\nIn groente, fruit, aardappelen, volkorenbrood, ontbijtgranen, peulvruchten en noten zitten veel voedingsvezels. Per dag wordt geadviseerd zo’n 30 tot 40 gram voedingsvezels te eten. Omdat er veel verschillende typen vezels zijn met elk hun eigen goede eigenschappen, is het belangrijk om vezels uit verschillende typen voedingsmiddelen te eten.',
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
                                                                                launch('https://www.voedingscentrum.nl/encyclopedie/vezels.aspxx');
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
                                                text:
                                                    AppLocalizations.of(context)
                                                        .salttext,
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
                                                                    'Zout'),
                                                                content:
                                                                    RichText(
                                                                  text:
                                                                      TextSpan(
                                                                    text:
                                                                        'Zout is belangrijk voor het regelen van de vochtbalans in het lichaam, het regelen van de bloeddruk en voor een goede werking van spier- en zenuwcellen. Het komt zelden voor dat mensen te weinig zout binnenkrijgen. Zout is de belangrijkste bron van natrium in onze voeding. Te veel zout eten kan echter leiden tot een hoge bloeddruk. Een hoge bloeddruk verhoogt de kans op hart- en vaatziekten.\n\nDe dagelijkse aanbevolen hoeveelheid zout voor mannen en vrouwen is 3 gram. De maximum aanbevolen hoeveelheid zout per dag is 6 gram. Deze advieswaarden gelden niet voor personen die grote hoeveelheden zweet verliezen als gevolg van extreme omstandigheden, zoals wedstrijdsporters of werken in extreem warme omstandigheden.',
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
                                                                                launch('https://www.voedingscentrum.nl/encyclopedie/koolhydraten.aspxx');
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
                                                                        'Calcium is een mineraal dat je nodig hebt voor de opbouw en het onderhoud van de botten en het gebit. Calcium helpt tegen botontkalking op latere leeftijd en is nodig voor een goede werking van de zenuwen en spieren, de bloedstolling en het transport van andere mineralen in het lichaam.\n\nDe dagelijks aanbevolen hoeveelheden haal je voornamelijk uit melk en kaas. De rest haal je uit andere producten zoals dranken (water, koffie, thee). Ook in graanproducten en groenten zit een beetje calcium.\n\nDe dagelijkse aanbevolen hoeveelheid calcium voor mannen tussen de 29 en 69 jaar en voor vrouwen tussen de 25 en 50 jaar is 950 milligram.',
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
                                                                        'Foliumzuur (vitamine B11) is nodig voor de groei en goede werking van het lichaam en voor de aanmaak van witte en rode bloedcellen. Foliumzuur is ook belangrijk voor de vroege ontwikkeling van het ongeboren kind. Foliumzuur komt van nature voor in groenten, vooral de groene soorten, volkorenproducten, brood, vlees en zuivel.\n\nDe dagelijkse aanbevolen hoeveelheid foliumzuur voor mannen en vrouwen is 300 microgram.',
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
                                      '${cubit.foliumzuur.toStringAsFixed(0)} µg',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      '',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      '300 µg',
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
                                                                        'Fosfor of fosfaat geeft samen met calcium stevigheid aan botten en tanden. Ook vervult fosfor een functie bij de energiestofwisseling (tijdelijke opslag en transport) in het lichaam. Fosfor komt in alle voedingsmiddelen voor in de vorm van fosfaat. Fosfor zit vooral in melk, melkproducten, kaas, vis, vlees, peulvruchten en volkoren producten. Het lichaam heeft niet snel een tekort aan fosfor. \n\nDe dagelijkse aanbevolen hoeveelheid fosfor voor mannen en vrouwen is 550 milligram.',
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
                                      '${cubit.fosfor.toStringAsFixed(0)} mg',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      '',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      '550 mg',
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
                                                text: 'IJzer*',
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
                                                                  ' IJzer',
                                                                ),
                                                                content:
                                                                    RichText(
                                                                  text:
                                                                      TextSpan(
                                                                    text:
                                                                        'IJzer is o.a. belangrijk voor de vorming van hemoglobine, een onderdeel van rode bloedcellen. Rode bloedcellen vervoeren zuurstof door ons lichaam.\n\nIJzer komt in eten voor in 2 vormen; heemijzer en non-heemijzer. Heemijzer zit alleen in dierlijke producten (vlees, vis en kip). Non-heemijzer zit in dierlijke en plantaardige producten (brood, volkorenproducten, peulvruchten, noten, groene groenten zoals spinazie, postelein, paksoi en snijbiet). Heemijzer wordt wat beter opgenomen. \n\nDe dagelijkse aanbevolen hoeveelheid ijzer voor mannen is 11 milligram en voor vrouwen 16 milligram. Voor ',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            16,
                                                                        color: Theme.of(context)
                                                                            .primaryColor),
                                                                    children: <
                                                                        TextSpan>[
                                                                      TextSpan(
                                                                        text:
                                                                            'vegetariërs',
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                16,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            color: Theme.of(context).primaryColor),
                                                                      ),
                                                                      TextSpan(
                                                                        text:
                                                                            ' is het van belang extra te letten op ijzer.',
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                16,
                                                                            color:
                                                                                Theme.of(context).primaryColor),
                                                                      ),
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
                                                                        'Jodium is een spoorelement dat belangrijk is voor de productie van schildklierhormonen. Deze hormonen zijn nodig voor een goede groei, de ontwikkeling van het zenuwstelsel en de stofwisseling. Van nature komt jodium voor in zeevis, eieren, zuivelproducten en zeewier. Toegevoegd jodium zit in sommige vleeswaren, gejodeerd keukenzout en bakkerszout.\n\nDe dagelijkse aanbevolen hoeveelheid jodium voor mannen en vrouwen is 150 microgram.',
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
                                                                        'Kalium is betrokken bij het regelen van de vochtbalans en bloeddruk in het lichaam. Kalium heeft daarbij een gunstig effect op de bloeddruk omdat het het bloeddrukverhogende effect van natrium tegenwerkt. Een tekort komt zelden voor. Kalium komt in bijna alle voedingsmiddelen voor. Het zit vooral in groente, fruit, aardappelen, vlees, vis, noten en ook in melkproducten en brood.\n\nDe dagelijkse aanbevolen hoeveelheid kalium voor mannen en vrouwen is 3500 milligram.',
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
                                                                        'Magnesium is nodig voor onder andere de vorming van bot en spieren en speelt een rol bij de goede werking van spieren en overdracht van zenuwprikkels. Het zit in veel verschilende voedingsmiddelen zoals bijvoorbeeld volkorenbrood en andere volkoren graanproducten, groente, noten, melk en melkproducten en vlees. Ook water kan bijdragen aan de inname van magnesium.\n\nDe dagelijkse aanbevolen hoeveelheid magnesium voor mannen is 350 milligram en voor vrouwen 300 milligram.',
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
                                                                        'Natrium is belangrijk voor het regelen van de vochtbalans in het lichaam, het regelen van de bloeddruk en voor een goede werking van spier- en zenuwcellen. Het komt zelden voor dat mensen te weinig zout binnenkrijgen. Zout is de belangrijkste bron van natrium in onze voeding. Te veel zout eten kan echter leiden tot een hoge bloeddruk. Een hoge bloeddruk verhoogt de kans op hart- en vaatziekten.\n\nDe dagelijkse aanbevolen hoeveelheid natrium voor mannen en vrouwen is 1500 milligram (1,5 gram). De maximum aanbevolen hoeveelheid natrium per dag is 2400 milligram ',
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
                                                                        'Niacine (vitamine B3) is belangrijk voor de energievoorziening van het lichaam en de aanmaak van vetzuren. Niacine zit in vlees, vis, volkoren graanproducten, groente en aardappelen.\n\nDe dagelijks aanbevolen hoeveelheid niacine die je nodig hebt hangt af van het aantal calorieën dat je eet. Voor jou is het uitgerekend met je huidige calorie doel op: "${(calGoal).toStringAsFixed(0)}" calorieën. Dat komt neer op ${(((calGoal * 4.2) / 1000) * 1.6).toStringAsFixed(0)} mg.',
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
                                      '${(((calGoal * 4.2) / 1000) * 1.6).toStringAsFixed(0)} mg',
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
                                                                        'Selenium of seleen is een spoorelement. Selenium zit in de lever en beschermt rode bloedlichaampjes en cellen tegen beschadiging. Verder maakt selenium zware metalen die soms in voeding terecht kunnen komen minder giftig. Selenium is ook belangrijk voor een goede werking van de schildklier. Het zit in veel voedingsmiddelen, zowel in dierlijke als plantaardige producten. Een tekort komt normaal gesproken niet voor en het is bijna onmogelijk om met eten te veel binnen te krijgen.\n\n De dagelijks aanbevolen hoeveelheid voor mannen en vrouwen is 70 milligram. De aanbevolen bovengrens is 300 miligram.',
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
                                                text: 'Vitamine A',
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
                                                                        'Vitamine A of retinol is van belang voor de normale groei, een gezonde huid, haar en nagels en een goede werking van de ogen en het afweersysteem. Het zit vooral in dierlijke producten zoals vlees(waren), zuivel vis en eidooier. Daarnaast wordt het toegevoegd aan margarine, halvarine en bakproducten. Vooral in lever zit veel vitamine A. Carotenoïden (provitamine A) komen veel voor in verschillende soorten groenten, zoals wortel, boerenkool, spinazie en andijvie.\n\nDe aanbevolen dagelijkse hoeveelheid van vitamine A voor een volwassen man 800 microgram en voor een volwassen vrouw 680 microgram.',
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
                                                text: 'Vitamine B1',
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
                                                                        'Thiamine (vitamine B1) is onmisbaar voor de energievoorziening van het lichaam, en voor een goede werking van de hartspier en het zenuwstelsel. Bij een tekort aan vitamine B1 kunnen afwijkingen aan het zenuwstelsel en psychische afwijkingen ontstaan. Thiamine komt voor in brood en graanproducten, aardappelen, groente, vlees en vleeswaren, melk en melkproducten.\n\nDe dagelijkse aanbevolen hoeveelheid voor mannen en vrouen is afhankelijk van het aantal calorieën dat je eet. Voor jouw calorie doel is het uitgrekend op "${(calGoal).toStringAsFixed(0)}" calorieën. Dat komt neer op ${((cubit.kCalSum * 0.0041868) * 0.1).toStringAsFixed(1)} mg.',
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
                                                text: 'Vitamine B12*',
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
                                                                        'Vitamine B12 (cobalamine) is nodig voor de aanmaak van rode bloedcellen. Rode bloedcellen zijn nodig om zuurstof in je bloed te vervoeren. Daarnaast is vitamine B12 nodig voor een goede werking van het zenuwstelsel. Vitamine B12 zit alleen in dierlijke producten, zoals melk, melkproducten, vlees, vleeswaren, vis en eieren.',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            16,
                                                                        color: Theme.of(context)
                                                                            .primaryColor),
                                                                    children: <
                                                                        TextSpan>[
                                                                      TextSpan(
                                                                        text:
                                                                            ' Veganisten',
                                                                        style: new TextStyle(
                                                                            color:
                                                                                Theme.of(context).primaryColor,
                                                                            fontWeight: FontWeight.bold),
                                                                      ),
                                                                      TextSpan(
                                                                        text:
                                                                            ' wordt aangeraden een vitamine B12-supplement te slikken of producten te gebruiken met toegevoegd vitamine B12.\n\nDe dagelijks aanbevolen hoeveelheid voor mannen en vrouwen is 2.8 microgram per dag.',
                                                                        style:
                                                                            new TextStyle(
                                                                          color:
                                                                              Theme.of(context).primaryColor,
                                                                        ),
                                                                      ),
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
                                                                        'Riboflavine (vitamine B2) is onmisbaar voor de energievoorziening van het lichaam. Het speelt namelijk een belangrijke rol bij het vrijmaken van energie voor je lichaam uit koolhydraten, eiwitten en vetten. Riboflavine zit vooral in melk en melkproducten, maar ook in vlees, vleeswaren, groente, fruit, brood en graanproducten.\n\nDe dagelijk aanbevolen hoeveelheid voor mannen en vrouwen is 1,6 milligram.',
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
                                                                        'Vitamine B6 is belangrijk voor de stofwisseling, vooral voor de afbraak en opbouw van aminozuren. Aminozuren zijn de bouwstenen van eiwitten. Vitamine B6 zit in vlees, eieren, vis, brood en graanproducten, aardappelen, peulvruchten, groente, melk, melkproducten en kaas.\n\nDe dagelijks aanbevolen hoeveelheid voor mannen en vrouwen is 1.5 milligram.',
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
                                                text: 'Vitamine C',
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
                                                                    'Vitamine C'),
                                                                content:
                                                                    RichText(
                                                                  text:
                                                                      TextSpan(
                                                                    text:
                                                                        'Vitamine C of ascorbinezuur is de bekendste vitamine. Vitamine C heeft een functie als antioxidant in het lichaam en is nodig voor de vorming van bindweefsel, de opname van ijzer en het in stand houden van de weerstand. Vitamine C zit in fruit, groente en aardappelen, met name in koolsoorten, citrusfruit, kiwi’s, bessen en aardbeien. Om vitamine C zoveel mogelijk te behouden, is het belangrijk om groente in weinig water te koken, en niet langer dan nodig is.\n\nDe dagelijkse aanbeveling voor mannen en vrouwen is 75 milligram',
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
                                                                                launch('https://www.voedingscentrum.nl/encyclopedie/vitamine-c.aspx');
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
                                      '${cubit.vitC.toStringAsFixed(0)} mg',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      '',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      '75 mg',
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
                                                text: 'Vitamine D',
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
                                                                        'Vitamine D is een vetoplosbare vitamine. Vitamine D is een van de weinige vitamines die het lichaam zelf kan maken. Onder invloed van zonlicht wordt in de huid vitamine D gevormd. Daarnaast levert de voeding vitamine D.\n\nVoor iedereen geldt een aanbevolen dagelijkse hoeveelheid van 10 microgram vitamine D. Alleen mensen van boven de 70 moeten 20 microgram per dag binnen krijgen.',
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
                                                text: 'Vitamine E',
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
                                                                    'Vitamine E'),
                                                                content:
                                                                    RichText(
                                                                  text:
                                                                      TextSpan(
                                                                    text:
                                                                        'Vitamine E is een vetoplosbare vitamine. Vitamine E werkt als antioxidant en beschermt zo de cellen, bloedvaten, organen, ogen en weefsel. Vitamine E speelt ook een rol bij het regelen van de stofwisseling in de cel. Vitamine E zit in zonnebloemolie, halvarine, margarine, brood, graanproducten, noten, zaden, groenten en fruit.\n\n De dagelijkse aanbeveling voor mannen is 13 milligram en voor vrouwen 11 milligram',
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
                                                                                launch('https://www.voedingscentrum.nl/encyclopedie/vitamine-e.aspx');
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
                                      '${cubit.vitE.toStringAsFixed(0)} mg',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      '',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      '11 mg',
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
                                                                        'Het advies voor volwassenen is om per dag 1,5 tot 2 liter vocht te drinken. Water voorziet je lichaam net als andere dranken van vocht. Omdat water geen calorieën bevat, is het een goede dorstlesser. Het drinkwater uit de kraan is in Nederland van goede kwaliteit. De eisen daarvoor zijn vastgelegd in de Waterleidingwet. ',
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
                                                                        'Zink is onder meer nodig bij de opbouw van eiwitten, de groei en ontwikkeling van weefsel, en een goede werking van het afweer-/immuunsysteem. Zink komt in kleine hoeveelheden voor in veel verschillende voedingsmiddelen, zoals vlees, kaas, graanproducten, noten en schaal- en schelpdieren zoals garnalen en mosselen.\n\nDe dagelijkse aanbeveling van zink voor mannen is 9 milligram en voor vrouwen 7 milligram. Een veilige bovengrens is 25 milligram per dag.',
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
                      ' staat voor de minimale consumptie per dag. Het maakt niet uit als je de ene dag meer binnenkrijgt dan de andere dag. Voor meer informatie, kijk op de website voedingscentrum.nl.\n\nDoor links op het macronutriënt of micronutriënt te klikken krijg je meer informatie van het voedingscentrum',
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
