import 'package:flutter/material.dart';

class ConnectionGuideDialog extends StatelessWidget {
  const ConnectionGuideDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Connect Your Device'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              'USB Debugging:',
              [
                '1. Enable Developer Options on your Android device:',
                '   • Go to Settings > About Phone',
                '   • Tap "Build Number" 7 times',
                '2. Enable USB Debugging:',
                '   • Go to Settings > Developer Options',
                '   • Enable "USB Debugging"',
                '3. Connect your device via USB',
                '4. Allow USB Debugging when prompted',
              ],
            ),
            const SizedBox(height: 16),
            _buildSection(
              'Wireless Debugging (Android 11+):',
              [
                '1. Enable Wireless Debugging:',
                '   • Go to Settings > Developer Options',
                '   • Enable "Wireless Debugging"',
                '2. Get pairing code and IP address:',
                '   • Tap "Wireless Debugging"',
                '   • Tap "Pair device with QR code" or "Pair device with pairing code"',
                '3. In terminal, run:',
                '   • adb pair <ip-address:port>',
                '   • Enter the pairing code when prompted',
                '4. Connect to device:',
                '   • adb connect <ip-address:port>',
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }

  Widget _buildSection(String title, List<String> steps) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        ...steps.map((step) => Padding(
              padding: const EdgeInsets.only(left: 8, bottom: 4),
              child: Text(step),
            )),
      ],
    );
  }
}
