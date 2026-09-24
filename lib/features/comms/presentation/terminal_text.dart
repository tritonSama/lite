import 'package:flutter/material.dart';

class TerminalText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final Duration typingSpeed;

  const TerminalText({
    super.key,
    required this.text,
    this.style,
    this.typingSpeed = const Duration(milliseconds: 30),
  });

  @override
  State<TerminalText> createState() => _TerminalTextState();
}

class _TerminalTextState extends State<TerminalText> {
  String _displayedText = '';
  int _currentIndex = 0;
  bool _isTyping = true;

  @override
  void initState() {
    super.initState();
    _startTyping();
  }

  @override
  void didUpdateWidget(covariant TerminalText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) {
      _displayedText = '';
      _currentIndex = 0;
      _isTyping = true;
      _startTyping();
    }
  }

  void _startTyping() async {
    while (_currentIndex < widget.text.length && mounted) {
      await Future.delayed(widget.typingSpeed);
      if (mounted) {
        setState(() {
          _currentIndex++;
          _displayedText = widget.text.substring(0, _currentIndex);
        });
      }
    }
    if (mounted) {
      setState(() {
        _isTyping = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text('$_displayedText${_isTyping ? '_' : ''}', style: widget.style);
  }
}
