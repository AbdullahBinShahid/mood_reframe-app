import 'package:mood_reframe/services/ai_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;

import 'reframe_screen.dart';

class DumpScreen extends StatefulWidget {
  const DumpScreen({super.key});

  @override
  State<DumpScreen> createState() => _DumpScreenState();
}

class _DumpScreenState extends State<DumpScreen>
    with TickerProviderStateMixin {
  final TextEditingController _thoughtController = TextEditingController();
  String? _selectedMood;
  bool _isLoading = false;
  late AnimationController _floatController;
  late AnimationController _pulseController;

  final List<Map<String, String>> _moods = [
    {'label': 'Stressed', 'emoji': '😤'},
    {'label': 'Anxious', 'emoji': '😰'},
    {'label': 'Overwhelmed', 'emoji': '😵'},
    {'label': 'Sad', 'emoji': '😢'},
  ];

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _thoughtController.dispose();
    _floatController.dispose();
    _pulseController.dispose();
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: Colors.white,
        title: Row(
          children: [
            const Text('🌧️', style: TextStyle(fontSize: 24)),
            const SizedBox(width: 10),
            Text('Something went wrong',
                style: GoogleFonts.nunito(
                    fontWeight: FontWeight.w700, fontSize: 17)),
          ],
        ),
        content: Text(message,
            style:
                GoogleFonts.nunito(fontSize: 14, color: Colors.grey.shade600)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Try Again',
                style: GoogleFonts.nunito(
                    color: const Color.fromARGB(255, 139, 106, 209),
                    fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ── Gradient background ──
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF1A0533),
                  Color(0xFF2D1060),
                  Color(0xFF4A1580),
                  Color.fromARGB(255, 150, 115, 209),
                ],
                stops: [0.0, 0.35, 0.65, 1.0],
              ),
            ),
          ),

          // ── Decorative blurred orbs ──
          AnimatedBuilder(
            animation: _floatController,
            builder: (_, __) {
              final t = _floatController.value;
              return Stack(
                children: [
                  Positioned(
                    top: -60 + (t * 30),
                    right: -60,
                    child: _GlowOrb(
                        size: 260,
                        color: const Color(0xFF9B59B6).withOpacity(0.35)),
                  ),
                  Positioned(
                    top: 180 - (t * 20),
                    left: -80,
                    child: _GlowOrb(
                        size: 200,
                        color: const Color(0xFF6C3483).withOpacity(0.25)),
                  ),
                  Positioned(
                    bottom: 200 + (t * 25),
                    right: -40,
                    child: _GlowOrb(
                        size: 180,
                        color: const Color(0xFFAF7AC5).withOpacity(0.20)),
                  ),
                  Positioned(
                    bottom: -40,
                    left: -30,
                    child: _GlowOrb(
                        size: 220,
                        color: const Color(0xFF7D3C98).withOpacity(0.30)),
                  ),
                ],
              );
            },
          ),

          // ── Floating particles ──
          ...List.generate(6, (i) => _FloatingParticle(index: i, controller: _floatController)),

          // ── Star dots ──
          ..._buildStarDots(),

          // ── Main content ──
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top bar
                  Animate(
                    effects: const [
                      FadeEffect(duration: Duration(milliseconds: 700)),
                      SlideEffect(
                        begin: Offset(0, -0.15),
                        end: Offset.zero,
                        duration: Duration(milliseconds: 700),
                        curve: Curves.easeOutCubic,
                      ),
                    ],
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                    color: Colors.white.withOpacity(0.25),
                                    width: 1),
                              ),
                              child: const Center(
                                child: Image(
                                  image: AssetImage('assets/logo.png'),
                                  width: 150,
                                  height: 150,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Mood Reframe',
                              style: GoogleFonts.playfairDisplay(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ],
                        ),
                        AnimatedBuilder(
                          animation: _pulseController,
                          builder: (_, __) => Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white
                                  .withOpacity(0.1 + _pulseController.value * 0.05),
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(
                                  color: Colors.white.withOpacity(0.2),
                                  width: 1),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 7,
                                  height: 7,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF2ECC71),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                          color: const Color(0xFF2ECC71)
                                              .withOpacity(0.6),
                                          blurRadius: 6)
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text('AI Ready',
                                    style: GoogleFonts.nunito(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 36),

                  // Hero text
                  Animate(
                    effects: const [
                      FadeEffect(
                          delay: Duration(milliseconds: 150),
                          duration: Duration(milliseconds: 700)),
                      SlideEffect(
                        delay: Duration(milliseconds: 150),
                        begin: Offset(0, 0.2),
                        end: Offset.zero,
                        duration: Duration(milliseconds: 700),
                        curve: Curves.easeOutCubic,
                      ),
                    ],
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 7),
                          decoration: BoxDecoration(
                            color: const Color(0xFFAF7AC5).withOpacity(0.25),
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(
                                color: const Color(0xFFAF7AC5).withOpacity(0.4),
                                width: 1),
                          ),
                          child: Text(
                            '🧠  AI-powered thought reframing',
                            style: GoogleFonts.nunito(
                              color: const Color(0xFFD7BDE2),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "What's weighing\non you right now?",
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 34,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Pour it out — no judgement here.\nWe\'ll help you see it differently. 💜',
                          style: GoogleFonts.nunito(
                            fontSize: 15,
                            color: Colors.white.withOpacity(0.65),
                            fontWeight: FontWeight.w500,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Stats row
                  Animate(
                    effects: const [
                      FadeEffect(
                          delay: Duration(milliseconds: 250),
                          duration: Duration(milliseconds: 700)),
                    ],
                    child: Row(
                      children: [
                        _StatBadge(emoji: '✨', label: '3 Reframes'),
                        const SizedBox(width: 10),
                        _StatBadge(emoji: '⚡', label: 'Instant'),
                        const SizedBox(width: 10),
                        _StatBadge(emoji: '🔒', label: 'Private'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Text input card
                  Animate(
                    effects: const [
                      FadeEffect(
                          delay: Duration(milliseconds: 300),
                          duration: Duration(milliseconds: 700)),
                      SlideEffect(
                        delay: Duration(milliseconds: 300),
                        begin: Offset(0, 0.2),
                        end: Offset.zero,
                        duration: Duration(milliseconds: 700),
                        curve: Curves.easeOutCubic,
                      ),
                    ],
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.10),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.20),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 30,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                            child: Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFE74C3C),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFF39C12),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF2ECC71),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'Your thought space',
                                  style: GoogleFonts.nunito(
                                    color: Colors.white.withOpacity(0.45),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          TextField(
                            controller: _thoughtController,
                            minLines: 5,
                            maxLines: 8,
                            onChanged: (_) => setState(() {}),
                            style: GoogleFonts.nunito(
                              fontSize: 16,
                              color: Colors.white,
                              height: 1.65,
                              fontWeight: FontWeight.w500,
                            ),
                            decoration: InputDecoration(
                              hintText:
                                  '"I always mess things up. Nothing ever works out for me…"',
                              hintStyle: GoogleFonts.nunito(
                                color: Colors.white.withOpacity(0.30),
                                fontSize: 15,
                                height: 1.55,
                                fontStyle: FontStyle.italic,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                            ),
                            cursorColor: const Color(0xFFAF7AC5),
                          ),
                          // Character count
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  '${_thoughtController.text.length} chars',
                                  style: GoogleFonts.nunito(
                                    color: Colors.white.withOpacity(0.30),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Mood chips
                  Animate(
                    effects: const [
                      FadeEffect(
                          delay: Duration(milliseconds: 400),
                          duration: Duration(milliseconds: 600)),
                    ],
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'HOW ARE YOU FEELING?',
                          style: GoogleFonts.nunito(
                            fontSize: 11,
                            color: Colors.white.withOpacity(0.45),
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: _moods.map((mood) {
                            final isSelected = _selectedMood == mood['label'];
                            return GestureDetector(
                              onTap: () => setState(() =>
                                  _selectedMood =
                                      isSelected ? null : mood['label']),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 10),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? const Color(0xFF9B59B6)
                                      : Colors.white.withOpacity(0.10),
                                  borderRadius: BorderRadius.circular(50),
                                  border: Border.all(
                                    color: isSelected
                                        ? const Color(0xFF9B59B6)
                                        : Colors.white.withOpacity(0.20),
                                    width: 1.5,
                                  ),
                                  boxShadow: isSelected
                                      ? [
                                          BoxShadow(
                                            color: const Color(0xFF9B59B6)
                                                .withOpacity(0.4),
                                            blurRadius: 14,
                                            offset: const Offset(0, 4),
                                          )
                                        ]
                                      : [],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(mood['emoji']!,
                                        style: const TextStyle(fontSize: 16)),
                                    const SizedBox(width: 7),
                                    Text(
                                      mood['label']!,
                                      style: GoogleFonts.nunito(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
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

                  const SizedBox(height: 32),

                  // Reframe button
                  Animate(
                    effects: const [
                      FadeEffect(
                          delay: Duration(milliseconds: 500),
                          duration: Duration(milliseconds: 600)),
                      SlideEffect(
                        delay: Duration(milliseconds: 500),
                        begin: Offset(0, 0.3),
                        end: Offset.zero,
                        duration: Duration(milliseconds: 600),
                        curve: Curves.easeOutCubic,
                      ),
                    ],
                    child: SizedBox(
                      width: double.infinity,
                      height: 62,
                      child: ElevatedButton(
                        onPressed:
                            (_isLoading || _thoughtController.text.trim().isEmpty)
                                ? null
                                : _onReframePressed,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          disabledBackgroundColor: Colors.white.withOpacity(0.08),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: EdgeInsets.zero,
                        ),
                        child: Ink(
                          decoration: BoxDecoration(
                            gradient: _thoughtController.text.trim().isEmpty || _isLoading
                                ? null
                                : const LinearGradient(
                                    colors: [
                                      Color(0xFF8E44AD),
                                      Color(0xFF6C3483),
                                    ],
                                  ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: _thoughtController.text.trim().isEmpty || _isLoading
                                ? []
                                : [
                                    BoxShadow(
                                      color: const Color(0xFF8E44AD).withOpacity(0.5),
                                      blurRadius: 20,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                          ),
                          child: Container(
                            alignment: Alignment.center,
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
                                          fontWeight: FontWeight.w800,
                                          color: _thoughtController.text.trim().isEmpty
                                              ? Colors.white.withOpacity(0.3)
                                              : Colors.white,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Icon(
                                        Icons.auto_awesome_rounded,
                                        color: _thoughtController.text.trim().isEmpty
                                            ? Colors.white.withOpacity(0.3)
                                            : Colors.white,
                                        size: 20,
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Footer
                  Animate(
                    effects: const [
                      FadeEffect(
                          delay: Duration(milliseconds: 600),
                          duration: Duration(milliseconds: 600)),
                    ],
                    child: Center(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.lock_outline_rounded,
                                  size: 13,
                                  color: Colors.white.withOpacity(0.35)),
                              const SizedBox(width: 5),
                              Text(
                                'Your thoughts are private & never stored',
                                style: GoogleFonts.nunito(
                                  fontSize: 12,
                                  color: Colors.white.withOpacity(0.35),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '✦ Powered by ABS DEVELOPMENTS ✦',
                            style: GoogleFonts.nunito(
                              fontSize: 12,
                              color: Colors.white.withOpacity(0.25),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildStarDots() {
    final positions = [
      [0.15, 0.08], [0.75, 0.12], [0.45, 0.05], [0.90, 0.25],
      [0.05, 0.35], [0.85, 0.45], [0.25, 0.55], [0.70, 0.60],
      [0.10, 0.72], [0.60, 0.80], [0.40, 0.90], [0.92, 0.85],
    ];
    return positions.asMap().entries.map((entry) {
      final i = entry.key;
      final pos = entry.value;
      return Positioned(
        left: pos[0] * MediaQuery.of(context).size.width,
        top: pos[1] * MediaQuery.of(context).size.height,
        child: AnimatedBuilder(
          animation: _floatController,
          builder: (_, __) {
            final opacity = 0.2 +
                0.5 *
                    math.sin((_floatController.value * 2 * math.pi) +
                        (i * math.pi / 6));
            return Opacity(
              opacity: opacity.clamp(0.0, 1.0),
              child: Container(
                width: i % 3 == 0 ? 3 : 2,
                height: i % 3 == 0 ? 3 : 2,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            );
          },
        ),
      );
    }).toList();
  }
}

// ── Glow orb widget ──
class _GlowOrb extends StatelessWidget {
  final double size;
  final Color color;
  const _GlowOrb({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(color: color, blurRadius: 80, spreadRadius: 20),
        ],
      ),
    );
  }
}

// ── Floating particle ──
class _FloatingParticle extends StatelessWidget {
  final int index;
  final AnimationController controller;

  const _FloatingParticle({required this.index, required this.controller});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final positions = [
      [0.2, 0.3], [0.8, 0.2], [0.5, 0.5],
      [0.1, 0.65], [0.9, 0.7], [0.6, 0.15],
    ];
    final pos = positions[index % positions.length];
    final emojis = ['✦', '◆', '○', '✦', '◇', '●'];

    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        final offset = math.sin((controller.value * 2 * math.pi) +
                (index * math.pi / 3)) *
            15;
        return Positioned(
          left: pos[0] * size.width,
          top: pos[1] * size.height + offset,
          child: Opacity(
            opacity: 0.08,
            child: Text(
              emojis[index % emojis.length],
              style: TextStyle(
                color: Colors.white,
                fontSize: index % 2 == 0 ? 18 : 12,
              ),
            ),
          ),
        );
      },
    );
  }
}

// ── Stat badge ──
class _StatBadge extends StatelessWidget {
  final String emoji;
  final String label;
  const _StatBadge({required this.emoji, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: Colors.white.withOpacity(0.15), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 13)),
          const SizedBox(width: 5),
          Text(
            label,
            style: GoogleFonts.nunito(
              color: Colors.white.withOpacity(0.70),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}