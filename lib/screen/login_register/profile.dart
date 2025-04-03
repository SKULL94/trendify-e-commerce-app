import 'package:Trendify/screen/login_register/login.dart';
import 'package:Trendify/screen/shared/under_contruction.dart';
import 'package:Trendify/utilis/custom_text.dart';
import 'package:Trendify/utilis/media_query.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, this.email});

  final String? email;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late SharedPreferences prefs;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: getWidth(context, 20)),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Image(
                    image: const AssetImage('assets/trend.png'),
                    width: getWidth(context, 120),
                  ),
                ],
              ),
              SizedBox(height: getHeight(context, 10)),
              CustomText(
                text: widget.email!.split('@')[0],
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              CustomText(
                text: widget.email.toString(),
                fontSize: 14,
                color: Colors.grey,
              ),
              SizedBox(height: getHeight(context, 5)),
              Card(
                color: Colors.white,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(getWidth(context, 10)),
                ),
                child: Padding(
                  padding: EdgeInsets.all(getWidth(context, 12)),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const CustomText(
                            text: "Account Settings",
                            fontWeight: FontWeight.bold,
                          ),
                          Icon(Icons.settings, color: Colors.blue),
                        ],
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.location_on),
                        title: const CustomText(text: "Manage Addresses"),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const UnderContruction(),
                            ),
                          );
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.light_mode),
                        title: const CustomText(text: "Switch Themes"),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const UnderContruction(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: getHeight(context, 10)),
              Card(
                color: Colors.white,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(getWidth(context, 10)),
                ),
                child: Padding(
                  padding: EdgeInsets.all(getWidth(context, 12)),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const CustomText(
                            text: "Order Details",
                            fontWeight: FontWeight.bold,
                          ),
                          const Icon(Icons.history, color: Colors.blue),
                        ],
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.delivery_dining_rounded),
                        title: const CustomText(text: "Delivered"),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {},
                      ),
                      ListTile(
                        leading: const Icon(Icons.history),
                        title: const CustomText(text: "Processing"),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: getHeight(context, 15)),
              CustomText(
                text: 'CONTACT US',
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
              SizedBox(height: getHeight(context, 5)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(onPressed: () {}, icon: const Icon(Icons.phone)),
                  IconButton(
                    onPressed: () {},
                    icon: Image.asset(
                      'assets/mailWhite.png',
                      width: getWidth(context, 30),
                      height: getHeight(context, 30),
                      color: Colors.black,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Image.asset(
                      'assets/instaWhite.png',
                      width: getWidth(context, 30),
                      height: getHeight(context, 30),
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              SizedBox(height: getHeight(context, 10)),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
                child: SizedBox(
                  height: getHeight(context, 40),
                  child: Card(
                    elevation: 2,
                    color: Colors.redAccent,
                    child: const Center(
                      child: CustomText(text: "Log Out", color: Colors.white),
                    ),
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
