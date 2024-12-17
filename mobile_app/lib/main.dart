import 'package:flutter/material.dart';
import 'package:monitoring_app/pages/register.dart';
import 'mqtt/mqtt_service.dart';
import 'services/api_service.dart';
import 'pages/home.dart';
import 'pages/login.dart';
import 'components/loading_screen.dart';
import 'pages/detail_suhu.dart';
import 'pages/detail_lembap.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final MqttService mqttService = MqttService(
    'broker.hivemq.com',
    ['temp/mufrih', 'humid/mufrih']
    // ApiService(),
  );

  double tempMessage = 0;
  double humidMessage = 0;

  void _onMessageReceived(String topic, double message) {
    setState(() {
      if (topic == 'temp/mufrih') {
        tempMessage = message;
        print(message);
        print(message.runtimeType);
      } else if (topic == 'humid/mufrih') {
        humidMessage = message;
        print(message);
        print(message.runtimeType);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    mqttService.onMessageReceived = _onMessageReceived;
    mqttService.connect();
  }

  @override
  void dispose() {
    mqttService.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => LoadingScreen(),
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/home': (context) => HomeScreen(tempMessage: tempMessage, humidMessage: humidMessage),
        '/suhu': (context) => TemperatureScreen(currentTemp: tempMessage,),
        '/kelembapan': (context) => RiwayatSuhuPage()
      },
    );
  }
}
