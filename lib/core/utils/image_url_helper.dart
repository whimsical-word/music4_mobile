class ImageUrlHelper {
  static const String s3BaseUrl =
      'https://music4-v3-storage-kenz.s3.ap-southeast-1.amazonaws.com/';

  static String? resolve(String? path) {
    if (path == null || path.isEmpty) {
      return null;
    }

    if (path.startsWith('http://') || path.startsWith('https://')) {
      return path;
    }

    return '$s3BaseUrl$path';
  }
}
