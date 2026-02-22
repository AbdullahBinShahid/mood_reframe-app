import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReframeCard extends StatefulWidget {
  final String emoji;
  final String label;
  final String text;
  final int index;
  final String saveKey;

  const ReframeCard({
    super.key,
    required this.emoji,
    required this.label,
    required this.text,
    required this.index,
    required this.saveKey,
  });

  @override
  State<ReframeCard> createState() => _ReframeCardState();
}

class _ReframeCardState extends State<ReframeCard> {
  bool _isBookmarked = false;

  @override
  void initState() {
    super.initState();
    _loadBookmark();
  }

  Future<void> _loadBookmark() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isBookmarked = prefs.getBool(widget.saveKey) ?? false;
    });
  }

  Future<void> _toggleBookmark() async {
    final prefs = await SharedPreferences.getInstance();
    final newValue = !_isBookmarked;
    await prefs.setBool(widget.saveKey, newValue);
    if (newValue) {
      // Save the actual text too
      final savedList = prefs.getStringList('saved_reframes') ?? [];
      final entry = '${widget.emoji} ${widget.label}: ${widget.text}';
      if (!savedList.contains(entry)) {
        savedList.add(entry);
        await prefs.setStringList('saved_reframes', savedList);
      }
    } else {
      final savedList = prefs.getStringList('saved_reframes') ?? [];
      savedList.removeWhere((e) => e.contains(widget.text));
      await prefs.setStringList('saved_reframes', savedList);
    }
    setState(() {
      _isBookmarked = newValue;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            newValue ? 'Reframe saved! 🌟' : 'Reframe removed',
            style: GoogleFonts.nunito(),
          ),
          backgroundColor: const Color(0xFF7C5CBF),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Animate(
      effects: [
        FadeEffect(
          delay: Duration(milliseconds: 200 * widget.index),
          duration: const Duration(milliseconds: 500),
        ),
        SlideEffect(
          delay: Duration(milliseconds: 200 * widget.index),
          duration: const Duration(milliseconds: 500),
          begin: const Offset(0, 0.3),
          end: Offset.zero,
          curve: Curves.easeOutCubic,
        ),
      ],
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF7C5CBF).withOpacity(0.10),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(widget.emoji, style: const TextStyle(fontSize: 22)),
                      const SizedBox(width: 8),
                      Text(
                        widget.label,
                        style: GoogleFonts.nunito(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF7C5CBF),
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: _toggleBookmark,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Icon(
                        _isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                        key: ValueKey(_isBookmarked),
                        color: _isBookmarked ? const Color(0xFF7C5CBF) : Colors.grey.shade400,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Container(
                height: 1,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF7C5CBF).withOpacity(0.15),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                widget.text,
                style: GoogleFonts.nunito(
                  fontSize: 15,
                  height: 1.65,
                  color: const Color(0xFF3D3450),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}