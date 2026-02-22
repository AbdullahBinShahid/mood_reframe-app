import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../models/reframe_model.dart';

class AiService {
  static const List<String> _models = [
    'gemini-2.0-flash-exp',
    'gemini-exp-1206',
    'gemini-2.0-flash-thinking-exp',
    'gemini-2.0-pro-exp',
    'learnlm-1.5-pro-experimental',
  ];

  static Future<List<String>> getAvailableModels(String apiKey) async {
    final url = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models?key=$apiKey',
    );
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final models = data['models'] as List;
      return models
          .where((m) =>
              (m['supportedGenerationMethods'] as List)
                  .contains('generateContent'))
          .map((m) => (m['name'] as String).replaceFirst('models/', ''))
          .toList();
    }
    return [];
  }

  static Future<ReframeModel> getReframes({
    required String thought,
    String? mood,
  }) async {
    final apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
    if (apiKey.isEmpty) {
      throw Exception('API key not found. Please check your .env file.');
    }

    // Fetch available models dynamically
    final availableModels = await getAvailableModels(apiKey);
    print('✅ Available models: $availableModels');

    // Prefer flash/fast models, skip vision/embedding models
    final preferred = availableModels.where((m) =>
        m.contains('flash') || m.contains('pro') || m.contains('gemini')).toList();

    final modelsToTry = preferred.isNotEmpty ? preferred : _models;

    final moodText = mood != null
        ? 'I feel $mood and I\'m thinking: '
        : 'I\'m thinking: ';

    final prompt = '''You are a compassionate cognitive reframing assistant. 
When given a negative thought, respond with exactly 3 reframes in this JSON format:
{
  "logical": "...",
  "compassionate": "...",
  "growth": "..."
}
Keep each reframe under 3 sentences. Be warm, grounded, and non-preachy.
${moodText}$thought

Respond ONLY with the JSON object, no markdown, no extra text.''';

    final body = jsonEncode({
      'contents': [
        {
          'parts': [
            {'text': prompt}
          ]
        }
      ],
      'generationConfig': {
        'temperature': 0.7,
        'maxOutputTokens': 500,
      },
    });

    String lastError = 'No models available.';
    for (final model in modelsToTry) {
      print('🔄 Trying model: $model');
      try {
        final url = Uri.parse(
          'https://generativelanguage.googleapis.com/v1beta/models/$model:generateContent?key=$apiKey',
        );

        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: body,
        );

        print('📡 Status: ${response.statusCode} for $model');

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final text =
              data['candidates'][0]['content']['parts'][0]['text'] as String;

          if (text.isEmpty) continue;

          String jsonText = text.trim();
          final start = jsonText.indexOf('{');
          final end = jsonText.lastIndexOf('}');
          if (start != -1 && end != -1) {
            jsonText = jsonText.substring(start, end + 1);
          }

          final Map<String, dynamic> json = jsonDecode(jsonText);
          print('✅ Success with model: $model');
          return ReframeModel.fromJson(json);
        } else {
          final error = jsonDecode(response.body);
          lastError = error['error']?['message'] ?? 'Error with model $model';
          print('❌ Failed $model: $lastError');
          continue;
        }
      } catch (e) {
        lastError = e.toString();
        print('❌ Exception $model: $lastError');
        continue;
      }
    }

    throw Exception(lastError);
  }
}