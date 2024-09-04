# Weather App_clone

## 프로젝트 소개 👨‍💻

Weather App은 Flutter를 기반으로 한 실시간 날씨 정보 제공 앱. 사용자의 현재 위치를 추적하고, OpenWeatherMap API를 활용해 해당 위치의 날씨와 대기질 정보를 시각적으로 제공하는 기능을 가지고 있음. 

## 목적 🎯

이 프로젝트는 클론 코딩 학습을 목적으로 하며, 외부 API(OpenWeatherMap)를 사용해 데이터를 받아오고, 이를 Flutter 애플리케이션에서 활용하는 방법을 익히기 위해 제작되었음. API 통신, 데이터 처리, 상태 관리 및 UI 구성 등의 기술을 실습하며, 실시간 데이터를 기반으로 정보를 시각화하는 앱을 완성하는 것이 목표이다.

## 주요 기능 ✨

- **현재 위치 기반 날씨 정보 제공:** 사용자의 위치를 자동으로 추적해 해당 위치의 실시간 날씨와 대기 정보를 제공.
- **시각적 대기질 지수 표현:** 대기질 지수에 따라 아이콘과 텍스트로 상태를 시각적으로 표현.
- **날씨 및 대기질 상세 정보 표시:** 기온, 날씨 설명, 미세먼지 농도 등의 정보를 포함.
- **자동 업데이트:** 실시간으로 정보를 주기적으로 갱신하여 최신 데이터를 제공.

## 주요 파일 구조 🗂️

```plaintext
lib/
│
├── data/
│   ├── my_location.dart      # 사용자의 현재 위치를 추적하는 클래스
│   └── network.dart          # API 호출을 통해 날씨 및 대기질 데이터를 가져오는 클래스
│
├── model/
│   └── model.dart            # 날씨 및 대기질 상태에 따른 아이콘 및 텍스트를 반환하는 클래스
│
├── screens/
│   ├── loading.dart          # 로딩 화면을 처리하는 위젯
│   └── weather_screen.dart   # 날씨 및 대기질 정보를 시각적으로 표시하는 메인 화면
│
└── main.dart                 # 애플리케이션의 진입점
```
주요 코드 🔑
 <details>
<summary>1.현재위치 추적 (lib/data/my_location.dart)</summary>
<div markdown="1">
 <br>
lib/data/my_location.dart 파일에서 사용자의 현재 위치를 추적하여 위도와 경도를 가져오고, 이를 통해 OpenWeatherMap API에서 해당 위치의 날씨 데이터를 조회할 수 있음.

```dart

class Mylocation {
  double? latitude2;
  double? longitude2;

  Future<void> getMyCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      latitude2 = position.latitude;
      longitude2 = position.longitude;
    } catch (e) {
      print('위치 정보를 가져오는 중 오류 발생: $e');
    }
  }
}
```
</div>
</details>

  <details>
<summary>2.날씨 및 대기질 정보 가져오기(lib/data/network.dart)</summary>
<div markdown="2">
 <br>
lib/data/network.dart 파일에서는 OpenWeatherMap API와 통신하여 날씨와 대기질 데이터를 가져오는 기능을 구현.

```dart

class Network {
  final String url;
  final String url2;

  Network(this.url, this.url2);

  Future<dynamic> getJsonData() async {
    http.Response response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
  }

  Future<dynamic> getAirData() async {
    http.Response response = await http.get(Uri.parse(url2));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
  }
}
```
</div>
</details>

  <details>
<summary>3. 날씨 및 대기질 UI 렌더링(lib/screens/weather_screen.dart)</summary>
<div markdown="3">
 <br>
lib/screens/weather_screen.dart 파일에서는 OpenWeatherMap API에서 가져온 날씨 및 대기질 정보를 사용자에게 시각적으로 표시하는 UI를 구현.

  ```dart
 
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
    super.initState();
    updateData(widget.parseWeatherData, widget.parseAirPolution);
  }

  void updateData(dynamic weatherData, dynamic airdata) {
    double temp2 = weatherData['main']['temp'];
    var condition = weatherData['weather'][0]['id'];
    var index = airdata['list'][0]['main']['aqi'];
    des = weatherData['weather'][0]['description'];
    dust1 = airdata['list'][0]['components']['pm10'].toDouble();
    dust2 = airdata['list'][0]['components']['pm2_5'].toDouble();
    temp = temp2.toInt();
    cityName = weatherData['name'];
    icon = model.getWeatherIcon(condition);
    airicon = model.getAirIcon(index);
    airState = model.getAirCondition(index);

    print(cityName);
    print(temp);
  }

  String getSystemTime() {
    var now = DateTime.now();
    return DateFormat("h:mm a").format(now);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(''),
        leading: IconButton(
          style: ButtonStyle(iconColor: MaterialStateProperty.all(Colors.white)),
          icon: Icon(Icons.near_me),
          onPressed: () {},
          iconSize: 30,
        ),
        actions: [
          IconButton(
            style: ButtonStyle(iconColor: MaterialStateProperty.all(Colors.white)),
            icon: Icon(Icons.location_searching),
            onPressed: () {},
            iconSize: 30,
          ),
        ],
      ),
      body: Container(
        child: Stack(
          children: [
            Image.asset(
              'image/background.jpg',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
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
                              SizedBox(height: 150),
                              Text(
                                '$cityName',
                                style: GoogleFonts.lato(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 35,
                                  color: Colors.white,
                                ),
                              ),
                              Row(
                                children: [
                                  TimerBuilder.periodic(
                                    Duration(minutes: 1),
                                    builder: (context) {
                                      return Text(
                                        DateFormat('h:mm a').format(date),
                                        style: GoogleFonts.lato(
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                      );
                                    },
                                  ),
                                  Text(
                                    DateFormat(' - EEEE').format(date),
                                    style: GoogleFonts.lato(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    DateFormat('.d.MMM, yyy').format(date),
                                    style: GoogleFonts.lato(
                                      fontSize: 16,
                                      color: Colors.white,
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
                                    color: Colors.white,
                                  )),
                              Row(
                                children: [
                                  icon!,
                                  SvgPicture.asset('svg/climacon-sun.svg'),
                                  SizedBox(width: 10),
                                  Text(
                                    '$des',
                                    style: GoogleFonts.lato(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
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
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 10),
                                airicon!,
                                SizedBox(height: 10),
                                airState!
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  '미세먼지',
                                  style: GoogleFonts.lato(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  '$dust1',
                                  style: GoogleFonts.lato(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  '㎍/m3',
                                  style: GoogleFonts.lato(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
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
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  '㎍/m3',
                                  style: GoogleFonts.lato(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
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
            ),
          ],
        ),
      ),
    );
  }
}

```
</div>
</details>

## 사용된 패키지 📦

- [geolocator](https://pub.dev/packages/geolocator): 사용자의 위치 정보를 추적하기 위한 패키지. 사용자의 현재 위치를 가져옴.
- [http](https://pub.dev/packages/http): HTTP 요청을 보내고, 외부 API로부터 데이터를 받아오기 위한 패키지. OpenWeatherMap API와 통신하여 날씨 정보를 가져옴.
- [google_fonts](https://pub.dev/packages/google_fonts): 다양한 구글 폰트를 쉽게 사용하기 위한 패키지. 앱에서 텍스트 스타일링에 사용.
- [flutter_svg](https://pub.dev/packages/flutter_svg): SVG 형식의 이미지를 Flutter에서 렌더링하기 위한 패키지. 날씨 아이콘 등 다양한 벡터 이미지를 화면에 표시할 때 사용.
- [timer_builder](https://pub.dev/packages/timer_builder): 실시간 타이머 기능을 구현하기 위한 패키지. 주기적으로 화면을 갱신하는 데 사용.
- [intl](https://pub.dev/packages/intl): 날짜와 시간 형식을 지역에 맞게 포맷팅하기 위한 패키지. 앱 내에서 날짜와 시간 표현을 처리.
- [flutter_spinkit](https://pub.dev/packages/flutter_spinkit): 로딩 스피너를 제공하는 패키지. 데이터를 불러오는 동안 사용자에게 로딩 상태를 시각적으로 표시.

