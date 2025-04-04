import 'package:Trendify/utils/custom_text.dart';
import 'package:Trendify/utils/media_query.dart';
import 'package:flutter/material.dart';

class TopNotification extends StatefulWidget {
  const TopNotification({super.key});

  @override
  _TopNotificationState createState() => _TopNotificationState();
}

class _TopNotificationState extends State<TopNotification> {
  bool _isVisible = false;

  void showNotification() {
    setState(() => _isVisible = true);
    Future.delayed(
      const Duration(seconds: 2),
      () => setState(() => _isVisible = false),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: _isVisible ? 0 : -50,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.green,
              padding: EdgeInsets.all(getWidth(context, 16)),
              child: const CustomText(
                text: 'Successfully logged in!',
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showNotification,
        child: const Icon(Icons.check),
      ),
    );
  }
}
