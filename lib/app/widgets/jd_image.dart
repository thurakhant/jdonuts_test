import 'package:cached_network_image/cached_network_image.dart';
import 'package:material_ui/material_ui.dart';

import '../theme/app_colors.dart';
import 'skeleton.dart';

/// The one image widget. `assets/...` paths load from the bundle (so the
/// first airplane-mode launch still shows pictures); http(s) URLs load
/// through a disk cache with a shimmer placeholder and an error state.
class JdImage extends StatelessWidget {
  const JdImage(
    this.source, {
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    super.key,
  });

  final String source;
  final BoxFit fit;
  final double? width;
  final double? height;

  static bool isAsset(String source) => source.startsWith('assets/');

  @override
  Widget build(BuildContext context) {
    if (isAsset(source)) {
      return Image.asset(
        source,
        fit: fit,
        width: width,
        height: height,
        excludeFromSemantics: true,
        errorBuilder: (_, _, _) => const _BrokenImage(),
      );
    }
    return CachedNetworkImage(
      imageUrl: source,
      fit: fit,
      width: width,
      height: height,
      placeholder: (_, _) =>
          SkeletonBox(width: width, height: height, radius: 0),
      errorWidget: (_, _, _) => const _BrokenImage(),
    );
  }
}

class _BrokenImage extends StatelessWidget {
  const _BrokenImage();

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: AppColors.surfaceMuted,
      child: Center(
        child: Icon(
          Icons.broken_image_outlined,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}
