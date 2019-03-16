import "package:flutter/material.dart";
import "package:http/http.dart" as http;

import "dart:convert";
import "dart:async";
import "dart:math" as math;

import "helper/helper.dart";
import 'detail.dart';

class WeatherPage extends StatelessWidget {

  final double long;
  final double lat;
  final String address;

  final String url = "https://api.darksky.net/forecast/412dcc4dbaf574cae8032de561f62ca5";

  WeatherPage({this.long, this.lat, this.address}) {
    this._getWeather();
  }

  Future<http.Response> fetchWeatherData() {
    return http.get("${this.url}/${this.lat},${this.long}");
  }

  void _getWeather() {
    print("${this.url}/${this.lat},${this.long}");
  }

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      appBar: AppBar(
        title: Text(address)
      ),
      body: FutureBuilder(
        future: fetchWeatherData(),
        builder: (context, snapshot) {
          if(snapshot.hasData) {
            if(snapshot.data != null) {
              return DisplayWeather(data: json.decode(snapshot.data.body));
            }
          } else {
            return Container(
              child: Center(
                child: CircularProgressIndicator()
              )
            );
          }
        },
      )
    );
  }

}
class DisplayWeather extends StatelessWidget {
  Map<String, dynamic> data;

  DisplayWeather({this.data});

  @override
  Widget build(BuildContext ctx) {
    return Column(
      children: <Widget>[
        Container(
          //decoration: BoxDecoration(color: Colors.blue),
          height: MediaQuery.of(ctx).size.height * 0.3,
          padding: EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Helper().getWeatherIcon(data["currently"]["icon"]),
              SizedBox(width: 20.0),
              Text("${Helper().fahrenheit2Celsius(data["currently"]["temperature"])} °C",
                style: TextStyle(
                  fontSize: 50.0
                )
              )
            ]
          ),
        ),
        WeatherForecast(data: data)
      ]
    );
  }
}

class WeatherForecast extends StatefulWidget {

  final Map<String, dynamic> data;

  WeatherForecast({Key key, this.data}) : super(key: key);

  @override
  _WeatherForecastState createState() => _WeatherForecastState(data);

}

class _WeatherForecastState extends State<WeatherForecast> {

  final Map<String, dynamic> data;
  bool displayHourly = false;

  _WeatherForecastState(this.data);

  Widget _generateListTiles(BuildContext context, int index) {
    Map<String, dynamic> currData;
            
    if(displayHourly) {
      currData = data["hourly"]["data"][index];
    } else {
      currData = data["daily"]["data"][index + 1]; 
    }

    final Map<int, String> weekdays = {
      1: "Monday",
      2: "Tuesday",
      3: "Wednesday",
      4: "Thursday",
      5: "Friday",
      6: "Saturday",
      7: "Sunday"
    };
    final DateTime currDateTime = DateTime.fromMillisecondsSinceEpoch(currData["time"] * 1000);

    Text subtitle;
    Text title;
    if(displayHourly) {

      title = Text(Helper().getTimeString(currDateTime.hour));
      subtitle = Text("It's ${currData["summary"]} with ${Helper().fahrenheit2Celsius(currData["temperature"])} °C");
    } else {
      final String hottest = Helper().fahrenheit2Celsius(currData["temperatureHigh"].toDouble());
      final String coldest = Helper().fahrenheit2Celsius(currData["temperatureLow"].toDouble());

      title = Text(weekdays[currDateTime.weekday]);
      subtitle = Text("Max: $hottest °C, Min: $coldest °C");
    }

    return ListTile(
      leading: Helper().getWeatherIcon(currData["icon"]),
      title: title,
      subtitle: subtitle,
      onTap: () {
        if(displayHourly) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => HourDetailsPage(data: currData)));
        } else {
          Navigator.push(context, MaterialPageRoute(builder: (cnotext) => DayDetailsPage(data: currData, weekday: weekdays[currDateTime.weekday],)));
        }
      },
    );
  }

  @override
  Widget build(BuildContext ctx) {

    return Expanded(
      child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: 10.0, right: 10.0),
          decoration: BoxDecoration(color: Colors.grey[200]),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(displayHourly ? "Hours" : "Days"),
              ),
              FlatButton(
                child: Text("Switch"),
                onPressed: () {
                  setState(() {
                    displayHourly = !displayHourly;
                  });
                },
              )
            ],
          )
        ),
        Expanded(
          child: ListView.builder(
          itemCount: displayHourly ? 24 : 7,
          itemBuilder: (context, index) => _generateListTiles(context, index),
        )
        )
      ],
      )
    );

  }

} 