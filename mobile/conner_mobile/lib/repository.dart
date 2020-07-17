import 'dart:convert';
import 'dart:io';

import 'package:conner_mobile/model.dart';

class Repository {
  Future<ServerInfo> getAvailableServer() {
    final int port = 8991;
    return Future(() => ServerInfo("192.168.43.190", port));
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

  sendMessage(Socket s, String msg) {
    s.add(utf8.encode(msg));
  }

  Future<Socket> connect(ServerInfo srv) async {
    print('waiting fo');
    Socket socket = await Socket.connect(srv.ip, srv.port);
    print('connected');
    return socket;
  }

  Stream<String> getStringStream(Socket s) {
    return s.map((List<int> event) => utf8.decode(event));
  }
}
