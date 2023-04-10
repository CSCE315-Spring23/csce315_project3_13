import 'package:csce315_project3_13/Services/menu_item_helper.dart';

import '../../../Models/models_library.dart';
import 'package:flutter/material.dart';

class Win_View_Menu extends StatefulWidget {
  static const String route = '/view-menu-manager';
  const Win_View_Menu({Key? key}) : super(key: key);

  @override
  State<Win_View_Menu> createState() => _Win_View_Menu_State();
}


class _Win_View_Menu_State extends State<Win_View_Menu> {
  final List<Map<String, String>> _menu_info = [];
  int visibility_ctrl = 0;
  String title = 'Manage Smoothies';
  bool _isLoading = true;
  List<menu_item_obj> _menu_items = [];
  menu_item_helper item_helper = menu_item_helper();
/*
  Future<List<menu_item_obj>> getData() async {
    return item_helper.getAllSmoothiesInfo();
  }
*/
  Future<String> getData() async {
    // Simulate fetching data from an API
    _menu_items = await item_helper.getAllSmoothiesInfo();

    for (menu_item_obj smoothie in _menu_items)
      {
        final new_row = {
          'id' : smoothie.menu_item_id.toString(),
          'name' : smoothie.menu_item,
          'price' : smoothie.item_price.toStringAsFixed(2),
        };
        _menu_info.add(new_row);
      }

    print('test');
    return 'Finished with data';
  }

  void confirmRemoval(String item_name)
  {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Item Deletion'),
          content: Text(
              'Are you sure you want to delete $item_name'
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                setState(() {
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children:  <Widget>[
            IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              onPressed: () {
                if (title == 'Manage Smoothies')
                  {
                    title = 'Manage Addons';
                    setState(() {
                      visibility_ctrl = 2;
                    });
                  }
                else if (title == 'Manage Addons')
                {
                  title = 'Manage Snacks';
                  setState(() {
                    visibility_ctrl = 1;
                  });
                }
                else if (title == 'Manage Snacks')
                {
                  title = 'Manage Smoothies';
                  setState(() {
                    visibility_ctrl = 0;
                  });
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(title),
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios_rounded),
              onPressed: () {
                if (title == 'Manage Smoothies')
                {
                  title = 'Manage Snacks';
                  setState(() {
                    visibility_ctrl = 1;
                  });
                }
                else if (title == 'Manage Snacks')
                {
                  title = 'Manage Addons';
                  setState(() {
                    visibility_ctrl = 2;
                  });
                }
                else if (title == 'Manage Addons')
                {
                  title = 'Manage Smoothies';
                  setState(() {
                    visibility_ctrl = 0;
                  });
                }
              },
            ),
          ],),
        centerTitle: true,
      ),
      body: Offstage(
        offstage: visibility_ctrl != 0,
        child: FutureBuilder<void>(
          future: getData(),
          builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.only(bottom: 125),
                child: Stack(
                  children: <Widget>[
                    ListView.builder(
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return DataTable(
                          //columnSpacing: 20,
                          //headingRowHeight: 50, // Set the height of the header row
                          columns: const <DataColumn>[
                            DataColumn(label: Text('Id'),),
                            DataColumn(label: Text('Name'),),
                            DataColumn(label: Text('Price')),
                            DataColumn(label: Text('Edit')),
                          //  DataColumn(label: Text('Delete')),
                          ],
                          rows: _menu_info.map((rowData) {
                            final rowIndex = _menu_info.indexOf(rowData);
                            return DataRow(cells: [
                              DataCell(Text('${rowData['id']}')),
                              DataCell(Text('${rowData['name']}')),
                              DataCell(Text('${rowData['price']}')),
                              DataCell(
                                  IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: () {
                                      }
                                  )
                              ),
                        /*      DataCell(
                                  IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () {
                                        // _menu_info.removeAt(rowIndex);
                                        confirmRemoval(rowData['name']!);
                                        // removeSmoothie();
                                      }
                                  )
                              ),*/
                            ]);
                          }).toList(),
                        );
                      },
                      itemCount: _menu_info.length + 1, // Set the number of items in the ListView to 1
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
      bottomSheet: Container(height: 125, color: Colors.red,),
    );
  }
}

