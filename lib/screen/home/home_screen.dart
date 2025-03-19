import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:schedule_generator/network/gemini_service.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = false;
  final List<Map<String, dynamic>> _coffees = [];
  final TextEditingController _coffeeController = TextEditingController();
  String? errorMessage;

  List<String> bahan = [];
  List<String> langkah = [];

  void addTask() {
    if (_coffeeController.text.isNotEmpty) {
      _coffees.clear;
      setState(() {
        _coffees.add({
          'nama_kopi': _coffeeController.text,
          'bahan': '',
          'langkah': '',
        });
        _coffeeController.clear();
      });
    }
  }

  Future<void> generateSchedule() async {
    setState(() {
      _isLoading = true;
      errorMessage = null;
    });

    try {
      final result = await GeminiServices.generateSchedule(_coffees);

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
      appBar: AppBar(title: const Text('Schedule Generator')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _coffeeController,
              decoration: InputDecoration(
                hintText: 'Nama Kopi',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: addTask,
              label: const Text(
                'Tambahkan Nama Kopi',
                style: TextStyle(color: Colors.white),
              ),
              icon: const Icon(Icons.add, color: Colors.white),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                backgroundColor: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 16),
            if (_coffees.isNotEmpty)
              ElevatedButton.icon(
                onPressed: _isLoading ? null : generateSchedule,
                label: Text(
                  _isLoading ? 'Generating ...' : 'Generate Recipe',
                  style: const TextStyle(color: Colors.white),
                ),
                icon: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 1,
                        ),
                      )
                    : const Icon(Icons.schedule, color: Colors.white),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: Colors.cyan,
                ),
              ),
            const SizedBox(height: 10),
            if (!_isLoading && errorMessage != null)
              Card(
                color: Colors.red,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                  3,
                  (index) => Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
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
                  Card(
                    color: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Bahan",
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          if (bahan.isEmpty)
                            Text(
                              'Tidak ada bahan',
                              style: GoogleFonts.poppins(color: Colors.white),
                            ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: bahan.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 4.0),
                                child: Text(
                                  '${index + 1}. ${bahan[index]}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Langkah Pembuatan',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  ListView.separated(
                    separatorBuilder: (BuildContext context, int index) =>
                        SizedBox(
                      height: 10,
                    ),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: langkah.length,
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[600],
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                  offset: Offset(5, 5),
                                  color: const Color(0x6B000000),
                                  blurRadius: 10)
                            ]),
                        child: ListTile(
                          leading: Text('${index + 1}'),
                          title: Text(
                            langkah[index],
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
