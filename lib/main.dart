import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

BuildContext scaffoldContext;

displaySnackBar(BuildContext context, String msg) {
  final snackBar = SnackBar(
    content: Text(msg),
    action: SnackBarAction(
      label: 'Ok',
      onPressed: () {},
    ),
  );
  Scaffold.of(scaffoldContext).showSnackBar(snackBar);
}

void main() {
  runApp(MaterialApp(
    title: "LED Blink",
    debugShowCheckedModeBanner: false,
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    getInitLedState(); // Getting initial state of LED, which is by default on
  }
  String _status = '';
  String url =
      'http://192.168.1.200:80/'; //IP Address which is configured in NodeMCU Sketch
  var response;

  getInitLedState() async {
    try {
      response = await http.get(url, headers: {"Accept": "plain/text"});
      setState(() {
        _status = 'On';
      });
    } catch (e) {
      // If NodeMCU is not connected, it will throw error
      print(e);
      setState(() {
        _status = 'Not Connected';
      });
    }
  }

  toggleLed() async {
    try {
      response = await http.get(url + 'led', headers: {"Accept": "plain/text"});
      setState(() {
        _status = response.body;
        print(response.body);
      });
    } catch (e) {
      // If NodeMCU is not connected, it will throw error
      print(e);
      displaySnackBar(context, 'Module Not Connected');
    }
  }

  turnOnLed() async {
    try {
      response =
      await http.get(url + 'led/on', headers: {"Accept": "plain/text"});
      setState(() {
        _status = response.body;
        print(response.body);
      });
    } catch (e) {
      // If NodeMCU is not connected, it will throw error
      print(e);
      displaySnackBar(context, 'Module Not Connected');
    }
  }

  turnOffLed() async {
    try {
      response =
      await http.get(url + 'led/off', headers: {"Accept": "plain/text"});
      setState(() {
        _status = response.body;
        print(response.body);
      });
    } catch (e) {
      // If NodeMCU is not connected, it will throw error
      print(e);
      displaySnackBar(context, 'Module Not Connected');
    }
  }
  BuildContext scaffoldContext;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 255, 255, 0.95),
      appBar: AppBar(
        title: Text("NodeMCU With Flutter"),
        centerTitle: true,
      ),
      body: Builder(builder: (BuildContext context) {
        scaffoldContext = context;
        return ListView(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    onPressed: toggleLed,
                    child: Text('Toggle LED'),
                  ),
                  RaisedButton(
                    onPressed: turnOnLed,
                    child: Text('Turn LED On'),
                  ),
                  RaisedButton(
                    onPressed: turnOffLed,
                    child: Text('Turn LED Off'),
                  ),
                ],
              ),
            ),
            Text(
              'LED Status: $_status',
              textAlign: TextAlign.center,
            )
          ],
        );
      }),
    );
  }
}
