import 'package:flutter/material.dart';
import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:camerawesome/pigeon.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({Key? key}) : super(key: key);

  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CameraAwesomeBuilder.custom(
        builder: (cameraState, preview) {
          return cameraState.when(
            onPreparingCamera: (state) => const Center(child: CircularProgressIndicator()),
            onPhotoMode: (state) => TakePhotoUI(state),
            onVideoMode: (state) => RecordVideoUI(state, recording: false),
            onVideoRecordingMode: (state) => RecordVideoUI(state, recording: true),
          );
        },
        saveConfig: SaveConfig.photoAndVideo(),
      ),
    );
  }
}

class TakePhotoUI extends StatelessWidget {
  final PhotoCameraState state;

  const TakePhotoUI(this.state, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class RecordVideoUI extends StatelessWidget {
  final CameraState state;
  final bool recording;

  const RecordVideoUI(this.state, {super.key, required this.recording});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
