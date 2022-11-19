import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
void main() => runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Weather App",
      home: Home(),
    )
);


class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  var temp, description, currently, city,humidity, windSpeed,lat,lon,local;

  TextEditingController textEditingController=TextEditingController();

  //location added
  void location()async{
    await Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      lat=position.latitude.toStringAsFixed(2);
      lon=position.longitude.toStringAsFixed(2);
    });
  }

  void localWeather() async {

    var response = await http.get(Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&units=metric&appid=ed3271385dcc46a2192c3d6082980989")); //api key
    var results = jsonDecode(response.body);
    setState(() {
      this.temp = results['main']['temp'];
      this. local = results['name'];
      this.description = results['weather'][0]['description'];
      this.currently = results['weather'][0]['main'];
      this.humidity = results['main']['humidity'];
      this.windSpeed = results['wind']['speed'];
    });
  }

  //textfield ...
  void getWeather() async {
    // String ApiKey="ed3271385dcc46a2192c3d6082980989";
    //String url="https://api.openweathermap.org/data/2.5/weather?q={london}&appid={Apikey}";
    var response = await http.get(Uri.parse("https://api.openweathermap.org/data/2.5/weather?q=$city&units=metric&appid=ed3271385dcc46a2192c3d6082980989")); //api key
    var results = jsonDecode(response.body);
    setState(() {
      this.lat=results['coord']['lat'];
      this.lon=results['coord']['lon'];
      this.temp =results['main']['temp'];
      this.description = results['weather'][0]['description'];
      this.currently = results['weather'][0]['main'];
      this.humidity = results['main']['humidity'];
      this.windSpeed = results['wind']['speed'];
    });
  }
  void citySearch(){
    setState(() {
      city=textEditingController.text;
    });
  }
  @override
  void initState() {
    super.initState();
    getWeather();
    localWeather();
    location();
    citySearch();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget> [
          Container (

            child: Column(

              children: <Widget> [
                SizedBox(height:100),
                Row(
                  children: [
                    SizedBox(width:50),
                    Text("Latitude  : ",
                    ),
                    Text(lat!=null?lat.toString():"loading",
                    ),

                    SizedBox(width:55),
                    Text("Longitude  : ",
                    ),
                    Text(lon!=null?lon.toString():"loading",
                    ),
                  ],
                ),
                SizedBox(height:20),
                Text(local.toString(),
                ),
                SizedBox(height:20),
                MaterialButton(onPressed:(){
                  location();
                  localWeather();
                },
                  child: Text('location'),
                  color: Colors.blueAccent,
                ),

                SizedBox(
                  width:150,
                  child: TextField(
                    textAlign: TextAlign.center,
                    controller:textEditingController ,
                    decoration: InputDecoration(
                      hintText: "city name",

                    ),
                  ),
                ),
                SizedBox(height:30),
                MaterialButton(onPressed: (){
                  getWeather();
                  citySearch();
                },
                  child: Text("getWeather"),
                  color:Colors.blueAccent,
                ),
                SizedBox(height:20,),
                // Icon(Icons.add_call),
                Text(
                  temp!=null ? temp.toString()+" °C" : "loading",
                  style: TextStyle(
                    color: Color(0xFF00E676),
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),

              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: ListView(
                children: <Widget>[
                  ListTile(
                    leading: FaIcon(FontAwesomeIcons.thermometer),
                    title: Text("Temperature"),
                    trailing: Text(temp!=null ? temp.toString()+"\u00B0C" : "just wait, loading"),
                  ),
                  ListTile(
                    leading: FaIcon(FontAwesomeIcons.cloud),
                    title: Text("Weather"),
                    trailing: Text(description!=null ? description.toString() : "Loading"),
                  ),
                  ListTile(
                    leading: FaIcon(FontAwesomeIcons.sun),
                    title: Text("Humidity"),
                    trailing: Text(humidity!=null ? humidity.toString() : "Loading"),
                  ),
                  ListTile(
                    leading: FaIcon(FontAwesomeIcons.wind),
                    title: Text("Wind Speed"),
                    trailing: Text(windSpeed!=null ? windSpeed.toString() : "Loading"),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}