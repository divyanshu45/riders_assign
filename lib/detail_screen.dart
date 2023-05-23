import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class RiderDetailsScreen extends StatefulWidget {
  final int id;
  const RiderDetailsScreen({Key? key, required this.id}) : super(key: key);

  @override
  State<RiderDetailsScreen> createState() => _RiderDetailsScreenState();
}

class _RiderDetailsScreenState extends State<RiderDetailsScreen> {

  final _ridersBox = Hive.box('riders');

  late PageController pageController;

  Map item = {};
  List<Uint8List> images = [];
  List<String> docs = [
    'Aadhaar Card',
    'PAN Card',
    'Driving License',
    'Bank Cheque',
    'Photo'
  ];


  Future<dynamic> getDetails() async {
    item = await _ridersBox.get(widget.id);
    debugPrint(item.toString());
    images.addAll([
      item['documents']['AadhaarCard'],
      item['documents']['PANCard'],
      item['documents']['DL'],
      item['documents']['BlankCheque'],
      item['documents']['Photo'],
    ]);
    return item;
  }

  @override
  void initState() {
    super.initState();
    pageController = PageController(
      keepPage: true,
      initialPage: 0,
    );
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: FutureBuilder<dynamic>(
            future: getDetails(),
            builder: (context, snapshot) {
              if(snapshot.connectionState == ConnectionState.waiting){
                return Center(child: CircularProgressIndicator(),);
              }
              return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'View Rider',
                          style: TextStyle(
                              fontSize: 24
                          ),
                        ),
                        SizedBox(height: 16,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: (){
                                pageController.previousPage(duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
                              },
                              child: Container(
                                padding: EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: Colors.grey)
                                ),
                                child: Icon(Icons.arrow_back_ios_new_rounded)
                              ),
                            ),
                            Container(
                              height: 400,
                              width: 250,
                              child: PageView.builder(
                                controller: pageController,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, ind) {
                                  return Column(
                                    children: [
                                      Image.memory(
                                        images[ind],
                                        height: 350,
                                        width: 250,
                                      ),
                                      SizedBox(
                                        height: 6,
                                      ),
                                      Text(docs[ind])
                                    ],
                                  );
                                },
                                itemCount: 5,
                              ),
                            ),
                            InkWell(
                              onTap: (){
                                pageController.nextPage(duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
                              },
                              child: Container(
                                  padding: EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(color: Colors.grey)
                                  ),
                                  child: Icon(Icons.arrow_forward_ios_rounded)
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 14,
                        ),
                        Divider(height: 1, color: Colors.grey, thickness: 2,),
                        SizedBox(
                          height: 20,
                        ),
                        Text('Name - ${item['name']}', style: TextStyle(fontSize: 16),),
                        SizedBox(
                          height: 10,
                        ),
                        Text('Phone Number - ${item['phone']}', style: TextStyle(fontSize: 16),),
                        SizedBox(
                          height: 10,
                        ),
                        Text('Address - ${item['currentAddress']}', style: TextStyle(fontSize: 16),),
                        SizedBox(
                          height: 10,
                        ),
                        Text('Locality - ${item['locality']}', style: TextStyle(fontSize: 16),),
                        SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CupertinoButton(
                              onPressed: () async {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Rider is rejected')));
                              },
                              child: Text('Reject'),
                              color: Colors.blue,
                            ),
                            CupertinoButton(
                                onPressed: () async {
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Rider is accepted')));
                                },
                                child: Text('Accept'),
                                color: Colors.blue
                            )
                          ],
                        )
                      ],
                    ),
                  )
              );
            },
          )
      ),
    );
  }
}
