import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sizer/sizer.dart';
import 'core/routes/app_router.dart';

final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final appDocumentDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);

  await Hive.openBox('users');
  await Hive.openBox('chats');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp.router(
          title: 'Mini Chat Application',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Color(0xff005acf),
              primary: Color(0xff005acf),
              brightness: Brightness.light,
            ),
            useMaterial3: true,
            appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
          ),
          routerConfig: AppRouter.goRouter,
          builder: (context, child) {
            return Navigator(
              observers: [routeObserver],
              onPopPage: (route, result) => route.didPop(result),
              pages: [MaterialPage(child: child!)],
            );
          },
        );
      },
    );
  }
}
