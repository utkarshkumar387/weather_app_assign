import 'package:flutter/material.dart';
import 'package:weather_app_assign/modules/weather_page/models/loading_model.dart';
import 'lat_lon_detail_state.dart';
import 'weather_detail_state.dart';

@immutable
class AppState {
  final WeatherDetailState weatherDetailState;
  final WeatherDetailState searchedWeatherDetailState;
  final LatLonDetailState latLonDetailState;
  final LoadingStatus loadingStatus;
  final LoadingStatus searchScreenLoadingStatus;
  const AppState({
    required this.weatherDetailState,
    required this.latLonDetailState,
    required this.loadingStatus,
    required this.searchedWeatherDetailState,
    required this.searchScreenLoadingStatus,
  });

  factory AppState.init() {
    return AppState(
      weatherDetailState: WeatherDetailState.init(),
      searchedWeatherDetailState: WeatherDetailState.init(),
      latLonDetailState: LatLonDetailState.init(),
      loadingStatus: LoadingStatus.idle,
      searchScreenLoadingStatus: LoadingStatus.idle,
    );
  }

  AppState copyWith({
    WeatherDetailState? weatherDetailState,
    WeatherDetailState? searchedWeatherDetailState,
    LatLonDetailState? latLonDetailState,
    LoadingStatus? loadingStatus,
    LoadingStatus? searchScreenLoadingStatus,
  }) {
    return AppState(
      weatherDetailState: weatherDetailState ?? this.weatherDetailState,
      latLonDetailState: latLonDetailState ?? this.latLonDetailState,
      loadingStatus: loadingStatus ?? this.loadingStatus,
      searchedWeatherDetailState:
          searchedWeatherDetailState ?? this.searchedWeatherDetailState,
      searchScreenLoadingStatus:
          searchScreenLoadingStatus ?? this.searchScreenLoadingStatus,
    );
  }

  @override
  bool operator ==(covariant AppState other) {
    if (identical(this, other)) return true;

    return other.weatherDetailState == weatherDetailState &&
        other.latLonDetailState == latLonDetailState &&
        other.loadingStatus == loadingStatus &&
        other.searchedWeatherDetailState == searchedWeatherDetailState &&
        other.searchScreenLoadingStatus == searchScreenLoadingStatus;
  }

  @override
  int get hashCode {
    return weatherDetailState.hashCode ^
        latLonDetailState.hashCode ^
        loadingStatus.hashCode ^
        searchedWeatherDetailState.hashCode ^
        searchScreenLoadingStatus.hashCode;
  }
}
