import 'package:weather_app_assign/modules/weather_page/models/weather_model.dart';

class WeatherDetailState {
  final WeatherModel? weatherDetail;
  final String? place;
  final String? searchedPlace;

  WeatherDetailState({
    required this.weatherDetail,
    required this.place,
    required this.searchedPlace,
  });

  factory WeatherDetailState.init() {
    return WeatherDetailState(
      weatherDetail: null,
      place: '',
      searchedPlace: '',
    );
  }

  WeatherDetailState copyWith({
    WeatherModel? weatherDetail,
    String? place,
    String? searchedPlace,
  }) {
    return WeatherDetailState(
      weatherDetail: weatherDetail ?? this.weatherDetail,
      place: place ?? this.place,
      searchedPlace: searchedPlace ?? this.searchedPlace,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'weatherDetails': weatherDetail,
      'place': place,
      'searchedPlace': searchedPlace,
    };
  }
}
