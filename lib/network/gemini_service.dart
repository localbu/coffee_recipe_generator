import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiServices {
  static const String apiKey = 'AIzaSyDXGcb28Uf3n55GGiSz8vVK_HlwFluh1OA';

  static Future<Map<String, dynamic>> generateCofee(
      List<Map<String, dynamic>> tasks) async {
    final prompt = _buildPrompt(tasks);
    final model = GenerativeModel(
      model: 'gemini-2.0-flash',
      apiKey: apiKey,
      generationConfig: GenerationConfig(
        temperature: 1,
        topK: 40,
        topP: 0.95,
        maxOutputTokens: 8192,
        responseMimeType: 'text/plain',
      ),
    );

    final chat = model.startChat(history: [
      Content.multi([
        TextPart(
            'Kamu adalah AI ahli dalam dunia kopi. Ketika pengguna menyebutkan nama kopi (misalnya "espresso", "latte"), hasilkan resep dalam **JSON valid** dan hanya ambil yang data terakhir apabila menampilkan list. Format:\n'
            '```json\n'
            '{\n'
            '  "nama_kopi": "<nama_kopi>",\n'
            '  "bahan": ["<bahan 1>", "<bahan 2>"],\n'
            '  "langkah": ["<langkah 1>", "<langkah 2>"]\n'
            '}\n'
            '```\n'
            '⚠️ **Jangan tambahkan teks di luar JSON**!'),
      ]),
    ]);

    try {
      final response = await chat.sendMessage(Content.text(prompt));
      final responseText =
          (response.candidates.first.content.parts.first as TextPart).text;

      if (responseText.isEmpty) {
        return {"error": "Failed to generate recipe."};
      }

      // Extract JSON inside triple backticks
      final jsonMatch =
          RegExp(r'```json\n([\s\S]*?)\n```').firstMatch(responseText);

      if (jsonMatch != null) {
        return jsonDecode(jsonMatch.group(1)!);
      }

      // Attempt direct parsing (if API response is already JSON)
      return jsonDecode(responseText);
    } catch (e) {
      return {"error": "Failed to generate recipe"};
    }
  }

  static String _buildPrompt(List<Map<String, dynamic>> coffee) {
    String coffeeList =
        coffee.map((kopi) => "- ${kopi['nama_kopi']}").join("\n");
    return "Buatkan resep kopi untuk:\n$coffeeList\n"
        "Formatkan hasilnya sebagai JSON valid (tanpa teks tambahan).";
  }
}
