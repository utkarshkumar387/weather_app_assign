import 'dart:async';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import 'package:weather_app_assign/environment_config.dart';
import 'package:weather_app_assign/modules/weather_page/connector/searched_weatherpage_view_connector.dart';
import 'package:weather_app_assign/modules/weather_page/models/loading_model.dart';
import 'package:weather_app_assign/modules/weather_page/models/weather_model.dart';
import 'package:weather_app_assign/redux/states/app_state.dart';
import 'package:weather_app_assign/utilities/navigation_handler.dart';

class GetCurrentLocationWeatherDetailsAction extends ReduxAction<AppState> {
  @override
  Future<AppState?> reduce() async {
    var client = http.Client();
    try {
      final lat = state.latLonDetailState.lat;
      final lon = state.latLonDetailState.lon;
      final response = await client.get(
        Uri.parse(
          "https://api.openweathermap.org/data/3.0/onecall?lat=$lat&lon=$lon&units=metric&appid=${EnvironmentConfig.API_KEY}",
          // "",
        ),
        headers: {'content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final responseModel = WeatherModel.fromJson(json.decode(response.body));

        return state.copyWith(
          weatherDetailState: state.weatherDetailState.copyWith(
            weatherDetail: responseModel,
          ),
        );
      } else {
        Fluttertoast.showToast(msg: 'Server error');
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  @override
  void before() => dispatch(ChangeLoadingStatusAction(LoadingStatus.loading));

  @override
  void after() => dispatch(ChangeLoadingStatusAction(LoadingStatus.success));
}

class GetSearchedLocationWeatherDetailsAction extends ReduxAction<AppState> {
  final double lat;
  final double lon;
  GetSearchedLocationWeatherDetailsAction({
    required this.lat,
    required this.lon,
  });
  @override
  Future<AppState?> reduce() async {
    var client = http.Client();
    try {
      final response = await client.get(
        Uri.parse(
          "https://api.openweathermap.org/data/3.0/onecall?lat=$lat&lon=$lon&units=metric&appid=${EnvironmentConfig.API_KEY}",
        ),
        headers: {'content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        await dispatch(
          GetAddressForSearchedLatLon(lat: lat, lon: lon),
        );
        final responseModel = WeatherModel.fromJson(json.decode(response.body));
        return state.copyWith(
          searchedWeatherDetailState: state.weatherDetailState.copyWith(
            weatherDetail: responseModel,
          ),
        );
      } else {
        Fluttertoast.showToast(msg: 'Invalid location');
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  @override
  void before() =>
      dispatch(ChangeSearchScreenLoadingStatusAction(LoadingStatus.loading));

  @override
  void after() =>
      dispatch(ChangeSearchScreenLoadingStatusAction(LoadingStatus.success));
}

class GetSearchedLocationDetailsAction extends ReduxAction<AppState> {
  final String searchCityName;
  GetSearchedLocationDetailsAction({
    required this.searchCityName,
  });
  @override
  Future<AppState?> reduce() async {
    if (searchCityName.isEmpty) {
      Fluttertoast.showToast(msg: 'Please enter city name');
      return null;
    }
    var client = http.Client();
    try {
      final response = await client.get(
        Uri.parse(
          "http://api.openweathermap.org/geo/1.0/direct?q=$searchCityName&limit=1&appid=${EnvironmentConfig.API_KEY}",
        ),
        headers: {'content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final responseModel = json.decode(response.body);
        if (responseModel.length == 0) {
          Fluttertoast.showToast(msg: 'Invalid location');
          return null;
        }
        Navigator.push(
          NavigationHandler.navigatorKey.currentContext!,
          MaterialPageRoute(
            builder: (_) => SearchedWeatherpageViewConnector(
              lat: responseModel[0]['lat'],
              lon: responseModel[0]['lon'],
            ),
          ),
        );
      } else {
        Fluttertoast.showToast(msg: 'Server error');
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }
}

class SetPlaceAction extends ReduxAction<AppState> {
  String? place;
  SetPlaceAction({required this.place});
  @override
  Future<AppState?> reduce() async {
    return state.copyWith(
      weatherDetailState: state.weatherDetailState.copyWith(
        place: place,
      ),
    );
  }
}

class SetSearchedPlaceAction extends ReduxAction<AppState> {
  String? place;
  SetSearchedPlaceAction({required this.place});
  @override
  Future<AppState?> reduce() async {
    return state.copyWith(
      weatherDetailState: state.weatherDetailState.copyWith(
        searchedPlace: place,
      ),
    );
  }
}

class ChangeLoadingStatusAction extends ReduxAction<AppState> {
  final LoadingStatus loadingStatus;

  ChangeLoadingStatusAction(this.loadingStatus);

  @override
  AppState reduce() {
    return state.copyWith(
      loadingStatus: loadingStatus,
    );
  }
}

class GetAddressForSearchedLatLon extends ReduxAction<AppState> {
  final double lat;
  final double lon;
  GetAddressForSearchedLatLon({required this.lat, required this.lon});
  @override
  Future<AppState?> reduce() async {
    String? currentAddress;
    await placemarkFromCoordinates(lat, lon)
        .then((List<Placemark> placemarks) async {
      Placemark place = placemarks[0];
      currentAddress =
          '${place.subLocality}, ${place.locality}, ${place.administrativeArea}';

      await store.dispatch(SetSearchedPlaceAction(place: currentAddress));
    }).catchError((e) {
      debugPrint(e);
    });
  }
}

class ChangeSearchScreenLoadingStatusAction extends ReduxAction<AppState> {
  final LoadingStatus loadingStatus;

  ChangeSearchScreenLoadingStatusAction(this.loadingStatus);

  @override
  AppState reduce() {
    return state.copyWith(
      searchScreenLoadingStatus: loadingStatus,
    );
  }
}
