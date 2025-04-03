import 'package:flutter/material.dart';

double getWidth(
  BuildContext context,
  double value, {
  double denominator = 375,
}) {
  return (value / denominator) * MediaQuery.of(context).size.width;
}

double getHeight(
  BuildContext context,
  double value, {
  double denominator = 812,
}) {
  return (value / denominator) * MediaQuery.of(context).size.height;
}
