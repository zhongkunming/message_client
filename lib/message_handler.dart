import 'dart:io';
import 'package:message_client/http_client.dart';

import 'dart:isolate';
import 'package:message_client/notification/notification.dart';

import 'main.dart';

// const host = "192.168.80.173:8080";
const host = "39.103.133.90:8080";
const sysMessageTodo = "/sys/message/todo";

fetchTodo(SendPort sendPort) async {
  ReceivePort receivePort = ReceivePort();
  receivePort.listen((message) {
    if (message) {
      receivePort.close();
      Isolate.current.kill(priority: Isolate.immediate);
      return;
    }
  });
  sendPort.send(receivePort.sendPort);

  while (true) {
    sleep(const Duration(seconds: 10));

    var jsonResult = await sendHttpPost(host, sysMessageTodo, {}, {});
    var resultDataList = jsonResult['data'];
    for (var value in resultDataList) {
      sendPort.send(value);
      sleep(const Duration(seconds: 3));
    }
  }
}

class BackgroundFetchTodo {
  // 接收端口
  ReceivePort receivePort = ReceivePort();

  late SendPort childSendPort;

  BackgroundFetchTodo();

  startBackgroundFetchTodo() {
    Isolate.spawn(fetchTodo, receivePort.sendPort);

    receivePort.listen((message) {
      if (message is SendPort) {
        childSendPort = message;
      } else {
        var title = message['title'];
        var content = message['content'];
        notification.send(title, content);
      }
    });
  }

  closeBackgroundFetchTodo() {
    childSendPort.send(true);
  }
}
