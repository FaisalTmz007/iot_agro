import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  // final Function(int) onTap;

  const CustomBottomNavigationBar({
    required this.currentIndex,
    Key? key,
    // required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.thermostat),
          label: 'Suhu',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.water_drop),
          label: 'Kelembapan',
        ),
      ],
      currentIndex: currentIndex,
      onTap: (index) {
        if(index == 0){
          Navigator.pushReplacementNamed(context, '/home');
        }else if(index == 1){
          Navigator.pushReplacementNamed(context, '/suhu');
        }else if(index == 2){
          Navigator.pushReplacementNamed(context, '/kelembapan');
        }
      },
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
    );
  }
}
