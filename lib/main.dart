import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:eatmission/services/auth_service.dart';
import 'package:eatmission/wrapper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'Views/screens.dart';
import 'package:eatmission/shared/app_cubit.dart';
import 'package:eatmission/shared/dairy_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(
          create: (_) => AuthService(),
        ),
      ],
        child: MultiBlocProvider(
        providers: [
    BlocProvider(
    create: (BuildContext context) => AppCubit(),
    ),
    BlocProvider(
    create: (BuildContext context) =>
    DairyCubit()..getUsersTripsList(Source.cache),
    ),
    // BlocProvider(
    // create: (BuildContext context) => GoalCubit(),
    // )
    ],
      child: MaterialApp(
        title: 'Flutter Auth Example',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => Wrapper(),
          '/login': (context) => LoginScreen(),
          '/register': (context) => RegisterScreen(),
        },
      ),
        ),
    );

  }
}
