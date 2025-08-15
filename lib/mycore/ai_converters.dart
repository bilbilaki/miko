// lib/core/ai_converters.dart
import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart' as gemini;
import 'package:miko/mycore/chat_controller.dart';
import 'package:openai_dart/openai_dart.dart' as openai;

import 'ai_core_models.dart';

class AiMessageConverters {
  // ---------- OpenAI ----------

  static List<openai.ChatCompletionMessage> buildOpenAiMessages(
    List<UnifiedMessage> msgs, {
    bool includeFilesAsTextNotice = true,
    required AiSettings settings
  }) {
    final List<openai.ChatCompletionMessage> out = [];
    for (final m in msgs) {
      switch (m.role) {
        case MessageRole.system:
          out.add(openai.ChatCompletionMessage.system(
            content: settings.systemPrompt,
          ));
          break;
        case MessageRole.user:
          final parts = <openai.ChatCompletionMessageContentPart>[];
          if ((m.text ?? '').isNotEmpty) {
            parts.add(openai.ChatCompletionMessageContentPart.text(
              text: m.text!,
            ));
          }
          for (final a in m.attachments) {
            a.map(
              image: (img) {
                final dataUrl = 'data:${img.mimeType};base64,${img.base64Data}';
                parts.add(
                  openai.ChatCompletionMessageContentPart.image(
                    imageUrl: openai.ChatCompletionMessageImageUrl(url: dataUrl),
                  ),
                );
              },
              audio: (aud) {
                final fmt = _toOpenAiAudioFormat(aud.format);
                parts.add(
                  openai.ChatCompletionMessageContentPart.audio(
                    inputAudio: openai.ChatCompletionMessageInputAudio(
                      data: base64Encode(aud.bytes),
                      format: fmt,
                    ),
                  ),
                );
              },
              file: (file) {
                if (includeFilesAsTextNotice) {
                  parts.add(openai.ChatCompletionMessageContentPart.text(
                    text: 'Attached file: ${file.fileName} (${file.mimeType}, ${file.size ?? file.bytes.length} bytes)',
                  ));
                }
              },
              chunk: (chunk) {
                parts.add(openai.ChatCompletionMessageContentPart.text(
                  text: chunk.text,
                ));
              },
            );
          }
          // OpenAI requires at least one content field
          if (parts.isEmpty) {
            parts.add(
              openai.ChatCompletionMessageContentPart.text(text: ''),
            );
          }
          out.add(
            openai.ChatCompletionMessage.user(
              content: openai.ChatCompletionUserMessageContent.parts(parts),
            ),
          );
          break;
        case MessageRole.assistant:
          out.add(openai.ChatCompletionMessage.assistant(
            content: m.text,
          ));
          break;
        case MessageRole.tool:
          // Fallback: map tool to assistant textual message
          out.add(openai.ChatCompletionMessage.assistant(
            content: m.text,
          ));
          break;
      }
    }
    return out;
  }

  static openai.ChatCompletionMessageInputAudioFormat _toOpenAiAudioFormat(
      AudioFormat f) {
    switch (f) {
      case AudioFormat.wav:
        return openai.ChatCompletionMessageInputAudioFormat.wav;
      case AudioFormat.mp3:
        return openai.ChatCompletionMessageInputAudioFormat.wav;

    }
  }

  // ---------- Gemini ----------

  static List<gemini.Content> buildGeminiHistory(List<UnifiedMessage> msgs) {
    final List<gemini.Content> out = [];
    for (final m in msgs) {
      final parts = <gemini.Part>[];

      if ((m.text ?? '').isNotEmpty) {
        parts.add(gemini.TextPart(m.text!));
      }

      for (final a in m.attachments) {
        a.map(
          image: (img) {
            parts.add(
              gemini.DataPart(
                img.mimeType,
                base64Decode(img.base64Data),
              ),
            );
          },
          audio: (aud) {
            parts.add(
              gemini.DataPart(
                aud.format.mimeType,
                aud.bytes,
              ),
            );
          },
          file: (file) {
            parts.add(
              gemini.DataPart(
                file.mimeType,
                file.bytes,
              ),
            );
          },
          chunk: (chunk) {
            parts.add(gemini.TextPart(chunk.text));
          },
        );
      }

      final role = _toGeminiRole(m.role);
      out.add(gemini.Content(role, parts));
    }
    return out;
  }

  static String _toGeminiRole(MessageRole role) {
    switch (role) {
      case MessageRole.user:
      case MessageRole.system: // No native system role in Gemini chat
        return 'user';
      case MessageRole.assistant:
      case MessageRole.tool: // Map tool outputs as model text by default
        return 'model';
    }
  }
}