import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riders_assign/home_screen.dart';

class AddDocumentsScreen extends StatefulWidget {
  final Map<String, dynamic> info;
  const AddDocumentsScreen({Key? key, required this.info}) : super(key: key);

  @override
  State<AddDocumentsScreen> createState() => _AddDocumentsScreenState();
}

class _AddDocumentsScreenState extends State<AddDocumentsScreen> {

  final ridersBox = Hive.box('riders');
  final documentsMap = <String, dynamic>{};

  @override
  Widget build(BuildContext context) {

    debugPrint(widget.info.toString());

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Upload Documnets',
                  style: TextStyle(
                    fontSize: 24
                  ),
                ),
                const SizedBox(
                  height: 14,
                ),
                DocumentWidget(title: 'AadhaarCard', docMap: documentsMap,),
                DocumentWidget(title: 'PANCard', docMap: documentsMap),
                DocumentWidget(title: 'DL', docMap: documentsMap),
                DocumentWidget(title: 'BlankCheque',  docMap: documentsMap),
                DocumentWidget(title: 'Photo',  docMap: documentsMap),
                const SizedBox(height: 16,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CupertinoButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Back'),
                      color: Colors.blue,
                    ),
                    CupertinoButton(
                      onPressed: () async {
                        _createRider(widget.info);
                      },
                      child: const Text('Save'),
                      color: Colors.blue
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _createRider(Map<String, dynamic> newRider) async {
    if(documentsMap['AadhaarCard'] == null ||
        documentsMap['PANCard'] == null ||
        documentsMap['DL'] == null ||
        documentsMap['BlankCheque'] == null ||
        documentsMap['Photo'] == null ){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: const Text('Please upload all the documents')));
      return;
    }

    newRider['documents'] = documentsMap;
    await ridersBox.add(newRider);
    debugPrint('Uploaded ====== amount of data is ${ridersBox.length}');
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const HomeScreen()), (route) => false);
  }
}

class DocumentWidget extends StatefulWidget {
  final String title;
  final Map<String, dynamic> docMap;

  const DocumentWidget({Key? key, required this.title, required this.docMap}) : super(key: key);

  @override
  State<DocumentWidget> createState() => _DocumentWidgetState();
}

class _DocumentWidgetState extends State<DocumentWidget> {
  bool value = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration:
          BoxDecoration(border: Border.all(color: Colors.black54, width: 1)),
      child: Row(
        children: [
          Checkbox(
            value: value,
            onChanged: null
          ),
          const SizedBox(
            width: 4,
          ),
          Expanded(
            child: Text(widget.title),
          ),
          Row(
            children: [
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.blue)
                ),
                onPressed: () {
                  pickImage();
                },
                child: const Text('Add')
              ),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.blue)
                ),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (_) {
                        return Center(
                          child: Wrap(
                            children: [
                              Image.memory(widget.docMap[widget.title] as Uint8List,)
                            ],
                          ),
                        );
                      }
                  );
                },
                child: const Text('View')
              )
            ],
          )
        ],
      ),
    );
  }

  Future<void> pickImage() async{
    ImagePicker imagePicker = ImagePicker();
    XFile? image = await imagePicker.pickImage(source: ImageSource.camera);
    if(image == null) return;

    Uint8List imageBytes = await image.readAsBytes();
    widget.docMap[widget.title] = imageBytes;
    setState(() {
      value = true;
    });
  }
}
