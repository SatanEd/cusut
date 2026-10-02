import 'package:flutter/material.dart';

/// Two-line "wordmark" app bar matching the Atelier visual language: a
/// small emblem mark, a serif title, and an uppercase section label.
class AtelierAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AtelierAppBar({super.key, required this.title, required this.section});

  final String title;
  final String section;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return AppBar(
      titleSpacing: 16,
      title: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: scheme.secondary, width: 1.5),
            ),
            child: Icon(Icons.content_cut, size: 16, color: scheme.secondary),
          ),
          const SizedBox(width: 10),
          // Flexible + ellipsis: translated titles vary a lot in length.
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.headlineSmall?.copyWith(color: scheme.primary),
                ),
                Text(
                  section.toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.labelSmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                    letterSpacing: 1.2,
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
