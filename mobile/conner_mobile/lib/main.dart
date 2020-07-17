import 'package:conner_mobile/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  runApp(MyApp());
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
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  SocketBloc _bloc;

  @override
  Widget build(BuildContext context) {
    if (_bloc == null) {
      _bloc = SocketBloc();
      _bloc.add(Connect());
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('conner-mobile'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        child: BlocBuilder<SocketBloc, SocketState>(
          bloc: _bloc,
          builder: (context, state) {
            if (state is SearchingNetwork) {
              return Text('searching network');
            } else if (state is Connecting) {
              return Text('connecting to ${state.to}');
            } else if (state is Connected) {
              return SendingWidget(onSend: (msg) {
                _bloc.add(SendMessage(msg));
              });
            } else if (state is Failed) {
              return Text('failed: ${state.reason}');
            } else {
              return Text('disconected');
            }
          },
        ),
      ),
    );
  }
}

class SendingWidget extends StatefulWidget {
  final Function(String) onSend;

  const SendingWidget({Key key, this.onSend}) : super(key: key);

  @override
  _SendingWidgetState createState() => _SendingWidgetState();
}

class _SendingWidgetState extends State<SendingWidget> {
  final msgController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextFormField(
          controller: msgController,
        ),
        RaisedButton(
          child: Text('send'),
          onPressed: () {
            widget.onSend(msgController.text);
          },
        )
      ],
    );
  }
}
