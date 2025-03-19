import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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

  List bahan = [];
  List langkah = [];

  void addTask() {
    if (_coffeeController.text.isNotEmpty) {
      setState(() {
        _coffees.add({
          'nama_kopi': _coffeeController.text,
          'bahan': '',
          'langkah': '',
        });
        _coffeeController.clear();
        print(_coffees);
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
        bahan = List.from(result['bahan']);
        langkah = List.from(result['langkah']);

        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        bahan.clear();
        langkah.clear();
        errorMessage = 'failed to generate schedule\n$e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Schedule Generator'),
      ),
      body: SingleChildScrollView(
        child: Padding(
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
              SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: addTask,
                label: Text(
                  'Tambahkan Nama Kopi',
                  style: TextStyle(color: Colors.white),
                ),
                icon: Icon(Icons.add, color: Colors.white),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: Colors.blueAccent,
                ),
              ),
              SizedBox(height: 16),
              if (_coffees.isNotEmpty)
                SizedBox(
                  height: 150,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _coffees.length,
                    itemBuilder: (context, index) {
                      var coffee = _coffees[index];
                      return Card(
                        child: ListTile(
                          leading: Icon(FontAwesomeIcons.listCheck),
                          title: Text(coffee['nama_kopi']),
                          trailing: IconButton(
                            onPressed: () {
                              setState(() {
                                _coffees.removeAt(index);
                              });
                            },
                            icon: Icon(Icons.delete),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              if (_coffees.isNotEmpty)
                ElevatedButton.icon(
                  onPressed: generateSchedule,
                  label: Text(
                    _isLoading ? 'Generating ...' : 'Generate recipe',
                    style: TextStyle(color: Colors.white),
                  ),
                  icon: _isLoading
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 1,
                          ),
                        )
                      : Icon(Icons.schedule, color: Colors.white),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: Colors.cyan,
                  ),
                ),
              SizedBox(height: 10),
              if (!_isLoading &&
                  errorMessage != null &&
                  errorMessage!.isNotEmpty)
                Card(
                  color: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(
                          Icons.error,
                          color: Colors.white,
                        ),
                        SizedBox(width: 8),
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
                  children: [
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: SizedBox(height: 10, width: 300),
                      ),
                    ),
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: SizedBox(height: 40, width: 200),
                      ),
                    ),
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: SizedBox(height: 100, width: 300),
                      ),
                    ),
                  ],
                ),
              // Display generated schedule
              if (!_isLoading && (langkah.isNotEmpty || bahan.isNotEmpty))
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
                            SizedBox(
                              height: 8,
                            ),
                            if (bahan.isEmpty)
                              Text(
                                'Tidak Ada Tugas',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                ),
                              ),
                            ListView.builder(
                                shrinkWrap: true,
                                itemCount: bahan.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Column(
                                    children: [Text('${bahan[index]}')],
                                  );
                                })
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Card(
                      color: Colors.yellowAccent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Langkah",
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            if (langkah.isEmpty)
                              Text(
                                'Tidak Ada langkah',
                                style: GoogleFonts.poppins(
                                  color: Colors.black,
                                ),
                              ),
                            ListView.builder(
                              itemCount: langkah.length,
                              shrinkWrap: true,
                                itemBuilder: (BuildContext context, int index) {
                              return Column(
                                children: [Text('${langkah[index]}')],
                              );
                            })
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                  ],
                )
            ],
          ),
        ),
      ),
    );
  }
}
