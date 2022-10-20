import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:message_client/notification/notification_interface.dart';


class Notification implements NotificationInterFace {
  final FlutterLocalNotificationsPlugin np = FlutterLocalNotificationsPlugin();

  @override
  init() async {
    var android = const AndroidInitializationSettings("@mipmap/ic_launcher");
    var darwin = const DarwinInitializationSettings();
    var linux = const LinuxInitializationSettings(defaultActionName: "消息推送");
    await np.initialize(
        InitializationSettings(
            android: android, iOS: darwin, macOS: darwin, linux: linux),
        onDidReceiveNotificationResponse: callback,
        onDidReceiveBackgroundNotificationResponse: callback);
  }

  /// 点击通知回调事件
  @override
  void callback(dynamic obj) async {
    if (obj is NotificationResponse) {
      NotificationResponse payload = obj;
      print("its callback $payload");
    }
  }

  /// params为点击通知时，可以拿到的参数，title和body仅仅是展示作用
  /// Map params = {};
  /// params['type'] = "100";
  /// params['id'] = "10086";
  /// params['content'] = "content";
  /// notification.send("title", "content",params: json.encode(params));
  ///
  /// notificationId指定时，不在根据时间生成
  @override
  void send(String title, String body, {int? notificationId, String? params}) {
    // 构建描述
    var androidDetails = const AndroidNotificationDetails(
      //区分不同渠道的标识
      'cn.zhongkunming.push',
      //channelName渠道描述不要随意填写，会显示在手机设置，本app 、通知列表中，
      //规范写法根据业务：比如： 重要通知，一般通知、或者，交易通知、消息通知、等
      'message-notification',
      //通知的级别
      importance: Importance.max,
      priority: Priority.max,
      //可以单独设置每次发送通知的图标
      // icon: ''
      //显示进度条 3个参数必须同时设置
      // progress: 19,
      // maxProgress: 100,
      // showProgress: true
    );
    var darwinDetails = const DarwinNotificationDetails();
    var linuxDetails = const LinuxNotificationDetails();
    var details = NotificationDetails(
        android: androidDetails,
        iOS: darwinDetails,
        macOS: darwinDetails,
        linux: linuxDetails);

    WidgetsFlutterBinding.ensureInitialized();
    // 显示通知, 第一个参数是id,id如果一致则会覆盖之前的通知
    // String? payload, 点击时可以拿到的参数
    np.show(notificationId ?? DateTime.now().millisecondsSinceEpoch >> 10,
        title, body, details,
        payload: params);
  }

  ///清除所有通知
  void cleanNotification() {
    np.cancelAll();
  }

  ///清除指定id的通知
  /// `tag`参数指定Android标签。 如果提供，
  /// 那么同时匹配 id 和 tag 的通知将会
  /// 被取消。 `tag` 对其他平台没有影响。
  void cancelNotification(int id, {String? tag}) {
    np.cancel(id, tag: tag);
  }
}
