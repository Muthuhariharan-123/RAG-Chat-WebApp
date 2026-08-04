class ChatMessage {
  const ChatMessage.user(this.text)
      : isUser = true,
        isError = false,
        sources = const [];

  const ChatMessage.bot(this.text, {this.sources = const []})
      : isUser = false,
        isError = false;

  const ChatMessage.error(this.text)
      : isUser = false,
        isError = true,
        sources = const [];

  final String text;
  final bool isUser;
  final bool isError;
  final List<String> sources;
}
