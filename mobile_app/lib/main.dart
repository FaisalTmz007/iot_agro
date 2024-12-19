import 'package:flutter/material.dart';
import 'pages/register.dart';
import 'mqtt/mqtt_service.dart';
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
    'iotAgro/relay'
    // ApiService(),
  );

  int tempMessage = 0;
  int humidMessage = 0;

  void _onMessageReceived(String topic, int message) {
    setState(() {
      tempMessage = message;
      print(message);
      print(message.runtimeType);
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
        '/': (context) => HomeScreen(tempMessage: tempMessage, humidMessage: humidMessage),
        // '/login': (context) => LoginScreen(),
        // '/register': (context) => RegisterScreen(),
        // '/suhu': (context) => TemperatureScreen(currentTemp: tempMessage,),
        // '/kelembapan': (context) => RiwayatSuhuPage()
      },
    );
  }
}
