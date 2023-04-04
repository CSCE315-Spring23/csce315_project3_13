import 'package:flutter/material.dart';

class Win_View_Menu extends StatefulWidget {
  static const String route = '/view-menu-manager';
  const Win_View_Menu({Key? key}) : super(key: key);

  @override
  State<Win_View_Menu> createState() => _Win_View_Menu_State();
}

class _Win_View_Menu_State extends State<Win_View_Menu> {
  final List<Map<String, String>> _menu_info = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Manage Menu"),
        centerTitle: true,
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          DataTable(
            columnSpacing: 0,
            columns: const <DataColumn>[
              DataColumn(label: Text('Id'),),
              DataColumn(label: Text('Name'),),
              DataColumn(label: Text('Price')),
              DataColumn(label: Text('Amount in Stock')),
              DataColumn(label: Text('Type')),
              DataColumn(label: Text('Delete')),
              DataColumn(label: Text('Edit')),
            ],
            rows: _menu_info.map((rowData) {
              final rowIndex = _menu_info.indexOf(rowData);
              return DataRow(cells: [
                DataCell(Text('${rowData['index']}')),
                DataCell(Text('${rowData['name']}')),
                DataCell(Text('${rowData['price']}')),
                DataCell(Text('${rowData['amount in stock']}')),
                DataCell(Text('${rowData['type']}')),
                DataCell(
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      _menu_info.removeAt(rowIndex);
                      }
                  )
                ),
                DataCell(
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                        _menu_info.removeAt(rowIndex);
                    },
                  ),
                ),
              ]);
            }).toList(),
          ),
        ],
      ),
      bottomSheet: Container(height: 200, color: Colors.red,),
    );
  }
}

