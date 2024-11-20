import 'dart:io';

import 'package:attendance_system/config/config.dart';
import 'package:attendance_system/controller/attendance.dart';
import 'package:flutter/material.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final _ctrlIP = TextEditingController(text: 'localhost');

  void getConfig() async {
    File file = File('config.cfg');
    if (!await file.exists()) {
      DbConfig.ip = _ctrlIP.text;
      file.writeAsString(_ctrlIP.text);
    } else {
      _ctrlIP.text = await file.readAsString();
      DbConfig.ip = _ctrlIP.text;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Server Settings'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
              width: 250,
              child: TextField(
                controller: _ctrlIP,
                keyboardType: const TextInputType.numberWithOptions(
                  signed: false,
                  decimal: true,
                ),
                maxLength: 64,
              ),
            ),
          ),
          ElevatedButton.icon(
            onPressed: () async {
              DbConfig.ip = _ctrlIP.text;
              File file = File('config.cfg');
              file.writeAsString(DbConfig.ip);
              AttendanceCtrl.checkConnection().then((onValue) {
                Navigator.pushNamed(context, '/camera');
                // debugPrint('Connection Establised');
              }).onError((e, s) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return const SimpleDialog(
                      title: Text(
                        'Connection Timeout',
                      ),
                      children: [
                        Center(
                            child: Text(
                          'Could not connect to server',
                        )),
                      ],
                    );
                  },
                );
              });
            },
            label: const Text('Set Server IP'),
            icon: const Icon(Icons.check),
          ),
        ],
      ),
    );
  }
}
