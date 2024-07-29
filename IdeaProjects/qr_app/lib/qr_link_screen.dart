import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Import the url_launcher package
import 'package:flutter/services.dart'; // Import the clipboard package

class QRLinkScreen extends StatelessWidget {
  final String link;

  const QRLinkScreen({Key? key, required this.link}) : super(key: key);

  // Function to launch the URL
  Future<void> _launchURL(BuildContext context, String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      // Display a message if the URL can't be launched
      showDialog(
        context: context, // Use the context passed to the function
        builder: (context) => AlertDialog(
          title: const Text('Invalid URL'),
          content: const Text('Cannot launch the URL.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  // Function to copy the link to the clipboard
  void _copyLink(BuildContext context) {
    Clipboard.setData(ClipboardData(text: link));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Link copied to clipboard'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generated Link'),
        backgroundColor: Colors.lightBlue.shade200,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Generated Link:',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                _launchURL(context, link); // Pass the context to the launch function
              },
              child: Text(
                link,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.blue, // Set link color to blue
                  decoration: TextDecoration.underline, // Underline the text
                  decorationColor: Colors.blue, // Underline color matches text color
                ),
                textAlign: TextAlign.center, // Center the text
              ),
            ),
            const SizedBox(height: 20),

            // Row for horizontal button alignment
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.link),
                  tooltip: 'Open Link',
                  onPressed: () => _launchURL(context, link), // Open the link when pressed
                ),
                const SizedBox(width: 10), // Space between buttons
                IconButton(
                  icon: const Icon(Icons.copy),
                  tooltip: 'Copy Link',
                  onPressed: () => _copyLink(context), // Copy the link to clipboard when pressed
                ),
                const SizedBox(width: 10), // Space between buttons
                IconButton(
                  icon: const Icon(Icons.qr_code_scanner),
                  tooltip: 'Scan Again',
                  onPressed: () {
                    Navigator.pop(context); // Navigate back to QRScanner screen
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
