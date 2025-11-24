import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:toutcas/src/localization/app_localizations.dart';

class InputURLView extends StatefulWidget { 
  final String? initialValue;
  final ValueChanged<String>? onEnterPressed;
  final ValueChanged<String>? onChanged;

  const InputURLView({
    super.key,
    this.initialValue,
    this.onEnterPressed,
    this.onChanged,
  });

  @override
  State<InputURLView> createState() => _InputURLViewState();
}

class _InputURLViewState extends State<InputURLView> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  late Color textColor;

  @override
  void initState() {
    super.initState();
    textColor = Colors.grey;
    _controller = TextEditingController(text: widget.initialValue);
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose(); 
    super.dispose();
  }

  void _selectAllText() {
    _controller.selection = TextSelection(
      baseOffset: 0,
      extentOffset: _controller.text.length,
    );
  }
  
  void _onFocusChange() { 
    if (!_focusNode.hasFocus) {  
      setState(() {
        textColor = Colors.grey;
        _controller.selection = TextSelection.fromPosition(
          TextPosition(offset: 0),
        );
      });
    } else { 
      setState(() { 
        textColor = Colors.black;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.initialValue != null) {
      _controller.text = widget.initialValue!;
    } 
    return KeyboardListener(
      focusNode: FocusNode(),
      onKeyEvent: (KeyEvent event) {
        if (event is KeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.enter) {
          if (widget.onEnterPressed != null) {
            widget.onEnterPressed!(_controller.text);
          }
        }
      },
      child: GestureDetector(
        onTap: () {
          _focusNode.requestFocus();
          _selectAllText();
        },
        child: TextField( 
          style: TextStyle(fontSize: 13, color: textColor),
          controller: _controller,
          focusNode: _focusNode,
          onChanged: widget.onChanged,
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context)!.askToutCasOrEnterAURL,
            hintStyle: TextStyle(color: Colors.grey),
            filled: true,
            fillColor: Colors.grey[100], 
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 10,
            ),
            isDense: true,
          ),
        ),
      ),
    );
  }
}
