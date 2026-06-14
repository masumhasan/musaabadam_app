class CategoryModel {
  final String id;
  final String name;
  final String slug;
  final String? parentId;
  final String? iconUrl;
  final bool isActive;
  final int sortOrder;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.slug,
    this.parentId,
    this.iconUrl,
    required this.isActive,
    required this.sortOrder,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['_id'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String,
      parentId: _extractParentId(json['parentId']),
      iconUrl: json['iconUrl'] as String?,
      isActive: (json['isActive'] as bool?) ?? true,
      sortOrder: (json['sortOrder'] as int?) ?? 0,
    );
  }

  static String? _extractParentId(dynamic raw) {
    if (raw == null) return null;
    if (raw is String) return raw;
    if (raw is Map<String, dynamic>) return raw['_id'] as String?;
    return null;
  }
}
