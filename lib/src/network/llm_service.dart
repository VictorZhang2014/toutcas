
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/material.dart';
import 'package:toutcas/src/env.dart'; 
import 'llm_data.dart';

class LLMService extends LLMData {
  final String apiUrl = EXTERNAL_BASE_URL;
  final String apiToken;
  final String model;
  
  LLMService({required this.apiToken, required this.model});
 
  final Dio _dio = Dio();

  void configureDioProxy() { 
    (_dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      final client = HttpClient();
      // Force the client to look at the environment variables (HTTP_PROXY, etc.)
      client.findProxy = HttpClient.findProxyFromEnvironment;
      return client;
    };
  }

  Future<String> sendMessage(String userMessage) async {
    addUserMessage(userMessage); 
    bool failed = false;
    configureDioProxy();
    try { 
      final body = {
        'messages': messages,
        'model': model,
        'stream': false,
      };  
      final response = await _dio.post(
        apiUrl,
        data: body,  
        options: Options(
          headers: {
            'Authorization': 'Bearer $apiToken',
            'Content-Type': 'application/json',
          },
        ),
      );  
      if (response.statusCode == 200) { 
        final data = response.data; 
        final assistantMessage = data['choices'][0]['message']['content']; 
        addAssistantMessage(assistantMessage);
        return assistantMessage ?? "";
      } else {
        failed = true;
        // throw Exception('Failed to get response: ${response.statusCode} - ${response.data}');
      }
    } catch (e) { 
      if (e is DioException) {
          debugPrint("DioError Response: ${e.response?.data}");
      } 
      failed = true;
    }
    if (failed) {
      // Remove the user message if request failed
      if (messages.isNotEmpty &&
          messages.last['role'] == 'user') {
        messages.removeLast();
      } 
    }
    return "";
  }

}
