import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:monitoring_app/services/api_service.dart';
import '../components/custom_app_bar.dart';
import '../components/custom_bottom_navbar.dart';
import '../components/data_terkini.dart';
import '../components/grafik_data.dart';
import '../components/table_data.dart';

class TemperatureScreen extends StatefulWidget {
  final double currentTemp;

  const TemperatureScreen({
    required this.currentTemp,
    Key? key
  }) : super(key: key);

  @override
  State<TemperatureScreen> createState() => _TemperatureScreenState();
}

class _TemperatureScreenState extends State<TemperatureScreen> {
  ApiService apiService = ApiService();
  List<dynamic> tempData = [];
  bool isLoading = true;
  String stringTemp = "";

  @override
  void initState(){
    super.initState();
    stringTemp = "${widget.currentTemp}\u00B0C";

    fetchTempData(); //ambil data dari api
  }

  Future<void> fetchTempData() async {
    try{
      List<dynamic> data = await apiService.getTemp();
      print(data);
      setState(() {
        tempData = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching data: $e');
    }
  }

  // convert data temperatureDetails to FlSpots
  List<FlSpot> getTemperatureSpots(List< dynamic> data) {
    return data.asMap().entries.map((entry) {
      int index = entry.key;
      double temperature = entry.value['message']; // Ambil nilai suhu

      // Konversi waktu ke nilai x, jika dibutuhkan
      String time = entry.value['timeStamp']; // Contoh: '10:00'
      List<String> timeParts = time.split(':');
      double xValue = double.parse(timeParts[0]) + (double.parse(timeParts[1]) / 60); // 10:30 -> 10.5

      return FlSpot(xValue, temperature); // (x = waktu, y = suhu)
    }).toList();
  }

  // Fungsi untuk memilih tanggal
  // Future<void> _selectDate(BuildContext context) async {
  //   final DateTime? pickedDate = await showDatePicker(
  //     context: context,
  //     initialDate: selectedDate,
  //     firstDate: DateTime(2022),
  //     lastDate: DateTime.now(),
  //   );
  //   if (pickedDate != null && pickedDate != selectedDate) {
  //     setState(() {
  //       selectedDate = pickedDate;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    List<FlSpot> spots = getTemperatureSpots(tempData);
    print(spots);

    return Scaffold(
      appBar: const CustomAppBar(pageName: "Data Suhu"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ===================== Suhu Terkini ==================
              DataTerkini(currentData: stringTemp, dataName: "Suhu Terkini"),
              const SizedBox(height: 20),

              // ============== Grafik RIwayat Suhu ===============
              GrafikData(spotsData: spots, grafikName: "Riwayat Suhu"),
              const SizedBox(height: 20),

              // ========== Table Riwayat Suhu ========
              // TableData(tableName: "Data Riwayat Suhu", tema: "Suhu", tableList: temperatureDetails),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 1),
    );
  }
}
