import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiSuggestion {
    static String apiKey = 'AIzaSyDXGcb28Uf3n55GGiSz8vVK_HlwFluh1OA';

  Future<Map<String, dynamic>> generateRecommend() async {
    final prompt =
        "Pilih satu jenis kopi yang cocok untuk hari ini dan buatkan resepnya.\n"
        "Formatkan hasilnya dalam JSON valid tanpa teks tambahan.\n"
        "```json\n"
        "{\n"
        "  \"nama_kopi\": \"<nama_kopi>\",\n"
        "  \"bahan\": [\"<bahan 1>\", \"<bahan 2>\"]\n"
        "  \"langkah\": [\"<langkah 1>\", \"<langkah 2>\"]\n"
        "}\n"
        "```";

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

    try {
      final response = await model.generateContent([Content.text(prompt)]);
      final responseText =
          (response.candidates.first.content.parts.first as TextPart).text;

      if (responseText.isEmpty) {
        return {"error": "Failed to generate recipe."};
      }

      // Ekstrak JSON dari hasil respons
      final jsonMatch =
          RegExp(r'```json\n([\s\S]*?)\n```').firstMatch(responseText);
      if (jsonMatch != null) {
        return jsonDecode(jsonMatch.group(1)!);
      }

      // Jika langsung berupa JSON
      return jsonDecode(responseText);
    } catch (e) {
      return {"error": "Failed to generate recipe: $e"};
    }
  }
}
