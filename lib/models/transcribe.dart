import 'dart:convert';

class LogProbToken {
  final String token;
  final double? logprob;
  final List<int>? bytes;

  LogProbToken({required this.token, this.logprob, this.bytes});

  factory LogProbToken.fromJson(Map<String, dynamic> json) {
    return LogProbToken(
      token: json['token'] ?? '',
      logprob: (json['logprob'] != null) ? (json['logprob'].toDouble()) : null,
      bytes: json['bytes'] != null
          ? List<int>.from((json['bytes'] as List).map((e) => e as int))
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'token': token,
    'logprob': logprob,
    'bytes': bytes,
  };
}

class UsageTokens {
  final String? type;
  final int? inputTokens;
  final Map<String, dynamic>? inputTokenDetails;
  final int? outputTokens;
  final int? totalTokens;

  UsageTokens({
    this.type,
    this.inputTokens,
    this.inputTokenDetails,
    this.outputTokens,
    this.totalTokens,
  });

  factory UsageTokens.fromJson(Map<String, dynamic> json) {
    return UsageTokens(
      type: json['type'],
      inputTokens: json['input_tokens'],
      inputTokenDetails: json['input_token_details'] != null
          ? Map<String, dynamic>.from(json['input_token_details'])
          : null,
      outputTokens: json['output_tokens'],
      totalTokens: json['total_tokens'],
    );
  }

  Map<String, dynamic> toJson() => {
    'type': type,
    'input_tokens': inputTokens,
    'input_token_details': inputTokenDetails,
    'output_tokens': outputTokens,
    'total_tokens': totalTokens,
  };
}

class UsageDuration {
  final String? type;
  final double? seconds;

  UsageDuration({this.type, this.seconds});

  factory UsageDuration.fromJson(Map<String, dynamic> json) {
    return UsageDuration(
      type: json['type'],
      seconds: json['seconds'] != null ? (json['seconds'].toDouble()) : null,
    );
  }

  Map<String, dynamic> toJson() => {'type': type, 'seconds': seconds};
}

class SimpleTranscription {
  final String text;
  final List<LogProbToken>? logprobs;
  final UsageTokens? usage;

  SimpleTranscription({required this.text, this.logprobs, this.usage});

  factory SimpleTranscription.fromJson(Map<String, dynamic> json) {
    return SimpleTranscription(
      text: json['text'] ?? '',
      logprobs: json['logprobs'] != null
          ? List<LogProbToken>.from(
              (json['logprobs'] as List).map((e) => LogProbToken.fromJson(e)),
            )
          : null,
      usage: json['usage'] != null ? UsageTokens.fromJson(json['usage']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'text': text,
    'logprobs': logprobs?.map((e) => e.toJson()).toList(),
    'usage': usage?.toJson(),
  };
}

class WordTiming {
  final String word;
  final double start;
  final double end;

  WordTiming({required this.word, required this.start, required this.end});

  factory WordTiming.fromJson(Map<String, dynamic> json) {
    return WordTiming(
      word: json['word'] ?? '',
      start: (json['start'] != null) ? json['start'].toDouble() : 0.0,
      end: (json['end'] != null) ? json['end'].toDouble() : 0.0,
    );
  }

  Map<String, dynamic> toJson() => {'word': word, 'start': start, 'end': end};
}

class Segment {
  final int? id;
  final int? seek;
  final double? start;
  final double? end;
  final String? text;
  final List<int>? tokens;
  final double? temperature;
  final double? avgLogprob;
  final double? compressionRatio;
  final double? noSpeechProb;

  Segment({
    this.id,
    this.seek,
    this.start,
    this.end,
    this.text,
    this.tokens,
    this.temperature,
    this.avgLogprob,
    this.compressionRatio,
    this.noSpeechProb,
  });

  factory Segment.fromJson(Map<String, dynamic> json) {
    return Segment(
      id: json['id'],
      seek: json['seek'],
      start: json['start'] != null ? json['start'].toDouble() : null,
      end: json['end'] != null ? json['end'].toDouble() : null,
      text: json['text'],
      tokens: json['tokens'] != null
          ? List<int>.from((json['tokens'] as List).map((e) => e as int))
          : null,
      temperature: json['temperature'] != null
          ? json['temperature'].toDouble()
          : null,
      avgLogprob: json['avg_logprob'] != null
          ? json['avg_logprob'].toDouble()
          : null,
      compressionRatio: json['compression_ratio'] != null
          ? json['compression_ratio'].toDouble()
          : null,
      noSpeechProb: json['no_speech_prob'] != null
          ? json['no_speech_prob'].toDouble()
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'seek': seek,
    'start': start,
    'end': end,
    'text': text,
    'tokens': tokens,
    'temperature': temperature,
    'avg_logprob': avgLogprob,
    'compression_ratio': compressionRatio,
    'no_speech_prob': noSpeechProb,
  };
}

class VerboseTranscription {
  final String? task;
  final String? language;
  final double? duration;
  final String text;
  final List<WordTiming>? words;
  final List<Segment>? segments;
  final UsageDuration? usage;

  VerboseTranscription({
    this.task,
    this.language,
    this.duration,
    required this.text,
    this.words,
    this.segments,
    this.usage,
  });

  factory VerboseTranscription.fromJson(Map<String, dynamic> json) {
    return VerboseTranscription(
      task: json['task'],
      language: json['language'],
      duration: json['duration'] != null ? json['duration'].toDouble() : null,
      text: json['text'] ?? '',
      words: json['words'] != null
          ? List<WordTiming>.from(
              (json['words'] as List).map((e) => WordTiming.fromJson(e)),
            )
          : null,
      segments: json['segments'] != null
          ? List<Segment>.from(
              (json['segments'] as List).map((e) => Segment.fromJson(e)),
            )
          : null,
      usage: json['usage'] != null
          ? UsageDuration.fromJson(json['usage'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'task': task,
    'language': language,
    'duration': duration,
    'text': text,
    'words': words?.map((e) => e.toJson()).toList(),
    'segments': segments?.map((e) => e.toJson()).toList(),
    'usage': usage?.toJson(),
  };
}

class UsageDetails {
  final int inputTokens;
  final int outputTokens;
  final int totalTokens;
  final Map<String, dynamic>? raw;

  UsageDetails({
    required this.inputTokens,
    required this.outputTokens,
    required this.totalTokens,
    this.raw,
  });

  factory UsageDetails.fromJson(Map<String, dynamic> json) {
    return UsageDetails(
      inputTokens: json['input_tokens'] ?? 0,
      outputTokens: json['output_tokens'] ?? 0,
      totalTokens: json['total_tokens'] ?? 0,
      raw: json,
    );
  }
}

class TranscriptionResponse {
  final String text;
  final UsageDetails? usage;
  final Map<String, dynamic>? raw;

  TranscriptionResponse({required this.text, this.usage, this.raw});

  factory TranscriptionResponse.fromJson(Map<String, dynamic> json) {
    return TranscriptionResponse(
      text: json['text'] ?? '',
      usage: json.containsKey('usage')
          ? UsageDetails.fromJson(json['usage'])
          : null,
      raw: json,
    );
  }

  String toJson() => json.encode(raw ?? {'text': text});
}

/// For streaming events:
/// Example streaming JSON:
/// {"type":"transcript.text.delta","delta":"I","logprobs":[...]}
/// {"type":"transcript.text.done","text":"final text", "logprobs":[...], "usage": {...}}
class TranscriptDelta {
  final String type;
  final String? delta; // partial text for delta events
  final String? text; // final text for done events
  final List<dynamic>? logprobs;
  final UsageDetails? usage;
  final Map<String, dynamic>? raw;

  TranscriptDelta({
    required this.type,
    this.delta,
    this.text,
    this.logprobs,
    this.usage,
    this.raw,
  });

  factory TranscriptDelta.fromJson(Map<String, dynamic> json) {
    return TranscriptDelta(
      type: json['type'] ?? '',
      delta: json['delta'],
      text: json['text'],
      logprobs: json['logprobs'],
      usage: json.containsKey('usage')
          ? UsageDetails.fromJson(json['usage'])
          : null,
      raw: json,
    );
  }

  bool get isDone => type == 'transcript.text.done';

  @override
  String toString() {
    if (isDone) return text ?? '';
    return delta ?? '';
  }
}
