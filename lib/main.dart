import 'package:flutter/material.dart';
import 'package:message_client/notification.dart';
import 'package:message_client/message_handler.dart';
import 'package:window_manager/window_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //初始化本地通知
  await notification.init();
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '消息平台客户端',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainAppPage(title: '消息平台客户端'),
    );
  }
}

class MainAppPage extends StatefulWidget {
  const MainAppPage({super.key, required this.title});

  final String title;

  @override
  State<MainAppPage> createState() => _MainAppPageState();
}

class _MainAppPageState extends State<MainAppPage> {
  bool _subscribe = false;
  late BackgroundFetchTodo backgroundFetchTodo;

  void _onPressed() {
    setState(() {
      _subscribe = !_subscribe;
    });

    print(_subscribe);
    if (_subscribe) {
      backgroundFetchTodo = BackgroundFetchTodo();
      backgroundFetchTodo.startBackgroundFetchTodo();
    } else {
      backgroundFetchTodo.closeBackgroundFetchTodo();
    }
  }

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
            ElevatedButton.icon(
              icon: const Icon(Icons.send_sharp),
              label: Text(_subscribe ? "取消订阅" : "订阅"),
              onPressed: _onPressed,
            ),
          ],
        ),
      ),
    );
  }
}
