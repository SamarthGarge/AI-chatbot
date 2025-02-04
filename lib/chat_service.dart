import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ChatService {
  final String _apiKey;

  ChatService() : _apiKey = dotenv.env['GEMINI_API_KEY']!;

  static const String _apiUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent';

  Future<String> sendMessage(String message) async {
    try {
      final response = await http.post(
        Uri.parse('$_apiUrl?key=$_apiKey'), // Append the API key as a query parameter
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': message}
              ]
            }
          ]
        }),
      );

      // print('Response Status Code: ${response.statusCode}'); // Debug: Print status code
      // print('Response Body: ${response.body}'); // Debug: Print response body

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Extract the response text from the API response
        return data['candidates'][0]['content']['parts'][0]['text'];
      } else {
        throw Exception('Failed to load response: ${response.statusCode}');
      }
    } catch (e) {
      // print('Error: $e'); // Debug: Print the exception
      throw Exception('Failed to send message: $e');
    }
  }
}