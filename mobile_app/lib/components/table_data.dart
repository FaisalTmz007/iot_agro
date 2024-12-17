import 'package:flutter/material.dart';

class TableData extends StatelessWidget {
  final String tableName;
  final String tema;
  final List tableList;

  const TableData({
    required this.tableName,
    required this.tema,
    required this.tableList,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "$tableName",
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 10),
        Table(
          border: TableBorder.all(color: Colors.blue),
          columnWidths: const {
            0: FixedColumnWidth(40),
            1: FlexColumnWidth(),
            2: FlexColumnWidth(),
          },
          children: [
            TableRow(
              decoration: const BoxDecoration(
                color: Colors.blueAccent
              ),
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'No',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "$tema",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Waktu',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ]
            ),
            ...tableList.map(
                    (data) => TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(data['id'].toString()),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("${data['content']}\u00B0C"),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(data['time']),
                        ),
                      ]
                    ))
          ],
        )
      ],
    );
  }
}
