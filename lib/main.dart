import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';

String isConnected = "Not Connected";

void main() async {
  Socket s = await Socket.connect('10.0.0.70', 80);
  isConnected = "Connected to: ${s.remoteAddress.address}:${s.remotePort}";

  runApp(MyApp(s));
}

class MyApp extends StatelessWidget {
  Socket? socket;

  MyApp(Socket s) {
    socket = s;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wifi Connection',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(
        title: 'Connect to Wifi',
        channel: socket,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final Socket? channel;
  final String title;

  const MyHomePage({Key? key, required this.title, required this.channel}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String incomingData = "No data";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: const Text("Read",
                  style: TextStyle(
                      color: Colors.white,
                      fontStyle: FontStyle.italic,
                      fontSize: 20.0
                  )
              ),
              color: Colors.red,
              onPressed: _togglePower,
            ),
            Text(isConnected,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 10.0
              ),
            ),
            Text(incomingData,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 10.0
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _togglePower() {
    widget.channel?.listen((data) {
      setState(() {
        incomingData = String.fromCharCodes(data).trim();
      });
    });
  }

  @override
  void dispose(){
    widget.channel?.close();
    super.dispose();
  }
}