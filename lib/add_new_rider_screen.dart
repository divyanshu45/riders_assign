import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:riders_assign/add_doucuments_screen.dart';

class AddNewRiderScreen extends StatefulWidget {
  const AddNewRiderScreen({Key? key}) : super(key: key);

  @override
  State<AddNewRiderScreen> createState() => _AddNewRiderScreenState();
}

class _AddNewRiderScreenState extends State<AddNewRiderScreen> {

  final formKey = GlobalKey<FormState>();

  final mp = <String, dynamic>{};

  String dropdownvalue = 'Locality 1';
  var items = [
    'Locality 1',
    'Locality 2',
    'Locality 3',
    'Locality 4'
  ];

  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _currAddressController;
  late TextEditingController _currPinController;
  late TextEditingController _bankAccController;
  late TextEditingController _ifscController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
    _currAddressController = TextEditingController();
    _currPinController = TextEditingController();
    _bankAccController = TextEditingController();
    _ifscController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Add New Rider',
                    style: const TextStyle(
                        fontSize: 24
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text('Name'),
                  TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        hintText: 'Robert',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)
                        )
                      ),
                      validator: (val) => val!.isEmpty ? 'Enter Name' : null,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text('Phone Number'),
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                        hintText: '9999999999',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)
                        )
                    ),
                    validator: (val) =>
                    val!.isEmpty || val.length != 10
                        ? 'Enter 10 digit Phone Number'
                        : null,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text('Localities'),
                  DropdownButtonFormField(
                    value: dropdownvalue,
                    isExpanded: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)
                      )
                    ),
                    icon: const Icon(Icons.keyboard_arrow_down),
                    borderRadius: BorderRadius.circular(10),
                    items: items.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownvalue = newValue!;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text('Current Address'),
                  TextFormField(
                      controller: _currAddressController,
                      decoration: InputDecoration(
                          hintText: 'Address',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)
                          )
                      ),
                      validator: (val) => val!.isEmpty ? 'Enter Address' : null
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text('Current PinCode'),
                  TextFormField(
                    controller: _currPinController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        hintText: '999999',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)
                        )
                    ),
                    validator: (val) =>
                    val!.isEmpty || val.length != 6
                        ? 'Enter 6 digit PIN'
                        : null,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text('Bank Account Number'),
                  TextFormField(
                    controller: _bankAccController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        hintText: '99999999999',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)
                        )
                    ),
                    validator: (val) =>
                    val!.isEmpty || val.length != 11
                        ? 'Enter 11 digit Account Number'
                        : null,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text('IFSC Number'),
                  TextFormField(
                    controller: _ifscController,
                    decoration: InputDecoration(
                        hintText: '999999',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)
                        )
                    ),
                    validator: (val) => val!.isEmpty ? 'Enter IFSC Number' : null,
                  ),
                  const SizedBox(height: 14,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CupertinoButton(
                        onPressed: () {
                          final isValid = formKey.currentState!.validate();
                          if (!isValid) return;

                          _makeMap();
                          Navigator.of(context).push(MaterialPageRoute(builder: (
                              context) => AddDocumentsScreen(info: mp)));
                        },
                        child: const Text('Next'),
                        color: Colors.blue,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _makeMap(){
    mp['name'] = _nameController.text;
    mp['phone'] = _phoneController.text;
    mp['locality'] = dropdownvalue;
    mp['currentAddress'] = _currAddressController.text;
    mp['currentPin'] = _currPinController.text;
    mp['bankAccNumber'] = _bankAccController.text;
    mp['ifscNumber'] = _ifscController.text;
  }
}
