import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';

class EmotionSelector extends StatelessWidget {
  final String selectedEmotion;
  final Function(String) onEmotionSelected;

  const EmotionSelector({
    super.key,
    required this.selectedEmotion,
    required this.onEmotionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // First row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: AppConstants.emotionEmojis.take(5).map((emoji) {
            final isSelected = emoji == selectedEmotion;
            return GestureDetector(
              onTap: () => onEmotionSelected(emoji),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary.withOpacity(0.2)
                      : Colors.transparent,
                  border: Border.all(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(
                            context,
                          ).colorScheme.outline.withOpacity(0.3),
                    width: isSelected ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(emoji, style: const TextStyle(fontSize: 32)),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 12),
        // Second row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: AppConstants.emotionEmojis.skip(5).take(5).map((emoji) {
            final isSelected = emoji == selectedEmotion;
            return GestureDetector(
              onTap: () => onEmotionSelected(emoji),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary.withOpacity(0.2)
                      : Colors.transparent,
                  border: Border.all(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(
                            context,
                          ).colorScheme.outline.withOpacity(0.3),
                    width: isSelected ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(emoji, style: const TextStyle(fontSize: 32)),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
