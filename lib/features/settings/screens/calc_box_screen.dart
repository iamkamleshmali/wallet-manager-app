import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class CalcBoxScreen extends StatefulWidget {
  const CalcBoxScreen({super.key});

  @override
  State<CalcBoxScreen> createState() => _CalcBoxScreenState();
}

class _CalcBoxScreenState extends State<CalcBoxScreen> {
  String _input = '';
  String _result = '0';
  final List<String> _history = [];

  void _onKey(String key) {
    setState(() {
      if (key == 'AC') {
        _input = '';
        _result = '0';
      } else if (key == 'DEL') {
        if (_input.isNotEmpty) {
          _input = _input.substring(0, _input.length - 1);
        }
      } else if (key == '=') {
        _calculate();
      } else if (['+', '-', '×', '÷', '%'].contains(key)) {
        if (_input.isEmpty && _result != '0') {
          _input = _result + key;
        } else if (_input.isNotEmpty) {
          final last = _input[_input.length - 1];
          if (['+', '-', '×', '÷', '%'].contains(last)) {
            _input = _input.substring(0, _input.length - 1) + key;
          } else {
            _input += key;
          }
        }
      } else {
        _input += key;
      }
    });
  }

  void _calculate() {
    if (_input.isEmpty) return;
    try {
      String exp = _input.replaceAll('×', '*').replaceAll('÷', '/');
      // Simple parser for basic math
      final matches = RegExp(r'(\d+(\.\d+)?|[\+\-\*/])').allMatches(exp).map((m) => m.group(0)!).toList();
      if (matches.isEmpty) return;

      double total = double.tryParse(matches[0]) ?? 0.0;
      for (int i = 1; i < matches.length - 1; i += 2) {
        final op = matches[i];
        final val = double.tryParse(matches[i + 1]) ?? 0.0;
        if (op == '+') total += val;
        if (op == '-') total -= val;
        if (op == '*') total *= val;
        if (op == '/') {
          if (val != 0) total /= val;
        }
      }

      String res = total.toStringAsFixed(2);
      if (res.endsWith('.00')) res = res.substring(0, res.length - 3);

      _history.insert(0, '$_input = $res');
      _result = res;
      _input = '';
    } catch (_) {
      _result = 'Error';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        title: const Text('CalcBox'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history_rounded),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: AppColors.darkCard,
                builder: (_) => Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Calculation History',
                        style: TextStyle(color: AppColors.textPrimaryDark, fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: _history.isEmpty
                            ? const Center(child: Text('No calculations yet', style: TextStyle(color: AppColors.textSecondaryDark)))
                            : ListView.separated(
                                itemCount: _history.length,
                                separatorBuilder: (_, __) => const Divider(color: AppColors.darkDivider),
                                itemBuilder: (context, index) {
                                  return Text(
                                    _history[index],
                                    style: const TextStyle(color: AppColors.textPrimaryDark, fontSize: 14, fontFamily: 'Sora'),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Display area
          Expanded(
            child: Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _input.isEmpty ? ' ' : _input,
                    style: const TextStyle(color: AppColors.textSecondaryDark, fontSize: 24, fontFamily: 'Sora'),
                  ),
                  const SizedBox(height: 8),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      _result,
                      style: const TextStyle(
                        color: AppColors.textPrimaryDark,
                        fontSize: 48,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'Sora',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Keypad area
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            decoration: const BoxDecoration(
              color: AppColors.darkCard,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: Column(
              children: [
                _buildRow(['AC', 'DEL', '%', '÷'], isTopRow: true),
                _buildRow(['7', '8', '9', '×']),
                _buildRow(['4', '5', '6', '-']),
                _buildRow(['1', '2', '3', '+']),
                _buildRow(['0', '.', '=']),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(List<String> keys, {bool isTopRow = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: keys.map((k) {
          final isEquals = k == '=';
          final isOperator = ['÷', '×', '-', '+', '='].contains(k);
          final isAction = ['AC', 'DEL', '%'].contains(k);

          Color bg = AppColors.darkCardElevated;
          Color fg = AppColors.textPrimaryDark;

          if (isEquals) {
            bg = AppColors.expense;
            fg = Colors.white;
          } else if (isOperator) {
            bg = AppColors.darkBackground;
            fg = AppColors.income;
          } else if (isAction) {
            bg = AppColors.darkBackground;
            fg = AppColors.expense;
          }

          return Expanded(
            flex: k == '0' ? 2 : 1,
            child: Container(
              height: 58,
              margin: const EdgeInsets.all(4),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: bg,
                  foregroundColor: fg,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  padding: EdgeInsets.zero,
                ),
                onPressed: () => _onKey(k),
                child: Text(
                  k,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: isOperator || isEquals ? FontWeight.w800 : FontWeight.w600,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
