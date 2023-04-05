// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:push_notifications/screens/screens.dart';
import 'package:push_notifications/services/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await PushNotificationService.initApp();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final GlobalKey<ScaffoldMessengerState> scafoldKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();

    PushNotificationService.messagesStream.listen((message) {
      print('MyApp: $message');

      navigatorKey.currentState?.pushNamed('message', arguments: message);

      final snackBar = SnackBar(
        content: Text('New: $message'),
        showCloseIcon: true,
      );
      scafoldKey.currentState?.showSnackBar(snackBar);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Push Notifications',
      initialRoute: 'home',
      navigatorKey: navigatorKey,
      scaffoldMessengerKey: scafoldKey,
      routes: {
        'home': (_) => const HomeScreen(),
        'message': (_) => const MessageScreen(),
      },
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
        appBarTheme: const AppBarTheme(backgroundColor: Colors.red),
      ),
    );
  }
}
