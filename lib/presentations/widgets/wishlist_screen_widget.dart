import 'package:Trendify/core/constants/images.dart';
import 'package:Trendify/core/utils/media_query.dart';
import 'package:Trendify/presentations/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart' as rive;

Widget emptyWishlist(context) {
  return Column(
    children: [
      SizedBox(
        height: getHeight(context, 500),
        child: rive.RiveAnimation.asset(
          Images.kitty,
          stateMachines: ['kitty'],
          onInit: (rive.Artboard artboard) {
            var controller = rive.StateMachineController.fromArtboard(
              artboard,
              'kitty',
            );
            if (controller != null) {
              artboard.addController(controller);
              controller.isActive = true;
            }
          },
        ),
      ),
      Expanded(
        flex: 3,
        child: CustomText(
          text: 'Pspsps... your wishlist is empty',
          fontSize: 18,
          color: Colors.blueGrey,
          fontWeight: FontWeight.w700,
        ),
      ),
    ],
  );
}
