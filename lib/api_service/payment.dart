import 'dart:convert';

import 'package:Trendify/api_service/base_api.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

class PaymentController {
  CardFieldInputDetails? _cardDetails;
  void updateCardDetails(CardFieldInputDetails? details) {
    _cardDetails = details;
  }

  Future<String?> payNow() async {
    try {
      if (_cardDetails == null || !_cardDetails!.complete) {
        return "Enter valid card details";
      }

      final response = await http.post(
        Uri.parse('${ApiService.baseUrl}/createpayment'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": "newcustomer@gmail.com",
          "name": "newcustomer",
          "amount": 5000,
        }),
      );

      final paymentData = jsonDecode(response.body);
      if (paymentData['error'] == true) {
        return "Error: ${paymentData['message']}";
      }

      final billingDetails = BillingDetails(
        address: Address(
          country: 'IN',
          city: 'Gurgaon',
          line1: 'addr1',
          line2: 'addr2',
          postalCode: '122001',
          state: 'Gurugram',
        ),
      );

      await Stripe.instance.confirmPayment(
        paymentIntentClientSecret: paymentData['paymentIntent'],
        data: PaymentMethodParams.card(
          paymentMethodData: PaymentMethodData(billingDetails: billingDetails),
        ),
      );

      return null;
    } catch (e) {
      return "Payment Error: $e";
    }
  }
}
