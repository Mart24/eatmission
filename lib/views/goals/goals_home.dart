import 'package:flutter/material.dart';
import 'package:food_app/Views/constants.dart';
import 'package:food_app/Views/goals/graphs_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:food_app/views/goals/log_cubit.dart';
import 'package:food_app/views/profile/faq_widget_view.dart';

import 'goals_screen.dart';

class GoalsHome extends StatefulWidget {
  const GoalsHome({Key key}) : super(key: key);

  @override
  _GoalsHomeState createState() => _GoalsHomeState();
}

class _GoalsHomeState extends State<GoalsHome>
    with SingleTickerProviderStateMixin {
  int currentIndex = 0;
  List<Widget> screens = [
    GoalsScreen(),
    GraphsScreen(),
    FaqView(),
  ];
  TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    LogCubit logCubit = LogCubit.instance(context);
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size(double.infinity, 50),
          child: Container(
            height: 50,
            color: kPrimaryColor,
            child: TabBar(
              controller: tabController,
              indicator: BoxDecoration(
                color: Colors.black.withOpacity(0.2),
                borderRadius: BorderRadius.circular(5),
              ),
              labelStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              labelColor: Colors.white,
              tabs: [
                Tab(child: Text(AppLocalizations.of(context).goals)),
                Tab(child: Text(AppLocalizations.of(context).graphs)),
                Tab(child: Text('Tips')),
              ],
              onTap: (index) {
                setState(() {
                  currentIndex = index;
                });
                switch (currentIndex) {
                  case 0:
                    logCubit.addLog("button goal");
                    print("log to goals");
                    break;
                  case 1:
                    logCubit.addLog("button graph");
                    print("log to graphs");
                    break;
                  case 2:
                    print("do nothing");
                    break;
                  default:
                    print("do nothing");
                }
              },
            ),
          ),
        ),
        body: TabBarView(
          controller: tabController,
          children: screens,
        ),
      ),
    );
  }
}
