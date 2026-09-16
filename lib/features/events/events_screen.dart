import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import 'package:byxex_match/core/widgets/screen_header.dart';

class _Event {
  final String image;
  final String title;
  final String round;
  final String date;
  const _Event({
    required this.image,
    required this.title,
    required this.round,
    required this.date,
  });
}

const _events = [
  _Event(
    image: 'assets/images/event_1.png',
    title: 'CUP 2026',
    round: '1/4',
    date: '19.06.2026',
  ),
  _Event(
    image: 'assets/images/event_2.png',
    title: 'CUP 2026',
    round: '1/2',
    date: '25.06.2026',
  ),
  _Event(
    image: 'assets/images/event_3.png',
    title: 'CUP 2026',
    round: 'FINAL',
    date: '10.07.2026',
  ),
];

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ByxexBackground(
        child: SafeArea(
          child: Column(
            children: [
              const ByxexHeader(title: 'EVENT'),
              const SizedBox(height: 22),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    for (var i = 0; i < _events.length; i++) ...[
                      _EventCard(event: _events[i], index: i),
                      if (i < _events.length - 1)
                        const SizedBox(height: 14),
                    ],
                  ],
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
                child: ByxexButton(
                  label: 'BACK',
                  onTap: () => context.pop(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EventCard extends StatelessWidget {
  final _Event event;
  final int index;
  const _EventCard({required this.event, required this.index});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Image banner with title + round overlaid on bottom
        AspectRatio(
          aspectRatio: 16 / 5,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(event.image, fit: BoxFit.cover),
                // bottom-only dark gradient so text reads
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.55),
                      ],
                      stops: const [0.45, 1.0],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 8, 14, 10),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          event.title,
                          style: const TextStyle(
                            fontFamily: 'BlackHanSans',
                            fontSize: 28,
                            color: Colors.white,
                            letterSpacing: 1.0,
                            height: 1,
                            shadows: [
                              Shadow(
                                color: Colors.black,
                                blurRadius: 6,
                                offset: Offset(1, 2),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          event.round,
                          style: const TextStyle(
                            fontFamily: 'BlackHanSans',
                            fontSize: 28,
                            color: Colors.white,
                            letterSpacing: 1.0,
                            height: 1,
                            shadows: [
                              Shadow(
                                color: Colors.black,
                                blurRadius: 6,
                                offset: Offset(1, 2),
                              ),
                            ],
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
        const SizedBox(height: 4),
        // Date label — white, right-aligned, under the card (no blue strip)
        Padding(
          padding: const EdgeInsets.only(right: 4),
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              event.date,
              style: const TextStyle(
                fontFamily: 'BlackHanSans',
                fontSize: 20,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ],
    )
        .animate()
        .fadeIn(
          duration: 400.ms,
          delay: Duration(milliseconds: index * 80),
        )
        .slideY(
          begin: 0.1,
          end: 0.0,
          duration: 400.ms,
          delay: Duration(milliseconds: index * 80),
        );
  }
}
