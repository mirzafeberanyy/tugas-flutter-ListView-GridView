import 'package:flutter/material.dart';

class CustomCurvedBottomBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;
  final VoidCallback onDiamondPressed;

  const CustomCurvedBottomBar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
    required this.onDiamondPressed,
  });

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF0096C7);

    return Container(
      height: 72,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(36),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withValues(alpha: 0.35),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavTab(
                index: 0,
                activeIcon: Icons.home_rounded,
                inactiveIcon: Icons.home_outlined,
                label: 'Home',
              ),
              _buildNavTab(
                index: 1,
                activeIcon: Icons.emoji_events_rounded,
                inactiveIcon: Icons.emoji_events_outlined,
                label: 'Trophies',
              ),
              const SizedBox(width: 48), // Ruang untuk tombol diamond di tengah
              _buildNavTab(
                index: 2,
                activeIcon: Icons.favorite_rounded,
                inactiveIcon: Icons.favorite_border_rounded,
                label: 'Favs',
              ),
              _buildNavTab(
                index: 3,
                activeIcon: Icons.explore_rounded,
                inactiveIcon: Icons.explore_outlined,
                label: 'Roster',
              ),
            ],
          ),

          // Tombol Diamond Rotated (+) dengan animasi Framer-Motion-like spring
          Positioned(
            top: -16,
            child: GestureDetector(
              onTap: onDiamondPressed,
              child: Container(
                width: 48,
                height: 48,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Transform.rotate(
                  angle: 0.785398, // 45 derajat (bentuk belah ketupat)
                  child: Container(
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: primaryColor.withValues(alpha: 0.45),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Transform.rotate(
                      angle: -0.785398, // Rotasi balik icon agar tanda + tetap tegak lurus
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavTab({
    required int index,
    required IconData activeIcon,
    required IconData inactiveIcon,
    required String label,
  }) {
    final isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () => onItemSelected(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white.withValues(alpha: 0.22) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: AnimatedScale(
          scale: isSelected ? 1.15 : 1.0,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutBack,
          child: Icon(
            isSelected ? activeIcon : inactiveIcon,
            color: isSelected ? Colors.white : Colors.white70,
            size: 24,
          ),
        ),
      ),
    );
  }
}
