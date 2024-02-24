import 'package:async_redux/async_redux.dart';

import '../states/app_state.dart';
import 'dev_tools_store.dart';

class DevToolsStateObserver extends StateObserver<AppState> {
  @override
  void observe(
    ReduxAction<AppState> action,
    AppState stateIni,
    AppState stateEnd,
    Object? error,
    int dispatchCount,
  ) {
    devToolsStore.dispatch(action);
  }
}
