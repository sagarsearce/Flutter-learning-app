import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter101/screens/cart/cart_page.dart';
import 'package:flutter101/screens/login/login.dart';
import 'package:flutter101/screens/profile/profile.dart';
import 'package:flutter101/services/analytics_service.dart';
import 'package:flutter101/services/auth_service.dart';
import 'package:flutter101/services/firebase_storage_service.dart';
import 'package:flutter101/services/firestore_service.dart';
import 'package:flutter101/services/flutterfire.dart';
import 'package:flutter101/theme.dart';
import 'package:provider/provider.dart';
import 'screens/Home/home.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'services/messaging_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await bootstrapeFlutterFire();
  initilizeFirebaseMessageService();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  static Analytics _analytics = Analytics(FirebaseAnalytics());
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          Provider<AuthService>(
            create: (context) => AuthService(FirebaseAuth.instance),
          ),
          Provider<FireStoreService>(
            create: (_) => FireStoreService(
              FirebaseFirestore.instance,
            ),
          ),
          Provider<Analytics>(
            create: (_) => Analytics(FirebaseAnalytics()),
          ),
          Provider<Storage>(create: (_) => Storage(FirebaseStorage.instance)),
          StreamProvider<User?>(
              initialData: null,
              create: (context) =>
                  context.read<AuthService>().authStateChanges),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: MyTheme.lightTheme(context),
          home: const AuthContainer(),
          navigatorObservers: <NavigatorObserver>[_analytics.observer],
          routes: {
            'home': (context) => const Home(),
            'login_page': (context) => const Login(),
            'cart_page': (context) => const Cart(),
            'profile_page': (context) => const Profile()
          },
        ));
  }
}

class AuthContainer extends StatelessWidget {
  const AuthContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();
    if (firebaseUser != null) {
      return const Home();
    } else {
      return const Login();
    }
  }
}
