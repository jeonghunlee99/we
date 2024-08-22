import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:weatherapp/data/my_location.dart';
import 'package:weatherapp/data/network.dart';
import 'package:weatherapp/screens/weather_screen.dart';

const apikey = '3ee1faf75b9cab24ae5e398d0577790c';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  double? latitude3;
  double? longitude3;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocation();
  }

  void getLocation() async {
    Mylocation mylocation = Mylocation();
    await mylocation.getMyCurrentLocation();
    latitude3 = mylocation.latitude2;
    longitude3 = mylocation.longitude2;
    print(latitude3);
    print(longitude3);

    Network network = Network(
        'https://api.openweathermap.org/data/2.5/weather?lat=$latitude3&lon=$longitude3&appid=$apikey&units=metric',
        'https://api.openweathermap.org/data/2.5/air_pollution?lat=$latitude3&lon=$longitude3&appid=$apikey');

    var weatherData = await network.getJsonData();

    var airData = await network.getAirData();
    print(airData);

    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return WeatherScreen(
        parseWeatherData: weatherData,
        parseAirPolution: airData,
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      body: Center(
        child: SpinKitDoubleBounce(
          color: Colors.white,
          size: 80,
        ),
      ),
    );
  }
}
