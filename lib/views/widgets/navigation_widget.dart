import 'package:eatmission/models/ingredients.dart';
import 'package:eatmission/views/home_screen.dart';
import 'package:eatmission/views/new_food_registration/food_search.dart';
import 'package:eatmission/views/home_screen_test.dart';
import 'package:eatmission/views/compare_feature/compare_page.dart';
import 'package:eatmission/views/goals/goals_home.dart';
import 'package:eatmission/views/profile/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

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
      // null,
      // null,
      // null,
      // null,
      // null,
      // null,
      // null,
      // null,
      // null,
      // null,
      null);

  int _currentIndex = 0;
  final List<Widget> _children = [
    const HomeScreen(),
   ComparePage(),
    HomeScreen(),
   GoalsHome(),
    Profiel(),
    //Lijstje(),
  ];

  @override
  Widget build(BuildContext context) {
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
                builder: (context) => NewFoodIntake(
                  //trip: newTrip,
                ),
              ));
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
          onTap: onTabTapped,
          currentIndex: _currentIndex,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.book),
                label: 'Home'),
            BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.balanceScaleRight),
                label: 'Compare'),
            BottomNavigationBarItem(
                icon: Icon(Icons.add),
                label: 'Intake'),
            BottomNavigationBarItem(
                icon: Icon(Icons.leaderboard),
                label: 'Goals'),
            BottomNavigationBarItem(
                icon: Icon(Icons.person_pin),
                label: 'Profile'),
            // BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: "List"),
          ]),
    );
  }

   void onTabTapped(int index) {
  //   if (index == 2) {
  //     final appCubit = AppCubit.instance(context);
  //     final uid = FirebaseAuth.instance.currentUser!.uid;
  //     appCubit.getOneWeekData(appCubit.database!, uid);
  //     // DateTime now = DateTime.now();
  //     // now =DateTime(now.year,now.month,now.day);
  //     // appCubit.getDataFromDatabase(appCubit.database, uid,
  //     //     limit: 7,
  //     //     where:"date > ? and date <= ?",
  //     //     whereArgs: [now.subtract(Duration(days: 7)).toIso8601String(),now.toIso8601String()]);
  //   }
  //   if (index != 1) {
  //     if ((ProductOneCubit.instance(context)).state is SearchResultFound1) {
  //       print('get out and product 1: ${(ProductOneCubit.tappedTripP1!.name)}');
  //     }
  //
  //     if ((ProductTwoCubit.instance(context)).state is SearchResultFoundTwo) {
  //       print('get out and product 2: ${(ProductTwoCubit.tappedTrip!.name)}');
  //     }
  //   } else {
  //     ProductOneCubit.instance(context).deleteChosenItem();
  //     ProductTwoCubit.instance(context).deleteChosenItem();
  //   }

    setState(() {
      _currentIndex = index;
    });
  }
}
