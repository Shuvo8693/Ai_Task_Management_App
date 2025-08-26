// lib/data/datasources/remote/ai_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AIService {
  static final String? _apiKey = dotenv.env['GEMINI_API_KEY'];
  static const String _baseUrl = 'generativelanguage.googleapis.com';

  Future<List<String>> generateTasksFromPrompt(String prompt) async {
    // For demo purposes, we'll simulate AI response
    // In a real app, you would call the Gemini API

    await Future.delayed(const Duration(seconds: 2)); // Simulate API call

    // Mock AI response based on prompt keywords
    if (prompt.toLowerCase().contains('week') || prompt.toLowerCase().contains('plan')) {
      return [
        "Plan weekly team meeting",
        "Review project milestones",
        "Prepare client presentation",
        "Schedule time for deep work",
        "Update task priorities"
      ];
    } else if (prompt.toLowerCase().contains('work') && prompt.toLowerCase().contains('wellness')) {
      return [
        "Complete project documentation",
        "Review code pull requests",
        "Team sync meeting",
        "30-minute meditation session",
        "Evening walk in the park"
      ];
    } else if (prompt.toLowerCase().contains('shopping')) {
      return [
        "Buy groceries for the week",
        "Purchase office supplies",
        "Order new headphones",
        "Get birthday gift for friend",
        "Pick up dry cleaning"
      ];
    }

    // Default response
    return [
      "Review and prioritize tasks",
      "Schedule important meetings",
      "Follow up on pending items",
      "Block time for focused work",
      "Plan breaks throughout the day"
    ];
  }

  Future<DateTime> suggestNewTime(DateTime originalDate) async {
    // Simulate AI suggesting a new time (usually tomorrow at 10am)
    await Future.delayed(const Duration(seconds: 1));

    final now = DateTime.now();
    DateTime suggestedTime;

    if (originalDate.isBefore(now)) {
      // If the original time is in the past, suggest tomorrow at 10am
      suggestedTime = DateTime(now.year, now.month, now.day + 1, 10);
    } else {
      // Otherwise, suggest the same time tomorrow
      suggestedTime = DateTime(originalDate.year, originalDate.month, originalDate.day + 1, originalDate.hour);
    }

    return suggestedTime;
  }

  // This would be the actual implementation with Gemini API
  Future<List<String>> _callGeminiAPI(String prompt) async {
    if (_apiKey == null) {
      throw Exception('API key not configured');
    }

    final url = Uri.https(_baseUrl, '/v1beta/models/gemini-pro:generateContent', {
      'key': _apiKey,
    });

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'contents': [
          {
            'parts': [
              {'text': 'Generate a list of 5 tasks based on this prompt: $prompt. Return only the tasks as a bulleted list without any additional text.'}
            ]
          }
        ],
        'generationConfig': {
          'temperature': 0.7,
          'topK': 40,
          'topP': 0.95,
          'maxOutputTokens': 1024,
        }
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final text = data['candidates'][0]['content']['parts'][0]['text'];
      return _parseAIResponse(text);
    } else {
      throw Exception('Failed to generate tasks: ${response.statusCode}');
    }
  }

  List<String> _parseAIResponse(String response) {
    // Parse the bulleted list response
    final lines = response.split('\n');
    return lines
        .where((line) => line.trim().startsWith('-') || line.trim().startsWith('*'))
        .map((line) => line.replaceAll(RegExp(r'^[-*]\s*'), '').trim())
        .where((task) => task.isNotEmpty)
        .toList();
  }
}