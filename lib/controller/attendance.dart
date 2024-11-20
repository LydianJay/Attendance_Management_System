import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:attendance_system/config/config.dart';
import 'package:image_picker/image_picker.dart';

class AttendanceCtrl {
  static Future<Map<String, String>?>? checkIn(XFile imageFile) async {
    final uri = Uri.http(DbConfig.pythonServer);

    debugPrint(uri.toString());
    final header = {"Content-Type": "application/json"};
    final req = http.Request('GET', uri);
    final imageBytes = await imageFile.readAsBytes();
    final base64Image = base64Encode(imageBytes);
    req.headers.addAll(header);
    req.body = jsonEncode({'image': base64Image});
    final response = await req.send();
    if (response.statusCode == 200) {
      debugPrint('Received Data!');
      final data = await response.stream.bytesToString();
      debugPrint(data);
      final retVal = jsonDecode(data);

      return {'name': retVal['name'], 'id': retVal['id'].toString()};
    } else {
      debugPrint("ERROR - Status Code: ${response.statusCode}");
    }
    return null;
  }

  static void insertAttendance(int id, bool isCheckIn) async {
    // final uri = Uri.https(DbConfig.ip, '/attendance-system/public/insert');
    final uri = Uri.https(DbConfig.ip, '/insert');
    debugPrint(uri.toString());
    final header = {"Content-Type": "application/json"};
    var req = http.Request('POST', uri);
    req.body = "{ \"id\":\"$id\",\"type\":\"${isCheckIn ? '1' : '2'}\" }";
    req.headers.addAll(header);
    final response = await req.send();
    if (response.statusCode == 200) {
      debugPrint('Received Data!');
      final data = await response.stream.bytesToString();
      debugPrint(data);
    } else {
      debugPrint("ERROR - Status Code: ${response.statusCode}");
    }
  }

  static Future<bool> checkConnection() async {
    final uri = Uri.https(DbConfig.ip);
    var req = http.Request('GET', uri);
    final header = {"Content-Type": "text/html"};
    req.headers.addAll(header);
    final response = await req.send();
    return response.statusCode == 200;
  }
}
