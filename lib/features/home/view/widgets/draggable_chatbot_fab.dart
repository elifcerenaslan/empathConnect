import 'package:flutter/material.dart';
import '../../../emergency/view/chatbot_view.dart';

class DraggableChatbotFab extends StatefulWidget {
  const DraggableChatbotFab({super.key});

  @override
  State<DraggableChatbotFab> createState() => _DraggableChatbotFabState();
}

class _DraggableChatbotFabState extends State<DraggableChatbotFab> {
  Offset position = const Offset(100, 100);
  bool isInitialized = false;

  void _snapToEdge(Size size) {
    setState(() {
      double dx = position.dx;
      double dy = position.dy;

      // Sola veya sağa yasla
      if (dx < size.width / 2) {
        dx = 16.0;
      } else {
        dx = size.width - 70 - 16.0;
      }

      // Dikeyde sınırla (alttan 16 piksel boşluk)
      if (dy < 16.0) dy = 16.0;
      if (dy > size.height - 70 - 16.0) {
        dy = size.height - 70 - 16.0;
      }

      position = Offset(dx, dy);
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);

        if (!isInitialized) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            setState(() {
              position = Offset(size.width - 70 - 16, size.height - 70 - 16);
              isInitialized = true;
            });
          });
          return const SizedBox.shrink();
        }

        return Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
              left: position.dx,
              top: position.dy,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    double newDx = position.dx + details.delta.dx;
                    double newDy = position.dy + details.delta.dy;

                    // Sınırları aşmasını engelle
                    if (newDx < 0) newDx = 0;
                    if (newDx > size.width - 70) newDx = size.width - 70;
                    if (newDy < 0) newDy = 0;
                    if (newDy > size.height - 70) newDy = size.height - 70;

                    position = Offset(newDx, newDy);
                  });
                },
                onPanEnd: (details) {
                  _snapToEdge(size);
                },
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ChatbotView()),
                  );
                },
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.chat, size: 24, color: Theme.of(context).colorScheme.onPrimary),
                      Text(
                        'Chat',
                        style: TextStyle(
                          fontSize: 10,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
