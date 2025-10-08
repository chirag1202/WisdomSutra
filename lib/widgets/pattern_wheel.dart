import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../constants/colors.dart';

typedef PatternChanged = void Function(int index, int value);

class PatternWheel extends StatefulWidget {
  final int index;
  final int value;
  final PatternChanged onChanged;
  const PatternWheel(
      {super.key,
      required this.index,
      required this.value,
      required this.onChanged});

  @override
  State<PatternWheel> createState() => _PatternWheelState();
}

class _PatternWheelState extends State<PatternWheel> {
  late FixedExtentScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = FixedExtentScrollController(initialItem: widget.value);
  }

  @override
  void didUpdateWidget(covariant PatternWheel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value && _controller.hasClients) {
      _controller.jumpToItem(widget.value);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 68,
      height: 180,
      decoration: BoxDecoration(
        color: AppColors.parchment,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(.35),
              blurRadius: 20,
              offset: const Offset(0, 12)),
          BoxShadow(
              color: AppColors.gold.withOpacity(.3),
              blurRadius: 12,
              spreadRadius: -4),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: CupertinoPicker(
          scrollController: _controller,
          itemExtent: 48,
          useMagnifier: true,
          magnification: 1.18,
          squeeze: 1.1,
          diameterRatio: 1.2,
          backgroundColor: Colors.transparent,
          onSelectedItemChanged: (v) => widget.onChanged(widget.index, v),
          children: List.generate(
            15,
            (i) => Center(
              child: Text(
                '$i',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall!
                    .copyWith(color: AppColors.indigoDeep),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
