class SubtitleItem {
  final int number;
  final String startTime;
  final String endTime;
  final String content;
  final String? translatedContent;
  final bool isVttFormat; // Track if from VTT file

  const SubtitleItem({
    required this.number,
    required this.startTime,
    required this.endTime,
    required this.content,
    this.translatedContent,
    this.isVttFormat = false,
  });

  SubtitleItem copyWith({String? translatedContent}) {
    return SubtitleItem(
      number: number,
      startTime: startTime,
      endTime: endTime,
      content: content,
      translatedContent: translatedContent ?? this.translatedContent,
      isVttFormat: isVttFormat,
    );
  }
}
