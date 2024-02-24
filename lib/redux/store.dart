import 'package:async_redux/async_redux.dart';
import 'package:weather_app_assign/redux/dev_tools/dev_tools_store_observer.dart';
import 'package:weather_app_assign/redux/states/app_state.dart';

Store<AppState> store = Store<AppState>(
  initialState: AppState.init(),
  stateObservers: <StateObserver<AppState>>[
    DevToolsStateObserver(),
  ],
);
