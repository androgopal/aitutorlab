import 'package:aitutorlab/utils/styleUtil.dart';
import 'package:flutter/material.dart';

import '../theme/common_color.dart';
import '../theme/mythemcolor.dart';

class CategoryCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String icon;
  final VoidCallback? onTap;

  const CategoryCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width/2.2,
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(18),
          border: Border(
            bottom:BorderSide(color: CommonColor.lightCardColor.withOpacity(0.5), width: 2)
          ),
          boxShadow: [
          BoxShadow(
              color: isDarkTheme ? myprimarycolor.withAlpha(80) : Colors.black12,
              blurRadius: 2,
              offset: Offset(0, 0)
          )
        ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon(icon, size: 40),
            setCachedImage(icon, 110, double.infinity, 10),
            const SizedBox(height: 5),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
