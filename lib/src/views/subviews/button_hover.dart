import 'package:flutter/material.dart';

class IconButtonHover extends StatefulWidget {
  final IconData icon; 
  final bool enabled; 
  final double iconSize; 
  final VoidCallback onPressed;

  const IconButtonHover({super.key, required this.icon, required this.enabled, required this.iconSize, required this.onPressed});

  @override
  State<IconButtonHover> createState() => _IconButtonHoverState();
}

class _IconButtonHoverState extends State<IconButtonHover> { 
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion( 
      onEnter: (_) => setState(() => _isHovering = true), 
      onExit: (_) => setState(() => _isHovering = false), 
      child: Material( 
        shape: RoundedRectangleBorder( 
          borderRadius: BorderRadius.circular(_isHovering ? 8.0 : 30.0),
        ), 
        color: _isHovering ? Colors.grey[100] : Colors.transparent, 
        clipBehavior: Clip.antiAlias, 
        child: GestureDetector(
          onTap: widget.onPressed,
          child: Padding(
            padding: EdgeInsets.all(widget.icon == Icons.menu_open_rounded || widget.icon == Icons.menu_rounded ? 5 : 8.0),
            child: Icon(widget.icon, size: widget.iconSize, color: widget.enabled ? Colors.black.withAlpha(150) : Colors.grey[400]),
          ),
        ),
      ),
    );
  }
}


class IconTextButtonHover extends StatefulWidget {
  final IconData icon; 
  final Color? iconColor; 
  final String text;  
  final bool enabled; 
  final VoidCallback onPressed;

  const IconTextButtonHover({super.key, required this.icon, this.iconColor, required this.text, required this.enabled, required this.onPressed});

  @override
  State<IconTextButtonHover> createState() => _IconTextButtonHoverState();
}

class _IconTextButtonHoverState extends State<IconTextButtonHover> { 
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion( 
      onEnter: (_) => setState(() => _isHovering = true), 
      onExit: (_) => setState(() => _isHovering = false), 
      child: Material( 
        shape: RoundedRectangleBorder( 
          borderRadius: BorderRadius.circular(_isHovering ? 8.0 : 30.0),
        ), 
        color: _isHovering ? Colors.grey[100] : Colors.transparent, 
        clipBehavior: Clip.antiAlias, 
        child: GestureDetector(
          onTap: widget.onPressed,
          child: Container( 
            margin: EdgeInsets.only(top: 2),
            color: Colors.grey[200],
            child: Wrap(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 6, right: 8, bottom: 6, left: 10),
                  child: Icon(widget.icon, size: 20, color: widget.iconColor ?? (widget.enabled ? Colors.black.withAlpha(150) : Colors.grey[400])),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 6, right: 10, bottom: 6, left: 0),
                  child: Text(widget.text, style: TextStyle(color: widget.enabled ? Colors.black.withAlpha(150) : Colors.grey[400])),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}