class Quote {
  final String text;
  final String author;

  Quote({required this.text, required this.author});

  Map<String, String> toMap() => {'text': text, 'author': author};
  factory Quote.fromMap(Map<String, dynamic> map) =>
      Quote(text: map['text'], author: map['author']);
}
