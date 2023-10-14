import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:youblink/screens/scanner_screen.dart';
import 'package:youblink/widgets/custom_dialog_alert.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const CustomAlertDialog();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.purple.shade400,
                Colors.purple.shade200,
              ],
            ),
          ),
        ),
        title: const Text("YOUBLINK", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.purple[300],
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
              onPressed: () {
                _showDialog(context);
              },
              icon: const Icon(Icons.info_rounded, color: Colors.white70))
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 120),
              Animate(
                onPlay: (controller) => controller.repeat(),
                effects: [
                  ShimmerEffect(
                    color: Colors.white70,
                    duration: 1200.ms,
                  )
                ],
                child: Container(
                  height: 180,
                  width: 180,
                  child: const Image(
                    image: AssetImage("assets/logo.png"),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const Text("Blink if you can!",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w300,
                      color: Colors.black54)),
              const Text("Eye blink detector demo",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w200,
                      color: Colors.black54)),
              Container(
                height: 100,
                // width: 300,
                // color: Colors.red,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Press ",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w200,
                            color: Colors.black54)),
                    Icon(Icons.camera, color: Colors.purple[700]),
                    const Flexible(
                      child: Text(" at bottom to get started",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w200,
                              color: Colors.black54)),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => const ScannerScreen());
        },
        child: const Icon(Icons.camera),
      ),
    );
  }
}
