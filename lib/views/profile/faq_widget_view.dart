import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food_app/views/constants.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class FaqView extends StatelessWidget {
  const FaqView({Key key}) : super(key: key);

  static const String _title = 'Tips & Tricks';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Title: _title,
      appBar: AppBar(
        title: const Text(_title),
        backgroundColor: kPrimaryColor,
      ),
      body: const MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  bool _customTileExpanded = false;

  List<GDPData> _chartData;
  TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    _chartData = getChartData();
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          ExpansionTile(
            title: Text('Wat is de impact van ons voedsel op de natuur?'),
            //   subtitle: const Text('Custom expansion arrow icon'),

            trailing: Icon(
              _customTileExpanded
                  ? Icons.arrow_drop_down_circle
                  : Icons.arrow_drop_down,
            ),
            children: <Widget>[
              //  ListTile(
              // title:
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                    'Het voedselsysteem levert wereldwijd een enorme bijdrage aan klimaatopwarming. Schattingen geven aan dat 26% van de wereldwijde CO2eq uitstoot afkomstig is van de voedselketen. Zoals te zien is op de afbeelding, is het grootste aandeel van de voedseluitstoot afkomstig van vee en visserij. Ook landbouw levert een groot aandeel. Het is echter belangrijk om te noemen dat de totale landbouw productie vele malen groter is dan de vleesproductie, waardoor gewassen aanzienlijk beter scoren per kilogram. Het verwerken en vervoeren van voedsel zorgt slechts voor iets minder dan één vijfde van de uitstoot. Ook zijn er tussen landen grote verschillen te vinden in deze cijfers, onder andere door bevolkingsgrootte, cultuur en vooral welvaart.'),
              ),
              Image.network(
                  'https://assets.weforum.org/editor/responsive_large_webp_xYEGxaqCqyW20yO4XWjGXrGv2uZxZqyEoMr2USCerJY.webp'),
            ],
            onExpansionChanged: (bool expanded) {
              setState(() => _customTileExpanded = expanded);
            },
          ),
          ExpansionTile(
            title: const Text('Wat is de belangrijkste impact factor?'),
            //   subtitle: const Text('Custom expansion arrow icon'),

            trailing: Icon(
              _customTileExpanded
                  ? Icons.arrow_drop_down_circle
                  : Icons.arrow_drop_down,
            ),
            children: const <Widget>[
              ListTile(
                  title: Text(
                      'Voor de opwarming van de aarde is CO2eq de belangrijkste factor, maar dit betekent niet dat de andere factoren niet belangrijk zijn. Ook landgebruik en waterverbruik zorgen voor veel klimaatgerelateerde problemen. Echter was het voor dit onderzoek niet mogelijk om deze data mee te nemen. Er is nog niet genoeg informatie beschikbaar om dit voor elk product te bepalen.')),
            ],
            onExpansionChanged: (bool expanded) {
              setState(() => _customTileExpanded = expanded);
            },
          ),
          ExpansionTile(
            title: const Text('Waarom de CO2-eq uitstoot?'),
            //   subtitle: const Text('Custom expansion arrow icon'),

            trailing: Icon(
              _customTileExpanded
                  ? Icons.arrow_drop_down_circle
                  : Icons.arrow_drop_down,
            ),
            children: const <Widget>[
              ListTile(
                  title: Text(
                      'CO2eq staat voor CO2 equivalenten gemeten in kilogram (kg). Het zijn alle broeikasgassen die vrijkomen tijdens de productie, transport of verwerking van het product. Behalve CO2 zijn er nog veel andere broeikasgassen, bijvoorbeeld methaan (CH4) of stikstofdioxiden (N2O). Om alle broeikasgassen samen te vatten, is de term CO2eq bedacht, wat inhoudt dat de andere uistootbronnen vertaald worden naar CO2 equivalenten. Methaan houdt 28x meer warmte vast dan CO2. De uitstoot van 1 g methaan wordt dus beschreven als 28 g CO2eq. Voor stikstofoxide is dit nog vele malen erger, namelijk 265 keer de impact dan CO2. Het kan dus zo zijn dat een product maar weinig CO2 uitstoot, maar toch een hoge CO2eq heeft. Dit komt dan door de uitstoot van andere broeikasgassen. Voorbeelden zijn de productie van vlees en rijst waarbij methaan vrijkomt. Voor CO2eq geldt altijd, hoe hoger hoe meer het bijdraagt aan klimaatopwarming. Probeer dus gerechten en producten te gebruiken met een lage CO2eq uitstoot.')),
            ],
            onExpansionChanged: (bool expanded) {
              setState(() => _customTileExpanded = expanded);
            },
          ),
          ExpansionTile(
            title: Text('Welke producten hebben een hoge uitstoot?'),
            //  subtitle: Text('Trailing expansion arrow icon'),
            children: <Widget>[
              // ListTile(
              //   title: Text('Answer number 1'),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                    '*Getallen in kg CO₂-equivalenten, gebaseerd op het gemiddelde aanbod van de producten op de Nederlandse markt'),
              ),
              Container(
                height: 400,
                child: SfCartesianChart(
                  title: ChartTitle(text: 'CO₂eq uitstoot per kg product'),
                  legend: Legend(isVisible: false),
                  tooltipBehavior: _tooltipBehavior,

                  series: <ChartSeries>[
                    BarSeries<GDPData, String>(
                        name: 'kg-CO₂-eq',
                        dataSource: _chartData,
                        xValueMapper: (GDPData gdp, _) => gdp.continent,
                        yValueMapper: (GDPData gdp, _) => gdp.gdp,
                        pointColorMapper: (GDPData gdp, _) => gdp.color,
                        dataLabelSettings: DataLabelSettings(isVisible: true),
                        enableTooltip: true)
                  ],
                  primaryXAxis: CategoryAxis(),
                  primaryYAxis: NumericAxis(
                      edgeLabelPlacement: EdgeLabelPlacement.shift,
                      //  numberFormat: NumberFormat.simpleCurrency(decimalDigits: 0),
                      title: AxisTitle(text: 'Bron: RIVM (2021)')),
                  // ),
                ),
              ),
            ],
          ),

          ExpansionTile(
            title: const Text('Gemakkelijke food-swaps'),
            //   subtitle: const Text('Custom expansion arrow icon'),

            trailing: Icon(
              _customTileExpanded
                  ? Icons.arrow_drop_down_circle
                  : Icons.arrow_drop_down,
            ),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        FaIcon(FontAwesomeIcons.paw, color: kPrimaryColor),
                        const Text('Runder gehakt:'),
                        const Text('3,1kg CO₂eq'),
                      ],
                    ),
                    Column(
                      children: [
                        Icon(Icons.percent, color: kPrimaryColor),
                        const Text('85% besparing'),
                      ],
                    ),
                    Column(
                      children: [
                        ImageIcon(
                          AssetImage("assets/icons/leaf_icon.png"),
                          color: kPrimaryColor,
                        ),
                        const Text('Vegetarisch gehakt:'),
                        const Text('0,44kg CO₂eq'),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        FaIcon(FontAwesomeIcons.paw, color: kPrimaryColor),
                        const Text('Glas melk:'),
                        const Text('0.4kg CO₂eq'),
                      ],
                    ),
                    Column(
                      children: [
                        Icon(Icons.percent, color: kPrimaryColor),
                        const Text('64% besparing'),
                      ],
                    ),
                    Column(
                      children: [
                        ImageIcon(
                          AssetImage("assets/icons/leaf_icon.png"),
                          color: kPrimaryColor,
                        ),
                        const Text('Glas melk (soja):'),
                        const Text('0.14kg CO₂eq'),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        FaIcon(FontAwesomeIcons.paw, color: kPrimaryColor),
                        const Text('Kip (100g):'),
                        const Text('1.2kg CO₂eq'),
                      ],
                    ),
                    Column(
                      children: [
                        Icon(Icons.percent, color: kPrimaryColor),
                        const Text('86% besparing'),
                      ],
                    ),
                    Column(
                      children: [
                        ImageIcon(
                          AssetImage("assets/icons/leaf_icon.png"),
                          color: kPrimaryColor,
                        ),
                        const Text('Tahoe (tofu):'),
                        const Text('0.17kg CO₂eq'),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        FaIcon(FontAwesomeIcons.paw, color: kPrimaryColor),
                        const Text('Hamburger:'),
                        const Text('3.1kg CO₂eq'),
                      ],
                    ),
                    Column(
                      children: [
                        Icon(Icons.percent, color: kPrimaryColor),
                        const Text('74% besparing'),
                      ],
                    ),
                    Column(
                      children: [
                        FaIcon(FontAwesomeIcons.paw, color: kPrimaryColor),
                        const Text('Kipburger:'),
                        const Text('0.80kg CO₂eq'),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        FaIcon(FontAwesomeIcons.paw, color: kPrimaryColor),
                        const Text('Hamburger:'),
                        const Text('3.1kg CO₂eq'),
                      ],
                    ),
                    Column(
                      children: [
                        Icon(Icons.percent, color: kPrimaryColor),
                        const Text('88% besparing'),
                      ],
                    ),
                    Column(
                      children: [
                        ImageIcon(
                          AssetImage("assets/icons/leaf_icon.png"),
                          color: kPrimaryColor,
                        ),
                        const Text('Vega burger:'),
                        const Text('0.38kg CO₂eq'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
            onExpansionChanged: (bool expanded) {
              setState(() => _customTileExpanded = expanded);
            },
          ),
          ExpansionTile(
            title: const Text('Waar komt de data vandaan?'),
            //   subtitle: const Text('Custom expansion arrow icon'),

            trailing: Icon(
              _customTileExpanded
                  ? Icons.arrow_drop_down_circle
                  : Icons.arrow_drop_down,
            ),
            children: const <Widget>[
              ListTile(
                  title: Text(
                      'De dataset in deze app bestaat uit ongeveer 2100 producten. Deze data is afkomstig uit het Nederlands Voedingsstoffenbestand (NEVO). Deze database bevat gegevens over de samenstelling van voedingsmiddelen die in Nederland regelmatig worden gebruikt of die van belang zijn voor bepaalde groepen in de bevolking. Hier staan helaas geen specifieke producten in met de barcode. Dit had het tracken natuurlijk makkelijker kunnen maken. \nDe data omtrent de CO₂ komt voornamelijk van een recent dataset van het RIVM (250 producten) en is aangevuld met data uit een Deense LCA database (500 producten).')),
            ],
            onExpansionChanged: (bool expanded) {
              setState(() => _customTileExpanded = expanded);
            },
          ),

          ExpansionTile(
            title: const Text('Wat betekent duurzaam eten?'),
            //   subtitle: const Text('Custom expansion arrow icon'),

            trailing: Icon(
              _customTileExpanded
                  ? Icons.arrow_drop_down_circle
                  : Icons.arrow_drop_down,
            ),
            children: const <Widget>[
              ListTile(title: Text('Answer number  1')),
            ],
            onExpansionChanged: (bool expanded) {
              setState(() => _customTileExpanded = expanded);
            },
          ),
          // const ExpansionTile(
          //   title: Text('Question 3'),
          //   subtitle: Text('Leading expansion arrow icon'),
          //   controlAffinity: ListTileControlAffinity.leading,
          //   children: <Widget>[
          //     ListTile(title: Text('This is tile number 3')),
          //   ],
          // ),
        ],
      ),
    );
  }

  List<GDPData> getChartData() {
    final List<GDPData> chartData = [
      GDPData('Bruine Bonen', 1.88, Colors.green),
      GDPData('Melk', 2.03, Colors.green),
      GDPData('Cashewnoten', 4.26, Colors.green),
      GDPData('Ei (gekookt)', 4.32, Colors.green),
      GDPData('Tofu', 4.34, Color.fromARGB(255, 185, 212, 185)),
      GDPData('Vegetarisch gehakt', 4.44, Color.fromARGB(255, 238, 231, 168)),
      GDPData(
          'Vegetarische schnitzel', 5.92, Color.fromARGB(255, 213, 205, 129)),
      GDPData('Kaas (20+)', 10.4, Color.fromARGB(255, 219, 164, 138)),
      GDPData('Kipfilet', 10.87, Color.fromARGB(255, 212, 131, 125)),
      GDPData('Varkensvlees', 12.42, Color.fromARGB(255, 233, 144, 138)),
      GDPData('Tonijn (blik)', 14.55, Color.fromARGB(255, 230, 102, 93)),
      GDPData('Hollandse garnalen', 15.41, Color.fromARGB(255, 202, 83, 74)),
      GDPData('Gehakt half-om-half', 20.37, Color.fromARGB(255, 231, 82, 72)),
      GDPData('Rundergehakt', 30.03, Color.fromARGB(255, 202, 54, 43)),
      GDPData('Runderbiefstuk', 31.34, Color.fromARGB(255, 173, 41, 32)),
    ];
    return chartData;
  }
}

class GDPData {
  GDPData(this.continent, this.gdp, this.color);
  final String continent;
  final double gdp;
  final Color color;
}
