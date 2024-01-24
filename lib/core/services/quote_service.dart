import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workshop5/core/models/quote.dart';

class QuoteService {
  final dio = Dio();
  late Quote quote = Quote(quoteText: '', owner: '', imgLink: '');
  List savedQuotes = [];
  Future<void> getQuote() async {
    try {
      final response = await dio.get(
        'http://api.forismatic.com/api/1.0/?method=getQuote&format=json&lang=en',
      );
      if (response.statusCode == 200) {
        quote = Quote.fromMap(response.data);
        await getImg(quote.owner);
      } else {
        quote = Quote(quoteText: 'The phoenix must burn to emerge', owner: 'Janet Fitch', imgLink: '');
      }
    } catch (e) {
      quote = Quote(quoteText: 'The phoenix must burn to emerge', owner: 'Janet Fitch', imgLink: '');
    }
  }

  getImg(String name) async {
    var image = await dio.get(
        "https://en.wikipedia.org/w/api.php?action=query&generator=search&gsrlimit=1&prop=pageimages%7Cextracts&pithumbsize=400&gsrsearch=$name&format=json");
    try {
      var res = image.data["query"]["pages"];
      res = res[res.keys.first];
      quote.imgLink = res["thumbnail"]["source"];
    } catch (e) {
      quote.imgLink = "";
    }
  }

  Future<void> saveQuote() async {
    savedQuotes.add(quote);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> quotesList = savedQuotes.map((quote) => jsonEncode(quote.toMap())).toList();
    prefs.setStringList('quotesList', quotesList);
  }

  Future<void> loadQuotes() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String>? quotesList = prefs.getStringList('quotesList');
    if (quotesList != null) {
      savedQuotes = quotesList.map((quoteJson) => Quote.fromMap(jsonDecode(quoteJson))).toList();
    }
  }
}
