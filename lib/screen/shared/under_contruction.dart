import 'package:Trendify/utils/custom_text.dart';
import 'package:Trendify/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class UnderConstruction extends StatefulWidget {
  const UnderConstruction({super.key});

  @override
  State<UnderConstruction> createState() => _UnderConstructionState();
}

class _UnderConstructionState extends State<UnderConstruction> {
  late RiveAnimationController _controller;
  final String _currentAnimation = 'look_idle'; // Default animation

  @override
  void initState() {
    super.initState();
    _controller = SimpleAnimation(_currentAnimation);
  }

  void _changeAnimation(String animationName) {
    setState(() {
      _controller.isActive = false; // Stop the current animation
      _controller = SimpleAnimation(animationName, autoplay: true);
    });
    _controller.isActive = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Rive Animation Example")),
      body: Column(
        children: [
          Expanded(
            child: RiveAnimation.asset(
              // 'assets/animated_login_character.riv',
              //'assets/login_screen_character.riv',
              Images.riveLogin,
              controllers: [_controller],
              stateMachines: ['State Machine 1'], // Add the state machine name
              onInit: (Artboard artboard) {
                var controller = StateMachineController.fromArtboard(
                  artboard,
                  _currentAnimation, //need to give the animation name here.
                );
                if (controller != null) {
                  artboard.addController(controller);
                }
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => _changeAnimation('success'),
                  child: CustomText(text: "Success"),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => _changeAnimation('fail'),
                  child: CustomText(text: "Fail"),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => _changeAnimation('hands_up'),
                  child: CustomText(text: "Wave"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class UnderContruction extends StatefulWidget {
  const UnderContruction({super.key});

  @override
  State<UnderContruction> createState() => _UnderContructionState();
}

class _UnderContructionState extends State<UnderContruction> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: RiveAnimation.asset(
              //'assets/login_no_bg.riv',
              //'assets/earth_loading.riv',
              Images.rive404,
              //'assets/cat_loading.riv',
              stateMachines: [
                // 'Loading Final - State Machine 1', //the name of the animation displayed at the top.
                //'Cat playing animation - State Machine 1',
                'SM_ComingSoon',
              ], // Add the state machine name
              // stateMachines: ['State Machine 1'],
              onInit: (Artboard artboard) {
                var controller = StateMachineController.fromArtboard(
                  artboard,
                  'SM_ComingSoon', // Make sure this matches exactly as seen in Rive
                  // 'State Machine 1',
                  //'look_idle',
                  //'Cat playing animation', // the name of the animation displayed at the left bottom.
                );
                if (controller != null) {
                  artboard.addController(controller);
                  controller.isActive = true;
                }
              },
            ),
          ),
          Expanded(
            // This ensures the text gets space
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: CustomText(
                text:
                    "Hi, the page you are looking for might be under construction!",
                color: Colors.black,
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
