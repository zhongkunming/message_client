import 'package:message_client/notification/notification_interface.dart';
import 'package:win_toast/win_toast.dart';

class WinNotification implements NotificationInterFace {
  @override
  init() async {
    await WinToast.instance().initialize(
        appName: '消息客户端', productName: '消息客户端', companyName: 'zhongkunming');
  }

  @override
  callback(obj) async {
    print("playload");
  }

  @override
  send(String title, String body, {int? notificationId, String? params}) async {
    var toast = await WinToast.instance().showToast(
      type: ToastType.text02,
      title: title,
      subtitle: body,
      // actions: List(),
    );
    if (toast != null) {
      toast.eventStream.listen((event) {
        if (event is ActivatedEvent) {
          callback(event);
        }
      });
    }
  }
}
