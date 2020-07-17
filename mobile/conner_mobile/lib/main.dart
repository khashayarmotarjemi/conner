import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:multicast_dns/multicast_dns.dart';
import 'package:ping_discover_network/ping_discover_network.dart';
import 'package:web_socket_channel/io.dart';
import 'package:wifi/wifi.dart';

void main() async {
  runApp(MyApp());

  final int port = 8991;

  print('waiting foo');

  Socket socket = await Socket.connect('192.168.43.190', port);
  print('connected');

  socket.listen((List<int> event) {
    print(utf8.decode(event));
  });

  socket.add(utf8.encode('hello'));

  await Future.delayed(Duration(seconds: 5));
  socket.add(utf8.encode('1234'));

//  socket.close();



/*
  final String ip = await Wifi.ip;
  final String subnet = ip.substring(0, ip.lastIndexOf('.'));
  print("subnet: $subnet");*/
//  final stream = NetworkAnalyzer.discover(subnet, port,timeout: Duration(microseconds: 100));
//  stream.listen((NetworkAddress addr) {
//    if (addr.exists) {
//    }
//  });

}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Conner',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Text('a'),
    );
  }
}
