import 'package:http/http.dart' as http;
import 'dart:convert';

var _utf8decoder = const Utf8Decoder();

sendHttpPost(String host, String uri, Map<String, String> header, Map<String, dynamic> body) async {
  var url = Uri.http(host, uri);
  var response = await http.post(url, headers: header, body: body);
  /// 将二进制 Byte 数据以 UTF-8 格式编码 , 获取编码后的字符串
  String responseString = _utf8decoder.convert(response.bodyBytes);
  /// 将 json 字符串信息转为 Map<String, dynamic> 类型的键值对信息
  return json.decode(responseString);
}