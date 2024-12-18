import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  Future<void> _addToGoogleCalendar() async {
    const String title = 'Notification Heading';
    const String description = 'Notification Description';

    final startDate = DateTime.now().toUtc(); 
    final endDate = startDate.add(const Duration(hours: 1)); 

    final uri = Uri.parse('https://www.google.com/calendar/event?action=TEMPLATE&text=${Uri.encodeQueryComponent(title)}&dates=${startDate.toIso8601String()}/${endDate.toIso8601String()}&details=${Uri.encodeQueryComponent(description)}');

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        throw 'Could not launch $uri';
      }
    } catch (e) {
      print('Error launching calendar: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Image.asset(
              'assets/Images/notification.png', 
              width: double.infinity,
              height: 500,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 16.0),
          Center(
            child: ElevatedButton(
              onPressed: () => _addToGoogleCalendar(),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
              ),
              child: const Text(
                'Add to Google Calendar',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
