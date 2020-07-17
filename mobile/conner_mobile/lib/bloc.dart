import 'dart:io';

import 'package:conner_mobile/model.dart';
import 'package:conner_mobile/repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SocketBloc extends Bloc<SocketEvent, SocketState> {
  final Repository repository = Repository();
  Socket socket;

  SocketBloc() : super(Disconnected());

  @override
  Stream<SocketState> mapEventToState(SocketEvent event) async* {
    if (event is Connect) {
      yield SearchingNetwork();
      final serverInfo = await repository.getAvailableServer();
      yield Connecting(serverInfo);
      socket = await repository.connect(serverInfo);
      if (socket != null) {
        yield Connected(repository.getStringStream(socket));
      } else {
        yield Failed(reason: "couldn't connect to socket");
      }
    } else if (event is SendMessage) {
      if(state is Connected) {
        repository.sendMessage(socket, event.msg);
      } else {
        yield Failed(reason: "not connected to any server");
      }
    } else if (event is Disconnect) {}
  }

  dispose() {
    socket.close();
  }
}

class SocketEvent {}

class SocketState {}

// events
class Connect extends SocketEvent {}

class SendMessage extends SocketEvent {
  final String msg;

  SendMessage(this.msg);
}

class Disconnect extends SocketEvent {}

// states
class SearchingNetwork extends SocketState {}

class Connecting extends SocketState {
  final ServerInfo to;

  Connecting(this.to);
}

class Disconnecting extends SocketState {
  final ServerInfo from;

  Disconnecting(this.from);
}

class Connected extends SocketState {
  final Stream<String> messages;

  Connected(this.messages);
}

class Disconnected extends SocketState {}

class Failed extends SocketState {
  final String reason;

  Failed({this.reason = ''});
}
