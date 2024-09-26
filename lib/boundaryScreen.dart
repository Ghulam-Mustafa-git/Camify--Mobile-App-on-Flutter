import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'dart:ui' as ui;
import 'serverConnection.dart' as sc;
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:image/image.dart' as img;

enum Shape { none, circle, rectangle }

class BoundaryScreen extends StatefulWidget {
  @override
  _BoundaryScreenState createState() => _BoundaryScreenState();
}

class _BoundaryScreenState extends State<BoundaryScreen> {
  Uint8List? _imageData;
  ui.Image? _image;
  Shape _selectedShape = Shape.none;
  Offset? _startPoint;
  Offset? _endPoint;
  Map<String, dynamic>? _shape;
  Offset? _dragStartPoint;
  bool _isDragging = false;
  double _rotationAngle = 0.0;
  double _borderWidth = 3.0;
  GlobalKey _repaintKey = GlobalKey();
  String url = sc.serverUrl;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _captureImage() async {
    try {
      final response = await http
          .get(Uri.parse('$url/capture_image'))
          .timeout(Duration(seconds: 60));

      if (response.statusCode == 200) {
        setState(() {
          _imageData = response.bodyBytes;
          _loadImage();
        });
      } else {
        // Handle non-200 status code
        print(
            'Error: Server responded with status code ${response.statusCode}');
      }
    } on TimeoutException catch (e) {
      // Handle timeout
      print('Error: Request timed out. $e');
    } on SocketException catch (e) {
      // Handle network error
      print('Error: Network error. $e');
    } catch (e) {
      // Handle other errors
      print('Error: An unexpected error occurred. $e');
    }
  }

  Future<void> _loadImage() async {
    final codec = await ui.instantiateImageCodec(_imageData!);
    final frame = await codec.getNextFrame();
    final image = frame.image;
    setState(() {
      _image = image;
      print('Received image resolution: ${image.width}x${image.height}');
    });
  }

  // Function to capture an image and resize it to 720x480
  Future<Uint8List> _capturePng() async {
    RenderRepaintBoundary boundary =
    _repaintKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

    // Capture the image with the highest possible quality
    ui.Image image = await boundary.toImage(pixelRatio: 1.0);
    print('captured image resolution: ${image.width}x${image.height}');

    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List originalBytes = byteData!.buffer.asUint8List();

    // Decode the image to manipulate its size
    img.Image originalImage = img.decodeImage(originalBytes)!;

    // Resize the image to 720x480
    img.Image resizedImage = img.copyResize(originalImage, width: image.width, height: image.height);

    // Encode the resized image back to PNG
    Uint8List resizedBytes = Uint8List.fromList(img.encodePng(resizedImage));

    return resizedBytes;
  }

  Future<void> _sendBoundaryImage() async {
    Uint8List pngBytes = await _capturePng();

    var request = http.MultipartRequest('POST', Uri.parse('$url/upload_image'));
    request.files.add(http.MultipartFile.fromBytes('image', pngBytes,
        filename: 'image_with_boundary.jpg'));
    var response = await request.send();

    if (response.statusCode == 200) {
      print('Image sent successfully');
    } else {
      print('Error: ${response.statusCode}');
    }
  }

  void _resetShape() {
    setState(() {
      _shape = null;
      _startPoint = null;
      _endPoint = null;
      _rotationAngle = 0.0;
    });
  }

  bool _isInsideShape(Offset point) {
    if (_shape == null) return false;
    if (_shape!['shape'] == Shape.circle) {
      final center = Offset(
        (_shape!['start'].dx + _shape!['end'].dx) / 2,
        (_shape!['start'].dy + _shape!['end'].dy) / 2,
      );
      final radius = (_shape!['start'] - _shape!['end']).distance / 2;
      return (point - center).distance <= radius;
    } else if (_shape!['shape'] == Shape.rectangle) {
      final rect = Rect.fromPoints(_shape!['start'], _shape!['end']);
      return rect.contains(point);
    }
    return false;
  }

  void _startDragging(Offset point) {
    if (_isInsideShape(point)) {
      setState(() {
        _dragStartPoint = point;
        _isDragging = true;
      });
    }
  }

  void _updateDragging(Offset point) {
    if (_isDragging && _dragStartPoint != null) {
      final dx = point.dx - _dragStartPoint!.dx;
      final dy = point.dy - _dragStartPoint!.dy;
      setState(() {
        _shape!['start'] =
            Offset(_shape!['start'].dx + dx, _shape!['start'].dy + dy);
        _shape!['end'] = Offset(_shape!['end'].dx + dx, _shape!['end'].dy + dy);
        _dragStartPoint = point;
      });
    }
  }

  void _endDragging() {
    setState(() {
      _isDragging = false;
      _dragStartPoint = null;
    });
  }

  void _rotateShape(bool clockwise) {
    if (_shape != null) {
      setState(() {
        final angleIncrement =
        0.1; // Adjust this value for larger/smaller steps
        _rotationAngle += clockwise ? angleIncrement : -angleIncrement;
        _shape!['rotation'] = _rotationAngle;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.red,
        title: const Text(
          'Boundary Setting',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _image != null
                ? RepaintBoundary(
              key: _repaintKey,
              child: GestureDetector(
                onScaleStart: (details) {
                  if (_shape == null) {
                    RenderBox box =
                    context.findRenderObject() as RenderBox;
                    setState(() {
                      _startPoint = box.globalToLocal(details.focalPoint);
                    });
                  } else {
                    _startDragging(details.localFocalPoint);
                  }
                },
                onScaleUpdate: (details) {
                  if (_shape == null) {
                    RenderBox box =
                    context.findRenderObject() as RenderBox;
                    setState(() {
                      _endPoint = box.globalToLocal(details.focalPoint);
                    });
                  } else {
                    if (details.pointerCount == 1) {
                      _updateDragging(details.localFocalPoint);
                    }
                  }
                },
                onScaleEnd: (details) {
                  if (_shape == null &&
                      _startPoint != null &&
                      _endPoint != null) {
                    setState(() {
                      _shape = {
                        'shape': _selectedShape,
                        'start': _startPoint,
                        'end': _endPoint,
                        'rotation': _rotationAngle,
                      };
                      _startPoint = null;
                      _endPoint = null;
                    });
                  } else {
                    _endDragging();
                  }
                },
                child: Container(
                  width: 720,
                  height: 274,
                  child: CustomPaint(
                    painter: BoundaryPainter(
                      _image,
                      _shape,
                      _startPoint,
                      _endPoint,
                      _selectedShape,
                      _borderWidth,
                      _rotationAngle,
                    ),
                  ),
                ),
              ),
            )
                : Text('No image captured.'),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.red),
              ),
              onPressed: _captureImage,
              child: Text(
                'Capture Image',
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Border Width:"),
                Slider(
                  value: _borderWidth,
                  min: 1.0,
                  max: 10.0,
                  onChanged: (value) {
                    setState(() {
                      _borderWidth = value;
                    });
                  },
                ),
              ],
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.red),
              ),
              onPressed: _sendBoundaryImage,
              child: Text(
                'Set Boundary',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        backgroundColor: Colors.red,
        children: [
          SpeedDialChild(
            child: Icon(Icons.circle),
            label: 'Circle',
            backgroundColor:
            _selectedShape == Shape.circle ? Colors.green : Colors.red,
            onTap: () {
              setState(() {
                _selectedShape = Shape.circle;
              });
            },
          ),
          SpeedDialChild(
            child: Icon(Icons.crop_square),
            label: 'Rectangle',
            backgroundColor:
            _selectedShape == Shape.rectangle ? Colors.green : Colors.red,
            onTap: () {
              setState(() {
                _selectedShape = Shape.rectangle;
              });
            },
          ),
          SpeedDialChild(
            child: Icon(Icons.refresh),
            label: 'Reset',
            backgroundColor: Colors.red,
            onTap: _resetShape,
          ),
          SpeedDialChild(
            child: Icon(Icons.rotate_right),
            label: 'Rotate Clockwise',
            backgroundColor: Colors.red,
            onTap: () => _rotateShape(true),
          ),
          SpeedDialChild(
            child: Icon(Icons.rotate_left),
            label: 'Rotate Counterclockwise',
            backgroundColor: Colors.red,
            onTap: () => _rotateShape(false),
          ),
        ],
      ),
    );
  }
}

class BoundaryPainter extends CustomPainter {
  final ui.Image? image;
  final Map<String, dynamic>? shape;
  final Offset? startPoint;
  final Offset? endPoint;
  final Shape selectedShape;
  final double borderWidth;
  final double rotationAngle;

  BoundaryPainter(this.image, this.shape, this.startPoint, this.endPoint,
      this.selectedShape, this.borderWidth, this.rotationAngle);

  @override
  void paint(Canvas canvas, Size size) {
    if (image != null) {
      paintImage(
        canvas: canvas,
        image: image!,
        rect: Rect.fromLTWH(0, 0, size.width, size.height),
        fit: BoxFit
            .contain, // Ensure the image is fitted to the container properly
      );
    }

    final paint = Paint()
      ..color = Colors.green
      ..strokeWidth = borderWidth
      ..style = PaintingStyle.stroke;

    if (shape != null) {
      canvas.save();
      final center = Offset(
        (shape!['start'].dx + shape!['end'].dx) / 2,
        (shape!['start'].dy + shape!['end'].dy) / 2,
      );
      canvas.translate(center.dx, center.dy);
      canvas.rotate(shape!['rotation']);
      canvas.translate(-center.dx, -center.dy);

      if (shape!['shape'] == Shape.circle) {
        final circleCenter = Offset(
          (shape!['start'].dx + shape!['end'].dx) / 2,
          (shape!['start'].dy + shape!['end'].dy) / 2,
        );
        final radius = (shape!['start'] - shape!['end']).distance / 2;
        canvas.drawCircle(circleCenter, radius, paint);
      } else if (shape!['shape'] == Shape.rectangle) {
        canvas.drawRect(Rect.fromPoints(shape!['start'], shape!['end']), paint);
      }
      canvas.restore();
    }

    if (startPoint != null && endPoint != null) {
      if (selectedShape == Shape.circle) {
        final center = Offset(
          (startPoint!.dx + endPoint!.dx) / 2,
          (startPoint!.dy + endPoint!.dy) / 2,
        );
        final radius = (startPoint! - endPoint!).distance / 2;
        canvas.drawCircle(center, radius, paint);
      } else if (selectedShape == Shape.rectangle) {
        canvas.drawRect(Rect.fromPoints(startPoint!, endPoint!), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}