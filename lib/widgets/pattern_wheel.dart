import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/theme.dart';

typedef PatternChanged = void Function(int index, int value);

class PatternWheel extends StatefulWidget {
  final int index;
  final int value;
  final PatternChanged onChanged;
  final bool isTouched;
  const PatternWheel(
      {super.key,
      required this.index,
      required this.value,
      required this.onChanged,
      this.isTouched = false});

  @override
  State<PatternWheel> createState() => _PatternWheelState();
}

class _PatternWheelState extends State<PatternWheel> {
  late FixedExtentScrollController _controller;
  static const int kItems =
      120; // sufficient for smooth flicking without overdraw
  late final List<Widget> _items; // cache children to avoid rebuild cost
  int _lastNotified = -1;

  @override
  void initState() {
    super.initState();
    final initial = (widget.value.clamp(1, kItems)) - 1;
    _controller = FixedExtentScrollController(initialItem: initial);
    _items = List.generate(
      kItems,
      (i) => Center(
        child: Text(
          '${i + 1}',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.indigoDeep,
            height: 1.1,
          ),
        ),
      ),
    );
  }

  @override
  void didUpdateWidget(covariant PatternWheel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value && _controller.hasClients) {
      final target = (widget.value.clamp(1, kItems)) - 1;
      _controller.jumpToItem(target);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<SutraColors>();
    final accent = colors?.accent ?? AppColors.gold;
    final borderColor = widget.isTouched
        ? accent.withAlpha((255 * .85).round())
        : Colors.redAccent;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      width: 72,
      height: 200,
      decoration: BoxDecoration(
        color: AppColors.parchment,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: borderColor,
          width: widget.isTouched ? 1.6 : 2.6,
        ),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withAlpha((255 * .28).round()),
              blurRadius: 24,
              offset: const Offset(0, 14)),
          BoxShadow(
              color: AppColors.gold.withAlpha((255 * .25).round()),
              blurRadius: 16,
              spreadRadius: -4),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: CupertinoPicker(
          scrollController: _controller,
          itemExtent: 42,
          useMagnifier: true,
          magnification: 1.1,
          squeeze: 1.0,
          diameterRatio: 1.2,
          selectionOverlay: const CupertinoPickerDefaultSelectionOverlay(
            background: Color(0x22000000),
          ),
          // iOS-like gentle scroll physics; reduces jitter on low-end devices
          looping: true,
          backgroundColor: Colors.transparent,
          onSelectedItemChanged: (v) {
            final value = (v % kItems) + 1; // 1..120
            if (value != _lastNotified) {
              _lastNotified = value;
              widget.onChanged(widget.index, value);
            }
          },
          children: _items,
        ),
      ),
    );
  }
}
