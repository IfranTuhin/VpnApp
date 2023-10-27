import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vpn_basic_project/App_Perferences/perferences.dart';
import 'package:vpn_basic_project/Screens/home_screen.dart';


late Size sizeScreen;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AppPerferences.initHive();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Free Vpn',
      theme: ThemeData(
          appBarTheme: AppBarTheme(
              centerTitle: true, elevation: 3
          ),
      ),
      themeMode: AppPerferences.isModeDark ? ThemeMode.dark : ThemeMode.light,
      darkTheme: ThemeData(
          brightness: Brightness.dark,
          appBarTheme: AppBarTheme(
              centerTitle: true, elevation: 3
          ),
      ),
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}


extension AppTheme on ThemeData{

  Color get lightTextColor => AppPerferences.isModeDark ? Colors.white70 : Colors.black54;
  Color get bottomNavigationColor => AppPerferences.isModeDark ? Colors.white12 : Colors.redAccent;

}