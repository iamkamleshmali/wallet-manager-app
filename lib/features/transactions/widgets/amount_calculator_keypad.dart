import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class AmountCalculatorKeypad extends StatefulWidget {
  final String initialValue;
  final ValueChanged<String> onChanged;
  final VoidCallback onDone;

  const AmountCalculatorKeypad({
    super.key,
    required this.initialValue,
    required this.onChanged,
    required this.onDone,
  });

  @override
  State<AmountCalculatorKeypad> createState() => _AmountCalculatorKeypadState();
}

class _AmountCalculatorKeypadState extends State<AmountCalculatorKeypad> {
  late String _expression;

  @override
  void initState() {
    super.initState();
    _expression = widget.initialValue == '0' ? '' : widget.initialValue;
  }

  void _onKeyPress(String key) {
    setState(() {
      if (key == 'C') {
        _expression = '';
      } else if (key == '⌫') {
        if (_expression.isNotEmpty) {
          _expression = _expression.substring(0, _expression.length - 1);
        }
      } else if (key == '=') {
        _evaluate();
      } else if (key == 'OK') {
        _evaluate();
        widget.onDone();
        return;
      } else if (['+', '-', '×', '÷'].contains(key)) {
        if (_expression.isEmpty) return;
        final last = _expression[_expression.length - 1];
        if (['+', '-', '×', '÷'].contains(last)) {
          _expression = _expression.substring(0, _expression.length - 1) + key;
        } else {
          _expression += key;
        }
      } else if (key == '.') {
        if (_expression.isEmpty) {
          _expression = '0.';
        } else {
          // Check if current number segment already has a dot
          final segments = _expression.split(RegExp(r'[\+\-\×\÷]'));
          if (!segments.last.contains('.')) {
            _expression += '.';
          }
        }
      } else {
        // Digit pressed
        if (_expression == '0') {
          _expression = key;
        } else {
          _expression += key;
        }
      }
    });

    widget.onChanged(_expression.isEmpty ? '0' : _expression);
  }

  void _evaluate() {
    if (_expression.isEmpty) return;
    try {
      // Simple parser for +, -, ×, ÷
      String exp = _expression.replaceAll('×', '*').replaceAll('÷', '/');
      // Evaluate tokens sequentially
      final parts = RegExp(r'(\d+(\.\d+)?|[\+\-\*/])').allMatches(exp).map((m) => m.group(0)!).toList();
      if (parts.isEmpty) return;

      double result = double.tryParse(parts[0]) ?? 0.0;
      for (int i = 1; i < parts.length - 1; i += 2) {
        final op = parts[i];
        final nextVal = double.tryParse(parts[i + 1]) ?? 0.0;

        if (op == '+') result += nextVal;
        if (op == '-') result -= nextVal;
        if (op == '*') result *= nextVal;
        if (op == '/') {
          if (nextVal != 0) result /= nextVal;
        }
      }

      String resStr = result.toStringAsFixed(2);
      if (resStr.endsWith('.00')) {
        resStr = resStr.substring(0, resStr.length - 3);
      }
      _expression = resStr;
      widget.onChanged(_expression);
    } catch (_) {
      // Keep expression intact on format error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.darkCard,
        border: Border(top: BorderSide(color: AppColors.darkBorder, width: 1)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildRow(['7', '8', '9', '÷']),
          _buildRow(['4', '5', '6', '×']),
          _buildRow(['1', '2', '3', '-']),
          _buildRow(['.', '0', '⌫', '+']),
          _buildBottomActionRow(),
        ],
      ),
    );
  }

  Widget _buildRow(List<String> keys) {
    return Row(
      children: keys.map((key) {
        final isOperator = ['+', '-', '×', '÷'].contains(key);
        return Expanded(
          child: _KeyButton(
            text: key,
            isOperator: isOperator,
            onPressed: () => _onKeyPress(key),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBottomActionRow() {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: _KeyButton(
            text: 'C',
            textColor: AppColors.expense,
            onPressed: () => _onKeyPress('C'),
          ),
        ),
        Expanded(
          flex: 1,
          child: _KeyButton(
            text: '=',
            isOperator: true,
            onPressed: () => _onKeyPress('='),
          ),
        ),
        Expanded(
          flex: 2,
          child: Container(
            height: 54,
            margin: const EdgeInsets.all(4),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.expense,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              onPressed: () => _onKeyPress('OK'),
              child: const Text(
                '✓ OK',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _KeyButton extends StatelessWidget {
  final String text;
  final bool isOperator;
  final Color? textColor;
  final VoidCallback onPressed;

  const _KeyButton({
    required this.text,
    this.isOperator = false,
    this.textColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      margin: const EdgeInsets.all(3),
      child: Material(
        color: isOperator ? AppColors.darkCardElevated : AppColors.darkBackground,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(10),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: textColor ??
                    (isOperator ? AppColors.expenseLight : AppColors.textPrimaryDark),
                fontSize: 18,
                fontWeight: isOperator ? FontWeight.w700 : FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
