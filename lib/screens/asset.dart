import 'package:flutter/material.dart';

class AssetScreen extends StatefulWidget {
  const AssetScreen({Key? key}) : super(key: key);

  @override
  _AssetScreenState createState() => _AssetScreenState();
}

class _AssetScreenState extends State<AssetScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(204, 0, 0, 1.0),
        title: const Text(
          "Asset",
          style: TextStyle(color: Colors.white, fontSize: 18),
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
      body: Column(
        children: [
          // TabBar
          TabBar(
            controller: _tabController,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.red,
            tabs: const [
              Tab(text: "My Asset"),
              Tab(text: "History"),
            ],
          ),
          // Search Bar and Action Button
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: "Search",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    showComingSoonPopup(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: const Text("Search",
                      style: TextStyle(color: Colors.white, fontSize: 18)),
                ),
              ],
            ),
          ),
          // Asset Table
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildAssetTable(),
                const Center(child: Text("No History")),
              ],
            ),
          ),
        ],
      ),
    );
  }

 Widget _buildAssetTable() {
  final List<Map<String, String>> assets = [
    {
      "Asset Type": "Laptop",
      "Series Number": "J8N0WUKKR05C34C",
      "Received Date": "23/11/2018",
      "Model": "Asus Zenbook UX360",
      "Status": "BAIK",
    },
    {
      "Asset Type": "Kartu Asuransi",
      "Series Number": "8000100654628081",
      "Received Date": "23/11/2018",
      "Model": "IP-1250",
      "Status": "BAIK",
    },
    {
      "Asset Type": "Kartu Parkir",
      "Series Number": "6396 9094 2039 1143",
      "Received Date": "23/11/2018",
      "Model": "",
      "Status": "BAIK",
    },
    {
      "Asset Type": "Kartu Akses Internal",
      "Series Number": "00615",
      "Received Date": "23/11/2018",
      "Model": "Master Card",
      "Status": "BAIK",
    },
    {
      "Asset Type": "Kartu Akses Gedung",
      "Series Number": "44666",
      "Received Date": "23/11/2018",
      "Model": "",
      "Status": "BAIK",
    },
    {
      "Asset Type": "Kartu Identitas",
      "Series Number": "06051306202202",
      "Received Date": "23/11/2018",
      "Model": "",
      "Status": "BAIK",
    },
  ];

  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: DataTable(
      columns: const [
        DataColumn(label: Text('Asset Type')),
        DataColumn(label: Text('Series Number')),
        DataColumn(label: Text('Received Date')),
        DataColumn(label: Text('Model')),
        DataColumn(label: Text('Status')),
      ],
      rows: assets.map((asset) {
        return DataRow(
          cells: [
            DataCell(
              GestureDetector(
                onTap: () {
                  // Trigger the ComingSoonPopup when clicked
                  showComingSoonPopup(context);
                },
                child: Text(
                  asset['Asset Type']!,
                  style: const TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
            DataCell(Text(asset['Series Number']!)),
            DataCell(Text(asset['Received Date']!)),
            DataCell(Text(asset['Model']!)),
            DataCell(Text(asset['Status']!)),
          ],
        );
      }).toList(),
    ),
  );
}
}
