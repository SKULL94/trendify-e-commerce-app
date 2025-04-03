import 'package:Trendify/utilis/custom_text.dart';
import 'package:flutter/material.dart';

class OrderStatusSplashScreen extends StatefulWidget {
  const OrderStatusSplashScreen({super.key, required this.status});
  final String status;
  @override
  OrderStatusSplashScreenState createState() => OrderStatusSplashScreenState();
}

class OrderStatusSplashScreenState extends State<OrderStatusSplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2000),
    );
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_animationController);
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Opacity(
              opacity: _animation.value,
              child:
                  widget.status == 'success'
                      ? CustomText(
                        text: 'Order Success!',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      )
                      : CustomText(
                        text: 'Payment failed',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
            );
          },
        ),
      ),
    );
  }
}
