import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/reframe_model.dart';
import '../widgets/reframe_card.dart';

class ReframeScreen extends StatelessWidget {
  final String originalThought;
  final ReframeModel reframes;

  const ReframeScreen({
    super.key,
    required this.originalThought,
    required this.reframes,
  });

  @override
  Widget build(BuildContext context) {
    // Use a unique key based on the thought for bookmark storage
    final baseKey = originalThought.hashCode.toString();

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
          child: Column(
            children: [
              // Top bar
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 12, 16, 0),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.arrow_back_ios_new_rounded),
                      color: const Color(0xFF7C5CBF),
                    ),
                    Expanded(
                      child: Text(
                        'Mood Reframe',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF3D3450),
                        ),
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        'assets/logo.png',
                        width: 24,
                        height: 24,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),

              // Scrollable content
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Original thought card
                      Animate(
                        effects: const [
                          FadeEffect(duration: Duration(milliseconds: 500)),
                          SlideEffect(
                            begin: Offset(0, -0.15),
                            end: Offset.zero,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.easeOutCubic,
                          ),
                        ],
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.85),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: const Color(0xFF7C5CBF).withOpacity(0.15),
                              width: 1.5,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'You wrote:',
                                style: GoogleFonts.nunito(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF7C5CBF),
                                  letterSpacing: 1.0,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '"$originalThought"',
                                style: GoogleFonts.playfairDisplay(
                                  fontSize: 15,
                                  color: Colors.grey.shade600,
                                  fontStyle: FontStyle.italic,
                                  height: 1.55,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 28),

                      // Section label
                      Animate(
                        effects: const [
                          FadeEffect(
                              delay: Duration(milliseconds: 150),
                              duration: Duration(milliseconds: 500)),
                        ],
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Here are 3 ways to',
                              style: GoogleFonts.playfairDisplay(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF3D3450),
                                height: 1.2,
                              ),
                            ),
                            Text(
                              'see this differently ✨',
                              style: GoogleFonts.playfairDisplay(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF7C5CBF),
                                height: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Reframe cards
                      ReframeCard(
                        emoji: '🧠',
                        label: 'Logical',
                        text: reframes.logical,
                        index: 1,
                        saveKey: '${baseKey}_logical',
                      ),
                      ReframeCard(
                        emoji: '💛',
                        label: 'Compassionate',
                        text: reframes.compassionate,
                        index: 2,
                        saveKey: '${baseKey}_compassionate',
                      ),
                      ReframeCard(
                        emoji: '🚀',
                        label: 'Growth',
                        text: reframes.growth,
                        index: 3,
                        saveKey: '${baseKey}_growth',
                      ),

                      const SizedBox(height: 8),

                      // Try Another Thought button
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
                          height: 60,
                          child: OutlinedButton(
                            onPressed: () => Navigator.of(context).pop(),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                color: Color(0xFF7C5CBF),
                                width: 2,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.refresh_rounded,
                                  color: Color(0xFF7C5CBF),
                                  size: 20,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  'Try Another Thought',
                                  style: GoogleFonts.nunito(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF7C5CBF),
                                    letterSpacing: 0.2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Gentle reminder
                      Animate(
                        effects: const [
                          FadeEffect(
                              delay: Duration(milliseconds: 850),
                              duration: Duration(milliseconds: 500)),
                        ],
                        child: Center(
                          child: Text(
                            'ABS DEVELOPMENT 💜',
                            style: GoogleFonts.nunito(
                              fontSize: 14,
                              color: Colors.grey.shade400,
                              fontWeight: FontWeight.w600,
                            ),
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
      ),
    );
  }
}
