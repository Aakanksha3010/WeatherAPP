import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherApp extends StatefulWidget {
  @override
  _WeatherAppState createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  int temp = 0;
  String location = 'San Francisco';
  String searchApiUrl = 'https://www.metaweather.com/api/location/search/?query=';
  String searchlocationApi = 'https://www.metaweather.com/api/location/';
  int woeid = 2487956;
  String weather = 'clear';



  void fetchSearch(String input) async{
    var searchResult = await http.get(Uri.parse(searchApiUrl + input));
    var result = json.decode(searchResult.body)[0]; //to get the location of city

    setState(() {
          location = result['title'];
          woeid = result['woeid'];
        });
  }

  void fetchLocation() async{
    var searchLocation = await http.get(Uri.parse(searchlocationApi + woeid.toString()));
    var locationresult = json.decode(searchLocation.body);
    var consolidated_weathers = locationresult['consolidated_weather'];
    var data = consolidated_weathers[0];

    setState(() {
              temp = data['the_temp'].round();
              weather = data['weather_state_name'].replaceAll(' ','').toLowerCase();
        });
  }

  void onTextFieldSubmitted(String input){
    fetchSearch(input);
    fetchLocation();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/$weather.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                Center(
                  child: Text(
                    temp.toString() + '°C',style: TextStyle(color: Colors.white,fontSize: 60.0),
                  ),
                ),
                Center(
                  child: Text(
                    location,style: TextStyle(color: Colors.white,fontSize: 40.0),
                  ), 
                ),
              ],
            ),
            Column(
              children: [
                Container(
                  width: 300,
                  child: TextField(
                    onSubmitted: (String input){
                      onTextFieldSubmitted(input);
                    },
                    style: TextStyle(color: Colors.white,fontSize: 25.0),
                    decoration: InputDecoration(
                      hintText: 'Select your location...',
                      hintStyle: TextStyle(color: Colors.white,fontSize: 18.0),
                      prefixIcon: Icon(Icons.search,color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      
    );
  }
}