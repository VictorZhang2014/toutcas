import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart'; 
import 'package:toutcas/src/models/chat_message.dart';
import 'package:toutcas/src/network/llm_request.dart'; 
import 'package:toutcas/src/states/basic_config.dart'; 
import 'package:toutcas/src/views/settings_view.dart';
import 'package:toutcas/src/views/subviews/push_animation.dart';
import 'package:toutcas/src/localization/app_localizations.dart';
import 'package:gpt_markdown/gpt_markdown.dart';
import 'package:toutcas/src/models/web_tabdata.dart';

class LLMChatView extends StatefulWidget {  
  final WebTabData data;
  const LLMChatView({super.key, required this.data});

  @override
  State<LLMChatView> createState() => _LLMChatViewState();
}

class _LLMChatViewState extends State<LLMChatView> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  File? _selectedFile;
 
  late LLMRequest? llmRequest;
  late bool isRequesting = false;
  late Map<String, String> htmlContentCache = {};

  @override
  void initState() {
    super.initState();
    _setup();
  } 

  void _setup() {
    final config = BasicConfig(); 
    llmRequest = LLMRequest(
      model: config.appAIModel,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {  
      llmRequest?.addSystemMessage(AppLocalizations.of(context)!.aiprompt1);
      llmRequest?.addAssistantMessage(AppLocalizations.of(context)!.aigreetings);
      setState(() {
        _messages.add(ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          content: AppLocalizations.of(context)!.aigreetings,
          type: MessageType.text,
          isSentByMe: false,
          timestamp: DateTime.now(),
        ));
      });
    });
  }

  void _sendMessage() async {
    String currentUserQuery = _messageController.text.trim();
    if (currentUserQuery.isEmpty && _selectedFile == null) return;

    if (isRequesting) return;
    setState(() {
      isRequesting = true; 
    });

    setState(() {
      if (_selectedFile != null) {
        final extension = _selectedFile!.path.split('.').last.toLowerCase();
        final isImage = ['jpg', 'jpeg', 'png', 'gif', 'bmp'].contains(extension);
        
        _messages.add(ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          content: currentUserQuery,
          type: isImage ? MessageType.image : MessageType.document,
          isSentByMe: true,
          timestamp: DateTime.now(),
          fileName: _selectedFile!.path.split('/').last,
          filePath: _selectedFile!.path,
        ));
        
        _selectedFile = null;
      } else {
        _messages.add(ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          content: currentUserQuery,
          type: MessageType.text,
          isSentByMe: true,
          timestamp: DateTime.now(),
        )); 
      } 
      _messageController.clear();
    });

    String query = currentUserQuery; 
    String webContent = "";
    if (htmlContentCache[widget.data.url]?.isEmpty ?? true) {  
      query = "${widget.data.url}.\n $currentUserQuery"; 
      webContent = await llmRequest?.getWebPageContent(widget.data.url, widget.data.htmlcode) ?? ""; 
      if (webContent.length > 5) {
        htmlContentCache[widget.data.url] = webContent;
      }
    }
    String? llmRespTxt = await llmRequest?.sendMessage(query, webContent);
    if (llmRespTxt != null && llmRespTxt.isNotEmpty) {
      setState(() {
        _messages.add(ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          content: llmRespTxt.trim(),
          type: MessageType.text,
          isSentByMe: false,
          timestamp: DateTime.now(),
        ));
      }); 
    } 
    _scrollToBottom();
    setState(() {
      isRequesting = false; 
    });
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _pickFile(String ext) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      // allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf', 'doc', 'docx'],
      allowedExtensions: [ext],
    ); 
    if (result != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
      });
    }
  } 

  void _removeSelectedFile() {
    setState(() {
      _selectedFile = null;
    });
  }

  String _getFileIcon(String extension) {
    switch (extension.toLowerCase()) {
      case 'pdf':
        return '📄';
      case 'doc':
      case 'docx':
        return '📝';
      default:
        return '📎';
    }
  }

  @override
  Widget build(BuildContext context) { 
    final settings = BasicConfig(); 
    return ListenableBuilder(
      listenable: settings,
      builder: (context, child) { 
        return SelectionArea(
          child: Scaffold( 
            backgroundColor: Colors.grey[100], 
            body: Column(
              children: [
                SizedBox(height: 5),
                Wrap(
                  children: [
                    TextButton(
                      onPressed: () {
                        PushAnimation.push(context, PushAnimateType.centerBounce, const SettingsView(tabIndex: 1)); 
                      }, 
                      child: Wrap(
                        direction: Axis.vertical,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(settings.appAIModel, style: TextStyle(color: Colors.grey[500], fontSize: 12),), 
                          Text("• ${AppLocalizations.of(context)?.inUse}", style: TextStyle(color: Colors.green, fontSize: 10),),
                        ],
                      ), 
                    ),
                  ],
                ),
                Expanded(
                  child: _messages.isEmpty
                      ? const Center(child: Text('No messages yet'))
                      : ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.all(16),
                          itemCount: _messages.length,
                          itemBuilder: (context, index) {
                            return _buildMessageBubble(_messages[index]);
                          },
                        ),
                ),
                if (_selectedFile != null) _buildFilePreview(),
                _buildMessageInput(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFilePreview() {
    final fileName = _selectedFile!.path.split('/').last;
    final extension = fileName.split('.').last;
    final isImage = ['jpg', 'jpeg', 'png', 'gif', 'bmp'].contains(extension.toLowerCase());

    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          if (isImage)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(
                _selectedFile!,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            )
          else
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  _getFileIcon(extension),
                  style: const TextStyle(fontSize: 32),
                ),
              ),
            ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fileName,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  isImage ? 'Image' : 'Document',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: _removeSelectedFile,
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final alignment = message.isSentByMe ? Alignment.centerRight : Alignment.centerLeft;
    final color = message.isSentByMe
        ? Colors.lightBlue.withAlpha(35)
        : Colors.grey[100];
    final textColor = Colors.black;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Align(
        alignment: alignment,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7,
          ),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (message.type == MessageType.image && message.filePath != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: 200,
                        maxHeight: 200,
                      ),
                      child: Image.file(
                        File(message.filePath!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                if (message.type == MessageType.document && message.fileName != null)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: message.isSentByMe
                          ? Colors.white.withOpacity(0.2)
                          : Theme.of(context).colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _getFileIcon(message.fileName!.split('.').last),
                          style: const TextStyle(fontSize: 24),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            message.fileName!,
                            style: TextStyle(
                              color: textColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                if (message.content.isNotEmpty) ...[
                  if (message.type != MessageType.text) const SizedBox(height: 8),
                  // SelectableText(
                  //   message.content,
                  //   style: TextStyle(color: textColor),
                  //   selectionControls: MaterialTextSelectionControls(),
                  //   cursorColor: textColor,
                  //   toolbarOptions: const ToolbarOptions(
                  //     copy: true,
                  //     selectAll: true,
                  //   ),
                  // ), 
                  GptMarkdown(
                    message.content,
                    style: TextStyle(
                      color: textColor
                    ),
                  )
                ], 
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(30),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [ 
          PopupMenuButton<String>( 
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            offset: const Offset(0, -70),  
            tooltip: AppLocalizations.of(context)!.attachFile, 
            onSelected: (value) => _pickFile(value),  
            child: Container( 
              margin: EdgeInsets.only(left: 2),
              child: Icon(Icons.add_rounded, size: 19),
            ), 
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              // const PopupMenuItem<String>(
              //   value: 'image',
              //   child: ListTile(
              //     leading: Icon(Icons.image, color: Colors.purple),
              //     title: Text('Image'),
              //     dense: true,
              //     contentPadding: EdgeInsets.zero,
              //   ),
              // ),
              const PopupMenuItem<String>(
                value: 'pdf',
                child: ListTile(
                  leading: Icon(Icons.picture_as_pdf, color: Colors.red),
                  title: Text('PDF'),
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              // const PopupMenuItem<String>(
              //   value: 'word',
              //   child: ListTile(
              //     leading: Icon(Icons.description, color: Colors.blue),
              //     title: Text('Word Document'),
              //     dense: true,
              //     contentPadding: EdgeInsets.zero,
              //   ),
              // ),
            ],
          ), 
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.askAnything,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ), 
                contentPadding: const EdgeInsets.symmetric( 
                  vertical: 8,
                ),
              ),
              onSubmitted: (_) => _sendMessage(),
              maxLines: null,
              textInputAction: TextInputAction.send,
              style: TextStyle(fontSize: 14)
            ),
          ),
          const SizedBox(width: 4),
          isRequesting ?
          (Platform.isMacOS || Platform.isIOS ? CupertinoActivityIndicator() : CircularProgressIndicator()):
          IconButton( 
            icon: const Icon(Icons.arrow_upward_rounded),
            constraints: BoxConstraints(),
            onPressed: _sendMessage, 
            style: IconButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}