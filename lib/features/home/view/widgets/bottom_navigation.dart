import 'package:flutter/material.dart';

class BottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                context,
                icon: Icons.book_outlined,
                label: 'Günlük',
                index: 0,
                isSelected: currentIndex == 0,
              ),
              _buildNavItem(
                context,
                icon: Icons.people_outline,
                label: 'Topluluk',
                index: 1,
                isSelected: currentIndex == 1,
              ),
              _buildNavItem(
                context,
                icon: Icons.home,
                label: 'Ana Sayfa',
                index: 2,
                isSelected: currentIndex == 2,
              ),
              _buildNavItem(
                context,
                icon: Icons.self_improvement_outlined,
                label: 'Meditasyon',
                index: 3,
                isSelected: currentIndex == 3,
              ),
              _buildNavItem(
                context,
                icon: Icons.location_on_outlined,
                label: 'Harita',
                index: 4,
                isSelected: currentIndex == 4,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required int index,
    required bool isSelected,
  }) {
    final theme = Theme.of(context);
    final selectedColor = Color(0xFFBE79DF); // Mor renk
    final unselectedColor = Colors.black; // Siyah renk

    return GestureDetector(
      onTap: () => onTap(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isSelected
                  ? selectedColor.withOpacity(0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              size: isSelected ? 28 : 24,
              color: isSelected ? selectedColor : unselectedColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: isSelected
                ? theme.textTheme.bodySmall?.copyWith(
                    color: selectedColor,
                    fontWeight: FontWeight.w600,
                  )
                : theme.textTheme.bodySmall?.copyWith(
                    color: unselectedColor,
                    fontWeight: FontWeight.normal,
                  ),
          ),
        ],
      ),
    );
  }
}
