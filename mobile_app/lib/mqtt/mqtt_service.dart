import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'dart:convert';
import 'message_data.dart';
import '../services/api_service.dart';

class MqttService {
  final String broker;
  final List<String> topics;
  // final ApiService apiService;
  MqttServerClient? client;

  Function(String, double)? onMessageReceived;

  MqttService(this.broker, this.topics);

  Future<void> connect() async {
    client = MqttServerClient(broker, '');
    client!.logging(on: true);
    client!.setProtocolV311();
    client!.keepAlivePeriod = 20;
    client!.onDisconnected = _onDisconnected;
    client!.onConnected = _onConnected;
    client!.onSubscribed = _onSubscribed;

    final connMessage = MqttConnectMessage()
        .withClientIdentifier('flutter_client')
        .withWillQos(MqttQos.atMostOnce);
    client!.connectionMessage = connMessage;

    try {
      await client!.connect();
      _subscribeToTopics();
    } catch (e) {
      print('ERROR: $e');
      disconnect();
    }
  }

  void _subscribeToTopics() {
    if (client!.connectionStatus!.state == MqttConnectionState.connected) {
      print('Connected to MQTT broker!');
      for (String topic in topics) {
        client!.subscribe(topic, MqttQos.atLeastOnce);
      }
      client!.updates!.listen(_onMessage);
    } else {
      print('Failed to connect, status is ${client!.connectionStatus}');
    }
  }

  void _onMessage(List<MqttReceivedMessage<MqttMessage>> messages) {
    final MqttPublishMessage recMess = messages[0].payload as MqttPublishMessage;
    final String message = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
    String topic = messages[0].topic;
    String currentTime = DateTime.now().toIso8601String();
    double doubleValue = double.parse(message);

    print(message);
    print(messages);

    if (onMessageReceived != null) {
      onMessageReceived!(topic, doubleValue);

      // konversi data ke double
      // double? numericValue = double.tryParse(message);
    } else {
      print("No message received");
    }
  }

  void disconnect() {
    client?.disconnect();
  }

  Map<String, dynamic>? _parseJson(String jsonData) {
    try {
      return jsonDecode(jsonData);
    } catch (e) {
      print('Error parsing message: $e');
      return null;
    }
  }

  void _onConnected() => print('Connected to broker');
  void _onDisconnected() => print('Disconnected from broker');
  void _onSubscribed(String topic) => print('Subscribed to topic: $topic');
}
