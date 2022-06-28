import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart'
    as settingsscreen;
import 'package:food_app/Widgets/theme_provider.dart';
import 'package:food_app/shared/amount_cubit.dart';
import 'package:food_app/shared/fav_cubit.dart';
import 'package:food_app/shared/productOne_cubit.dart';
import 'package:food_app/shared/productTwo_cubit.dart';
import 'package:food_app/shared/recent_cubit.dart';
import 'package:food_app/views/goals/log_cubit.dart';
import 'package:provider/provider.dart' as provider1;
import '../l10n/l10n.dart';
import 'package:food_app/shared/app_cubit.dart';
import 'package:food_app/shared/dairy_cubit.dart';
import 'package:food_app/shared/goal_cubit.dart';
import 'package:food_app/shared/search_cubit.dart';
import 'Widgets/Navigation_widget.dart';
import 'package:food_app/Services/auth_service.dart';
import 'package:food_app/Widgets/Provider_Auth.dart';
import 'package:food_app/Views/sign_up_view.dart';
import 'package:food_app/Views/introduction_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// @dart=2.9
// /test
// macbook

/// Custom [BlocObserver] which observes all bloc and cubit instances.
class MyBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    print('onCreate -- ${bloc.runtimeType}');
  }

  @override
  void onEvent(Bloc bloc, Object event) {
    super.onEvent(bloc, event);
    print('onEvent -- ${bloc.runtimeType}, $event');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    print('onChange -- ${bloc.runtimeType}, $change');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print('onTransition -- ${bloc.runtimeType}, $transition');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    print('onError -- ${bloc.runtimeType}, $error');
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    print('onClose -- ${bloc.runtimeType}');
  }
}

// _incrementCounter() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   int goal = prefs.getInt('goal');
//   // await prefs.setInt('counter', counter);
// }

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //This can be used for accessing the darkmode.
  await settingsscreen.Settings.init(
      cacheProvider: settingsscreen.SharePreferenceCache());

  await Firebase.initializeApp();

  // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
  //     statusBarBrightness: Brightness.light,
  //     statusBarColor: Colors.transparent));
  Bloc.observer = MyBlocObserver();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of the application.

  void sendNotification({String title, String body}) async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    ////Set the settings for various platform
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const LinuxInitializationSettings initializationSettingsLinux =
        LinuxInitializationSettings(
      defaultActionName: 'hello',
    );
    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS,
            linux: initializationSettingsLinux);
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );

    ///
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'high_channel', 'High Importance Notification',
        description: "This channel is for important notification",
        importance: Importance.max);

    flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(channel.id, channel.name,
            channelDescription: channel.description),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => provider1.ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
        builder: (context, _) {
          final themeProvider = provider1.Provider.of<ThemeProvider>(context);
          return Provider(
            auth: AuthService(),
            child: MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (BuildContext context) => AppCubit(),
                ),
                BlocProvider(
                  create: (BuildContext context) => DairyCubit()
                    ..getUsersTripsList(Source.cache)
                    ..getCalGoal()
                    ..getSaveGoal()
                    ..getCarbGoal()
                    ..getProteinGoal(),
                ),
                BlocProvider(
                  create: (BuildContext context) => GoalCubit(),
                ),
                BlocProvider(
                  create: (BuildContext context) => SearchCubit(),
                ),
                BlocProvider(
                  create: (BuildContext context) => ProductTwoCubit(),
                ),
                BlocProvider(
                  create: (BuildContext context) => ProductOneCubit(),
                ),
                BlocProvider(
                  create: (BuildContext context) =>
                      FavCubit()..getUserFavTripsList(Source.serverAndCache),
                ),
                BlocProvider(
                  create: (BuildContext context) => RecentCubit()
                    ..getUserRecentTripsList(Source.serverAndCache),
                ),
                BlocProvider(
                  create: (BuildContext context) => AmountCubit(),
                ),
                BlocProvider(
                  create: (BuildContext context) => LogCubit(),
                ),
              ],
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Test123',
                // theme: ThemeData(
                //   primarySwatch: Colors.green,
                //   backgroundColor: Colors.yellow,
                // ),
                themeMode: themeProvider.themeMode,
                theme: Mythemes.lightTheme,
                darkTheme: Mythemes.darkTheme,
                home: HomeController(),
                routes: <String, WidgetBuilder>{
                  '/signUp': (BuildContext context) =>
                      SignUpView(authFormType: AuthFormType.signUp),
                  '/signIn': (BuildContext context) =>
                      SignUpView(authFormType: AuthFormType.signIn),
                  '/home': (BuildContext context) => HomeController(),
                },
                supportedLocales: L10n.all,
                localizationsDelegates: [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                ],
              ),
            ),
          );
        },
      );
}

class HomeController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthService auth = Provider.of(context).auth;
    return StreamBuilder<String>(
      stream: auth.onAuthStateChanged,
      builder: (context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final bool signedIn = snapshot.hasData;
          if (signedIn) {
            print('auth signed in ${snapshot.data}');
            AppCubit.instance(context).createDB(snapshot.data, 'goals');
            return Home();
          } else {
            return OnBoardingPage();
          }
        }
        return CircularProgressIndicator();
      },
    );
  }
}
