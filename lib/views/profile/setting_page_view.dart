import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food_app/Services/auth_service.dart';
import 'package:food_app/Widgets/Provider_Auth.dart';
import 'package:food_app/Widgets/notification.dart';
import 'package:food_app/shared/app_cubit.dart';
import 'package:food_app/shared/dairy_cubit.dart';
import 'package:food_app/views/constants.dart';
import 'package:food_app/views/profile/bmr_test.dart';
import 'package:food_app/views/profile/co2_calorie_goal_view.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class SettingsThreePage extends StatelessWidget {
  static final String path = "lib/src/pages/settings/settings3.dart";
  final TextStyle headerStyle = TextStyle(
    color: Colors.grey.shade800,
    fontWeight: FontWeight.bold,
    fontSize: 20.0,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        backgroundColor: kPrimaryColor,
        title: Text(
          'Settings',
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Account Instellingen",
              style: headerStyle,
            ),
            const SizedBox(height: 10.0),
            Card(
              elevation: 0.5,
              margin: const EdgeInsets.symmetric(
                vertical: 4.0,
                horizontal: 0,
              ),
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.person),
                    title: Text("Participant"),
                    onTap: () {},
                  ),
                  _buildDivider(),
                  // SwitchListTile(
                  //   activeColor: Colors.green,
                  //   value: false,
                  //   title: Text("Dark mode"),
                  //   onChanged: (val) {},
                  // ),
                  ListTile(
                    leading: FaIcon(FontAwesomeIcons.chartLine),

                    // leading: CircleAvatar(
                    //   backgroundImage:
                    //       AssetImage('assets/icons/first_idea.png'),
                    // ),
                    title: Text("Calorie & CO2 goal"),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Goalgoal(),
                          ));
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.calculate),
                    title: Text("Bereken BMR, AMR en BMI"),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BMRcalculation(),
                          ));
                    },

// onPressed: () {
//           Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => NewFoodIntake(
//                 ),
//               ));
//         },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20.0),
            Text(
              "PUSH NOTIFICATIONS",
              style: headerStyle,
            ),
            Card(
              margin: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 0,
              ),
              child: Column(
                children: <Widget>[
                  SwitchListTile(
                    activeColor: Colors.green,
                    value: true,
                    title: Text("Received notification"),
                    onChanged: (val) {},
                  ),
                ],
              ),
            ),
            Card(
              margin: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 0,
              ),
              child: ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text("Logout"),
                onTap: () async {
                  try {
                    AuthService auth = Provider.of(context).auth;
                    DairyCubit.instance(context).init();
                    // DairyCubit.instance(context).getUsersTripsList();
                    await auth.signOut();
                    print("Signed Out!");
                    AppCubit.instance(context).init();
                  } catch (e) {
                    print(e);
                  }
                },
              ),
            ),
            const SizedBox(height: 60.0),
          ],
        ),
      ),
    );
  }

  Container _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 8.0,
      ),
      width: double.infinity,
      height: 1.0,
      color: Colors.grey.shade300,
    );
  }
}
