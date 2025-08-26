import 'package:flutter/material.dart';
import '../../upcoming_services.dart';
import '../../exploreteleo.dart';
import '../../services.dart';
import '../../events.dart';

class HomeContentSection extends StatelessWidget {
  final double Function(double, double, double) getResponsiveValue;
  final double Function() getResponsivePadding;

  const HomeContentSection({
    super.key,
    required this.getResponsiveValue,
    required this.getResponsivePadding,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UpcomingServices(
            getResponsiveValue: getResponsiveValue,
            getResponsivePadding: getResponsivePadding,
          ),
          ExploreTELEO(
            getResponsiveValue: getResponsiveValue,
            getResponsivePadding: getResponsivePadding,
          ),
          Services(
            getResponsiveValue: getResponsiveValue,
            getResponsivePadding: getResponsivePadding,
          ),
          Events(
            getResponsiveValue: getResponsiveValue,
            getResponsivePadding: getResponsivePadding,
          ),
          SizedBox(
            height: getResponsiveValue(100, 120, 140),
          ),
        ],
      ),
    );
  }
}
