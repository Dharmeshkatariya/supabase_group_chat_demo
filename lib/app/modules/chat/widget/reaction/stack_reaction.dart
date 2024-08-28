import 'package:flutter/material.dart';
import 'package:supabase_app_demo/models/message_reaction.dart';

class StackedReactions extends StatelessWidget {
  const StackedReactions({
    super.key,
    required this.reactions,
    this.size = 20.0,
    this.direction = TextDirection.ltr,
  });

  final List<MessageReaction> reactions;

  final double size;

  final TextDirection direction;

  @override
  Widget build(BuildContext context) {
    final reactionsToShow =
        reactions.length > 2 ? reactions.sublist(0, 3) : reactions;

    final remaining = reactions.length - reactionsToShow.length;

    Widget createReactionWidget(MessageReaction reaction, int index) {
      return Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: const BorderRadius.all(Radius.circular(25)),
        ),
        child: Text(
          reaction.reaction,
          style: TextStyle(fontSize: size),
        ),
      );
    }

    final reactionWidgets = reactionsToShow.asMap().entries.map((entry) {
      final index = entry.key;
      final reaction = entry.value;
      return createReactionWidget(reaction, index);
    }).toList();

    return reactions.isEmpty
        ? const SizedBox.shrink()
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                height: size + 8,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  clipBehavior: Clip.none,
                  children: reactionWidgets,
                ),
              ),
              if (remaining > 0)
                Container(
                  padding: const EdgeInsets.all(2.0),
                  margin: const EdgeInsets.all(2.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                    borderRadius: const BorderRadius.all(Radius.circular(25)),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).colorScheme.onBackground,
                        offset: const Offset(0.0, 1.0),
                        blurRadius: 6.0,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Material(
                        color: Colors.transparent,
                        child: Text(
                          '+$remaining',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          );
  }
}
