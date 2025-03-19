import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiServices {
  static const String apiKey = 'AIzaSyDXGcb28Uf3n55GGiSz8vVK_HlwFluh1OA';
  static Future<Map<String, dynamic>> generateSchedule(
    List<Map<String, dynamic>> tasks,
  ) async {
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
            'Kamu adalah AI ahli dalam dunia kopi dan pembuatan resep. Tugasmu adalah mengenerate resep kopi berdasarkan nama jenis kopi yang diberikan oleh pengguna. Ketika pengguna hanya menyebutkan nama kopi (misalnya "espresso", "latte", "cappuccino", dll.), kamu harus memberikan output berupa daftar bahan-bahan yang diperlukan dan langkah-langkah pembuatannya dalam format JSON. \n\nFormat output yang harus kamu ikuti:\n{\n  "nama_kopi": "<nama_kopi>",\n  "bahan": [\n    "<bahan 1>",\n    "<bahan 2>",\n    "...",\n    "<bahan n>"\n  ],\n  "langkah": [\n    "<langkah 1>",\n    "<langkah 2>",\n    "...",\n    "<langkah n>"\n  ]\n}\n\nKetentuan:\n1. Output yang dihasilkan harus berupa JSON valid tanpa tambahan teks atau komentar.\n2. Pastikan daftar bahan dan langkah sesuai dengan jenis kopi yang diminta.\n3. jika nama kopi sama seperti sebelumnya maka tetap berikan sesuai format \n4. Jika nama kopi tidak dikenali atau tidak ada data resep yang tersedia, kembalikan output JSON dengan format:\n{\n  "error": "Resep untuk jenis kopi ini tidak ditemukan."\n}\n\nContoh Input:\nlatte\n\nContoh Output:\n{\n  "nama_kopi": "latte",\n  "bahan": [\n    "susu segar",\n    "espresso",\n    "gula (opsional)"\n  ],\n  "langkah": [\n    "Seduh espresso.",\n    "Panaskan susu hingga berbusa.",\n    "Tuangkan susu ke dalam cangkir espresso.",\n    "Tambahkan gula sesuai selera."\n  ]\n}\n'),
      ]),
      Content.model([
        TextPart(
            'Oke, saya mengerti. Saya siap menerima nama kopi dari Anda dan menghasilkan resep dalam format JSON yang telah ditentukan.\n'),
      ]),
      Content.multi([
        TextPart('latte'),
      ]),
      Content.model([
        TextPart(
            '```json\n{\n  "nama_kopi": "latte",\n  "bahan": [\n    "60 ml espresso",\n    "300 ml susu segar",\n    "Gula atau sirup (opsional)"\n  ],\n  "langkah": [\n    "Siapkan espresso menggunakan mesin espresso atau alat seduh kopi lainnya.",\n    "Panaskan susu menggunakan mesin uap atau microwave hingga hangat dan berbusa.",\n    "Tuangkan espresso ke dalam cangkir saji.",\n    "Tuangkan susu hangat secara perlahan ke dalam cangkir, tahan busa susu dengan sendok.",\n    "Gunakan sendok untuk menahan busa, lalu tuangkan susu cair terlebih dahulu hingga cangkir hampir penuh.",\n    "Tambahkan busa susu di atasnya.",\n    "Tambahkan gula atau sirup sesuai selera jika diinginkan."\n  ]\n}\n```'),
      ]),
    ]);
    final message = prompt;
    final content = Content.text(message);
    try {
      final response = await chat.sendMessage(content);
      print(response.text);
      final responseText =
          (response.candidates.first.content.parts.first as TextPart).text;

      if (responseText.isEmpty) {
        return {"error": "failed to generate recipe"};
      }

      RegExp jsonPattern = RegExp(r'\{.*\}', dotAll: true);
      final match = jsonPattern.firstMatch(responseText);

      if (match != null) {
        return json.decode(match.group(0)!);
      }
      return jsonDecode(responseText);
    } catch (e) {
      return {"error": "failed to genereate recipe \n$e"};
    }
  }

  static String _buildPrompt(List<Map<String, dynamic>> coffee) {
    String coffeeName = coffee
        .map(
          (kopi) =>
              "-${kopi['nama_kopi']}",
        )
        .join("\n");
    return "buatkan lah daftar bahan dan step by step cara pembuatan kopi: \n$coffeeName\n. dan berikan response sesuai format awal dan dalam bentuk JSON";
  }
}
