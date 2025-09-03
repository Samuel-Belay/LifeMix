import 'dart:convert';
import 'package:http/http.dart' as http;

class AIService {
  final String openAiApiKey = 'YOUR_OPENAI_API_KEY';

  Future<List<String>> getHabitSuggestions(List<String> currentHabits) async {
    final prompt = "Suggest related habits for: ${currentHabits.join(', ')}";
    final response = await _callOpenAI(prompt);
    return response.split(RegExp(r',|\n')).map((e) => e.trim()).toList();
  }

  Future<String> categorizeExpense(String item) async {
    final prompt = "Categorize this expense: $item";
    final response = await _callOpenAI(prompt);
    return response.trim();
  }

  Future<String> analyzeMood(String journalText) async {
    final prompt = "Detect sentiment of this journal entry: $journalText";
    final response = await _callOpenAI(prompt);
    return response.trim();
  }

  Future<String> _callOpenAI(String prompt) async {
    final url = Uri.parse('https://api.openai.com/v1/completions');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $openAiApiKey',
    };
    final body = jsonEncode({
      'model': 'text-davinci-003',
      'prompt': prompt,
      'max_tokens': 60,
    });

    final res = await http.post(url, headers: headers, body: body);
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return data['choices'][0]['text'];
    } else {
      throw Exception('OpenAI API error: ${res.body}');
    }
  }
}
