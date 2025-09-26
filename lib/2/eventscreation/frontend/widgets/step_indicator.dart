import 'package:flutter/material.dart';

class StepIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const StepIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(totalSteps, (index) {
          final isActive = index + 1 <= currentStep;
          final isCurrent = index + 1 == currentStep;
          
          return Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isActive ? const Color(0xFFFFC107) : Colors.white, // Changed to yellow
                  border: Border.all(
                    color: const Color(0xFFFFC107), // Changed to yellow
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(
                      color: isActive ? Colors.white : const Color(0xFFFFC107), // Changed to yellow
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              if (index < totalSteps - 1)
                Container(
                  width: 20,
                  height: 2,
                  color: isActive ? const Color(0xFFFFC107) : Colors.grey[300], // Changed to yellow
                ),
            ],
          );
        }),
      ),
    );
  }
}
