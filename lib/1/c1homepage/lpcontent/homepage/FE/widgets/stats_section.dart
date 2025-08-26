import 'package:flutter/material.dart';
import '../../BE/models/landing_page_models.dart';

class StatsSection extends StatelessWidget {
  final List<StatCard> statCards;
  final double Function(double, double, double) getResponsiveValue;

  const StatsSection({
    super.key,
    required this.statCards,
    required this.getResponsiveValue,
  });

  @override
  Widget build(BuildContext context) {
    final cardSpacing = getResponsiveValue(10, 14, 18);
    return Row(
      children: statCards
          .asMap()
          .entries
          .map((entry) {
            final index = entry.key;
            final card = entry.value;
            return [
              Expanded(child: _buildStatCard(card)),
              if (index < statCards.length - 1) SizedBox(width: cardSpacing),
            ];
          })
          .expand((widgets) => widgets)
          .toList(),
    );
  }

  Widget _buildStatCard(StatCard card) {
    final cardPadding = getResponsiveValue(6, 8, 10);
    final borderRadius = getResponsiveValue(10, 12, 14);
    return Container(
      padding: EdgeInsets.all(cardPadding),
      decoration: BoxDecoration(
        color: AppConfig.secondaryColor,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            card.title,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: getResponsiveValue(14, 16, 18),
              fontWeight: FontWeight.w500,
              letterSpacing: 0.3,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: getResponsiveValue(1, 2, 3)),
          // Placeholder space for values - keeping structure but removing content
          SizedBox(height: getResponsiveValue(20, 24, 28)),
          SizedBox(height: getResponsiveValue(0, 1, 2)),
          // Placeholder space for change indicators - keeping structure but removing content
          SizedBox(height: getResponsiveValue(12, 14, 16)),
        ],
      ),
    );
  }
}
