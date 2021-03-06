import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_app/Models/ingredients.dart';
import 'package:food_app/Views/compare_feature/compare_page.dart';
import 'package:food_app/Views/constants.dart';
import 'package:food_app/Views/goals/goals_home.dart';
import 'package:food_app/Views/dashboard_diary_view.dart';
import 'package:food_app/Widgets/notification.dart';
import 'package:food_app/shared/app_cubit.dart';
import 'package:food_app/shared/productOne_cubit.dart';
import 'package:food_app/shared/productTwo_cubit.dart';
import 'package:food_app/views/goals/log_cubit.dart';
import 'package:food_app/views/new_food_registration.dart/food_search/food_search.dart';
import 'package:food_app/views/profile/bmr_test.dart';
import 'package:food_app/views/profile/faq_widget_view.dart';
import 'package:food_app/views/profile/setting_page_view.dart';
import '../Views/profile/profile_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

const colordarkgreen = const Color(0xFF7AA573);

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final newTrip = Trip(
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      // null,
      // null,
      // null,
      // null,
      // null,
      null,
      null,
      null);

  int _currentIndex = 0;
  final List<Widget> _children = [
    HomePage(),
    ComparePage(),
    NewFoodIntake(),
    //FaqView(),
    GoalsHome(),
    SettingsThreePage(),
    //Lijstje(),
  ];

  @override
  Widget build(BuildContext context) {
    LogCubit logCubit = LogCubit.instance(context);

    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Food App"),
      //   backgroundColor: kPrimaryColor,
      //   actions: [
      //     IconButton(
      //         icon: Icon(Icons.add),
      //         onPressed: () {
      //           Navigator.push(
      //               context,
      //               MaterialPageRoute(
      //                 builder: (context) => NewFoodIntake(
      //                   trip: newTrip,
      //                 ),
      //               ));
      //         }),
      //     IconButton(
      //       icon: Icon(Icons.logout),
      //       onPressed: () async {
      //         try {
      //           AuthService auth = Provider.of(context).auth;
      //           DairyCubit.instance(context).init();
      //           // DairyCubit.instance(context).getUsersTripsList();
      //           await auth.signOut();
      //           print("Signed Out!");
      //         } catch (e) {
      //           print(e);
      //         }
      //       },
      //     )
      //   ],
      // ),
      body: Stack(
        children: [
          _children[_currentIndex],
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NewFoodIntake(),
              ));

          print("log to Intake button");
        },
        //  label: const Text('Food'),
        child: const Icon(
          Icons.add,
          color: Colors.black54,
        ),
        backgroundColor: Colors.white,
        elevation: 4,

        // foregroundColor: Colors.white,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          unselectedItemColor: Colors.grey,
          selectedItemColor: kPrimaryColor,
          onTap: onTabTapped,
          currentIndex: _currentIndex,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.book),
                activeIcon: Icon(Icons.book, color: kPrimaryColor),
                label: 'Dashboard'),

            BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.balanceScaleRight),
                label: AppLocalizations.of(context).comparetext),
            BottomNavigationBarItem(
                icon: Icon(Icons.add),
                activeIcon: Icon(Icons.add, color: kPrimaryColor),
                label: AppLocalizations.of(context).intaketext),
            // BottomNavigationBarItem(
            //     icon: FaIcon(FontAwesomeIcons.questionCircle),
            //     // activeIcon:
            //     //     Icon(Icons.bar_chart_outlined, color: kPrimaryColor),
            //     label: 'Info'),
            BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.chartLine),
                // activeIcon:
                //     Icon(Icons.bar_chart_outlined, color: kPrimaryColor),
                label: AppLocalizations.of(context).goalstext),
            BottomNavigationBarItem(
                icon: Icon(Icons.person_pin),
                label: AppLocalizations.of(context).profiletext),
            // BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: "List"),
          ]),
    );
  }

  void onTabTapped(int index) {
    LogCubit logCubit = LogCubit.instance(context);

    if (index == 2) {
      final appCubit = AppCubit.instance(context);
      final uid = FirebaseAuth.instance.currentUser.uid;
      appCubit.getOneWeekData(appCubit.database, uid);
      // DateTime now = DateTime.now();
      // now =DateTime(now.year,now.month,now.day);
      // appCubit.getDataFromDatabase(appCubit.database, uid,
      //     limit: 7,
      //     where:"date > ? and date <= ?",
      //     whereArgs: [now.subtract(Duration(days: 7)).toIso8601String(),now.toIso8601String()]);
    }
    if (index != 1) {
      if ((ProductOneCubit.instance(context)).state is SearchResultFound1) {
        print('get out and product 1: ${(ProductOneCubit.tappedTripP1.name)}');
      }

      if ((ProductTwoCubit.instance(context)).state is SearchResultFoundTwo) {
        print('get out and product 2: ${(ProductTwoCubit.tappedTrip.name)}');
      }
    } else {
      ProductOneCubit.instance(context).deleteChosenItem();
      ProductTwoCubit.instance(context).deleteChosenItem();
    }

    setState(() {
      _currentIndex = index;
    });
    switch (_currentIndex) {
      case 0:
        logCubit.add1Log("Dashboard button");
        print("log to Dashboard button");
        break;
      case 1:
        logCubit.add1Log("Compare button");
        print("log to Compare button");
        break;

      case 2:
        logCubit.add1Log("Intake button");
        print("log to Intake button");
        break;
      case 3:
        logCubit.add1Log("Goals button");
        print("log to Goals button");
        break;
      case 4:
        logCubit.add1Log("Profile button");
        print("log to Profile button");
        break;
      default:
        print("do nothing");
    }
  }
}
