import 'package:flutter/material.dart';
import 'package:workshop5/core/services/quote_service.dart';

import '../../core/models/quote.dart';

class StoredQuotes extends StatefulWidget {
  const StoredQuotes({super.key});

  @override
  State<StoredQuotes> createState() => _StoredQuotesState();
}

class _StoredQuotesState extends State<StoredQuotes> {
  QuoteService quoteService = QuoteService();
  bool working = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadQuotes();
  }

  void loadQuotes() async{
    setState(() {
      working=false;
    });
    await quoteService.loadQuotes();
    setState(() {
      working=true;
    });
  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        body: Stack(
          alignment: Alignment.center,
          fit: StackFit.expand,
          children: [
            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0, 0.6, 1],
                  colors: [
                    Colors.blueGrey[800]!.withAlpha(70),
                    Colors.blueGrey[800]!.withAlpha(220),
                    Colors.blueGrey[800]!.withAlpha(255),
                  ],
                ),
              ),
              padding:const EdgeInsets.symmetric(horizontal: 20, vertical: 100),
              child: Container(

              ),
            ),
            Column(
              children: [
                const SizedBox(height: 20,),
                const Text('Saved Quotes',style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white
                ),),
                const SizedBox(height: 20,),
                working?Expanded(
                  child: ListView.builder(
                      itemCount: quoteService.savedQuotes.length,
                      itemBuilder: (context, index) {
                        final Quote quote = quoteService.savedQuotes[index];
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          child: ListTile(
                            title: Center(
                              child: Text(
                                quote.owner,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 15, bottom: 10),
                              child: Text(
                                '"${quote.quoteText}"',
                                style: const TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
                              ),
                            ),
                          ),
                        );
                      }),
                ):const Center(child: CircularProgressIndicator(
                  color: Colors.black,
                ),),
              ],
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back,),
        ),
      ),
    );
  }
}
