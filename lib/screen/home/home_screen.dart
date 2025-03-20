import 'package:flutter/material.dart';
import 'package:schedule_generator/network/gemini_suggestion.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, dynamic>? coffeeRecipe;
  bool isLoading = true;

  final GeminiSuggestion gemini = GeminiSuggestion();

  @override
  void initState() {
    super.initState();
    _fetchCoffeeSuggestion();
  }

  Future<void> _fetchCoffeeSuggestion() async {
    final response = await gemini.generateRecommend();

    setState(() {
      coffeeRecipe = response;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[50], // Soft brown background
      appBar: AppBar(
        title: Text(
          "Kopi Hari Ini",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.brown[700], // Dark brown app bar
        centerTitle: true,
      ),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator(color: Colors.brown[700])
            : coffeeRecipe == null || coffeeRecipe!.containsKey("error")
                ? Text(
                    "Gagal mendapatkan rekomendasi kopi.",
                    style: TextStyle(color: Colors.red, fontSize: 16),
                  )
                : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 30),
                      child: Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.brown[100], // Light brown container
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.brown.shade300,
                              blurRadius: 10,
                              spreadRadius: 2,
                              offset: Offset(2, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Coffee Name
                            Center(
                              child: Text(
                                "${coffeeRecipe!['nama_kopi']}",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.brown[800],
                                ),
                              ),
                            ),
                            SizedBox(height: 20),

                            // Ingredients Section
                            Text(
                              'Bahan:',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.brown[900]),
                            ),
                            SizedBox(height: 5),
                            ...coffeeRecipe!['bahan']
                                .map<Widget>(
                                  (bahan) => Container(
                                    margin: EdgeInsets.only(top: 5),
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.brown[200], // Soft beige
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      "- $bahan",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                )
                                .toList(),

                            SizedBox(height: 20),

                            // Steps Section
                            Text(
                              "Langkah-langkah:",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.brown[900]),
                            ),
                            SizedBox(height: 5),
                            ...coffeeRecipe!['langkah']
                                .asMap()
                                .entries
                                .map<Widget>(
                                  (entry) => Container(
                                    margin: EdgeInsets.only(top: 5),
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.brown[300], // Darker beige
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${entry.key + 1}. ",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.brown[900],
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            entry.value,
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                                .toList(),

                            SizedBox(height: 20),

                            // Refresh Button
                            Center(
                              child: ElevatedButton(
                                onPressed: () => _fetchCoffeeSuggestion(),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.brown[700],
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  "Coba Rekomendasi Baru",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
