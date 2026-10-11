/// 950 -> "950", 1200 -> "1.2K", 3000 -> "3K", 2500000 -> "2.5M".
String formatCount(int count) {
  if (count >= 1000000) return '${_trim(count / 1000000)}M';
  if (count >= 1000) return '${_trim(count / 1000)}K';
  return count.toString();
}

String _trim(double value) {
  final text = value.toStringAsFixed(1);
  return text.endsWith('.0') ? text.substring(0, text.length - 2) : text;
}
