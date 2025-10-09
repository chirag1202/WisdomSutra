import 'package:flutter/material.dart';
import '../constants/colors.dart';

class SutraLogo extends StatelessWidget {
  final double size;
  final bool vertical;
  final bool showTitle;
  const SutraLogo(
      {super.key, this.size = 72, this.vertical = true, this.showTitle = true});

  @override
  Widget build(BuildContext context) {
    final image = Image.asset(
      'assets/images/Logo.png.png', // matches actual file name in assets/images
      width: size,
      height: size,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
      isAntiAlias: true,
      errorBuilder: (_, __, ___) =>
          Icon(Icons.spa, size: size, color: AppColors.gold),
    );

    final title = showTitle
        ? Text(
            'WISDOM\nSUTRA',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displaySmall!.copyWith(
                  fontSize: size * .35,
                  height: 1.05,
                  letterSpacing: 1.2,
                ),
          )
        : const SizedBox.shrink();

    final children = <Widget>[
      image,
      if (showTitle) const SizedBox(height: 8, width: 12),
      if (showTitle) title,
    ];

    return vertical
        ? Column(mainAxisSize: MainAxisSize.min, children: children)
        : Row(mainAxisSize: MainAxisSize.min, children: children);
  }
}
