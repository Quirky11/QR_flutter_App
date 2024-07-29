import 'package:flutter/material.dart';
import 'package:qr_app/qrDisplay_screen.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qr_app/qr_scanner.dart'; // Make sure to import QRScanner

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue.shade200,
        title: const Text('Quirky QR'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white54,
              Colors.grey,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'assests/image/qrImage.png', // Ensure the path is correct
                  height: 150, // You can adjust the height
                  fit: BoxFit.cover, // This keeps the aspect ratio
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Enter link to generate QR code',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 15,
                      ),
                    ),
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    String data = _controller.text;
                    if (data.isNotEmpty && _isValidUrl(data)) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QRDisplayScreen(qrData: data),
                        ),
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Invalid Link'),
                          content: const Text('Please enter a valid URL to generate a QR code.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  child: const Text('Generate QR Code'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QRScanner(),
                      ),
                    );
                  },
                  child: const Text('Scan QR Code'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _isValidUrl(String url) {
    // Validate URL using Uri.tryParse
    Uri? uri = Uri.tryParse(url);
    if (uri != null && (uri.isScheme("http") || uri.isScheme("https"))) {
      return true;
    }
    return false;
  }
}
