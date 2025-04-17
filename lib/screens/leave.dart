import 'package:flutter/material.dart';
import 'annualleave.dart';
import 'unplannedleave.dart';

class LeavePage extends StatelessWidget {
  const LeavePage({Key? key}) : super(key: key);

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

  void _showLeaveOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'What type of leave do you want to apply for?',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ),
            _buildOption(context, 'Annual Leave', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LeaveFormScreen()),
              );
            }),
            _buildOption(context, 'Unplanned Leave', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UnplannedLeaveScreen()),
              );
            }),
            _buildOption(context, 'Planned Leave', () {
              showComingSoonPopup(context);
            }),
            const Divider(height: 1),
            _buildOption(context, 'Cancel', () {
              Navigator.pop(context);
            }, color: Colors.red),
          ],
        );
      },
    );
  }

  static Widget _buildOption(
      BuildContext context, String text, VoidCallback onTap,
      {Color color = Colors.black}) {
    return ListTile(
      title: Center(
        child: Text(
          text,
          style: TextStyle(
            fontSize: 18,
            color: color,
            fontWeight: text == 'Cancel' ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(204, 0, 0, 1.0),
        title: const Text(
          "Leave",
          style: TextStyle(color: Colors.white, fontSize: 18),
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bagian Bulan
          Container(
            color: Colors.black87,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                const Text(
                  "September",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward, color: Colors.white),
                  onPressed: () {},
                ),
              ],
            ),
          ),

          // Bagian Leaves Report
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Leaves report",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    buildLeaveCircle("10", "Annual Leave"),
                    buildLeaveCircle("9", "Planned Leave"),
                    buildLeaveCircle("3", "Unplanned Leave"),
                  ],
                ),
                const SizedBox(height: 20),

                // Tombol See Detail dan Apply Leave
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LeavePageDetail(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    minimumSize: const Size(double.infinity, 45),
                  ),
                  child: const Text("See Detail",
                      style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    _showLeaveOptions(context); // Panggil fungsi pop-up
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    minimumSize: const Size(double.infinity, 45),
                  ),
                  child: const Text("Apply Leave",
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),

          // Bagian National Holidays
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "2023 National Holidays",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 10),

          // Daftar National Holidays
          Expanded(
            child: ListView.builder(
              itemCount: 7,
              itemBuilder: (context, index) {
                return Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black26),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        "1 Jan 2023",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text("New Year's Day"),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk Lingkaran Leaves Report
  Widget buildLeaveCircle(String value, String title) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.black, width: 5),
          ),
          child: Center(
            child: Text(
              value,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(title),
      ],
    );
  }
}

class LeavePageDetail extends StatelessWidget {
  const LeavePageDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.red,
            title: const Text(
              'Leave',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pop(context); // Kembali ke halaman sebelumnya
              },
            ),
            bottom: const TabBar(
              labelColor: Colors.black,
              indicatorColor: Colors.black,
              tabs: [
                Tab(text: 'All'),
                Tab(text: 'Casual Leave'),
                Tab(text: 'Sick Leave'),
                Tab(text: 'Unpaid Leave'),
              ],
            ),
          ),
          body: const LeaveList(),
        ),
      ),
    );
  }
}

class LeaveList extends StatelessWidget {
  const LeaveList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        // Remaining balance
        Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'The remaining balance of all leave types:',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                color: Colors.grey.shade300,
                child: const Text(
                  '8',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        // Section Header - January 2025
        _buildSectionHeader('January 2025'),
        _buildLeaveCard('7 Days Application', 'Mon, 13 Jan', 'Annual Leave',
            'Denied', Colors.red),
        // Section Header - December 2024
        _buildSectionHeader('December 2024'),
        _buildLeaveCard('Full Day Application', 'Thu, 19 Dec', 'Sick Leave',
            'Approved', Colors.green),
        _buildLeaveCard('Half Day Application', 'Mon, 23 Dec', 'Annual Leave',
            'Approved', Colors.green),
        _buildLeaveCard('3 Days Application', 'Mon, 30 Dec', 'Unplanned Leave',
            'Submitted', Colors.orange),
        // Section Header - November 2024
        _buildSectionHeader('November 2024'),
        _buildLeaveCard('Full Day Application', 'Wed, 20 Nov', 'Sick Leave',
            'Approved', Colors.green),
        _buildLeaveCard('Full Day Application', 'Wed, 20 Nov', 'Sick Leave',
            'Approved', Colors.green),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 16, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildLeaveCard(String description, String date, String type,
      String status, Color statusColor) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: Colors.grey),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        title: Text(
          description,
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              date,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black),
            ),
            Text(
              type,
              style: const TextStyle(fontSize: 14, color: Colors.black),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                status,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 4),
            const Icon(Icons.chevron_right, color: Colors.black),
          ],
        ),
      ),
    );
  }
}
