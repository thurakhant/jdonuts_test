class PromoBanner {
  const PromoBanner({
    required this.id,
    required this.title,
    required this.imageUrl,
    this.badge,
  });

  final String id;
  final String title;
  final String imageUrl;

  /// Short pill label over the title ("New shop"); null when absent.
  final String? badge;
}
