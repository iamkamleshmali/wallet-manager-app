class GithubReleaseAsset {
  final String name;
  final String downloadUrl;
  final int size;

  const GithubReleaseAsset({
    required this.name,
    required this.downloadUrl,
    required this.size,
  });

  factory GithubReleaseAsset.fromJson(Map<String, dynamic> json) {
    return GithubReleaseAsset(
      name: (json['name'] as String?) ?? '',
      downloadUrl: (json['browser_download_url'] as String?) ?? '',
      size: (json['size'] as int?) ?? 0,
    );
  }
}

class GithubReleaseModel {
  final String tagName;
  final String title;
  final String body;
  final DateTime? publishedAt;
  final List<GithubReleaseAsset> assets;

  const GithubReleaseModel({
    required this.tagName,
    required this.title,
    required this.body,
    this.publishedAt,
    required this.assets,
  });

  String get cleanVersion {
    if (tagName.startsWith('v') || tagName.startsWith('V')) {
      return tagName.substring(1).trim();
    }
    return tagName.trim();
  }

  String? get apkDownloadUrl {
    for (final asset in assets) {
      if (asset.name.toLowerCase().endsWith('.apk')) {
        return asset.downloadUrl;
      }
    }
    return null;
  }

  int get apkSize {
    for (final asset in assets) {
      if (asset.name.toLowerCase().endsWith('.apk')) {
        return asset.size;
      }
    }
    return 0;
  }

  factory GithubReleaseModel.fromJson(Map<String, dynamic> json) {
    final assetsList = (json['assets'] as List<dynamic>?)
            ?.map((e) => GithubReleaseAsset.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];

    return GithubReleaseModel(
      tagName: (json['tag_name'] as String?) ?? '',
      title: (json['name'] as String?) ?? '',
      body: (json['body'] as String?) ?? 'Performance improvements and bug fixes.',
      publishedAt: json['published_at'] != null
          ? DateTime.tryParse(json['published_at'] as String)
          : null,
      assets: assetsList,
    );
  }
}
