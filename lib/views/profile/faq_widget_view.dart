import 'package:flutter/material.dart';
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
          ExpansionTile(
            title: Text('Welke producten hebben een hoge uitstoot?'),
            //  subtitle: Text('Trailing expansion arrow icon'),
            children: <Widget>[
              // ListTile(
              //   title: Text('Answer number 1'),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                    '*Getallen in kg CO2-equivalenten, gebaseerd op het gemiddelde aanbod van de producten op de Nederlandse markt'),
              ),
              Container(
                height: 400,
                child: SfCartesianChart(
                  title: ChartTitle(text: 'CO2eq uitstoot per kg product'),
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
            children: const <Widget>[
              ListTile(title: Text('Answer number  3')),
            ],
            onExpansionChanged: (bool expanded) {
              setState(() => _customTileExpanded = expanded);
            },
          ),
          ExpansionTile(
            title: const Text('Is biologisch eten duurzamer?'),
            //   subtitle: const Text('Custom expansion arrow icon'),

            trailing: Icon(
              _customTileExpanded
                  ? Icons.arrow_drop_down_circle
                  : Icons.arrow_drop_down,
            ),
            children: const <Widget>[
              ListTile(title: Text('Answer number  4')),
            ],
            onExpansionChanged: (bool expanded) {
              setState(() => _customTileExpanded = expanded);
            },
          ),
          ExpansionTile(
            title: const Text('What products are high in protein?'),
            //   subtitle: const Text('Custom expansion arrow icon'),

            trailing: Icon(
              _customTileExpanded
                  ? Icons.arrow_drop_down_circle
                  : Icons.arrow_drop_down,
            ),
            children: const <Widget>[
              ListTile(title: Text('Answer number  2')),
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
