import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_app/Views/constants.dart';
import 'package:food_app/shared/app_cubit.dart';
import 'package:food_app/views/goals/log_cubit.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GraphsScreen extends StatefulWidget {
  @override
  _GraphsScreenState createState() => _GraphsScreenState();
}

class _GraphsScreenState extends State<GraphsScreen>
    with SingleTickerProviderStateMixin {
  TabController tabController;

  String type;
  AppCubit appCubit;

  String uid;

  @override
  void initState() {
    super.initState();
    type = 'Calories';
    tabController = TabController(
      vsync: this,
      length: 4,
      initialIndex: 0,
    );
    appCubit = AppCubit.instance(context);
    uid = FirebaseAuth.instance.currentUser.uid;
    tabController.addListener(() {
      if (tabController.index == 0) {
        appCubit.getOneWeekData(appCubit.database, uid);
      } else if (tabController.index == 1) {
        appCubit.getOneWeekDataCo2(appCubit.database, uid);
      } else if (tabController.index == 2) {
        appCubit.getOneMonthData(appCubit.database, uid);
      } else if (tabController.index == 3) {
        appCubit.getOneMonthDataCo2(appCubit.database, uid);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    LogCubit logCubit = LogCubit.instance(context);

    // final String uid = FirebaseAuth.instance.currentUser.uid;
    // final AppCubit appCubit = AppCubit.instance(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 50),
        child: Container(
          height: 50,
          color: kPrimaryColor,
          child: TabBar(
            onTap: (index) {
              if (index == 0) {
                appCubit.getOneWeekData(appCubit.database, uid);
                logCubit.add2Log("week_kcal_button");
              } else if (index == 1) {
                appCubit.getOneWeekDataCo2(appCubit.database, uid);
                logCubit.add2Log("week_co2_button");
              } else if (index == 2) {
                appCubit.getOneMonthData(appCubit.database, uid);
                logCubit.add2Log("month_kcal_button");
              } else if (index == 3) {
                appCubit.getOneMonthDataCo2(appCubit.database, uid);
                logCubit.add2Log("month_co2_button");
              } else {
                print('error in tab index');
              }
            },
            indicator: BoxDecoration(
              color: Colors.black.withOpacity(0.4),
              borderRadius: BorderRadius.circular(5),
            ),
            controller: tabController,
            labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
            labelColor: Colors.white,
            tabs: [
              Text('Week kcal'),
              Text('Week co2'),
              Text('${AppLocalizations.of(context).month} kcal'),
              Text('${AppLocalizations.of(context).month} co2'),
            ],
          ),
        ),
      ),
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: tabController,
        children: [
          OneWeekGraph(),
          OneWeekGraphCo2(),
          OneMonthGraph(),
          OneMonthGraphCo2(),
        ],
      ),
    );
  }
}

class OneWeekGraph extends StatelessWidget {
  const OneWeekGraph({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appCubit = AppCubit.instance(context);
    return BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, state) {},
        builder: (BuildContext context, state) {
          if (state is DatabaseGetLoadingState) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Container(
              child: SfCartesianChart(
                  primaryXAxis: DateTimeAxis(),
                  legend: Legend(
                    isVisible: true,
                    // title: LegendTitle(text: type),
                    isResponsive: true,
                    position: LegendPosition.top,
                    alignment: ChartAlignment.near,
                    orientation: LegendItemOrientation.horizontal,
                  ),
                  tooltipBehavior: TooltipBehavior(enable: true),
                  primaryYAxis: NumericAxis(
                      title: AxisTitle(
                          text: AppLocalizations.of(context).calories,
                          textStyle: TextStyle(
                              color: Color.fromRGBO(75, 135, 185, 1))),
                      labelAlignment: LabelAlignment.start),
                  enableAxisAnimation: true,

                  // adding multiple axis
                  // axes: <ChartAxis>[
                  //   NumericAxis(
                  //       name: 'yAxis',
                  //       opposedPosition: true,
                  //       title: AxisTitle(
                  //           text: 'kg-CO₂',
                  //           textStyle: TextStyle(
                  //               color: Color.fromRGBO(192, 108, 132, 1))))
                  // ],
                  series: <LineSeries<double, DateTime>>[
                    LineSeries<double, DateTime>(
                        name: AppLocalizations.of(context).calories,
                        dataSource: appCubit.oneWeekCals,
                        xValueMapper: (double calories, int index) {
                          return DateTime.parse(
                              appCubit.oneWeekQueryResult[index]['date']);

                          // String day = DateFormat.MEd().format(DateTime.parse(
                          //     appCubit.oneWeekQueryResult[index]['date']));
                          // return day;
                        },
                        yValueMapper: (double calories, int index) => calories),
                    //   LineSeries<double, DateTime>(
                    //       name: 'CO₂',
                    //       animationDuration: 5000,
                    //       dataSource: appCubit.oneWeekCo2,
                    //       xValueMapper: (double co2, int index) {
                    //         return DateTime.parse(
                    //             appCubit.oneWeekQueryResult[index]['date']);

                    //         // String day = DateFormat.MEd().format(DateTime.parse(
                    //         //     appCubit.oneWeekQueryResult[index]['date']));
                    //         // return day;
                    //       },
                    //       yValueMapper: (double co2, int index) => co2,
                    //       yAxisName: 'yAxis'),
                  ]),
            );
          }
        });
  }
}

class OneWeekGraphCo2 extends StatelessWidget {
  const OneWeekGraphCo2({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appCubit = AppCubit.instance(context);
    return BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, state) {},
        builder: (BuildContext context, state) {
          if (state is DatabaseGetLoadingState) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Container(
              child: SfCartesianChart(
                  primaryXAxis: DateTimeAxis(),
                  legend: Legend(
                    isVisible: true,
                    // title: LegendTitle(text: type),
                    isResponsive: true,
                    position: LegendPosition.top,
                    alignment: ChartAlignment.near,
                    orientation: LegendItemOrientation.horizontal,
                  ),
                  tooltipBehavior: TooltipBehavior(enable: true),
                  primaryYAxis: NumericAxis(
                      title: AxisTitle(
                          text: 'kg-CO₂-eq',
                          textStyle: TextStyle(
                              color: Color.fromRGBO(75, 135, 185, 1))),
                      labelAlignment: LabelAlignment.start),
                  enableAxisAnimation: true,

                  // adding multiple axis
                  // axes: <ChartAxis>[
                  //   NumericAxis(
                  //       name: 'yAxis',
                  //       opposedPosition: true,
                  //       title: AxisTitle(
                  //           text: 'kg-CO₂',
                  //           textStyle: TextStyle(
                  //               color: Color.fromRGBO(192, 108, 132, 1))))
                  // ],
                  series: <LineSeries<double, DateTime>>[
                    LineSeries<double, DateTime>(
                        name: 'kg-CO₂-eq',
                        animationDuration: 5000,
                        dataSource: appCubit.oneWeekCo2,
                        xValueMapper: (double co2, int index) {
                          return DateTime.parse(
                              appCubit.oneWeekQueryResult[index]['date']);

                          // String day = DateFormat.MEd().format(DateTime.parse(
                          //     appCubit.oneWeekQueryResult[index]['date']));
                          // return day;
                        },
                        yValueMapper: (double co2, int index) => co2,
                        yAxisName: 'yAxis'),
                  ]),
            );
          }
        });
  }
}

class OneMonthGraph extends StatelessWidget {
  const OneMonthGraph({
    Key key,
    // @required this.oneMonthData,
  }) : super(key: key);

  // final List<Map> oneMonthData;

  @override
  Widget build(BuildContext context) {
    final appCubit = AppCubit.instance(context);
    return BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, state) {},
        builder: (BuildContext context, state) {
          if (state is DatabaseGetLoadingState) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Container(
              child: SfCartesianChart(
                  legend: Legend(
                    isVisible: true,
                    isResponsive: true,
                    position: LegendPosition.top,
                    alignment: ChartAlignment.near,
                    orientation: LegendItemOrientation.horizontal,
                  ),
                  tooltipBehavior: TooltipBehavior(enable: true),
                  primaryXAxis: DateTimeAxis(),
                  primaryYAxis: NumericAxis(
                      title: AxisTitle(
                          text: 'Calories',
                          textStyle: TextStyle(
                              color: Color.fromRGBO(75, 135, 185, 1))),
                      labelAlignment: LabelAlignment.start),
                  enableAxisAnimation: true,
                  // adding multiple axis
                  // axes: <ChartAxis>[
                  //   NumericAxis(
                  //       name: 'yAxis',
                  //       opposedPosition: true,
                  //       title: AxisTitle(
                  //           text: 'kg-Co2',
                  //           textStyle: TextStyle(
                  //               color: Color.fromRGBO(192, 108, 132, 1))))
                  // ],
                  series: <LineSeries<double, DateTime>>[
                    LineSeries<double, DateTime>(
                        name: 'Calories',
                        dataSource: appCubit.oneMonthCals,
                        xValueMapper: (double calories, int index) {
                          return DateTime.parse(
                              appCubit.oneMonthQueryResult[index]['date']);

                          // String day = DateFormat.Md().format(DateTime.parse(
                          //     appCubit.oneMonthQueryResult[index]['date']));
                          // return day;
                        },
                        yValueMapper: (double calories, int index) => calories),
                    // LineSeries<double, DateTime>(
                    //   name: 'kg/CO₂',
                    //   animationDuration: 5000,

                    //   dataSource: appCubit.oneMonthCo2,
                    //   xValueMapper: (double co2, int index) {
                    //     return DateTime.parse(
                    //         appCubit.oneMonthQueryResult[index]['date']);

                    //     // String day = DateFormat.Md().format(DateTime.parse(
                    //     //     appCubit.oneMonthQueryResult[index]['date']));
                    //     // return day;
                    //   },
                    //   yValueMapper: (double co2, int index) => co2,
                    //   // xAxisName: 'xAxis',
                    //   yAxisName: 'yAxis',
                    // ),
                  ]),
            );
          }
        });
  }
}

class OneMonthGraphCo2 extends StatelessWidget {
  const OneMonthGraphCo2({
    Key key,
    // @required this.oneMonthData,
  }) : super(key: key);

  // final List<Map> oneMonthData;

  @override
  Widget build(BuildContext context) {
    final appCubit = AppCubit.instance(context);
    return BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, state) {},
        builder: (BuildContext context, state) {
          if (state is DatabaseGetLoadingState) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Container(
              child: SfCartesianChart(
                  legend: Legend(
                    isVisible: true,
                    isResponsive: true,
                    position: LegendPosition.top,
                    alignment: ChartAlignment.near,
                    orientation: LegendItemOrientation.horizontal,
                  ),
                  tooltipBehavior: TooltipBehavior(enable: true),
                  primaryXAxis: DateTimeAxis(),
                  primaryYAxis: NumericAxis(
                      title: AxisTitle(
                          text: 'kg-Co2-eq',
                          textStyle: TextStyle(
                              color: Color.fromRGBO(75, 135, 185, 1))),
                      labelAlignment: LabelAlignment.start),
                  enableAxisAnimation: true,
                  // adding multiple axis
                  // axes: <ChartAxis>[
                  //   NumericAxis(
                  //       name: 'yAxis',
                  //       opposedPosition: true,
                  //       title: AxisTitle(
                  //           text: 'kg-Co2',
                  //           textStyle: TextStyle(
                  //               color: Color.fromRGBO(192, 108, 132, 1))))
                  // ],
                  series: <LineSeries<double, DateTime>>[
                    // LineSeries<double, DateTime>(
                    //     name: 'Calories',
                    //     dataSource: appCubit.oneMonthCals,
                    //     xValueMapper: (double calories, int index) {
                    //       return DateTime.parse(
                    //           appCubit.oneMonthQueryResult[index]['date']);

                    //       // String day = DateFormat.Md().format(DateTime.parse(
                    //       //     appCubit.oneMonthQueryResult[index]['date']));
                    //       // return day;
                    //     },
                    //     yValueMapper: (double calories, int index) => calories),
                    LineSeries<double, DateTime>(
                      name: 'kg/CO₂',
                      animationDuration: 5000,

                      dataSource: appCubit.oneMonthCo2,
                      xValueMapper: (double co2, int index) {
                        return DateTime.parse(
                            appCubit.oneMonthQueryResult[index]['date']);

                        // String day = DateFormat.Md().format(DateTime.parse(
                        //     appCubit.oneMonthQueryResult[index]['date']));
                        // return day;
                      },
                      yValueMapper: (double co2, int index) => co2,
                      // xAxisName: 'xAxis',
                      yAxisName: 'yAxis',
                    ),
                  ]),
            );
          }
        });
  }
}


// class ThreeMonthsGraph extends StatelessWidget {
//   const ThreeMonthsGraph({
//     Key key,
//     // @required this.threeMonthsData,
//   }) : super(key: key);

//   // final List<Map> threeMonthsData;

//   @override
//   Widget build(BuildContext context) {
//     final appCubit = AppCubit.instance(context);
//     return BlocConsumer<AppCubit, AppStates>(
//         listener: (BuildContext context, state) {},
//         builder: (BuildContext context, state) {
//           if (state is DatabaseGetLoadingState) {
//             return Center(
//               child: CircularProgressIndicator(),
//             );
//           } else {
//             return Container(
//               child: SfCartesianChart(
//                   primaryXAxis: DateTimeAxis(),
//                   legend: Legend(
//                     isVisible: true,
//                     // title: LegendTitle(text: type),
//                     isResponsive: true,
//                     position: LegendPosition.top,
//                     alignment: ChartAlignment.near,
//                     orientation: LegendItemOrientation.horizontal,
//                   ),
//                   tooltipBehavior: TooltipBehavior(enable: true),
//                   primaryYAxis: NumericAxis(
//                       title: AxisTitle(
//                           text: 'Calories',
//                           textStyle: TextStyle(
//                               color: Color.fromRGBO(75, 135, 185, 1))),
//                       labelAlignment: LabelAlignment.start),
//                   enableAxisAnimation: true,
//                   // adding multiple axis
//                   axes: <ChartAxis>[
//                     NumericAxis(
//                         name: 'yAxis',
//                         opposedPosition: true,
//                         title: AxisTitle(
//                             text: 'kg-Co2',
//                             textStyle: TextStyle(
//                                 color: Color.fromRGBO(192, 108, 132, 1))))
//                   ],
//                   series: <LineSeries<double, DateTime>>[
//                     LineSeries<double, DateTime>(
//                         name: 'Calories',
//                         dataSource: appCubit.threeMonthsCals,
//                         xValueMapper: (double calories, int index) {
//                           return DateTime.parse(
//                               appCubit.threeMonthsQueryResult[index]['date']);

//                           // String day = DateFormat.m().format(DateTime.parse(
//                           //     appCubit.threeMonthsQueryResult[index]['date']));
//                           // return day;
//                         },
//                         yValueMapper: (double calories, int index) => calories),
//                     LineSeries<double, DateTime>(
//                         name: 'Co2',
//                         animationDuration: 5000,
//                         dataSource: appCubit.threeMonthsCo2,
//                         xValueMapper: (double co2, int index) {
//                           return DateTime.parse(
//                               appCubit.threeMonthsQueryResult[index]['date']);

//                           // String day = DateFormat.MEd().format(DateTime.parse(
//                           //     appCubit.threeMonthsQueryResult[index]['date']));
//                           // return day;
//                         },
//                         yValueMapper: (double co2, int index) => co2,
//                         yAxisName: 'yAxis'),
//                   ]),
//             );
//           }
//         });
//   }
// }
