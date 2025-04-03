import 'package:Trendify/screen/shared/shared.dart';
import 'package:Trendify/utilis/custom_text.dart';
import 'package:Trendify/utilis/media_query.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CustomPaymentPage extends StatefulWidget {
  const CustomPaymentPage({super.key});

  @override
  CustomPaymentPageState createState() => CustomPaymentPageState();
}

class CustomPaymentPageState extends State<CustomPaymentPage> {
  CardFieldInputDetails? _cardDetails;

  Future<void> payNow() async {
    try {
      if (_cardDetails == null || !_cardDetails!.complete) {
        print("Enter valid card details");
        return;
      }

      final response = await http.post(
        Uri.parse('$url/createpayment'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": "newcustomer@gmail.com",
          "name": "newcustomer",
          "amount": 5000,
        }),
      );
      final paymentData = jsonDecode(response.body);

      if (paymentData['error'] == true) {
        print("Error: ${paymentData['message']}");
        return;
      }

      final paymentIntent = paymentData['paymentIntent'];
      final billingDetails = BillingDetails(
        address: Address(
          country: 'IN',
          city: 'Chennai',
          line1: 'addr1',
          line2: 'addr2',
          postalCode: '680681',
          state: 'kerala',
        ),
      );

      await Stripe.instance.confirmPayment(
        paymentIntentClientSecret: paymentIntent,
        data: PaymentMethodParams.card(
          paymentMethodData: PaymentMethodData(billingDetails: billingDetails),
        ),
      );
      print("Payment Successful!");
    } catch (e) {
      print("Payment Error: $e");
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
              onCardChanged: (card) => setState(() => _cardDetails = card),
            ),
            SizedBox(height: getHeight(context, 20)),
            SizedBox(
              width: getWidth(context, 200),
              child: ElevatedButton(
                onPressed: payNow,
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
