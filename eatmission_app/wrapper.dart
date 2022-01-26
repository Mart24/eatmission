import 'package:eatmission/views/widgets/navigation_widget.dart';
import 'package:eatmission/views/introduction_screen.dart';
import 'package:flutter/material.dart';
import 'package:eatmission/views/screens.dart';
import 'package:eatmission/services/auth_service.dart';
import 'package:provider/provider.dart';

import 'models/user_model.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return StreamBuilder<User?>(
      stream: authService.user,
      builder: (_, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final User? user = snapshot.data;
          return user == null ? OnBoardingPage() : Home();
        } else {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
