import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import 'package:byxex_match/core/widgets/screen_header.dart';

const _promos = [
  'Night Battle – night unlimited gaming with a 50% discount from 00:00 to 06:00.',
  'Hourly Assault – buy 3 hours of gameplay and get 1 hour free.',
  'Birthday – Your Rules – 50% discount on your birthday + 2 friends play for free.',
  'Bring a Friend – Get a Bonus – the new customer gets 1 hour free, and the inviter gets 30 minutes.',
  'Happy Hours – 30% discount on all PCs on weekdays from 12:00 to 16:00.',
];

class PromotionsScreen extends StatelessWidget {
  const PromotionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ByxexBackground(
        child: SafeArea(
          child: Column(
            children: [
              ByxexHeader(title: 'DISCOUNT'),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: _promos.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    return Text(
                      _promos[index],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'BlackHanSans',
                        fontSize: 19,
                        color: Colors.white,
                        letterSpacing: 0.5,
                        height: 1.45,
                      ),
                    )
                        .animate()
                        .fadeIn(
                          duration: 350.ms,
                          delay: Duration(milliseconds: index * 70),
                        );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
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
