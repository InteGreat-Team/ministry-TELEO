import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../BE/models/landing_page_models.dart';

class CategoriesSection extends StatelessWidget {
  final List<CategoryItem> categories;
  final int selectedCategory;
  final Function(int) onCategoryTap;
  final double Function(double, double, double) getResponsiveValue;
  final double Function() getResponsivePadding;

  const CategoriesSection({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategoryTap,
    required this.getResponsiveValue,
    required this.getResponsivePadding,
  });

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = getResponsivePadding();
    final verticalPadding = getResponsiveValue(24, 28, 32);

    List<Widget> categoryButtons = [];
    if (categories.isNotEmpty) {
      categoryButtons = categories
          .map((category) {
            if (category.isHome) {
              return _buildHomeButton(category);
            } else {
              return _buildCategoryButton(category);
            }
          })
          .expand((widgets) =>
              [widgets, SizedBox(width: getResponsiveValue(10, 12, 16))])
          .toList();
      if (categoryButtons.isNotEmpty) {
        categoryButtons.removeLast();
      }
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        horizontalPadding,
        verticalPadding,
        0,
        verticalPadding,
      ),
      child: SizedBox(
        height: getResponsiveValue(40, 44, 48),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          itemCount: categoryButtons.length,
          itemBuilder: (context, index) {
            return categoryButtons[index];
          },
        ),
      ),
    );
  }

  Widget _buildHomeButton(CategoryItem category) {
    final buttonSize = getResponsiveValue(40, 44, 48);
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onCategoryTap(category.id);
      },
      child: Container(
        width: buttonSize,
        height: buttonSize,
        decoration: BoxDecoration(
          color: selectedCategory == category.id
              ? AppConfig.accentColor
              : Colors.grey[200],
          shape: BoxShape.circle,
          boxShadow: selectedCategory == category.id
              ? [
                  BoxShadow(
                    color: AppConfig.accentColor.withOpacity(0.25),
                    blurRadius: 6,
                    offset: const Offset(0, 1),
                  ),
                ]
              : null,
        ),
        child: Icon(
          category.icon,
          color:
              selectedCategory == category.id ? Colors.white : Colors.grey[600],
          size: getResponsiveValue(18, 20, 22),
        ),
      ),
    );
  }

  Widget _buildCategoryButton(CategoryItem category) {
    final isSelected = selectedCategory == category.id;
    final fontSize = getResponsiveValue(11, 12, 13);
    final iconSize = getResponsiveValue(16, 17, 18);
    final horizontalPadding = getResponsiveValue(14, 16, 18);
    final verticalPadding = getResponsiveValue(8, 10, 12);

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onCategoryTap(category.id);
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppConfig.accentColor.withOpacity(0.08)
              : Colors.grey[50],
          borderRadius: BorderRadius.circular(20),
          border: isSelected
              ? Border.all(
                  color: AppConfig.accentColor.withOpacity(0.8),
                  width: 1,
                )
              : Border.all(color: Colors.grey[200]!, width: 0.5),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppConfig.accentColor.withOpacity(0.15),
                    blurRadius: 3,
                    offset: const Offset(0, 0.5),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              category.icon,
              color: isSelected ? AppConfig.accentColor : Colors.grey[500],
              size: iconSize,
            ),
            SizedBox(width: getResponsiveValue(6, 8, 10)),
            Text(
              category.label,
              style: TextStyle(
                color: isSelected ? AppConfig.accentColor : Colors.grey[500],
                fontSize: fontSize,
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                letterSpacing: 0.1,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
