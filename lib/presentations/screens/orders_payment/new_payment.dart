import 'package:Trendify/core/utils/media_query.dart';
import 'package:Trendify/data/datasources/datasources/payment.dart';
import 'package:Trendify/presentations/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class CustomPaymentPage extends StatefulWidget {
  const CustomPaymentPage({super.key});

  @override
  CustomPaymentPageState createState() => CustomPaymentPageState();
}

class CustomPaymentPageState extends State<CustomPaymentPage> {
  final PaymentController controller = PaymentController();

  void _handlePayNow() async {
    final error = await controller.payNow();
    if (error != null) {
    } else {
      print("Payment Successful!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CustomText(
          text: "Custom Payment UI",
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(getWidth(context, 20)),
        child: Column(
          children: [
            CardField(
              onCardChanged:
                  (card) => setState(() {
                    controller.updateCardDetails(card);
                  }),
            ),
            SizedBox(height: getHeight(context, 20)),
            SizedBox(
              width: getWidth(context, 200),
              child: ElevatedButton(
                onPressed: _handlePayNow,
                child: const CustomText(
                  text: "Pay Now",
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
