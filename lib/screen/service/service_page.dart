import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:schedule_generator/network/gemini_service.dart';
import 'package:schedule_generator/screen/history/history_page.dart';
import 'package:shimmer/shimmer.dart';

class ServiceScreen extends StatefulWidget {
  const ServiceScreen({super.key});

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  bool _isLoading = false;
  final List<Map<String, dynamic>> _coffees = [];
  final TextEditingController _coffeeController = TextEditingController();
  String? errorMessage;

  final _coffeeDB = Hive.box('coffeeBox');

  List<String> bahan = [];
  List<String> langkah = [];

  void handleSingleAction() async {
    if (_coffeeController.text.isEmpty) return;

    setState(() {
      _coffees.clear();
      _coffees.add({
        'nama_kopi': _coffeeController.text,
        'bahan': '',
        'langkah': '',
      });
      _coffeeController.clear();
      _isLoading = true;
      errorMessage = null;
    });

    try {
      final result = await GeminiServices.generateCofee(_coffees);

      if (result.containsKey('error')) {
        setState(() {
          _isLoading = false;
          bahan.clear();
          langkah.clear();
          errorMessage = result['error'];
        });
        return;
      }

      setState(() {
        bahan = List<String>.from(result['bahan'] ?? []);
        langkah = List<String>.from(result['langkah'] ?? []);
        _isLoading = false;
      });

      await _coffeeDB.add({
        'nama_kopi': result['nama_kopi'],
        'bahan': result['bahan'],
        'langkah': result['langkah'],
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        bahan.clear();
        langkah.clear();
        errorMessage = 'Gagal menghasilkan resep\n$e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[50], // Soft beige background
      appBar: AppBar(
        title: const Text(
          'Coffee Recipe Generator',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.brown[700],
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => HistoryPage()));
            },
            icon: Icon(Icons.history_sharp, color: Colors.white),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Input Field
            TextField(
              controller: _coffeeController,
              style: GoogleFonts.poppins(),
              decoration: InputDecoration(
                hintText: 'Nama Kopi',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.brown[100],
              ),
            ),
            const SizedBox(height: 10),

            // Add Coffee Button
            ElevatedButton.icon(
              onPressed: _isLoading ? null : handleSingleAction,
              label: Text(
                _isLoading ? 'Generating...' : 'Generate Recipe',
                style: const TextStyle(color: Colors.white),
              ),
              icon: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Icon(Icons.coffee, color: Colors.white),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown[700],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            const SizedBox(height: 16),

            if (!_isLoading && errorMessage != null)
              Card(
                color: Colors.red[700],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Icon(Icons.error, color: Colors.white),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          errorMessage!,
                          style: GoogleFonts.poppins(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            if (_isLoading)
              Column(
                children: List.generate(
                  3,
                  (index) => Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const SizedBox(height: 40, width: 300),
                      ),
                    ),
                  ),
                ),
              ),

            if (!_isLoading && (bahan.isNotEmpty || langkah.isNotEmpty))
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    '${_coffees[0]['nama_kopi']}',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Ingredients Section
                  Card(
                    color: Colors.brown[200],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Bahan",
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          const SizedBox(height: 8),
                          ...bahan.map((item) => Text('- $item')),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Steps Section
                  Text(
                    'Langkah Pembuatan',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  const SizedBox(height: 8),
                  ...langkah.asMap().entries.map((entry) => Card(
                        color: Colors.brown[300],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: ListTile(
                          leading: Text('${entry.key + 1}'),
                          title: Text(
                            entry.value,
                            style: TextStyle(color: Colors.white70),
                          ),
                        ),
                      )),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
