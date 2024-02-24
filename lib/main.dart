import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import 'package:weather_app_assign/modules/weather_page/connector/weatherpage_view_connector.dart';
import 'package:weather_app_assign/redux/states/app_state.dart';
import 'package:weather_app_assign/redux/store.dart';
import 'package:weather_app_assign/utilities/navigation_handler.dart';

void main() {
  NavigateAction.setNavigatorKey(NavigationHandler.navigatorKey);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather Now',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: StoreProvider<AppState>(
        store: store,
        child: Builder(
          builder: (context) {
            return MaterialApp(
              navigatorObservers: [
                NavigationHandler.routeObserver,
              ],
              debugShowCheckedModeBanner: false,
              home: const WeatherpageViewConnector(),
              navigatorKey: NavigationHandler.navigatorKey,
            );
          },
        ),
      ),
    );
  }
}
