import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:toutcas/src/env.dart';
import 'package:toutcas/src/models/chat_message.dart'; 
import 'llm_data.dart';

class LLMRequest extends LLMData {
  final String apiUrl = INTERNAL_BASE_URL; 
  final String model;
  
  LLMRequest({required this.model});
 
  final Dio _dio = Dio();

  Future<String> sendMessage(String conversationId, String userMessage, String webContent) async {  
    try { 
      final body = {
        'conversation_id': conversationId,
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

  Future<LLMResponse?> getWebPageContent(String url, String htmlcode) async {   
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
        final success = response.data["success"] as bool;
        final isPdf = response.data["is_pdf"] as bool;
        final content = response.data["content"] as String;
        var data = {"content": content, "is_pdf": isPdf};
        return LLMResponse(success, "", data);
      }   
    } catch (e) { 
      if (e is DioException) {
          debugPrint("DioError Response: ${e.response?.data}");
      }  
    }
    return null;  
  }

  Future<String> chatWithFileMessage(String conversationId, ChatPDFState webPdfState, ChatPDFState selectedPdfState, String userMessage, String webContent) async {  
    try {  
      FormData formData = FormData.fromMap({
        'conversation_id': conversationId,
        'messages': messages,
        'model': model,
        'stream': false,
        'text': userMessage,
        'web_content': webContent,   
        'file_name_web': webPdfState.fileName,   
        'file_name_user_uploaded': selectedPdfState.fileName,   
      }); 
      bool isUploaded1 = false, isUploaded2 = false;
      if (!webPdfState.isUploaded && webPdfState.pdfLocalPath.isNotEmpty) { 
        formData.files.add(MapEntry(
          'file_web',
          await MultipartFile.fromFile(
            webPdfState.pdfLocalPath,
            filename: webPdfState.fileName, 
          )
        ));
        isUploaded1 = true;
      }
      if (!selectedPdfState.isUploaded && selectedPdfState.pdfLocalPath.isNotEmpty) { 
        formData.files.add(MapEntry(
          'file_user_uploaded',
          await MultipartFile.fromFile(
            selectedPdfState.pdfLocalPath,
            filename: selectedPdfState.fileName, 
          )
        ));
        isUploaded2 = true;
      }
      Response response = await _dio.post(
        "$apiUrl/pdf_analyzer",
        data: formData,  
      );
      if (response.statusCode == 200) { 
        if (isUploaded1) webPdfState.isUploaded = true;
        if (isUploaded2) selectedPdfState.isUploaded = true;
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

  Future<LLMResponse?> burnConversation(String conversationId) async {   
    try { 
      final body = { 
        'conversation_id': conversationId
      };  
      final response = await _dio.post(
        "$apiUrl/burn_after_use",
        data: body,  
        options: Options(
          headers: { 
            'Content-Type': 'application/json',
          },
        ),
      );   
      if (response.statusCode == 200) {  
        final success = response.data["success"] as bool;
        return LLMResponse(success, "", {});
      }   
    } catch (e) { 
      if (e is DioException) {
          debugPrint("DioError Response: ${e.response?.data}");
      }  
    }
    return null;  
  }

}


class LLMRequestDownloader extends LLMRequest {

  LLMRequestDownloader({required super.model});

  Future<String> get _localPath async {
    final directory = await getTemporaryDirectory(); 
    return directory.path;
  }

  Future<File> localFile(String fileUrl) async {
    final path = await _localPath; 
    final name = fileUrl.split('/').last;
    if (name.endsWith(".pdf")) {
      return File('$path/$name');
    }
    return File('$path/$name.pdf');
  }

  Future<String> downloadPDF(String fileUrl, Function(String p) progress) async {
    final file = await localFile(fileUrl);
    String savedTmpPath = file.path;  
    try {
      await _dio.download(
        fileUrl,
        savedTmpPath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            double p = (received / total) * 100;
            progress(p.toStringAsFixed(0)); 
          }
        },
      );
      return savedTmpPath;
    } catch (e) {
      debugPrint('downloadPDF error : $e');
      return "";
    } 
  }

}

