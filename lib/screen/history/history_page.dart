import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final _coffeeDB = Hive.box('coffeeBox');
  final List<Map<String, dynamic>> _coffees = [];

  void loadTasks() {
    setState(() {
      _coffees.clear();
      for (var coffee in _coffeeDB.values) {
        if (coffee is Map) {
          _coffees.add(Map<String, dynamic>.from(coffee));
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    loadTasks(); // Load data from Hive
  }

  void deleteTask(int index) async {
    await _coffeeDB.deleteAt(index); // Delete from Hive
    setState(() {
      loadTasks(); // Refresh list
    });
  }

  // Function to show the detailed coffee recipe dialog
  void showCoffeeDetails(Map<String, dynamic> coffee) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.brown[50],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Coffee Name
                Text(
                  coffee['nama_kopi'],
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown[800],
                  ),
                ),
                SizedBox(height: 10),

                // Ingredients Section
                Text(
                  "Bahan:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ...coffee['bahan']
                    .map<Widget>((bahan) => Text("- $bahan"))
                    .toList(),
                SizedBox(height: 10),

                // Steps Section
                Text(
                  "Langkah-langkah:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ...coffee['langkah']
                    .map<Widget>((step) => Text("• $step"))
                    .toList(),
                SizedBox(height: 20),

                // Close Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Tutup", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History'),
      ),
      body: SafeArea(
        child: _coffees.isEmpty
            ? Center(
                child: Text(
                  'You do not have any history',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your History',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown[800],
                      ),
                    ),
                    SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _coffees.length,
                        itemBuilder: (context, index) {
                          final coffee = _coffees[index];

                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 4,
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(16),
                              leading: Icon(Icons.coffee, color: Colors.brown),
                              title: Text(
                                coffee['nama_kopi'],
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text('Klik untuk lihat detail'),
                              trailing: IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () => deleteTask(index),
                              ),
                              onTap: () => showCoffeeDetails(coffee),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
