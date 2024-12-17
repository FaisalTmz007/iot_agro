import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class GrafikData extends StatefulWidget {
  final List<FlSpot> spotsData;
  final String grafikName;

  const GrafikData({
    required this.spotsData,
    required this.grafikName,
    // required this.dateData,
    super.key
  });

  @override
  State<GrafikData> createState() => _GrafikDataState();
}

class _GrafikDataState extends State<GrafikData> {
  DateTime selectedDate = DateTime.now();
  Future<void> _selectedDate(BuildContext context) async{
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2022),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    int lebar = widget.spotsData.length.toInt();
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.grafikName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            TextButton(
                onPressed: () => _selectedDate(context),
                child: Text(
                  "Tanggal: ${selectedDate.toLocal().toString().split(' ')[0]}",
                  style: const TextStyle(color: Colors.blue),
                )
            ),
          ],
        ),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              width: 1000,
              height: (lebar*10).toDouble(),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
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
              child: LineChart(
                LineChartData(
                  // clipData: FlClipData.none(),
                  gridData: const FlGridData(show: true),
                  titlesData: FlTitlesData(
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: false,
                      )
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: false,
                      )
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          int hour = value.toInt();
                          int minute = ((value-hour) * 60).toInt();
                          return Text('$hour: ${minute.toString().padLeft(2, '0')}');
                        },
                        interval: 1,
                      )
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          int temp = value.toInt();
                          if (temp%5 != 0){
                            return const SizedBox.shrink();
                          }
                          return Text('$temp');
                        },
                        interval: 1,
                      )
                    )
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      isCurved: true,
                      color: Colors.blue,
                      barWidth: 4,
                      spots: widget.spotsData,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
