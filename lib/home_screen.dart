import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:riders_assign/detail_screen.dart';

import 'add_new_rider_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final _ridersBox = Hive.box('riders');

  List<Map<String, dynamic>> _items = [];

  bool result = false;

  @override
  void initState() {
    super.initState();
    getRidersList();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(14.0),
              child: Text(
                'Riders',
                style: TextStyle(
                  fontSize: 24
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemBuilder: (BuildContext context, int ind){
                  final item = _items[ind];
                  return Dismissible(
                    key: Key(item['key'].toString()),
                    confirmDismiss: (direction) async {
                      if (direction == DismissDirection.endToStart) {
                        await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: const Text(
                                  "Are you sure you want to reject ?"
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: (){
                                      setState(() {
                                        result = false;
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: const Text('No')
                                  ),
                                  TextButton(
                                      onPressed: (){
                                        setState(() {
                                          result = true;
                                        });
                                        Navigator.pop(context);
                                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Rider is rejected and removed')));
                                      },
                                      child: const Text('Yes')
                                  ),
                                ],
                                title: const Text('Warning'),
                              );
                            });
                        return result;
                      }else if (direction == DismissDirection.startToEnd) {
                        await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: const Text(
                                    "Are you sure you want to accept ?"
                                ),
                                actions: [
                                  TextButton(
                                      onPressed: (){
                                        setState(() {
                                          result = false;
                                        });
                                        Navigator.pop(context);
                                      },
                                      child: const Text('No')
                                  ),
                                  TextButton(
                                      onPressed: (){
                                        setState(() {
                                          result = true;
                                        });
                                        Navigator.pop(context);
                                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Rider is accepted and removed')));
                                      },
                                      child: const Text('Yes')
                                  ),
                                ],
                                title: const Text('Warning'),
                              );
                            });
                        return result;
                      }
                    },
                    onDismissed: (direction) async{
                      await _ridersBox.delete(item['key']);
                      getRidersList();
                    },
                    background: Container(color: Colors.green),
                    secondaryBackground: Container(color: Colors.red),
                    child: Container(
                      padding: const EdgeInsets.all(18),
                      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 1)
                      ),
                      child: InkWell(
                        onTap: () {
                          debugPrint(item['key'].toString());
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => RiderDetailsScreen(id: item['key'])));
                        },
                        child: Row(
                          children: [
                            Text(
                              item['name'],
                              style: const TextStyle(
                                  fontSize: 16
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                itemCount: _items.length,
              ),
            )
          ],
        ),
        floatingActionButton: CupertinoButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AddNewRiderScreen()));
            },
            child: const Text('Add'),
            color: Colors.blue
        )
      ),
    );
  }

  void getRidersList(){
    final data = _ridersBox.keys.map((key) {
      final item = _ridersBox.get(key);
      return {
        'key': key,
        'name': item['name'],
      };
    }).toList();
    setState(() {
      _items = data.reversed.toList();
    });
  }
}
