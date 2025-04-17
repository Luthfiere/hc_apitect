import 'package:flutter/material.dart';

class LeaveFormApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Annual Leave Form',
      theme: ThemeData(primarySwatch: Colors.red),
      home: LeaveFormScreen(),
    );
  }
}

void submittedPopup(BuildContext context) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text("Form Submitted!"),
      content: const Text("Leave form anda sudah terkirim!."),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(),
          child: const Text("Tutup"),
        ),
      ],
    ),
  );
}

class LeaveFormScreen extends StatefulWidget {
  const LeaveFormScreen({Key? key}) : super(key: key);
  @override
  _LeaveFormScreenState createState() => _LeaveFormScreenState();
}

class _LeaveFormScreenState extends State<LeaveFormScreen> {
  List<Map<String, dynamic>> leaveTypes = [
    {'type': 'Current Year', 'year': 2025, 'checked': false},
    {'type': 'Last Year', 'year': 2024, 'checked': false},
    {'type': 'Last Year', 'year': 2023, 'checked': false},
    {'type': 'Day Off', 'year': 2024, 'checked': false},
    {'type': 'Day Off', 'year': 2023, 'checked': false},
  ];

  DateTime? fromDate;
  DateTime? toDate;

  final TextEditingController reasonController = TextEditingController();
  final TextEditingController projectController = TextEditingController();

  Future<void> _selectDate(BuildContext context, bool isFrom) async {
    DateTime initialDate = fromDate ?? DateTime.now();
    DateTime firstDate = isFrom ? DateTime.now() : fromDate ?? DateTime.now();
    DateTime lastDate = DateTime(2100);

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isFrom ? initialDate : toDate ?? initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (picked != null) {
      setState(() {
        if (isFrom) {
          fromDate = picked;
          toDate = null; // Reset "To" date if "From" is updated
        } else {
          toDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(204, 0, 0, 1.0),
        title: Text('Annual Leave Form', style: TextStyle(color: Colors.white)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 18.0),
            child: Image.asset(
              'assets/logoptap.png',
              width: 50,
            ),
          ),
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Type of Leave',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ...leaveTypes.map((leave) => CheckboxListTile(
                  title: Text('${leave['type']} (${leave['year']})'),
                  value: leave['checked'],
                  onChanged: (bool? value) {
                    setState(() {
                      leave['checked'] = value ?? false;
                    });
                  },
                )),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('From',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      ElevatedButton(
                        onPressed: () => _selectDate(context, true),
                        child: Text(fromDate == null
                            ? 'Choose the date'
                            : '${fromDate!.toLocal()}'.split(' ')[0]),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('To', style: TextStyle(fontWeight: FontWeight.bold)),
                      ElevatedButton(
                        onPressed: fromDate != null
                            ? () => _selectDate(context, false)
                            : null,
                        child: Text(toDate == null
                            ? 'Choose the date'
                            : '${toDate!.toLocal()}'.split(' ')[0]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text('Reason', style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(
              controller: reasonController,
              maxLines: 3,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Type your reason here',
              ),
            ),
            SizedBox(height: 16),
            Text('Project', style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(
              controller: projectController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Add project here',
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    backgroundColor: Colors.red),
                onPressed: () {
                  submittedPopup(context);
                },
                child: Text('Submit',
                    style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
