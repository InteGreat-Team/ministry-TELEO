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
    // Force totalSteps to be 5 regardless of what's passed in
    const int actualTotalSteps = 5;
    
    return SizedBox(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(actualTotalSteps * 2 - 1, (index) {
          // If index is even, it's a circle
          if (index % 2 == 0) {
            final stepNumber = (index ~/ 2) + 1;
            final isCompleted = stepNumber <= currentStep;
            
            return Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: isCompleted ? const Color(0xFFFFC107) : Colors.transparent,
                border: Border.all(
                  color: const Color(0xFFFFC107),
                  width: 1.5,
                ),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '$stepNumber',
                  style: TextStyle(
                    color: isCompleted ? Colors.white : const Color(0xFFFFC107),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          } else {
            // It's a line
            return Container(
              width: 15,
              height: 1.5,
              color: const Color(0xFFFFC107),
            );
          }
        }),
      ),
    );
  }
}
