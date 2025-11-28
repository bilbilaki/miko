
String formatBytes(num bytes, {int decimals = 1}) {
  if (bytes <= 0) return '0 B';
  const sizes = ['B', 'KB', 'MB', 'GB', 'TB'];
  final i = (bytes == 0) ? 0 : (bytes.log() / 1024.log()).floor();
  final v = bytes / (1 << (10 * i));
  return '${v.toStringAsFixed(decimals)} ${sizes[i]}';
}

extension on num {
  double log() => (this == 0) ? 0 : (this > 0 ? (this).toDouble().log2() : 0);
  double log2() =>
      (this == 0) ? 0 : (this).toDouble().ln() / 0.6931471805599453;
  double ln() => (this == 0) ? 0 : (this).toDouble()._ln();
}

extension _Ln on double {
  double _ln() {
    // Quick ln approximation (sufficient for our formatting use)
    final x = this;
    final n = (x - 1.0) / (x + 1.0);
    var sum = 0.0;
    for (var i = 1; i < 20; i += 2) {
      sum += (1 / i) * (n.pow(i));
    }
    return 2 * sum;
  }

  double pow(int e) {
    var r = 1.0;
    for (var i = 0; i < e; i++) {
      r *= this;
    }
    return r;
  }
}

String formatPercent(double p) =>
    '${(p * 100).clamp(0, 100).toStringAsFixed(0)}%';

String formatSpeed(num bps) {
  if (bps <= 0) return '0 B/s';
  return '${formatBytes(bps)}/s';
}
