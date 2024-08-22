import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:intl/intl.dart';
import 'package:weatherapp/model/model.dart';

class WeatherScreen extends StatefulWidget {
  WeatherScreen({this.parseWeatherData, this.parseAirPolution});
  final parseWeatherData;
  final parseAirPolution;
  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {

  Model model = Model();
  String? cityName;
  int? temp;
  Widget? icon;
  String? des;
  Widget? airicon;
  Widget? airState;
  double? dust1;
  double? dust2;
  var date = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    updateData(widget.parseWeatherData, widget.parseAirPolution);
  }

  void updateData(dynamic weatherData, dynamic airdata) {
    double temp2 = weatherData['main']['temp'];
    var condition = weatherData['weather'][0]['id'];
    var index = airdata['list'][0]['main']['aqi'];
    des=weatherData['weather'][0]['description'];
    dust1=airdata['list'][0]['components']['pm10'].toDouble();
    dust2=airdata['list'][0]['components']['pm2_5'].toDouble();
    temp = temp2.toInt();
    cityName = weatherData['name'];
    icon=model.getWeatherIcon(condition);
    airicon=model.getAirIcon(index);
    airState=model.getAirCondition(index);

    print(cityName);
    print(temp);
  }

  String getSystemTime(){
    var now = DateTime.now();
    return DateFormat("h:mm a").format(now);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(''),
        leading: IconButton(style: ButtonStyle(iconColor: MaterialStateProperty.all(Colors.white) ),
          icon: Icon(Icons.near_me),
          onPressed: (){},
          iconSize: 30,
        ),
        actions:[
          IconButton(
            style: ButtonStyle(iconColor: MaterialStateProperty.all(Colors.white)),
            icon: Icon(
              Icons.location_searching
            ),
            onPressed: (){},
            iconSize: 30,
          ),

        ]


      ),
      body: Container(
        child: Stack(
          children: [
            Image.asset('image/background.jpg',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 150,
                              ),
                              Text('$cityName',
                              style: GoogleFonts.lato(
                                fontWeight: FontWeight.bold,
                                fontSize: 35,
                                color: Colors.white
                              )),
                              Row(
                                children: [
                                  TimerBuilder.periodic(
                                      (Duration(minutes: 1)),
                                      builder:(context){//buider는 항상 위젯은 반환 해줘야 함
                                        return Text(
                                          DateFormat('h:mm a').format(date),
                                          style: GoogleFonts.lato(
                                            fontSize: 16,
                                            color: Colors.white
                                          ),
                                        );

                                      }
                                      ),
                                  Text(
                                    DateFormat(' - EEEE').format(date),
                                    style: GoogleFonts.lato(
                                      fontSize: 16,
                                      color: Colors.white
                                    ),
                                  ),
                                  Text(
                                    DateFormat('.d.MMM, yyy').format(date),
                                    style: GoogleFonts.lato(
                                      fontSize: 16,
                                      color: Colors.white
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('$temp\u2103',
                                  style: GoogleFonts.lato(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 85,
                                      color: Colors.white
                                  )),
                              Row(
                                children: [
                                  icon!,
                                  SvgPicture.asset('svg/climacon-sun.svg'),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text('$des',
                                  style: GoogleFonts.lato(
                                    fontSize: 16,
                                    color: Colors.white
                                  ),)
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Divider(
                          height: 15,
                          thickness: 2,
                          color: Colors.white30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Text(
                                  'AQI(대기질지수)',
                                  style: GoogleFonts.lato(
                                    fontSize: 16,
                                    color: Colors.white
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                airicon!,
                                SizedBox(
                                  height: 10,
                                ),
                                airState!
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  '미세먼지',
                                  style: GoogleFonts.lato(
                                      fontSize: 16,
                                      color: Colors.white
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  '$dust1',
                                  style: GoogleFonts.lato(
                                      fontSize: 16,
                                      color: Colors.white
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  '㎍/m3',
                                  style: GoogleFonts.lato(
                                      fontSize: 16,
                                      color: Colors.white,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  '$dust2',
                                  style: GoogleFonts.lato(
                                      fontSize: 16,
                                      color: Colors.white
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  '84.03',
                                  style: GoogleFonts.lato(
                                      fontSize: 16,
                                      color: Colors.white
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  '㎍/m3',
                                  style: GoogleFonts.lato(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              ],
                            )
                          ],
                        )
                      ],

                    )
                  ],
                ),

              ),
            )
          ],
        ),
      ),
    );
  }
}
