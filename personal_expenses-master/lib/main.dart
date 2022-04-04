import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'components/main_components.dart';
import 'constants/styles/themes.dart';
import 'providers/appstate.dart';
import 'screens/auth/login.dart';
import 'screens/tabs/main_tab.dart';
import 'services/app/app_service.dart';
import 'services/auth/auth_service.dart';
import 'services/functions/callable_service.dart';
import 'services/global_context.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await Firebase.initializeApp();

  runApp(const PersonalExpenses());
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

class PersonalExpenses extends StatelessWidget {
  const PersonalExpenses({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthService _authService = AuthService(
      FirebaseAuth.instance,
      FirebaseFirestore.instance,
    );
    final AppService _appService = AppService(FirebaseFirestore.instance);
    final CallableService _callableService =
        CallableService(FirebaseFunctions.instance);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AppState(
            appService: _appService,
            authService: _authService,
            callableService: _callableService,
          ),
        )
      ],
      child: MaterialApp(
        navigatorKey: NavigationService.navigatorKey,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: const [Locale("tr")],
        locale: const Locale("tr"),
        theme: appTheme,
        debugShowCheckedModeBanner: false,
        builder: (context, child) => MediaQuery(
            child: child!,
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0)),
        home: SafeArea(
          top: false,
          bottom: false,
          child: Scaffold(
            body: StreamBuilder(
              stream: _authService.auth.authStateChanges(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return buildCircularProgress();
                }
                if (snapshot.hasData) {
                  return TabsScreen(userID: snapshot.data!.uid);
                }
                return const Login();
              },
            ),
          ),
        ),
      ),
    );
  }
}
