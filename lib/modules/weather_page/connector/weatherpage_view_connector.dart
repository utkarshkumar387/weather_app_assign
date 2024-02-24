import 'dart:async';

import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:weather_app_assign/modules/weather_page/action/lat_lon_detail_action.dart';
import 'package:weather_app_assign/modules/weather_page/action/weather_detail_action.dart';
import 'package:weather_app_assign/modules/weather_page/models/loading_model.dart';
import 'package:weather_app_assign/modules/weather_page/models/weather_model.dart';
import 'package:weather_app_assign/modules/weather_page/views/weather_page_view.dart';
import 'package:weather_app_assign/redux/states/app_state.dart';
import 'package:weather_app_assign/redux/store.dart';
import 'package:weather_app_assign/utilities/loading_indicator.dart';

class WeatherpageViewConnector extends StatefulWidget {
  const WeatherpageViewConnector({Key? key}) : super(key: key);

  @override
  State<WeatherpageViewConnector> createState() =>
      _WeatherpageViewConnectorState();
}

class _WeatherpageViewConnectorState extends State<WeatherpageViewConnector> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      vm: () => _ViewModelFactory(this),
      onInit: ((store) async {
        _getCurrentPosition();
      }),
      builder: (context, snapshot) {
        if (snapshot.loadingStatus != LoadingStatus.success) {
          return Container(
            color: Colors.white,
            child: const LoadingIndicator(),
          );
        }
        return WeatherPageView(
          weatherDetail: snapshot.weatherDetail,
          place: snapshot.place,
          onSearchTap: snapshot.onSearchTap,
        );
      },
    );
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();
    Position? currentPosition;
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      setState(() => currentPosition = position);
      await store.dispatch(SetLatLonAction(
          lat: currentPosition?.latitude, lon: currentPosition?.longitude));
      await store.dispatch(GetCurrentLocationWeatherDetailsAction());
      _getAddressFromLatLng(currentPosition!);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    String? currentAddress;
    await placemarkFromCoordinates(position.latitude, position.longitude)
        .then((List<Placemark> placemarks) async {
      Placemark place = placemarks[0];
      setState(() {
        currentAddress =
            '${place.subLocality}, ${place.locality}, ${place.administrativeArea}';
      });
      await store.dispatch(SetPlaceAction(place: currentAddress));
    }).catchError((e) {
      debugPrint(e);
    });
  }
}

class _ViewModel extends Vm {
  final Function(double, double) setLatLon;
  final WeatherModel? weatherDetail;
  final LoadingStatus loadingStatus;
  final String place;
  final Function(
    String searchString,
  ) onSearchTap;
  _ViewModel({
    required this.setLatLon,
    required this.weatherDetail,
    required this.loadingStatus,
    required this.place,
    required this.onSearchTap,
  }) : super(equals: [loadingStatus]);
}

class _ViewModelFactory
    extends VmFactory<AppState, _WeatherpageViewConnectorState> {
  _ViewModelFactory(_WeatherpageViewConnectorState widget) : super(widget);

  @override
  _ViewModel fromStore() => _ViewModel(
        setLatLon: (double lat, double lon) {
          dispatch(
            SetLatLonAction(lat: lat, lon: lon),
          );
        },
        weatherDetail: state.weatherDetailState.weatherDetail,
        loadingStatus: state.loadingStatus,
        place: state.weatherDetailState.place ?? '',
        onSearchTap: (
          String searchString,
        ) async {
          await dispatch(
            GetSearchedLocationDetailsAction(
              searchCityName: searchString,
            ),
          );
        },
      );
}
