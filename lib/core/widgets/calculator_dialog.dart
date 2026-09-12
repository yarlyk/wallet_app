import 'package:flutter/material.dart';

class CalculatorDialog extends StatefulWidget {
  final double? initialValue;
  const CalculatorDialog({super.key, this.initialValue});

  @override
  State<CalculatorDialog> createState() => _CalculatorDialogState();
}

class _CalculatorDialogState extends State<CalculatorDialog> {
  String _expression = '';

  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null && widget.initialValue != 0) {
      _expression = _formatOut(widget.initialValue!);
    }
  }

  String _formatOut(double v) {
    if (v == v.roundToDouble()) return v.toInt().toString();
    return v.toString().replaceAll('.', ',');
  }

  void _append(String s) {
    setState(() {
      _expression += s;
    });
  }

  void _backspace() {
    if (_expression.isEmpty) return;
    setState(() {
      _expression = _expression.substring(0, _expression.length - 1);
    });
  }

  void _clear() {
    setState(() {
      _expression = '';
    });
  }

  double? _eval(String expr) {
    try {
      final normalized = expr
          .replaceAll(',', '.')
          .replaceAll('×', '*')
          .replaceAll('÷', '/');
      if (normalized.trim().isEmpty) return null;
      final parser = _Parser(normalized);
      final v = parser.parse();
      if (!v.isFinite) return null;
      return v;
    } catch (_) {
      return null;
    }
  }

  void _apply() {
    final v = _eval(_expression);
    if (v == null) return;
    Navigator.pop(context, v);
  }

  @override
  Widget build(BuildContext context) {
    final preview = _eval(_expression);

    return AlertDialog(
      title: const Text('Калькулятор'),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              height: 90,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _expression.isEmpty ? '0' : _expression,
                    style: const TextStyle(fontSize: 22),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    preview != null ? '= ${_formatOut(preview)}' : ' ',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: GridView.count(
                shrinkWrap: true,
                crossAxisCount: 4,
                mainAxisSpacing: 6,
                crossAxisSpacing: 6,
                children: [
                  _btn('7'), _btn('8'), _btn('9'), _btn('÷'),
                  _btn('4'), _btn('5'), _btn('6'), _btn('×'),
                  _btn('1'), _btn('2'), _btn('3'), _btn('-'),
                  _btn('0'), _btn(','), _btn('('), _btn(')'),
                  _btn('.'), _btn('+'), _btnIcon(Icons.backspace, _backspace),
                  _btnIcon(Icons.close, _clear),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _clear,
          style: TextButton.styleFrom(foregroundColor: Colors.red),
          child: const Text('Сброс'),
        ),
        const Spacer(),
        TextButton(
          onPressed: () => Navigator.pop(context, null),
          child: const Text('Отмена'),
        ),
        ElevatedButton(
          onPressed: preview != null ? _apply : null,
          child: const Text('ОК'),
        ),
      ],
    );
  }

  Widget _btn(String label) {
    return OutlinedButton(
      onPressed: () => _append(label),
      child: Text(label, style: const TextStyle(fontSize: 18)),
    );
  }

  Widget _btnIcon(IconData icon, VoidCallback onTap) {
    return OutlinedButton(
      onPressed: onTap,
      child: Icon(icon, size: 18),
    );
  }
}

class _Parser {
  _Parser(this.src);
  final String src;
  int pos = 0;

  double parse() {
    final v = _expr();
    if (pos < src.length) throw 'Unexpected: ${src[pos]}';
    return v;
  }

  double _expr() {
    double v = _term();
    while (pos < src.length) {
      final c = src[pos];
      if (c == '+') {
        pos++;
        v += _term();
      } else if (c == '-') {
        pos++;
        v -= _term();
      } else {
        break;
      }
    }
    return v;
  }

  double _term() {
    double v = _factor();
    while (pos < src.length) {
      final c = src[pos];
      if (c == '*') {
        pos++;
        v *= _factor();
      } else if (c == '/') {
        pos++;
        v /= _factor();
      } else {
        break;
      }
    }
    return v;
  }

  double _factor() {
    if (pos >= src.length) throw 'Unexpected end';
    final c = src[pos];
    if (c == '-') {
      pos++;
      return -_factor();
    }
    if (c == '+') {
      pos++;
      return _factor();
    }
    if (c == '(') {
      pos++;
      final v = _expr();
      if (pos >= src.length || src[pos] != ')') throw 'Missing )';
      pos++;
      return v;
    }
    return _number();
  }

  double _number() {
    final start = pos;
    while (pos < src.length &&
        (RegExp(r'[0-9.]').hasMatch(src[pos]))) {
      pos++;
    }
    if (pos == start) throw 'Number expected at $pos';
    return double.parse(src.substring(start, pos));
  }
}

