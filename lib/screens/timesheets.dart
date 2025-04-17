import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Time Sheets',
      theme: ThemeData(primarySwatch: Colors.red),
      home: const TimeSheetPage(),
    );
  }
}

void showComingSoonPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Coming Soon"),
        content: const Text("Fitur ini sedang dalam pengembangan."),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text("Tutup"),
          ),
        ],
      ),
    );
  }

class TimeSheetPage extends StatelessWidget {
  const TimeSheetPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Dummy data for the table
    final List<Map<String, String>> timeSheetData = List.generate(50, (index) {
      final week = 50 - index;
      return {
        'Period': 'Week $week, 2024',
        'DateFrom': (week % 2 == 0) ? '2 Dec 2024' : '25 Nov 2024',
        'DateTo': '8 Dec 2024',
        'Status': 'To Submit',
        'TotalTime': '40.00',
      };
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Time Sheet', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromRGBO(204, 0, 0, 1.0),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                showCheckboxColumn: false, // Hilangkan checkbox di sebelah kiri
                headingRowColor: MaterialStateProperty.resolveWith(
                  (states) => const Color.fromARGB(255, 255, 128, 128),
                ),
                columns: const [
                  DataColumn(
                      label: Text('Period',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('Date from',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('Date to',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('Status',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('Total time',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                ],
                rows: timeSheetData.map((data) {
                  return DataRow(
                    cells: [
                      DataCell(Text(data['Period']!)),
                      DataCell(Text(data['DateFrom']!)),
                      DataCell(Text(data['DateTo']!)),
                      DataCell(Text(data['Status']!)),
                      DataCell(Text(data['TotalTime']!)),
                    ],
                    onSelectChanged: (selected) {
                      if (selected == true) {
                        // Navigasi ke halaman detail
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TimeSheetPageDetail(),
                          ),
                        );
                      }
                    },
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TimeSheetPageDetail extends StatelessWidget {
  const TimeSheetPageDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(178, 34, 34, 1.0),
        title: const Text(
          "Time Sheet",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tombol Save, Discard, Submit
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      showComingSoonPopup(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black87,
                    ),
                    child: const Text("Save",
                        style: TextStyle(color: Colors.white)),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      showComingSoonPopup(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                    ),
                    child: const Text("Discard",
                        style: TextStyle(color: Colors.white)),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      showComingSoonPopup(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(178, 34, 34, 1.0),
                    ),
                    child: const Text("Submit",
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),

            const Divider(),

            // Informasi Karyawan
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: const EdgeInsets.all(20),
                color: Colors.grey.shade300,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Employee",
                      style: TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      "Employee Name Displayed Here",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    buildInfoRow("Start Date", "25 Nov 2024"),
                    buildInfoRow("End Date", "1 Dec 2025"),
                    buildInfoRow("Unit", "Human Capital and General Services"),
                    buildInfoRow("Company", "PT Abhimata Persada"),
                    buildInfoRow("First Approver", "First Approver Name"),
                    buildInfoRow("Second Approver", "Second Approver Name"),
                  ],
                ),
              ),
            ),

            // Detail Tabel
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Detail",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            buildDetailTable(),

            // Add New Line
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GestureDetector(
                onTap: () {},
                child: const Text(
                  "add new line",
                  style: TextStyle(
                      color: Colors.grey, fontStyle: FontStyle.italic),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Fungsi untuk Baris Informasi
  Widget buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          SizedBox(
              width: 120,
              child: Text(title,
                  style: const TextStyle(fontWeight: FontWeight.bold))),
          const Text(":"),
          const SizedBox(width: 10),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  // Fungsi untuk Tabel Detail
  Widget buildDetailTable() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Table(
        border: TableBorder.all(color: Colors.black26),
        columnWidths: const {
          0: FixedColumnWidth(80),
          1: FixedColumnWidth(120),
          2: FixedColumnWidth(120),
          3: FlexColumnWidth(),
        },
        children: [
          buildTableRow(["Date", "Project", "Task", "Description"],
              isHeader: true),
          buildTableRow(["25 Nov", "Project Name", "Task Name", ""]),
          buildTableRow(["25 Nov", "Project Name", "Task Name", ""]),
          buildTableRow(["25 Nov", "Project Name", "Task Name", ""]),
          buildTableRow(["25 Nov", "Project Name", "Task Name", ""]),
          buildTableRow(["25 Nov", "Project Name", "Task Name", ""]),
        ],
      ),
    );
  }

  // Fungsi untuk Baris Tabel
  TableRow buildTableRow(List<String> cells, {bool isHeader = false}) {
    return TableRow(
      decoration:
          BoxDecoration(color: isHeader ? Colors.black87 : Colors.white),
      children: cells.map((cell) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            cell,
            style: TextStyle(
              fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
              color: isHeader ? Colors.white : Colors.black,
            ),
          ),
        );
      }).toList(),
    );
  }
}
