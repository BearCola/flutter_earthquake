import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Quakes'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List _earthQuakes;

  @override
  void initState() {
    getEarthQuakesList();
    super.initState();
  }

  Future<Map> getEarthQuakes() async {
    String apiUrl =
        'https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson';

    Response response = await get(apiUrl);
    return json.decode(response.body);
  }

  void getEarthQuakesList() async {
    Map earthQuake = await getEarthQuakes();
    setState(() {
      _earthQuakes = earthQuake['features'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemCount: _earthQuakes == null ? 0 : _earthQuakes.length,
        itemBuilder: (BuildContext context, int position) {
          return Column(
            children: <Widget>[
              Divider(
                height: 13.4,
              ),
              ListTile(
                title: Text(
                  getDateString(_earthQuakes[position]['properties']['time']),
                  style: TextStyle(fontSize: 17.2, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  _earthQuakes[position]['properties']['place'].toString(),
                ),
                leading: CircleAvatar(
                  backgroundColor: Colors.orange,
                  child: Text(
                      _earthQuakes[position]['properties']['mag'].toString()),
                ),
                onTap: () {
                  showTapMessage(
                      context, _earthQuakes[position]['properties']['title']);
                },
              )
            ],
          );
        },
      ),
    );
  }

  void showTapMessage(BuildContext context, String earthQuake) {
    var alertDialog = AlertDialog(
      title: Text(earthQuake),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Ok'),
        )
      ],
    );

    showDialog(
        context: context,
        builder: (context) {
          return alertDialog;
        });
  }

  String getDateString(int date) {
    DateTime dateTime = new DateTime.fromMillisecondsSinceEpoch(date);
    var formatter = DateFormat("EEE, MMM d, yyyy hh:mm aaa");
    String formatted = formatter.format(dateTime);
    return formatted;
  }
}
