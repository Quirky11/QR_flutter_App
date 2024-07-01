import 'package:flutter/material.dart';

class QRLinkScreen extends StatelessWidget {
  final String link;

  const QRLinkScreen({Key? key, required this.link}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Generated Link'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Generated Link:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            SelectableText(
              link,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Navigate back to QRScanner screen
              },
              child: Text('Scan Again'),
            ),
          ],
        ),
      ),
    );
  }
}
