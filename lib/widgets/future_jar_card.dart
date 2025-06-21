import 'package:flutter/material.dart';
import 'package:thinkback4/models/future_jar_model.dart';
import 'package:thinkback4/widgets/stamp_dialog.dart';

class FutureJarCard extends StatefulWidget {
  final FutureJar jar;
  final int daysLeft;

  const FutureJarCard({super.key, required this.jar, required this.daysLeft});

  @override
  _FutureJarCardState createState() => _FutureJarCardState();
}

class _FutureJarCardState extends State<FutureJarCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    bool isLocked = widget.daysLeft > 0;

    if (isLocked) {
      _controller.forward(from: 0);
    } else {
      // Unlocked: Show dialog
      showDialog(
        context: context,
        builder:
            (context) => StampDialog(
              imageUrl: widget.jar.imageUrl,
              suggestion: widget.jar.message,
              trend: widget.jar.title,
              onOk: () => Navigator.of(context).pop(),
            ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isLocked = widget.daysLeft > 0;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final sineValue =
            isLocked ? 10 * (0.5 - (0.5 - _animation.value).abs()) : 0.0;
        return Transform.translate(
          offset: Offset(sineValue * 2, 0),
          child: child,
        );
      },
      child: GestureDetector(
        onTap: _handleTap,
        child: Card(
          elevation: 4,
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color:
                  isLocked
                      ? Color.lerp(
                        Colors.transparent,
                        Colors.red,
                        _animation.value,
                      )!
                      : Colors.transparent,
              width: 2,
            ),
          ),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.all_inbox_outlined,
                    color: Colors.blueAccent,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.jar.title,
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        isLocked
                            ? 'Opens in ${widget.daysLeft} day${widget.daysLeft == 1 ? "" : "s"}'
                            : 'Unlocked! ✨',
                        style: TextStyle(
                          color: isLocked ? Colors.grey[700] : Colors.green,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  isLocked ? Icons.lock_outline : Icons.lock_open_outlined,
                  color: isLocked ? Colors.grey : Colors.green,
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
