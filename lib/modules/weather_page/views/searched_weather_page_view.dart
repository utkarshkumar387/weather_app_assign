import 'package:flutter/material.dart';
import 'package:weather_app_assign/modules/weather_page/action/weather_detail_action.dart';
import 'package:weather_app_assign/modules/weather_page/models/weather_model.dart';
import 'package:weather_app_assign/modules/weather_page/views/widgets/summary_card.dart';
import 'package:weather_app_assign/modules/weather_page/views/widgets/weather_detail_card.dart';
import 'package:weather_app_assign/redux/store.dart';
import 'package:weather_app_assign/utilities/generic_methods.dart';

class SearchedWeatherPageView extends StatefulWidget {
  final WeatherModel? weatherDetail;
  final String place;
  const SearchedWeatherPageView(
      {Key? key, required this.weatherDetail, required this.place})
      : super(key: key);

  @override
  State<SearchedWeatherPageView> createState() =>
      _SearchedWeatherPageViewState();
}

class _SearchedWeatherPageViewState extends State<SearchedWeatherPageView> {
  final TextEditingController cityTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 194, 188, 253),
        elevation: 0,
      ),
      body: Container(
        decoration: ShapeDecoration(
          color: const Color.fromARGB(255, 209, 205, 255),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            GenericMethods.getDate(int.parse(
                                widget.weatherDetail?.current.dt ?? '')),
                            style: const TextStyle(
                              color: Color.fromARGB(255, 44, 44, 44),
                              fontSize: 18,
                              fontFamily: 'Circular Std',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 10),
                                child: Text(
                                  widget.place,
                                  style: const TextStyle(
                                    color: Color.fromARGB(255, 44, 44, 44),
                                    fontSize: 14,
                                    fontFamily: 'Circular Std',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 40),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.network(
                              'http://openweathermap.org/img/w/${widget.weatherDetail?.current.weatherDetail[0].icon}.png'),
                          RichText(
                            text: TextSpan(
                              text: widget.weatherDetail?.current.temp ?? '',
                              style: const TextStyle(
                                color: Color.fromARGB(255, 44, 44, 44),
                                fontSize: 54,
                                fontFamily: 'Circular Std',
                                fontWeight: FontWeight.w500,
                              ),
                              children: const <TextSpan>[
                                TextSpan(
                                  text: ' deg',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 44, 44, 44),
                                    fontSize: 24,
                                    fontFamily: 'Circular Std',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      widget.weatherDetail?.current.weatherDetail[0].main ?? '',
                      style: const TextStyle(
                        color: Color.fromARGB(255, 44, 44, 44),
                        fontSize: 16,
                        fontFamily: 'Circular Std',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      height: 48,
                    ),
                    SummaryCard(weatherDetail: widget.weatherDetail?.current),
                    const SizedBox(
                      height: 32,
                    ),
                    const Text(
                      'Weather for next 7 days',
                      style: TextStyle(
                        color: Color.fromARGB(255, 44, 44, 44),
                        fontSize: 16,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                        height: 1.20,
                      ),
                    ),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: widget.weatherDetail?.daily.length,
                      itemBuilder: (context, index) {
                        return (index == 0)
                            ? const SizedBox.shrink()
                            : WeatherDetailCard(
                                icon: widget.weatherDetail?.daily[index]
                                    .weatherDetail[0].icon,
                                temp: widget.weatherDetail?.daily[index].temp,
                                weather: widget.weatherDetail?.daily[index]
                                    .weatherDetail[0].main,
                                date: widget.weatherDetail?.daily[index].dt,
                              );
                      },
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
