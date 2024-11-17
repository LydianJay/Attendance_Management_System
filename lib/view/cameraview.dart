import 'dart:async';
import 'dart:ffi' as dart_ffi;
import 'package:attendance_system/controller/attendance.dart';
import 'package:flutter/material.dart';
import 'package:camera_platform_interface/camera_platform_interface.dart';
import 'package:flutter/services.dart';
import 'package:attendance_system/predictor.dart';
import 'package:attendance_system/db/database.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class CameraView extends StatefulWidget {
  const CameraView({super.key});
  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  String _cameraInfo = 'Unknown';
  Predictor predictor = Predictor();
  List<CameraDescription> _cameras = <CameraDescription>[];
  int _cameraIndex = 0;
  int _cameraId = -1;
  bool _initialized = false;
  bool _previewPaused = false;
  Size? _previewSize;
  MediaSettings _mediaSettings = const MediaSettings(
    resolutionPreset: ResolutionPreset.medium,
    fps: 15,
    videoBitrate: 200000,
    audioBitrate: 32000,
    enableAudio: true,
  );
  StreamSubscription<CameraErrorEvent>? _errorStreamSubscription;
  StreamSubscription<CameraClosingEvent>? _cameraClosingStreamSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    _fetchCameras();
  }

  @override
  void dispose() {
    _disposeCurrentCamera();
    _errorStreamSubscription?.cancel();
    _errorStreamSubscription = null;
    _cameraClosingStreamSubscription?.cancel();
    _cameraClosingStreamSubscription = null;
    super.dispose();
  }

  /// Fetches list of available cameras from camera_windows plugin.
  Future<void> _fetchCameras() async {
    String cameraInfo;
    List<CameraDescription> cameras = <CameraDescription>[];

    // int cameraIndex = 0;
    try {
      cameras = await CameraPlatform.instance.availableCameras();
      if (cameras.isEmpty) {
        cameraInfo = 'No available cameras';
      } else {
        debugPrint('Cameras found ${cameras.length}');
        debugPrint('Cameras index ${cameras.toString()}');
        // cameraIndex = 0;

        cameraInfo = cameras.first.name;
      }
    } on PlatformException catch (e) {
      cameraInfo = 'Failed to get cameras: ${e.code}: ${e.message}';
    }

    if (mounted) {
      setState(() {
        // _cameraIndex = cameraIndex;
        _cameras = cameras;
        _cameraInfo = cameraInfo;
      });
    }
  }

  /// Initializes the camera on the device.
  Future<void> _initializeCamera() async {
    assert(!_initialized);

    if (_cameras.isEmpty) {
      return;
    }

    int cameraId = -1;
    try {
      final int cameraIndex = _cameraIndex % _cameras.length;
      final CameraDescription camera = _cameras[cameraIndex];

      cameraId = await CameraPlatform.instance.createCameraWithSettings(
        camera,
        _mediaSettings,
      );

      unawaited(_errorStreamSubscription?.cancel());
      _errorStreamSubscription = CameraPlatform.instance
          .onCameraError(cameraId)
          .listen(_onCameraError);

      unawaited(_cameraClosingStreamSubscription?.cancel());
      _cameraClosingStreamSubscription = CameraPlatform.instance
          .onCameraClosing(cameraId)
          .listen(_onCameraClosing);

      final Future<CameraInitializedEvent> initialized =
          CameraPlatform.instance.onCameraInitialized(cameraId).first;

      await CameraPlatform.instance.initializeCamera(
        cameraId,
      );

      final CameraInitializedEvent event = await initialized;
      _previewSize = Size(
        event.previewWidth,
        event.previewHeight,
      );

      if (mounted) {
        setState(() {
          _initialized = true;
          _cameraId = cameraId;
          _cameraIndex = cameraIndex;
          _cameraInfo = 'Capturing camera: ${camera.name}';
        });
      }
    } on CameraException catch (e) {
      try {
        if (cameraId >= 0) {
          await CameraPlatform.instance.dispose(cameraId);
        }
      } on CameraException catch (e) {
        debugPrint('Failed to dispose camera: ${e.code}: ${e.description}');
      }

      // Reset state.
      if (mounted) {
        setState(() {
          _initialized = false;
          _cameraId = -1;
          _cameraIndex = 0;
          _previewSize = null;

          _cameraInfo =
              'Failed to initialize camera: ${e.code}: ${e.description}';
        });
      }
    }
  }

  Future<void> _disposeCurrentCamera() async {
    if (_cameraId >= 0 && _initialized) {
      try {
        await CameraPlatform.instance.dispose(_cameraId);

        if (mounted) {
          setState(() {
            _initialized = false;
            _cameraId = -1;
            _previewSize = null;

            _previewPaused = false;
            _cameraInfo = 'Camera disposed';
          });
        }
      } on CameraException catch (e) {
        if (mounted) {
          setState(() {
            _cameraInfo =
                'Failed to dispose camera: ${e.code}: ${e.description}';
          });
        }
      }
    }
  }

  Widget _buildPreview() {
    return CameraPlatform.instance.buildPreview(_cameraId);
  }

  Future<void> _takePicture() async {
    final XFile file = await CameraPlatform.instance.takePicture(_cameraId);
    final result = await AttendanceCtrl.checkIn(file);
    if (result != null) {
      if (result['name']!.isNotEmpty) {
        _showResult(context, result['name']!, int.parse(result['id']!));
      } else {
        return showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Image Capture Result'),
                content: const Text('Face Not Recognized'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              );
            });
      }
    }
  }

  Future<void> _togglePreview() async {
    if (_initialized && _cameraId >= 0) {
      if (!_previewPaused) {
        await CameraPlatform.instance.pausePreview(_cameraId);
      } else {
        await CameraPlatform.instance.resumePreview(_cameraId);
      }
      if (mounted) {
        setState(() {
          _previewPaused = !_previewPaused;
        });
      }
    }
  }

  Future<void> _switchCamera() async {
    if (_cameras.isNotEmpty) {
      _cameraIndex = (_cameraIndex + 1) % _cameras.length;
      if (_initialized && _cameraId >= 0) {
        await _disposeCurrentCamera();
        await _fetchCameras();
        if (_cameras.isNotEmpty) {
          await _initializeCamera();
        }
      } else {
        await _fetchCameras();
      }
    }
  }

  Future<void> _onResolutionChange(ResolutionPreset newValue) async {
    setState(() {
      _mediaSettings = MediaSettings(
        resolutionPreset: newValue,
        fps: _mediaSettings.fps,
        videoBitrate: _mediaSettings.videoBitrate,
        audioBitrate: _mediaSettings.audioBitrate,
        enableAudio: _mediaSettings.enableAudio,
      );
    });
    if (_initialized && _cameraId >= 0) {
      // Re-inits camera with new resolution preset.
      await _disposeCurrentCamera();
      await _initializeCamera();
    }
  }

  void _onCameraError(CameraErrorEvent event) {
    if (mounted) {
      _scaffoldMessengerKey.currentState?.showSnackBar(
          SnackBar(content: Text('Error: ${event.description}')));

      // Dispose camera on camera error as it can not be used anymore.
      _disposeCurrentCamera();
      _fetchCameras();
    }
  }

  void _onCameraClosing(CameraClosingEvent event) {
    if (mounted) {
      _showInSnackBar('Camera is closing');
    }
  }

  void _showInSnackBar(String message) {
    _scaffoldMessengerKey.currentState?.showSnackBar(SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 1),
    ));
  }

  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  Future<void> _showResult(BuildContext context, String name, int id) {
    List<Widget> okay = [
      TextButton(
        onPressed: () async {
          // Insert attendance to db
          AttendanceCtrl.insertAttendance(id, true);
          Navigator.of(context).pop();
        },
        child: const Text('Check In'),
      ),
      TextButton(
        onPressed: () async {
          // Insert attendance to db
          AttendanceCtrl.insertAttendance(id, false);
          Navigator.of(context).pop();
        },
        child: const Text('Check Out'),
      ),
      TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: const Text('Not Me'),
      ),
    ];

    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Image Capture Result'),
            content: Text('Employee Name: $name'),
            actions: okay,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    double scrWidth = MediaQuery.of(context).size.width;
    double scrHeight = MediaQuery.of(context).size.height;
    final List<DropdownMenuItem<ResolutionPreset>> resolutionItems =
        ResolutionPreset.values
            .map<DropdownMenuItem<ResolutionPreset>>((ResolutionPreset value) {
      return DropdownMenuItem<ResolutionPreset>(
        value: value,
        child: Text(value.toString()),
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Camera'),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 5,
              horizontal: 10,
            ),
            child: Text('Selected Camera: $_cameraInfo'),
          ),
          if (_cameras.isEmpty)
            ElevatedButton(
              onPressed: _fetchCameras,
              child: const Text('Re-check available cameras'),
            ),
          if (_cameras.isNotEmpty)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                DropdownButton<ResolutionPreset>(
                  value: _mediaSettings.resolutionPreset,
                  onChanged: (ResolutionPreset? value) {
                    if (value != null) {
                      _onResolutionChange(value);
                    }
                  },
                  items: resolutionItems,
                ),
                ElevatedButton(
                  onPressed:
                      _initialized ? _disposeCurrentCamera : _initializeCamera,
                  child: Text(_initialized ? 'Dispose camera' : 'Start camera'),
                ),
                ElevatedButton(
                  onPressed: _initialized ? _takePicture : null,
                  child: const Text('Take picture'),
                ),
                ElevatedButton(
                  onPressed: _initialized ? _togglePreview : null,
                  child: Text(
                    _previewPaused ? 'Resume preview' : 'Pause preview',
                  ),
                ),
                if (_cameras.length > 1) ...<Widget>[
                  const SizedBox(width: 5),
                  ElevatedButton(
                    onPressed: _switchCamera,
                    child: const Text(
                      'Switch camera',
                    ),
                  ),
                ]
              ],
            ),
          const SizedBox(height: 5),
          if (_initialized && _cameraId > 0 && _previewSize != null)
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
              ),
              child: Align(
                child: Container(
                  constraints: const BoxConstraints(
                    maxHeight: 800,
                  ),
                  child: AspectRatio(
                    // aspectRatio: 1000 / 800,
                    aspectRatio: _previewSize!.width / _previewSize!.height,
                    child: _buildPreview(),
                  ),
                ),
              ),
            ),
          if (_previewSize != null)
            Center(
              child: Text(
                'Preview size: ${_previewSize!.width.toStringAsFixed(0)}x${_previewSize!.height.toStringAsFixed(0)}',
              ),
            ),
        ],
      ),
    );
  }
}
