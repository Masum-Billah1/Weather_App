import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
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
  var temp, description,sunset,sunrise, currently, city,humidity, windSpeed,lat,lon,local,feels_like;

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
      this.feels_like = results['main']['feels_like'];
      sunrise=results['sys']['sunrise'];
      sunset=results['sys']['sunset'];
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
      this.feels_like = results['main']['feels_like'];
      sunrise=results['sys']['sunrise'];
      sunset=results['sys']['sunset'];
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
      backgroundColor: Colors.greenAccent,
      appBar: AppBar(
        title: Text('Weather App')
      ),
      body: Column(
        children: <Widget> [
          Container (

            child: Column(

              children: <Widget> [
                SizedBox(height:30),
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
                    color: Colors.lightGreen,
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
                    leading: FaIcon(FontAwesomeIcons.sun),
                    title: Text("feelslike"),
                    trailing: Text(feels_like!=null ? feels_like.toString() : "Loading"),
                  ),
                  ListTile(
                    leading: FaIcon(FontAwesomeIcons.wind),
                    title: Text("Wind Speed"),
                    trailing: Text(windSpeed!=null ? windSpeed.toString() : "Loading"),
                  ),
                  ListTile(
                    leading: FaIcon(FontAwesomeIcons.wind),
                    title: Text("Sunset"),
                    trailing: Text(sunrise!=null ? formatted(sunrise).toString() : "Loading"),
                  ),
                  ListTile(
                    leading: FaIcon(FontAwesomeIcons.wind),
                    title: Text("Sunset"),
                    trailing: Text(sunrise!=null ? formatted(sunrise).toString() : "Loading"),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Image.network('https://rukminim1.flixcart.com/image/416/416/jzsqky80/poster/h/y/4/medium-nature-wall-poster-sunrise-poster-poster-high-resolution-original-imafjqjyasudq8sg.jpeg?q=70',height: 100,width:100,),
                        SizedBox(width:20,),
                        Image.network('https://media.istockphoto.com/id/1172427455/photo/beautiful-sunset-over-the-tropical-sea.jpg?s=612x612&w=0&k=20&c=i3R3cbE94hdu6PRWT7cQBStY_wknVzl2pFCjQppzTBg=',height:100,width:100),
                      ],
                    ),
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


String formatted(timeStamp) {
  final DateTime date1 = DateTime.fromMillisecondsSinceEpoch(timeStamp * 1000);
  return DateFormat('hh:mm a').format(date1);
}