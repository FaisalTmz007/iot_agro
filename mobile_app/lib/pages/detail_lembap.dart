import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../components/data_terkini.dart';
import '../components/grafik_data.dart';
import '../components/table_data.dart';
import '../components/custom_app_bar.dart';
import '../components/custom_bottom_navbar.dart';

class RiwayatSuhuPage extends StatefulWidget {
  const RiwayatSuhuPage({Key? key}) : super(key: key);

  @override
  State<RiwayatSuhuPage> createState() => _RiwayatSuhuPageState();
}

class _RiwayatSuhuPageState extends State<RiwayatSuhuPage> {
  String currentData = "83.2";
  String dataName = "Kelembapan Terkini";

  List<Map<String, dynamic>> temperatureData = List.generate(
    40,
        (index) => {
      'time': '${10 + index ~/ 10}:${(index % 10) * 6}'.padLeft(2, '0'),
      'content': index.toDouble(),
    },
  ); // Dummy Data Riwayat Suhu

  List<Map<String, dynamic>> temperatureDetails = [
    {'id': 1, 'content': 27.5, 'time': '10:00'},
    {'id': 2, 'content': 28.0, 'time': '11:00'},
    {'id': 3, 'content': 28.3, 'time': '12:00'},
    {'id': 4, 'content': 28.5, 'time': '13:00'},
  ];

  // Fungsi konversi data ke FlSpot
  List<FlSpot> getTemperatureSpots(List<Map<String, dynamic>> data) {
    return data.asMap().entries.map((entry) {
      String time = entry.value['time'];
      double temperature = entry.value['content'];
      List<String> timeParts = time.split(':');
      double xValue =
          double.parse(timeParts[0]) + (double.parse(timeParts[1]) / 60);

      return FlSpot(xValue, temperature);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    List<FlSpot> spots = getTemperatureSpots(temperatureData);
    // print(spots.length);

    return Scaffold(
      appBar: const CustomAppBar(pageName: "Kelembapan"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ========== SUHU TERKINI ==========
              DataTerkini(currentData: currentData, dataName: dataName),
              const SizedBox(height: 20),

              // ========== GRAFIK RIWAYAT SUHU ==========
              GrafikData(spotsData: spots, grafikName: "Data Riwayat Suhu"),
              const SizedBox(height: 20),

              // ========== TABEL RIWAYAT SUHU ==========
              TableData(tableName: "Tabel Riwayat Suhu", tema: "Suhu", tableList: temperatureDetails),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 2),
    );
  }
}
