import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  // Sample data for notifications
  final List<Map<String, String>> notifications = [
    {
      'title': 'New Order Received',
      'body': 'You have a new order from John Doe.',
      'time': '5 mins ago',
    },
    {
      'title': 'Order Shipped',
      'body': 'Your order has been shipped successfully.',
      'time': '1 hour ago',
    },
    {
      'title': 'Payment Successful',
      'body': 'Your payment for Order #12345 was successful.',
      'time': '2 hours ago',
    },
    {
      'title': 'New Message',
      'body': 'You have a new message from Customer Support.',
      'time': '3 hours ago',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: notifications.isEmpty
          ? Center(child: Text('No notifications available.'))
          : ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                return NotificationCard(
                  title: notifications[index]['title']!,
                  body: notifications[index]['body']!,
                  time: notifications[index]['time']!,
                );
              },
            ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final String title;
  final String body;
  final String time;

  const NotificationCard({
    Key? key,
    required this.title,
    required this.body,
    required this.time,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 8),
              Text(
                body,
                style: TextStyle(
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 8),
              Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  time,
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
