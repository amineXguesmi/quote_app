class Quote{

  late String quoteText;
  late String owner;
  late String imgLink;

  Quote({required this.quoteText,required this.owner,required this.imgLink});

  Quote.fromMap(Map<String, dynamic> map) {
      quoteText= map['quoteText']??"The phoenix must burn to emerge";
      owner= map['quoteAuthor']??"Janet Fitch";
      imgLink= map['quoteLink']??"";
  }

  Map<String, dynamic> toMap() {
    return {
      'quoteText': quoteText,
      'owner': owner,
      'imgLink': imgLink,
    };
  }
}