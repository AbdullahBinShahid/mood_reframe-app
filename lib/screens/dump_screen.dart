import 'package:mood_reframe/services/ai_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import 'reframe_screen.dart';

class DumpScreen extends StatefulWidget {
  const DumpScreen({super.key});

  @override
  State<DumpScreen> createState() => _DumpScreenState();
}

class _DumpScreenState extends State<DumpScreen> {
  final TextEditingController _thoughtController = TextEditingController();
  String? _selectedMood;
  bool _isLoading = false;

  final List<Map<String, String>> _moods = [
    {'label': 'Stressed', 'emoji': '😤'},
    {'label': 'Anxious', 'emoji': '😰'},
    {'label': 'Overwhelmed', 'emoji': '😵'},
    {'label': 'Sad', 'emoji': '😢'},
  ];

  @override
  void dispose() {
    _thoughtController.dispose();
    super.dispose();
  }

  Future<void> _onReframePressed() async {
    if (_thoughtController.text.trim().isEmpty) return;

    setState(() => _isLoading = true);

    try {
      final reframes = await AiService.getReframes(
        thought: _thoughtController.text.trim(),
        mood: _selectedMood,
      );

      if (!mounted) return;

      await Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder: (_, animation, __) => ReframeScreen(
            originalThought: _thoughtController.text.trim(),
            reframes: reframes,
          ),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.05),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                    parent: animation, curve: Curves.easeOutCubic)),
                child: child,
              ),
            );
          },
          transitionDuration: const Duration(milliseconds: 400),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      _showError(e.toString().replaceAll('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Text('🌧️', style: TextStyle(fontSize: 24)),
            const SizedBox(width: 10),
            Text(
              'Something went wrong',
              style:
                  GoogleFonts.nunito(fontWeight: FontWeight.w700, fontSize: 18),
            ),
          ],
        ),
        content: Text(
          message,
          style: GoogleFonts.nunito(fontSize: 15, color: Colors.grey.shade700),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Try Again',
              style: GoogleFonts.nunito(
                color: const Color(0xFF7C5CBF),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF3EFFF), Color(0xFFFFFFFF)],
            stops: [0.0, 1.0],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Animate(
                  effects: const [
                    FadeEffect(duration: Duration(milliseconds: 600)),
                    SlideEffect(
                      begin: Offset(0, -0.2),
                      end: Offset.zero,
                      duration: Duration(milliseconds: 600),
                      curve: Curves.easeOutCubic,
                    ),
                  ],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              'assets/logo.png',
                              width: 42,
                              height: 42,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Mood Reframe',
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 26,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF3D3450),
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),
                      Text(
                        'What\'s weighing on\nyou right now?',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF3D3450),
                          height: 1.25,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Write it out. This is a safe space.',
                        style: GoogleFonts.nunito(
                          fontSize: 16,
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Text input
                Animate(
                  effects: const [
                    FadeEffect(
                        delay: Duration(milliseconds: 200),
                        duration: Duration(milliseconds: 600)),
                    SlideEffect(
                      delay: Duration(milliseconds: 200),
                      begin: Offset(0, 0.2),
                      end: Offset.zero,
                      duration: Duration(milliseconds: 600),
                      curve: Curves.easeOutCubic,
                    ),
                  ],
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF7C5CBF).withOpacity(0.10),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _thoughtController,
                      minLines: 5,
                      maxLines: 8,
                      onChanged: (_) => setState(() {}),
                      style: GoogleFonts.nunito(
                        fontSize: 16,
                        color: const Color(0xFF3D3450),
                        height: 1.65,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        hintText:
                            'e.g. "I always mess things up. Nothing ever works out for me…"',
                        hintStyle: GoogleFonts.nunito(
                          color: Colors.grey.shade400,
                          fontSize: 15,
                          height: 1.55,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(20),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Mood chips
                Animate(
                  effects: const [
                    FadeEffect(
                        delay: Duration(milliseconds: 350),
                        duration: Duration(milliseconds: 600)),
                  ],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'How are you feeling? (optional)',
                        style: GoogleFonts.nunito(
                          fontSize: 14,
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.3,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: _moods.map((mood) {
                          final isSelected = _selectedMood == mood['label'];
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedMood =
                                    isSelected ? null : mood['label'];
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFF7C5CBF)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(
                                  color: isSelected
                                      ? const Color(0xFF7C5CBF)
                                      : Colors.grey.shade200,
                                  width: 1.5,
                                ),
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: const Color(0xFF7C5CBF)
                                              .withOpacity(0.25),
                                          blurRadius: 12,
                                          offset: const Offset(0, 4),
                                        ),
                                      ]
                                    : [],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(mood['emoji']!,
                                      style: const TextStyle(fontSize: 16)),
                                  const SizedBox(width: 6),
                                  Text(
                                    mood['label']!,
                                    style: GoogleFonts.nunito(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: isSelected
                                          ? Colors.white
                                          : const Color(0xFF3D3450),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 36),

                // Reframe button
                Animate(
                  effects: const [
                    FadeEffect(
                        delay: Duration(milliseconds: 450),
                        duration: Duration(milliseconds: 600)),
                    SlideEffect(
                      delay: Duration(milliseconds: 450),
                      begin: Offset(0, 0.3),
                      end: Offset.zero,
                      duration: Duration(milliseconds: 600),
                      curve: Curves.easeOutCubic,
                    ),
                  ],
                  child: SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      onPressed:
                          (_isLoading || _thoughtController.text.trim().isEmpty)
                              ? null
                              : _onReframePressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7C5CBF),
                        disabledBackgroundColor: Colors.grey.shade200,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        shadowColor: const Color(0xFF7C5CBF).withOpacity(0.4),
                      ).copyWith(
                        elevation: MaterialStateProperty.resolveWith<double>(
                          (states) =>
                              states.contains(MaterialState.disabled) ? 0 : 6,
                        ),
                        shadowColor: MaterialStateProperty.all(
                          const Color(0xFF7C5CBF).withOpacity(0.35),
                        ),
                      ),
                      child: _isLoading
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'Finding new perspectives…',
                                  style: GoogleFonts.nunito(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Reframe It',
                                  style: GoogleFonts.nunito(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color:
                                        _thoughtController.text.trim().isEmpty
                                            ? Colors.grey.shade400
                                            : Colors.white,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Icon(
                                  Icons.arrow_forward_rounded,
                                  color: _thoughtController.text.trim().isEmpty
                                      ? Colors.grey.shade400
                                      : Colors.white,
                                ),
                              ],
                            ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Footer note
                Center(
                  child: Text(
                    '✦ Powered by compassionate AI',
                    style: GoogleFonts.nunito(
                      fontSize: 13,
                      color: Colors.grey.shade400,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
