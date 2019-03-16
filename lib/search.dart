import "package:flutter/material.dart";
import "package:location/location.dart";
import "package:geocoder/geocoder.dart";

import "package:weather/weather.dart";

class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Weather")
      ),
      body: Padding(
        padding: EdgeInsets.all(0.0),
        child: SearchField()
      )
    );
  }

}

class SearchField extends StatelessWidget {

  final TextEditingController _searchCon = TextEditingController();
  Map<String, double> _currLocation = <String, double>{};

  void _getLocation(BuildContext ctx) async {

    var location = Location();
    
    try {
      _currLocation = await location.getLocation;
    } catch(e) {
      _currLocation = null;

      Scaffold.of(ctx).showSnackBar(
        SnackBar(
          content: Text("Failed to get location"),
        )
      );
    }

    if(_currLocation != null) {
      print(_currLocation);

      var addresses = await Geocoder.local.findAddressesFromCoordinates(Coordinates(_currLocation["latitude"], _currLocation["longitude"]));
      String address = addresses.first.addressLine;

      Navigator.push(ctx, MaterialPageRoute(builder: (context) => WeatherPage(lat: _currLocation["latitude"], long: _currLocation["longitude"], address: address,)));
    }
  }

  void _userInput(BuildContext ctx) async {
    var addresses = await Geocoder.local.findAddressesFromQuery(this._searchCon.text);
    double lat = addresses.first.coordinates.latitude;
    double long = addresses.first.coordinates.longitude;
    String address = addresses.first.addressLine;

    Navigator.push(ctx, MaterialPageRoute(builder: (context) => WeatherPage(lat: lat, long: long, address: address,)));
  }

  @override
  Widget build(BuildContext ctx) {
    return ListTile(
      leading: Padding(
        padding: EdgeInsets.only(top: 2.0),
        child: FlatButton(
          child: Icon(Icons.adjust),
          onPressed: () => _getLocation(ctx),
        ),
      ),
      title: TextField(
        decoration: InputDecoration(
          hintText: "City..."
        ),
        controller: _searchCon,
      ),
      trailing: FlatButton(
        child: Text("Go!"),
        onPressed: () => _userInput(ctx),
      ),
    );
  }

} 