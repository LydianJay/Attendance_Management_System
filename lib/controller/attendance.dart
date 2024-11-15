import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:attendance_system/config/config.dart';
import 'package:image_picker/image_picker.dart';

class AttendanceCtrl {
  static Future<String?>? checkIn(XFile imageFile) async {
    final uri = Uri.http(DbConfig.ip);

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
    } else {
      debugPrint("ERROR - Status Code: ${response.statusCode}");
    }
    return null;
  }
}
