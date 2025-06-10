// lib/presentation/widgets/nav_bar.dart
import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart'; // Import your AppTheme to use its colors

class NavBarItem {
  final String title;
  final GlobalKey sectionKey;
  final IconData? icon;

  NavBarItem({required this.title, required this.sectionKey, this.icon});
}

class PortfolioNavBar extends StatefulWidget {
  final List<NavBarItem> items;
  final Function(GlobalKey) onItemSelected;
  final GlobalKey? activeSectionKey;

  const PortfolioNavBar({
    super.key,
    required this.items,
    required this.onItemSelected,
    this.activeSectionKey,
  });

  @override
  State<PortfolioNavBar> createState() => _PortfolioNavBarState();
}

class _PortfolioNavBarState extends State<PortfolioNavBar> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isSmallScreen = MediaQuery.of(context).size.width < 700;

    return Container(
      height: 65, // Slightly increased height for better padding/presence
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24), // Increased padding
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor.withOpacity(0.97), // Use theme background, slightly transparent
        border: Border( // Add a subtle bottom border
          bottom: BorderSide(
            color: AppTheme.subtleBorderColor.withOpacity(0.6), // Use theme's subtle border
            width: 1.0,
          ),
        ),
        // boxShadow: [ // Elevation removed
        //   BoxShadow(
        //     color: Colors.black.withOpacity(0.2),
        //     blurRadius: 10,
        //     offset: const Offset(0, 2),
        //   ),
        // ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () => widget.onItemSelected(widget.items.first.sectionKey),
              child: Text(
                'Pranay Shah',
                style: theme.textTheme.headlineSmall?.copyWith( // Using headlineSmall from new theme
                  color: AppTheme.primaryColor, // Use theme's primary color
                  fontWeight: FontWeight.bold,
                  fontSize: 18, // Consistent size
                ),
              ),
            ),
          ),
          if (isSmallScreen)
            PopupMenuButton<NavBarItem>(
              icon: Icon(Icons.menu_rounded, color: AppTheme.onBackgroundColor, size: 28), // Slightly larger icon
              color: AppTheme.surfaceColor, // Use theme's surface color for dropdown
              elevation: 2, // Add a little elevation to the dropdown menu
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              onSelected: (item) => widget.onItemSelected(item.sectionKey),
              itemBuilder: (BuildContext context) {
                return widget.items.map((NavBarItem item) {
                  final bool isActive = widget.activeSectionKey == item.sectionKey;
                  return PopupMenuItem<NavBarItem>(
                    value: item,
                    child: Text(
                      item.title,
                      style: theme.textTheme.bodyMedium?.copyWith( // Using bodyMedium from theme
                        color: isActive ? AppTheme.primaryColor : AppTheme.onSurfaceColor,
                        fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  );
                }).toList();
              },
            )
          else
            Row(
              children: widget.items.map((item) {
                return _NavBarTextButton(
                  key: ValueKey('nav_item_${item.title}'), // Add unique keys
                  title: item.title,
                  isActive: widget.activeSectionKey == item.sectionKey,
                  onTap: () => widget.onItemSelected(item.sectionKey),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}

class _NavBarTextButton extends StatefulWidget {
  final String title;
  final bool isActive;
  final VoidCallback onTap;

  const _NavBarTextButton({
    super.key, // Accept key
    required this.title,
    required this.isActive,
    required this.onTap,
  });

  @override
  State<_NavBarTextButton> createState() => _NavBarTextButtonState();
}

class _NavBarTextButtonState extends State<_NavBarTextButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Determine text color based on active and hover states
    final Color textColor;
    if (widget.isActive) {
      textColor = AppTheme.primaryColor;
    } else if (_isHovered) {
      textColor = AppTheme.primaryColor.withOpacity(0.85);
    } else {
      textColor = AppTheme.onBackgroundColor.withOpacity(0.8); // Use theme color for normal text
    }

    final FontWeight fontWeight = widget.isActive || _isHovered ? FontWeight.w700 : FontWeight.w500;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0), // Adjusted padding
          child: Text(
            widget.title,
            style: theme.textTheme.bodyLarge?.copyWith( // Using bodyLarge from new theme
              color: textColor,
              fontWeight: fontWeight,
              letterSpacing: 0.6, // Slightly increased letter spacing
              fontSize: 15, // Consistent font size
            ),
          ),
        ),
      ),
    );
  }
}