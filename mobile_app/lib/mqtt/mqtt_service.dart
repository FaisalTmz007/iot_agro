import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'dart:convert';

class MqttService {
  final String broker;
  final String topics;
  MqttServerClient? client;

  Function(String, int)? onMessageReceived;

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
      client!.subscribe(topics, MqttQos.atLeastOnce);
      client!.updates!.listen(_onMessage);
    } else {
      print('Failed to connect, status is ${client!.connectionStatus}');
    }
  }

  void _onMessage(List<MqttReceivedMessage<MqttMessage>> messages) {
    final MqttPublishMessage recMess = messages[0].payload as MqttPublishMessage;
    final String message = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
    int intValue = int.parse(message);

    if (onMessageReceived != null) {
      onMessageReceived!(topics, intValue);
    } else {
      print("No message received");
    }
  }

  void disconnect() {
    client?.disconnect();
  }

  void _onConnected() => print('Connected to broker');
  void _onDisconnected() => print('Disconnected from broker');
  void _onSubscribed(String topic) => print('Subscribed to topic: $topic');
}
