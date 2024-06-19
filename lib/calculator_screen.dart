import 'package:calculator/button_values.dart';
import 'package:flutter/material.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String number1 = ""; // First number
  String operand = ""; // Operand (+, -, *, /)
  String number2 = ""; // Second number

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final double buttonSize = screenSize.width / 20; // Further reduced button size

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Center(
          child: Container(
            width: screenSize.width * 0.35, // Further reduce the overall container width
            height: screenSize.height * 0.5, // Further reduce the overall container height
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Center the calculator vertically
              children: [
                // Display output
                Expanded(
                  child: SingleChildScrollView(
                    reverse: true,
                    child: Container(
                      alignment: Alignment.bottomRight,
                      padding: const EdgeInsets.all(4), // Further reduced padding
                      child: Text(
                        "$number1$operand$number2".isEmpty ? "0" : "$number1$operand$number2",
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold), // Further reduced font size
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ),
                ),
                // Buttons
                Wrap(
                  children: Btn.buttonValues.map((value) {
                    final width = value == Btn.n0 ? buttonSize * 2 : buttonSize;
                    return SizedBox(width: width, height: buttonSize, child: buildButton(value));
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildButton(String value) {
    return Padding(
      padding: const EdgeInsets.all(0.5), // Further reduced padding
      child: Material(
        color: getBtnColor(value),
        clipBehavior: Clip.hardEdge,
        shape: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white24),
          borderRadius: BorderRadius.circular(25), // Adjusted border radius
        ),
        child: InkWell(
          onTap: () => onBtnTap(value),
          child: Center(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12), // Further reduced font size
            ),
          ),
        ),
      ),
    );
  }

  // Handle button tap
  void onBtnTap(String value) {
    if (value == Btn.del) {
      delete();
    } else if (value == Btn.clr) {
      clearAll();
    } else if (value == Btn.per) {
      convertToPercentage();
    } else if (value == Btn.calculate) {
      calculate();
    } else {
      appendValue(value);
    }
  }

  // Calculate the result
  void calculate() {
    if (number1.isEmpty || operand.isEmpty || number2.isEmpty) return;

    final num1 = double.parse(number1);
    final num2 = double.parse(number2);
    double result = 0.0;

    switch (operand) {
      case Btn.add:
        result = num1 + num2;
        break;
      case Btn.subtract:
        result = num1 - num2;
        break;
      case Btn.multiply:
        result = num1 * num2;
        break;
      case Btn.divide:
        result = num1 / num2;
        break;
    }

    setState(() {
      number1 = result.toStringAsPrecision(3).replaceAll(RegExp(r'\.0$'), '');
      operand = "";
      number2 = "";
    });
  }

  // Convert to percentage
  void convertToPercentage() {
    if (number1.isNotEmpty && operand.isNotEmpty && number2.isNotEmpty) {
      calculate();
    }

    if (operand.isNotEmpty) return;

    final number = double.parse(number1);
    setState(() {
      number1 = (number / 100).toString();
      operand = "";
      number2 = "";
    });
  }

  // Clear all input
  void clearAll() {
    setState(() {
      number1 = "";
      operand = "";
      number2 = "";
    });
  }

  // Delete last character
  void delete() {
    setState(() {
      if (number2.isNotEmpty) {
        number2 = number2.substring(0, number2.length - 1);
      } else if (operand.isNotEmpty) {
        operand = "";
      } else if (number1.isNotEmpty) {
        number1 = number1.substring(0, number1.length - 1);
      }
    });
  }

  // Append value to the appropriate variable
  void appendValue(String value) {
    if (value != Btn.dot && int.tryParse(value) == null) {
      if (operand.isNotEmpty && number2.isNotEmpty) calculate();
      operand = value;
    } else if (operand.isEmpty) {
      if (value == Btn.dot && number1.contains(Btn.dot)) return;
      if (value == Btn.dot && number1.isEmpty) value = "0.";
      number1 += value;
    } else {
      if (value == Btn.dot && number2.contains(Btn.dot)) return;
      if (value == Btn.dot && number2.isEmpty) value = "0.";
      number2 += value;
    }

    setState(() {});
  }

  // Get button color based on value
  Color getBtnColor(String value) {
    if ([Btn.del, Btn.clr].contains(value)) {
      return Colors.blueGrey;
    } else if ([Btn.per, Btn.multiply, Btn.add, Btn.subtract, Btn.divide, Btn.calculate].contains(value)) {
      return Colors.orange;
    } else {
      return Colors.black87;
    }
  }
}