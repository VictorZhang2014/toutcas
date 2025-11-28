import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:toutcas/src/models/IconTextModel.dart';
import 'package:toutcas/src/localization/app_localizations.dart';

class HomeContentDefaultView extends StatefulWidget {   
  final Function(String searchText, String filepath) onSearchText;
  const HomeContentDefaultView({super.key, required this.onSearchText});

  @override
  State<StatefulWidget> createState() => _HomeContentDefaultViewState();
}

class _HomeContentDefaultViewState extends State<HomeContentDefaultView> { 
  
  late String keyword = "";
  late List<IconTextPair> iconPairs = []; 
  
  @override
  Widget build(BuildContext context) { 
    return Container( 
      color: Colors.white,
      child: Center( 
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800), 
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [  
                const ChatLogo(),
                const SizedBox(height: 28),
                Container(
                  decoration: BoxDecoration( 
                    border: keyword.isEmpty ? Border() : Border.all(
                      color: Colors.grey[300]!, 
                      width: 1.0, 
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(25))
                  ),
                  child: Column(
                    children: [
                      ChatSearchField(onChangeKeyword: (kw) {
                        keyword = kw; 
                        iconPairs = IconTextModel().getAllByKeyword(keyword); 
                        setState(() { });
                      }, onSearchText: widget.onSearchText), 
                      if (keyword.isNotEmpty) Container(
                        height: 0.5,
                        color: Colors.grey[300],
                        margin: EdgeInsets.only(left: 20, right: 20),
                      ), 
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 300), 
                        child: ListView.builder(
                          itemCount: iconPairs.length,
                          itemBuilder: (context, index) {
                            bool isHovered = false;
                            return StatefulBuilder(
                              builder: (context, setState) {
                                return MouseRegion(
                                  onEnter: (_) => setState(() => isHovered = true),
                                  onExit: (_) => setState(() => isHovered = false),
                                  cursor: SystemMouseCursors.click, 
                                  child: AnimatedContainer(
                                    duration: Duration(milliseconds: 200),
                                    color: isHovered ? Colors.grey[200] : Colors.white,
                                    child: ListTile(
                                      leading: CachedNetworkImage(
                                        imageUrl: iconPairs[index].logo,
                                        placeholder: (context, url) => Icon(Icons.public_rounded, size: 22, color: Colors.grey[300]),
                                        errorWidget: (context, url, error) => Icon(Icons.public_rounded, size: 22, color: Colors.grey[300]),
                                        width: 24,
                                        height: 24,
                                        fit: BoxFit.cover,
                                      ),
                                      title: Text(
                                        "${iconPairs[index].name} - ${iconPairs[index].url.replaceFirst(RegExp(r'^https?://'), '')}", 
                                        style: TextStyle(fontSize: 15, color: Colors.black.withAlpha(190)),
                                      ),
                                      onTap: () => widget.onSearchText.call(iconPairs[index].url, ""),
                                    )
                                  ),
                                );
                              }
                            ); 
                          },
                        ), 
                      ), 
                    ],
                  ),
                ), 
              ],
            ),
          ),
        ),
      ),
    );
  } 

}

class ChatLogo extends StatelessWidget {
  const ChatLogo({super.key});

  @override
  Widget build(BuildContext context) { 
    return SizedBox(
      width: 58,
      height: 58,
      child: const Image(image: AssetImage('assets/images/logo.png'))
    );
  }
}

class ChatSearchField extends StatefulWidget {
  final Function(String keyword) onChangeKeyword;
  final Function(String searchText, String filepath) onSearchText;
  const ChatSearchField({super.key, required this.onChangeKeyword, required this.onSearchText});

  @override
  State<StatefulWidget> createState() => ChatSearchFieldState();

}

class ChatSearchFieldState extends State<ChatSearchField> {

  late TextEditingController _controller;
  late FocusNode _focusNode;
  late String keyword = "";
  late String selectedFilePath = "";

  @override
  void initState() { 
    super.initState();
    _focusNode = FocusNode();
    _controller = TextEditingController(); 
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [   
        Expanded(
          child: TextField(
            controller: _controller,
            focusNode: _focusNode,
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context)!.askToutCasOrEnterAURL,
              hintStyle: TextStyle(color: Colors.grey),
              prefixIcon: const Icon(Icons.search_rounded, size: 20, color: Colors.grey),
              suffixIcon: selectedFilePath.isNotEmpty ?
              IconButton(
                icon: Icon(Icons.picture_as_pdf_rounded, color: Colors.red, size: 35),
                onPressed: () { 
                  setState(() {
                    selectedFilePath = "";
                  });
                },
              )
              : PopupMenuButton<String>( 
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                offset: const Offset(0, -70),  
                tooltip: AppLocalizations.of(context)!.attachFile, 
                onSelected: (value) => _pickFile(value),  
                child: Container( 
                  margin: EdgeInsets.only(left: 2),
                  child: const Icon(Icons.add_circle_outline_rounded, size: 20, color: Colors.grey),
                ), 
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[ 
                  const PopupMenuItem<String>(
                    value: 'pdf',
                    child: ListTile(
                      leading: Icon(Icons.picture_as_pdf, color: Colors.red),
                      title: Text('PDF'),
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ), 
                ],
              ), 
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0), 
              ),
              enabledBorder: keyword.isNotEmpty ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: BorderSide(color: Colors.transparent, width: 0.5),
              ) : OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: BorderSide(color: Colors.grey, width: 0.5),
              ),
              focusedBorder: keyword.isNotEmpty ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: BorderSide(color: Colors.transparent, width: 0.5),
              ) : OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: BorderSide(color: Colors.grey, width: 0.5),
              ),  
            ),
            onChanged: (String text) {
              keyword = text.trim();
              widget.onChangeKeyword.call(keyword);
            },
            onSubmitted: (String value) => handleSearchSubmitted(value.trim()),
          ),
        ),
      ],
    );
  }

  void handleSearchSubmitted(String value) {  
    widget.onSearchText.call(value, selectedFilePath); 
    setState(() {
      _controller.text = "";
      selectedFilePath = "";
    });
  }

  Future<void> _pickFile(String ext) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom, 
      allowedExtensions: [ext],
    ); 
    if (result != null) {
      setState(() {
        selectedFilePath = result.files.single.path!;
      });
    }
  } 

}
 
/*
class SuggestionList extends StatelessWidget {
  const SuggestionList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        SuggestionTile(
          icon: Icons.location_on_outlined,
          title: "Find the best restaurants near me",
          subtitle:
              "Find highly rated restaurants near me for tonight, include cuisine and price",
        ),
        SizedBox(height: 12),
        SuggestionTile(
          icon: Icons.shopping_bag_outlined,
          title: "Build a weekly meal plan and grocery list",
          subtitle:
              "Create a 7-day dinner meal plan for two adults, 30 minutes per meal",
        ),
        SizedBox(height: 12),
        SuggestionTile(
          icon: Icons.compare_arrows_outlined,
          title: "Compare phone plans and pick the best deal",
          subtitle:
              "Research current mobile phone plans for an individual. Compare...",
        ),
        SizedBox(height: 12),
        SuggestionTile(
          icon: Icons.movie_filter_outlined,
          title: "Find movies and shows I recently viewed",
          subtitle:
              "Scan my recent browsing and surface movies and shows I viewed or...",
        ),
      ],
    );
  }
}
 
class SuggestionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const SuggestionTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) { 
    return ListTile(
      leading: Icon(icon, color: Colors.grey[700]),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: Colors.grey[600]),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      onTap: () {
        // Handle suggestion tap
      },
      hoverColor: Colors.grey[100],  
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
    );
  }
}
*/
