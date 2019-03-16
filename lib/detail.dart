import "package:flutter/material.dart";

import "helper/helper.dart";
import "weather.dart";

// Details page for one hour
class HourDetailsPage extends StatelessWidget {

  final Map<String, dynamic> data;
  DateTime time;

  HourDetailsPage({Key key, @required this.data}) : super(key: key) {
    time = DateTime.fromMillisecondsSinceEpoch(data["time"] * 1000);
  }

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Details for ${Helper().getTimeString(time.hour)}"),
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Helper().getWeatherIcon(data["icon"]),
                SizedBox(width: 20.0,),
                Text(Helper().getTimeString(time.hour),
                  style: TextStyle(fontSize: 40.0)
                )
              ]
            ),
            Padding(
              padding: EdgeInsets.only(top: 30.0),
              child: Text("Summary: ${data["summary"]}")
            ),
            Text("Humidity: ${data["humidity"] * 100} %"),
            Text("Precipitation: ${data["precipIntensity"]} mm with a chance of ${data["precipProbability"] * 100} %"),
            Text("Wind speed: ${data["windSpeed"]}")
          ],
        )
      )
    );
  }

}

// Details Page for full day
class DayDetailsPage extends StatelessWidget {

  final Map<String, dynamic> data;
  final String weekday;

  DayDetailsPage({Key key, this.data, this.weekday}) : super(key: key);

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Details for next $weekday"),
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Helper().getWeatherIcon(data["icon"]),
                SizedBox(width: 20.0,),
                Text(weekday,
                  style: TextStyle(fontSize: 40.0)
                )
              ]
            ),
            Padding(
              padding: EdgeInsets.only(top: 30.0),
              child: Text("Summary: ${data["summary"]}")
            ),
            Text("Highest temperature: ${data["temperatureHigh"]} at ${Helper().getTimeString(DateTime.fromMillisecondsSinceEpoch(data["temperatureHighTime"] * 1000).hour)}"),
            Text("Lowest temperature: ${data["temperatureLow"]} at ${Helper().getTimeString(DateTime.fromMillisecondsSinceEpoch(data["temperatureLowTime"] * 1000).hour)}"),
            Text("Humidity: ${(data["humidity"] * 100).toStringAsFixed(2)} %"),
            Text("Precipitation: ${data["precipIntensity"]} mm with a chance of ${data["precipProbability"] * 100} %")
          ],
        )
      )
    );
  }

}