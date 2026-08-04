class AskResponse {
  const AskResponse({required this.answer, this.sources = const []});

  final String answer;
  final List<String> sources;

  factory AskResponse.fromJson(Map<String, dynamic> json) {
    return AskResponse(
      answer: (json['answer'] as String?) ?? '',
      sources: (json['sources'] as List?)?.cast<String>() ?? const [],
    );
  }
}
