import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import 'package:byxex_match/core/theme/app_colors.dart';
import 'package:byxex_match/core/widgets/screen_header.dart';

class _MenuItem {
  final String name;
  final int price;
  const _MenuItem({required this.name, required this.price});
}

const _drinks = [
  _MenuItem(name: 'Water', price: 1),
  _MenuItem(name: 'Soda', price: 2),
  _MenuItem(name: 'Coconut', price: 4),
  _MenuItem(name: 'Limon', price: 4),
];

const _food = [
  _MenuItem(name: 'Meat Ball', price: 9),
  _MenuItem(name: 'Cake', price: 4),
  _MenuItem(name: 'Puncake', price: 8),
  _MenuItem(name: 'Cheese', price: 7),
];

const _snacks = [
  _MenuItem(name: 'Fire Snack', price: 1),
  _MenuItem(name: 'Carrot', price: 2),
  _MenuItem(name: 'Apple', price: 4),
  _MenuItem(name: 'Ice Snack', price: 4),
];

const _tabs = ['DRINKS', 'FOOD', 'SNACKS'];
const _tabData = [_drinks, _food, _snacks];

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  late final PageController _pageController;
  int _activeTab = 1; // start on FOOD (matches the screen's purpose)

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _activeTab);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToPage(int i) {
    _pageController.animateToPage(
      i,
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/screen_bg.png',
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) =>
                Container(color: AppColors.background),
          ),
          SafeArea(
            child: Column(
              children: [
                // MENU header — text only, decoration is part of menu_bg.png
                Builder(builder: (ctx) {
                  final size = MediaQuery.of(ctx).size;
                  return Padding(
                    padding: EdgeInsets.only(
                      top: size.height * 0.078 - 15,
                      right: size.width * 0.052,
                    ),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: SizedBox(
                        width: size.width * 0.58,
                        child: FittedBox(
                          alignment: Alignment.centerRight,
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'MENU',
                            maxLines: 1,
                            style: const TextStyle(
                              fontFamily: 'BlackHanSans',
                              fontSize: 32,
                              color: Colors.white,
                              letterSpacing: 2.5,
                              height: 1,
                            ),
                          ).animate().fadeIn(duration: 320.ms).slideX(
                                begin: 0.15,
                                curve: Curves.easeOutCubic,
                              ),
                        ),
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 24),

              // ── Category banner (animated label swap) ─────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _CategoryBanner(label: _tabs[_activeTab]),
              ),

              const SizedBox(height: 10),

              // ── Dots indicator ────────────────────────────────────────────
              _DotsIndicator(
                count: _tabs.length,
                active: _activeTab,
                onTap: _goToPage,
              ),

              const SizedBox(height: 14),

              // ── Swipeable grids ───────────────────────────────────────────
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _tabs.length,
                  onPageChanged: (i) => setState(() => _activeTab = i),
                  itemBuilder: (_, page) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _CategoryGrid(items: _tabData[page]),
                  ),
                ),
              ),

              // ── BACK button ───────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                child: ByxexButton(
                  label: 'BACK',
                  onTap: () => context.canPop()
                      ? context.pop()
                      : context.go('/home'),
                ),
              ),
            ],
          ),
          ),
        ],
      ),
    );
  }
}

// ── Category banner ───────────────────────────────────────────────────────
class _CategoryBanner extends StatelessWidget {
  final String label;
  const _CategoryBanner({required this.label});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Decorative banner asset (with fallback if not yet added)
          Positioned.fill(
            child: Image.asset(
              'assets/images/menu_tab_bg.png',
              fit: BoxFit.fill,
              errorBuilder: (_, __, ___) => _BannerFallback(),
            ),
          ),
          // Animated label swap
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 260),
            transitionBuilder: (child, anim) => FadeTransition(
              opacity: anim,
              child: ScaleTransition(scale: anim, child: child),
            ),
            child: Text(
              label,
              key: ValueKey(label),
              style: const TextStyle(
                fontFamily: 'BlackHanSans',
                fontSize: 20,
                color: Colors.white,
                letterSpacing: 2.5,
                height: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Fallback look while menu_tab_bg.png isn't dropped into assets yet.
class _BannerFallback extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: AppColors.accentCyan.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Padding(
            padding: EdgeInsets.only(left: 14),
            child: Icon(Icons.bolt_rounded, color: AppColors.accentCyan, size: 28),
          ),
          Padding(
            padding: EdgeInsets.only(right: 14),
            child: Icon(Icons.bolt_rounded, color: AppColors.accentCyan, size: 28),
          ),
        ],
      ),
    );
  }
}

// ── Dots indicator ────────────────────────────────────────────────────────
class _DotsIndicator extends StatelessWidget {
  final int count;
  final int active;
  final ValueChanged<int> onTap;

  const _DotsIndicator({
    required this.count,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final isActive = i == active;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => onTap(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 240),
              curve: Curves.easeOut,
              width: isActive ? 12 : 9,
              height: isActive ? 12 : 9,
              decoration: BoxDecoration(
                color: isActive
                    ? AppColors.accentGreen
                    : Colors.white.withValues(alpha: 0.35),
                shape: BoxShape.circle,
                boxShadow: isActive
                    ? const [
                        BoxShadow(
                          color: Color(0x6600D455),
                          blurRadius: 10,
                          spreadRadius: 1,
                        ),
                      ]
                    : null,
              ),
            ),
          ),
        );
      }),
    );
  }
}

// ── Grid of 4 product cards ───────────────────────────────────────────────
class _CategoryGrid extends StatelessWidget {
  final List<_MenuItem> items;
  const _CategoryGrid({required this.items});

  @override
  Widget build(BuildContext context) {
    // 2x2 grid pinned to top — cards a bit wider than tall (~1.5:1),
    // matches Figma proportions; empty space drops down to BACK button.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: AspectRatio(
                aspectRatio: 1.5,
                child: _ProductCard(item: items[0], index: 0),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AspectRatio(
                aspectRatio: 1.5,
                child: _ProductCard(item: items[1], index: 1),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: AspectRatio(
                aspectRatio: 1.5,
                child: _ProductCard(item: items[2], index: 2),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AspectRatio(
                aspectRatio: 1.5,
                child: _ProductCard(item: items[3], index: 3),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ── Product card ──────────────────────────────────────────────────────────
class _ProductCard extends StatelessWidget {
  final _MenuItem item;
  final int index;
  const _ProductCard({required this.item, required this.index});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Card background asset (purple/violet shape from Figma)
        Image.asset(
          'assets/images/menu_card_bg.png',
          fit: BoxFit.fill,
          errorBuilder: (_, __, ___) => Container(
            decoration: BoxDecoration(
              color: const Color(0xFF3F35B5),
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
        // Content overlay
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Center(
                  child: Text(
                    item.name.toUpperCase(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'BlackHanSans',
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 1.0,
                      height: 1.05,
                    ),
                  ),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  const Text(
                    'PRICE:',
                    style: TextStyle(
                      fontFamily: 'BlackHanSans',
                      fontSize: 12,
                      color: Colors.white,
                      letterSpacing: 0.8,
                      height: 1,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${item.price}',
                    style: const TextStyle(
                      fontFamily: 'BlackHanSans',
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 0.5,
                      height: 1,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    )
        .animate(key: ValueKey('${item.name}-$index'))
        .fadeIn(
          duration: 320.ms,
          delay: Duration(milliseconds: 60 * index),
        )
        .slideY(
          begin: 0.18,
          duration: 360.ms,
          delay: Duration(milliseconds: 60 * index),
          curve: Curves.easeOutCubic,
        );
  }
}
