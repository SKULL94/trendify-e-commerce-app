import 'package:Trendify/utils/custom_text.dart';
import 'package:Trendify/utils/images.dart';
import 'package:Trendify/utils/media_query.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart' as rive;

Widget priceRow(
  String title,
  String value, {
  Color? color,
  bool isBold = false,
  double fontSize = 14,
}) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 4),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(
          text: title,
          fontSize: fontSize,
          fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
        ),
        CustomText(
          text: value,
          fontSize: fontSize,
          fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
          // color: color,
        ),
      ],
    ),
  );
}

Widget emptyCart(context) {
  return Column(
    children: [
      SizedBox(
        height: getHeight(context, 500),
        child: rive.RiveAnimation.asset(
          Images.basket,
          stateMachines: ['Adding to basket - State Machine 1'],
          onInit: (rive.Artboard artboard) {
            var controller = rive.StateMachineController.fromArtboard(
              artboard,
              'State Machine 1',
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
          text: 'Hmm.. your cart looks empty :(',
          fontSize: 18,
          color: Colors.blueGrey,
          fontWeight: FontWeight.w700,
        ),
      ),
    ],
  );
}

void showCartDialogOptions(
  BuildContext context,
  String imageUrl,
  Function(String) callback,
) {
  showModalBottomSheet(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
    ),
    backgroundColor: Colors.white,
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return SizedBox(
        height: getHeight(context, 420),
        width: getWidth(context, 300),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: getHeight(context, 50)),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                  ),
                  width: getWidth(context, 80),
                  height: getHeight(context, 80),
                  child: Padding(
                    padding: EdgeInsets.all(getWidth(context, 8)),
                    child: Image(image: NetworkImage(imageUrl)),
                  ),
                ),
                SizedBox(height: getHeight(context, 10)),
                CustomText(
                  text: "Are you sure?",
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                Padding(
                  padding: EdgeInsets.all(getWidth(context, 8)),
                  child: CustomText(
                    text:
                        "This item made it all the way to your cart! Having second thoughts?",
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: getHeight(context, 10)),
                Container(
                  color: Colors.black,
                  width: getWidth(context, 300),
                  height: getHeight(context, 40),
                  child: TextButton(
                    onPressed: () {
                      callback("wishlist");
                      Navigator.pop(context);
                    },
                    child: CustomText(
                      text: "Move to Wishlist",
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(height: getHeight(context, 10)),
                TextButton(
                  onPressed: () {
                    callback("delete");
                    Navigator.pop(context);
                  },
                  child: CustomText(
                    text: "Remove",
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Positioned(
              top: 14,
              left: 14,
              child: IconButton(
                icon: Icon(Icons.cancel),
                color: Colors.grey.shade400,
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      );
    },
  );
}
