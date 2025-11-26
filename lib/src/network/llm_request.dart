import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:toutcas/src/env.dart'; 
import 'llm_data.dart';

class LLMRequest extends LLMData {
  final String apiUrl = INTERNAL_BASE_URL; 
  final String model;
  
  LLMRequest({required this.model});
 
  final Dio _dio = Dio();

  Future<String> sendMessage(String userMessage, String webContent) async {  
    try { 
      final body = {
        'messages': messages,
        'model': model,
        'stream': false,
        'text': userMessage,
        'web_content': webContent,
      };  
      final response = await _dio.post(
        "$apiUrl/text_analyser",
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

  Future<String> getWebPageContent(String url, String htmlcode) async {  
    try { 
      final body = { 
        'url': url,
        'htmlcode': htmlcode,
      };  
      final response = await _dio.post(
        "$apiUrl/webpage_content",
        data: body,  
        options: Options(
          headers: { 
            'Content-Type': 'application/json',
          },
        ),
      );  
      if (response.statusCode == 200) { 
        final data = response.data;   
        final content = data['content'];  
        return content ?? "";
      } else {  
      }
    } catch (e) { 
      if (e is DioException) {
          debugPrint("DioError Response: ${e.response?.data}");
      }  
    } 
    return "";
  }

  Future<String> sendPdfMessage(bool isUploaded, String filepath, String fileName, String userMessage, String webContent) async {  
    try {  
      FormData formData = FormData.fromMap({
        'messages': messages,
        'model': model,
        'stream': false,
        'text': userMessage,
        'web_content': webContent,  
        'file_name': fileName,
      }); 
      if (!isUploaded) {
        // Attach file only if it's not already uploaded
        formData.files.add(MapEntry(
          'file',
          await MultipartFile.fromFile(
            filepath,
            filename: fileName, 
          )
        ));
      }
      Response response = await _dio.post(
        "$apiUrl/pdf_analyzer",
        data: formData,  
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