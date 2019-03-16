import "dart:math" as math;

import "package:flutter/material.dart";

class Helper {
  String fahrenheit2Celsius(num temp) {
    return ((temp - 32) / 1.8).toStringAsFixed(0);
  }

  Widget getWeatherIcon(String icon) {

    switch (icon) {
      case "clear-day":
        return Icon(Icons.wb_sunny, size: 40.0, color: Colors.yellow);
      case "clear-night":
        return Icon(Icons.brightness_2, size: 40.0);
      case "cloudy":
      case "partly-cloudy":
      case "partly-cloudy-day":
      case "partly-cloudy-night":
        return Icon(Icons.filter_drama, size: 40.0, color: Colors.grey);
      case "rain":
        return Transform.rotate(
          angle: math.pi,
          child: Icon(Icons.place, size: 40.0, color: Colors.blue,)
        );
      case "snow":
        return Icon(Icons.ac_unit, size: 40.0);
    }

    return SizedBox(width: 0.0);
  }

  String n2str(num number, [int digits = 2]) {

    String result = number.toString();

    while(result.length < digits) {
      result = "0" + result;
    }

    return result;

  }

  String getTimeString(int hours) {

    String result;

    if(hours == 12) {
      result = hours.toString() + " PM";
    } else if(hours >= 13) {
      result = n2str(hours - 12) + " PM";
    } else {
      result = n2str(hours) + " AM";
    }

    return result;

  }
}