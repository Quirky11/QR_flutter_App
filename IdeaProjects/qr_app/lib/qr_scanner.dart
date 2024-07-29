import 'package:flutter/material.dart';
import 'package:qr_app/qr_link_screen.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

class QRScanner extends StatefulWidget {
  @override
  _QRScannerState createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> with SingleTickerProviderStateMixin {
  late QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _checkPermission();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _checkPermission() async {
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      await Permission.camera.request();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan QR Code'),
        backgroundColor: Colors.lightBlue.shade200,
      ),
      body: Stack(
        children: [
          _buildQrView(context),
          _buildOverlay(context),
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
    );
  }

  Widget _buildOverlay(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Stack(
        children: [
          // Square border
          Container(
            width: 250.0,
            height: 250.0,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white,
                width: 4.0,
              ),
            ),
          ),
          // Scanning line
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _animationController.value * 250.0),
                  child: child,
                );
              },
              child: Container(
                width: 250.0,
                height: 4.0,
                color: Colors.redAccent,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (scanData.code != null) {
        // Only proceed if the scanned data is not null
        String scannedData = scanData.code!;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => QRLinkScreen(link: scannedData),
          ),
        );
      }
    });
  }
}
