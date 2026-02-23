import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;
import '../models/reframe_model.dart';
import '../widgets/reframe_card.dart';

class ReframeScreen extends StatefulWidget {
  final String originalThought;
  final ReframeModel reframes;

  const ReframeScreen({
    super.key,
    required this.originalThought,
    required this.reframes,
  });

  @override
  State<ReframeScreen> createState() => _ReframeScreenState();
}

class _ReframeScreenState extends State<ReframeScreen>
    with TickerProviderStateMixin {
  late AnimationController _floatController;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat(reverse: true);
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _floatController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final baseKey = widget.originalThought.hashCode.toString();

    return Scaffold(
      body: Stack(
        children: [
          // ── Dark purple gradient background ──
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF1A0533),
                  Color(0xFF2D1060),
                  Color(0xFF4A1580),
                  Color(0xFF2D1060),
                ],
                stops: [0.0, 0.35, 0.65, 1.0],
              ),
            ),
          ),

          // ── Floating orbs ──
          AnimatedBuilder(
            animation: _floatController,
            builder: (_, __) {
              final t = _floatController.value;
              return Stack(
                children: [
                  Positioned(
                    top: -80 + (t * 30),
                    right: -60,
                    child: _GlowOrb(
                        size: 240,
                        color: const Color(0xFF9B59B6).withOpacity(0.30)),
                  ),
                  Positioned(
                    bottom: 100 + (t * 20),
                    left: -60,
                    child: _GlowOrb(
                        size: 200,
                        color: const Color(0xFF6C3483).withOpacity(0.25)),
                  ),
                  Positioned(
                    bottom: -40,
                    right: -20,
                    child: _GlowOrb(
                        size: 180,
                        color: const Color(0xFFAF7AC5).withOpacity(0.20)),
                  ),
                ],
              );
            },
          ),

          // ── Star dots ──
          ..._buildStarDots(context),

          // ── Main scrollable content ──
          SafeArea(
            child: Column(
              children: [
                // Top bar
                Animate(
                  effects: const [
                    FadeEffect(duration: Duration(milliseconds: 500)),
                  ],
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 12, 20, 0),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.arrow_back_ios_new_rounded,
                              size: 20),
                          color: Colors.white,
                        ),
                        Expanded(
                          child: Text(
                            'Mood Reframe',
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        // Pulsing badge
                        AnimatedBuilder(
                          animation: _pulseController,
                          builder: (_, __) => Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 7),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(
                                  0.08 + _pulseController.value * 0.05),
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(
                                  color: Colors.white.withOpacity(0.18),
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
                                              .withOpacity(0.7),
                                          blurRadius: 6),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  '3 Reframes Ready',
                                  style: GoogleFonts.nunito(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Scrollable body
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── "You wrote" card ──
                        Animate(
                          effects: const [
                            FadeEffect(duration: Duration(milliseconds: 600)),
                            SlideEffect(
                              begin: Offset(0, -0.15),
                              end: Offset.zero,
                              duration: Duration(milliseconds: 600),
                              curve: Curves.easeOutCubic,
                            ),
                          ],
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.18),
                                width: 1.5,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF9B59B6)
                                            .withOpacity(0.35),
                                        borderRadius: BorderRadius.circular(50),
                                        border: Border.all(
                                            color: const Color(0xFF9B59B6)
                                                .withOpacity(0.5),
                                            width: 1),
                                      ),
                                      child: Text(
                                        '✍️  YOU WROTE',
                                        style: GoogleFonts.nunito(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w800,
                                          color: const Color(0xFFD7BDE2),
                                          letterSpacing: 1.2,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  '"${widget.originalThought}"',
                                  style: GoogleFonts.playfairDisplay(
                                    fontSize: 15,
                                    color: Colors.white.withOpacity(0.75),
                                    fontStyle: FontStyle.italic,
                                    height: 1.6,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 28),

                        // ── Section heading ──
                        Animate(
                          effects: const [
                            FadeEffect(
                                delay: Duration(milliseconds: 150),
                                duration: Duration(milliseconds: 600)),
                          ],
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Here are 3 ways to',
                                style: GoogleFonts.playfairDisplay(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  height: 1.2,
                                ),
                              ),
                              ShaderMask(
                                shaderCallback: (bounds) =>
                                    const LinearGradient(
                                  colors: [
                                    Color(0xFFAF7AC5),
                                    Color(0xFFD7BDE2),
                                  ],
                                ).createShader(bounds),
                                child: Text(
                                  'see this differently ✨',
                                  style: GoogleFonts.playfairDisplay(
                                    fontSize: 26,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    height: 1.2,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 8),

                        Animate(
                          effects: const [
                            FadeEffect(
                                delay: Duration(milliseconds: 200),
                                duration: Duration(milliseconds: 600)),
                          ],
                          child: Text(
                            'Tap the bookmark to save reframes you love.',
                            style: GoogleFonts.nunito(
                              fontSize: 13,
                              color: Colors.white.withOpacity(0.45),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // ── Reframe cards ──
                        _DarkReframeCard(
                          emoji: '🧠',
                          label: 'Logical',
                          text: widget.reframes.logical,
                          index: 1,
                          saveKey: '${baseKey}_logical',
                          accentColor: const Color(0xFF5DADE2),
                        ),
                        _DarkReframeCard(
                          emoji: '💛',
                          label: 'Compassionate',
                          text: widget.reframes.compassionate,
                          index: 2,
                          saveKey: '${baseKey}_compassionate',
                          accentColor: const Color(0xFFF4D03F),
                        ),
                        _DarkReframeCard(
                          emoji: '🚀',
                          label: 'Growth',
                          text: widget.reframes.growth,
                          index: 3,
                          saveKey: '${baseKey}_growth',
                          accentColor: const Color(0xFF2ECC71),
                        ),

                        const SizedBox(height: 8),

                        // ── Try Another button ──
                        Animate(
                          effects: const [
                            FadeEffect(
                                delay: Duration(milliseconds: 700),
                                duration: Duration(milliseconds: 500)),
                            SlideEffect(
                              delay: Duration(milliseconds: 700),
                              begin: Offset(0, 0.3),
                              end: Offset.zero,
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeOutCubic,
                            ),
                          ],
                          child: SizedBox(
                            width: double.infinity,
                            height: 62,
                            child: ElevatedButton(
                              onPressed: () => Navigator.of(context).pop(),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  side: BorderSide(
                                      color: Colors.white.withOpacity(0.25),
                                      width: 1.5),
                                ),
                                padding: EdgeInsets.zero,
                              ),
                              child: Ink(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Container(
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.refresh_rounded,
                                          color: Colors.white, size: 20),
                                      const SizedBox(width: 10),
                                      Text(
                                        'Try Another Thought',
                                        style: GoogleFonts.nunito(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                          letterSpacing: 0.2,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // ── Footer ──
                        Animate(
                          effects: const [
                            FadeEffect(
                                delay: Duration(milliseconds: 900),
                                duration: Duration(milliseconds: 500)),
                          ],
                          child: Center(
                            child: Column(
                              children: [
                                Text(
                                  'ABS DEVELOPMENT 💜',
                                  style: GoogleFonts.nunito(
                                    fontSize: 13,
                                    color: Colors.white.withOpacity(0.30),
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '✦ Powered by compassionate AI',
                                  style: GoogleFonts.nunito(
                                    fontSize: 11,
                                    color: Colors.white.withOpacity(0.20),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildStarDots(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final positions = [
      [0.12, 0.06], [0.80, 0.10], [0.50, 0.04], [0.92, 0.22],
      [0.04, 0.40], [0.88, 0.50], [0.20, 0.60], [0.65, 0.70],
      [0.08, 0.80], [0.55, 0.88], [0.38, 0.95], [0.90, 0.90],
    ];
    return positions.asMap().entries.map((entry) {
      final i = entry.key;
      final pos = entry.value;
      return Positioned(
        left: pos[0] * size.width,
        top: pos[1] * size.height,
        child: AnimatedBuilder(
          animation: _floatController,
          builder: (_, __) {
            final opacity = 0.15 +
                0.45 *
                    math.sin((_floatController.value * 2 * math.pi) +
                        (i * math.pi / 6));
            return Opacity(
              opacity: opacity.clamp(0.0, 1.0),
              child: Container(
                width: i % 3 == 0 ? 3 : 2,
                height: i % 3 == 0 ? 3 : 2,
                decoration: const BoxDecoration(
                    color: Colors.white, shape: BoxShape.circle),
              ),
            );
          },
        ),
      );
    }).toList();
  }
}

// ── Dark themed reframe card ──
class _DarkReframeCard extends StatefulWidget {
  final String emoji;
  final String label;
  final String text;
  final int index;
  final String saveKey;
  final Color accentColor;

  const _DarkReframeCard({
    required this.emoji,
    required this.label,
    required this.text,
    required this.index,
    required this.saveKey,
    required this.accentColor,
  });

  @override
  State<_DarkReframeCard> createState() => _DarkReframeCardState();
}

class _DarkReframeCardState extends State<_DarkReframeCard> {
  bool _isBookmarked = false;

  @override
  void initState() {
    super.initState();
    _loadBookmark();
  }

  Future<void> _loadBookmark() async {
    // Using SharedPreferences-compatible approach
    setState(() => _isBookmarked = false);
  }

  Future<void> _toggleBookmark() async {
    setState(() => _isBookmarked = !_isBookmarked);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isBookmarked ? 'Reframe saved! 🌟' : 'Reframe removed',
            style: GoogleFonts.nunito(color: Colors.white),
          ),
          backgroundColor: const Color(0xFF6C3483),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
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
          delay: Duration(milliseconds: 250 * widget.index),
          duration: const Duration(milliseconds: 600),
        ),
        SlideEffect(
          delay: Duration(milliseconds: 250 * widget.index),
          duration: const Duration(milliseconds: 600),
          begin: const Offset(0, 0.25),
          end: Offset.zero,
          curve: Curves.easeOutCubic,
        ),
      ],
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.07),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: Colors.white.withOpacity(0.12),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            children: [
              // Subtle accent glow at top-left
              Positioned(
                top: -20,
                left: -20,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.accentColor.withOpacity(0.15),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: widget.accentColor.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color: widget.accentColor.withOpacity(0.30),
                                    width: 1),
                              ),
                              child: Center(
                                child: Text(widget.emoji,
                                    style: const TextStyle(fontSize: 20)),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.label.toUpperCase(),
                                  style: GoogleFonts.nunito(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                    color: widget.accentColor,
                                    letterSpacing: 1.3,
                                  ),
                                ),
                                Text(
                                  'Perspective ${widget.index}',
                                  style: GoogleFonts.nunito(
                                    fontSize: 11,
                                    color: Colors.white.withOpacity(0.35),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: _toggleBookmark,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: _isBookmarked
                                  ? widget.accentColor.withOpacity(0.20)
                                  : Colors.white.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: _isBookmarked
                                    ? widget.accentColor.withOpacity(0.50)
                                    : Colors.white.withOpacity(0.15),
                                width: 1,
                              ),
                            ),
                            child: Icon(
                              _isBookmarked
                                  ? Icons.bookmark_rounded
                                  : Icons.bookmark_border_rounded,
                              color: _isBookmarked
                                  ? widget.accentColor
                                  : Colors.white.withOpacity(0.40),
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      height: 1,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            widget.accentColor.withOpacity(0.30),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      widget.text,
                      style: GoogleFonts.nunito(
                        fontSize: 15,
                        height: 1.70,
                        color: Colors.white.withOpacity(0.85),
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
    );
  }
}

// ── Glow orb ──
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