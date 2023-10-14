import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_ml_vision/google_ml_vision.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:youblink/screens/home_screen.dart';
import 'package:youblink/widgets/custom_dialog_alert.dart';
import 'package:youblink/widgets/navigation_service.dart';

import '../utils/face_mask_painters.dart';
import '../utils/utils.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  dynamic _scanResults;
  CameraController? _camera;
  dynamic _currentDetector = Detector.text;
  bool _isDetecting = false;
  bool shouldShowDialog = false;
  CameraLensDirection _direction = CameraLensDirection.front;

  final FaceDetector _faceDetector = GoogleVision.instance.faceDetector(
      const FaceDetectorOptions(
          enableTracking: true,
          enableContours: true,
          mode: FaceDetectorMode.accurate,
          enableClassification: true));

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  void _showDialogAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const CustomAlertDialog();
      },
    );
  }

  void _showDialog() {
    if (shouldShowDialog) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('YOUBLINK'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('You just blinked!',
                    style:
                        TextStyle(fontWeight: FontWeight.w300, fontSize: 20)),
                Text('Task is done',
                    style:
                        TextStyle(fontWeight: FontWeight.w200, fontSize: 18)),
                Divider()
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  // Navigator.of(context).pop();
                  Get.to(() => const HomeScreen());
                  setState(() {
                    shouldShowDialog =
                        false; // Resetting the flag after dialog dismissal
                  });
                },
                style: TextButton.styleFrom(
                  side: const BorderSide(color: Colors.purple), // Outline color
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(25), // Adjust the border radius
                    side: const BorderSide(color: Colors.purple),
                  ),
                ),
                child: const Text('  Okay  '),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _initializeCamera() async {
    final CameraDescription description =
        await ScannerUtils.getCamera(_direction);

    _camera = CameraController(
      description,
      defaultTargetPlatform == TargetPlatform.iOS
          ? ResolutionPreset.high
          : ResolutionPreset.high,
      enableAudio: false,
    );
    await _camera?.initialize();

    await _camera?.startImageStream((CameraImage image) {
      if (_isDetecting) return;

      _isDetecting = true;

      ScannerUtils.detect(
        image: image,
        // detectInImage: _getDetectionMethod(),
        detectInImage: _faceDetector.processImage,
        imageRotation: description.sensorOrientation,
      ).then(
        (dynamic results) {
          if (_currentDetector == null) return;
          setState(() {
            _scanResults = results;
          });
        },
      ).whenComplete(() => Future.delayed(
          const Duration(
            milliseconds: 100,
          ),
          () => {_isDetecting = false}));
    });
  }

  void _handleEyesClosed() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!shouldShowDialog) {
        // Checking whether the dialog is already scheduled to display
        setState(() {
          shouldShowDialog = true;
        });
        _showDialog();
      }
    });
  }

  Widget _buildResults() {
    Widget noResultsText = Center(
      child: SpinKitFadingCube(
        color: Colors.purple[300],
        size: 50.0,
      ),
    );

    if (_scanResults == null ||
        _camera == null ||
        !_camera!.value.isInitialized) {
      return noResultsText;
    }

    CustomPainter painter;

    final Size imageSize = Size(
      _camera!.value.previewSize!.height,
      _camera!.value.previewSize!.width,
    );
    painter = FaceMask(
      imageSize,
      _scanResults,
      _handleEyesClosed,
    );

    return CustomPaint(
      painter: painter,
    );
  }

  Widget _buildImage() {
    return Container(
      constraints: const BoxConstraints.expand(),
      child: _camera == null
          ? SpinKitFadingCube(
              color: Colors.purple[300],
              size: 50.0,
            )
          : Column(
              children: [
                Expanded(
                  // This makes the container take all available space
                  child: Container(
                    child: Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        CameraPreview(_camera!),
                        _buildResults(),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: 100,
                            // width: 100,
                            decoration: const BoxDecoration(
                              color: Colors.transparent,
                            ),
                            child: ClipPath(
                                clipper: NotchedRectangleClipper(),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.purple.withOpacity(
                                        0.9), // Choose a visible color for demonstration
                                  ),
                                )),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Future<void> _toggleCameraDirection() async {
    if (_direction == CameraLensDirection.back) {
      _direction = CameraLensDirection.front;
    } else {
      _direction = CameraLensDirection.back;
    }

    await _camera?.stopImageStream();
    await _camera?.dispose();

    setState(() {
      _camera = null;
    });

    await _initializeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.purple.shade400,
                Colors.purple.shade200,
              ],
            ),
          ),
        ),
        title: const Text(
          'Youblink',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon:
              const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: <Widget>[
          IconButton(
              onPressed: () {
                _showDialogAlert(context);
              },
              icon: const Icon(Icons.info_rounded),
              color: Colors.white70)
        ],
      ),
      body: _buildImage(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: _toggleCameraDirection,
        child: _direction == CameraLensDirection.back
            ? const Icon(Icons.camera_front, color: Colors.purple)
            : const Icon(Icons.camera_rear, color: Colors.purple),
      ),
    );
  }

  @override
  void dispose() {
    _camera?.dispose().then((_) {
      _faceDetector.close();
    });

    _currentDetector = null;
    super.dispose();
  }
}
