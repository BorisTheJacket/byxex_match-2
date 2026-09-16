import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import 'package:byxex_match/core/theme/app_text_styles.dart';
import 'package:byxex_match/core/widgets/screen_header.dart';

class _Package {
  final String name;
  final int price;
  const _Package({required this.name, required this.price});
}

const _packages = [
  _Package(name: '1 Hour', price: 4),
  _Package(name: '3 Hours', price: 10),
  _Package(name: '5 Hours', price: 15),
  _Package(name: 'All Day', price: 25),
  _Package(name: 'All Night', price: 15),
  _Package(name: '1 Hour of Ps', price: 5),
];

class PricesScreen extends StatelessWidget {
  const PricesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ByxexBackground(
        child: SafeArea(
          child: Column(
            children: [
              const ByxexHeader(title: 'PRICE'),
              const SizedBox(height: 22),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    for (var i = 0; i < _packages.length; i++) ...[
                      _PriceRow(package: _packages[i], index: i),
                      if (i < _packages.length - 1)
                        const SizedBox(height: 12),
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

class _PriceRow extends StatelessWidget {
  final _Package package;
  final int index;
  const _PriceRow({required this.package, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/price_tile_bg.png'),
          fit: BoxFit.fill,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            package.name,
            style: AppTextStyles.priceRowName,
          ),
          Text(
            '${package.price}',
            style: AppTextStyles.priceRowValue,
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(
          duration: 350.ms,
          delay: Duration(milliseconds: index * 60),
        )
        .slideX(
          begin: 0.1,
          end: 0.0,
          duration: 350.ms,
          delay: Duration(milliseconds: index * 60),
        );
  }
}
