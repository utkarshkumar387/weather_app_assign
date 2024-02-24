import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import 'package:weather_app_assign/modules/weather_page/action/weather_detail_action.dart';
import 'package:weather_app_assign/modules/weather_page/models/loading_model.dart';
import 'package:weather_app_assign/modules/weather_page/models/weather_model.dart';
import 'package:weather_app_assign/modules/weather_page/views/searched_weather_page_view.dart';
import 'package:weather_app_assign/redux/states/app_state.dart';
import 'package:weather_app_assign/utilities/loading_indicator.dart';

class SearchedWeatherpageViewConnector extends StatefulWidget {
  final double lat;
  final double lon;
  const SearchedWeatherpageViewConnector({
    Key? key,
    required this.lat,
    required this.lon,
  }) : super(key: key);

  @override
  State<SearchedWeatherpageViewConnector> createState() =>
      _SearchedWeatherpageViewConnectorState();
}

class _SearchedWeatherpageViewConnectorState
    extends State<SearchedWeatherpageViewConnector> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      vm: () => _ViewModelFactory(this),
      onInit: (store) async {
        await store.dispatch(
          GetSearchedLocationWeatherDetailsAction(
            lat: widget.lat,
            lon: widget.lon,
          ),
        );
      },
      builder: (context, snapshot) {
        if (snapshot.loadingStatus != LoadingStatus.success) {
          return Container(
            color: Colors.white,
            child: const LoadingIndicator(),
          );
        }
        return SearchedWeatherPageView(
          weatherDetail: snapshot.searchedWeatherDetail,
          place: snapshot.place,
        );
      },
    );
  }
}

class _ViewModel extends Vm {
  final WeatherModel? searchedWeatherDetail;
  final LoadingStatus loadingStatus;
  final String place;
  _ViewModel({
    required this.searchedWeatherDetail,
    required this.loadingStatus,
    required this.place,
  }) : super(equals: [
          loadingStatus,
          searchedWeatherDetail,
        ]);
}

class _ViewModelFactory
    extends VmFactory<AppState, _SearchedWeatherpageViewConnectorState> {
  _ViewModelFactory(_SearchedWeatherpageViewConnectorState widget)
      : super(widget);

  @override
  _ViewModel fromStore() => _ViewModel(
      searchedWeatherDetail: state.searchedWeatherDetailState.weatherDetail,
      loadingStatus: state.searchScreenLoadingStatus,
      place: state.weatherDetailState.searchedPlace ?? '');
}
