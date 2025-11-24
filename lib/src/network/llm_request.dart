import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:toutcas/src/env.dart'; 
import 'llm_data.dart';

class LLMRequest extends LLMData {
  final String apiUrl = INTERNAL_BASE_URL; 
  final String model;
  
  LLMRequest({required this.model});
 
  final Dio _dio = Dio();

  Future<String> sendMessage(String userMessage) async {  
    try { 
      final body = {
        'messages': messages,
        'model': model,
        'stream': false,
        'text': userMessage,
      };  
      final response = await _dio.post(
        "$apiUrl/text_analyzer",
        data: body,  
        options: Options(
          headers: { 
            'Content-Type': 'application/json',
          },
        ),
      );  
      if (response.statusCode == 200) { 
        final data = response.data;  
        addUserMessage(userMessage); 
        final assistantMessage = data['llm_response']; 
        addAssistantMessage(assistantMessage);
        return assistantMessage ?? "";
      } else { 
        // throw Exception('Failed to get response: ${response.statusCode} - ${response.data}');
      }
    } catch (e) { 
      if (e is DioException) {
          debugPrint("DioError Response: ${e.response?.data}");
      }  
    } 
    return "";
  }

}