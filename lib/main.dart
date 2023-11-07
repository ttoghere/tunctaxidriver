import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tunctaxidriver/controllers/authentication_provider.dart';
import 'package:tunctaxidriver/controllers/main_screen.dart';
import 'package:tunctaxidriver/controllers/app_info.dart';
import 'package:tunctaxidriver/screens/splash/splash_screen.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_MyAppState>()!.restartApp();
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => AuthController()),
          ChangeNotifierProvider(create: (context) => MainScreenController()),
          ChangeNotifierProvider(create: (context) => AppInfo()),
        ],
        child: MaterialApp(
          title: 'Drivers App',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          initialRoute: MySplashScreen.routeName,
          debugShowCheckedModeBanner: false,
          routes: {
            MySplashScreen.routeName: (context) => const MySplashScreen()
          },
        ),
      ),
    );
  }
}
