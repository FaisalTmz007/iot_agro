import 'package:flutter/material.dart';
import '../components/custom_app_bar.dart';
import '../components/custom_bottom_navbar.dart';

class HomeScreen extends StatefulWidget {
  final int tempMessage;
  final int humidMessage;

  // Constructor untuk menerima data dari main.dart
  HomeScreen({required this.tempMessage, required this.humidMessage});
  // print(tempMessage);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String isOn = "";
  @override
  void initState(){
    super.initState();
    if (widget.tempMessage == 1){
      isOn = "ON";
    }else{
      isOn = "OFF";
    }
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(pageName: "Mobile App"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // ========== DATA RELAY ============
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                          'Relay',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w700
                          ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${isOn}', // Data suhu ditampilkan di sini
                        style: const TextStyle(
                          fontSize: 50,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // ========== Kelembapan ============
            // Container(
            //   padding: const EdgeInsets.all(16.0),
            //   decoration: BoxDecoration(
            //     color: Colors.white,
            //     borderRadius: BorderRadius.circular(12),
            //     boxShadow: [
            //       BoxShadow(
            //         color: Colors.grey.withOpacity(0.3),
            //         spreadRadius: 2,
            //         blurRadius: 6,
            //         offset: const Offset(0, 3),
            //       ),
            //     ],
            //   ),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //     children: [
            //       Column(
            //         crossAxisAlignment: CrossAxisAlignment.center,
            //         children: [
            //           const Text(
            //             'Kelembapan',
            //             style: TextStyle(
            //               fontSize: 30,
            //               fontWeight: FontWeight.w700,
            //             ),
            //           ),
            //           const SizedBox(height: 8),
            //           Text(
            //             '${widget.humidMessage} %', // Data kelembapan ditampilkan di sini
            //             style: const TextStyle(
            //               fontSize: 50,
            //             ),
            //           ),
            //         ],
            //       ),
            //       const SizedBox(width: 16),
            //       const Icon(
            //         Icons.water_drop,
            //         size: 100,
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 0),
    );
  }
}
