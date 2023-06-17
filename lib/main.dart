import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_chat_app/helper/helper_function.dart';
import 'package:flutter_chat_app/pages/home_page.dart';
import 'package:flutter_chat_app/pages/login_page.dart';
import 'package:flutter_chat_app/shared/constants.dart';
import 'package:dynamic_color/dynamic_color.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    // initializing for web
    await Firebase.initializeApp(
        options: FirebaseOptions(
      apiKey: Constants.apiKey,
      appId: Constants.appID,
      messagingSenderId: Constants.messagingSenderID,
      projectId: Constants.projectID,
    ));
  } else {
    // initializing for iOS, android
    await Firebase.initializeApp();
  }

  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  bool _isSignedIn = false;
  Color fallbackColor = Colors.blue;

  @override
  void initState() {
    super.initState();
    getUserLoggedInStatus();
  }

  getUserLoggedInStatus() async {
    await HelperFunctions.getUserLoggedInStatus().then(
      (value) {
        if (value != null) {
          setState(() {
            _isSignedIn = value;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        ColorScheme lightColorScheme;
        ColorScheme darkColorScheme;

        if (lightDynamic != null && darkDynamic != null) {
          print("USING DEVICE COLOR SCHEME");
          lightColorScheme = lightDynamic.harmonized()..copyWith();
          darkColorScheme = darkDynamic.harmonized()..copyWith();
        } else {
          lightColorScheme = ColorScheme.fromSeed(
            seedColor: fallbackColor,
          );
          darkColorScheme = ColorScheme.fromSeed(
            seedColor: fallbackColor,
            brightness: Brightness.dark,
          );
        }

        return MaterialApp(
          theme: ThemeData(
              useMaterial3: true,
              colorScheme: lightColorScheme,
              fontFamily: "Product-Sans"),
          debugShowCheckedModeBanner: false,
          home: _isSignedIn ? const HomePage() : const LoginPage(),
        );
      },
    );
  }
}
