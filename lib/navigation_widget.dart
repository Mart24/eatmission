import 'package:eatmission/screens/home_screen.dart';
import 'package:eatmission/screens/profile/profile_view.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    const HomeScreen(),
   // Foodpage(),
  //  GoalsHome(),
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
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          onTap: onTabTapped,
          currentIndex: _currentIndex,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.book), label: "Diary"),
            BottomNavigationBarItem(
                icon: Icon(Icons.restaurant), label: "Recipes"),
            BottomNavigationBarItem(
                icon: Icon(Icons.leaderboard), label: "Goals"),
            BottomNavigationBarItem(
                icon: Icon(Icons.person_pin), label: "Profile"),
            // BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: "List"),

          ]),
    );
  }

  void onTabTapped(int index) {
    if (index == 2) {
      // final appCubit = AppCubit.instance(context);
      // final uid = FirebaseAuth.instance.currentUser.uid;
      // appCubit.getOneWeekData(appCubit.database, uid);
      // DateTime now = DateTime.now();
      // now =DateTime(now.year,now.month,now.day);
      // appCubit.getDataFromDatabase(appCubit.database, uid,
      //     limit: 7,
      //     where:"date > ? and date <= ?",
      //     whereArgs: [now.subtract(Duration(days: 7)).toIso8601String(),now.toIso8601String()]);
    }
    setState(() {
      _currentIndex = index;
    });
  }
}
