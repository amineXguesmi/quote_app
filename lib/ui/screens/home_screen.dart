import 'package:flutter/material.dart';
import 'package:workshop5/core/services/quote_service.dart';
import 'package:workshop5/ui/screens/saved_qutoes_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  QuoteService quoteService = QuoteService();
  bool working = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getQuote();
  }
  void getQuote() async{
    setState(() {
      working = false;
    });
    await quoteService.getQuote();
    setState(() {
      working = true;
    });
  }
  Widget drawImg() {
    if (quoteService.quote.imgLink.isEmpty) {
      return Image.asset("assets/offline.jpg", fit: BoxFit.cover);
    } else {
      return Image.network(quoteService.quote.imgLink, fit: BoxFit.cover);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
          alignment: Alignment.center,
          fit: StackFit.expand,
          children: <Widget>[
            drawImg(),
            Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0, 0.6, 1],
                    colors: [
                      Colors.blueGrey[800]!.withAlpha(70),
                      Colors.blueGrey[800]!.withAlpha(220),
                      Colors.blueGrey[800]!.withAlpha(255),
                    ],
                  ),
                ),
                padding:const EdgeInsets.symmetric(horizontal: 20, vertical: 100),
                child: working?Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                            text:  '“ ' ,
                            style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.w700,
                                fontSize: 30),
                            children: [
                              TextSpan(
                                  text: quoteService.quote.quoteText,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 22)),
                              const TextSpan(
                                  text:  '”' ,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black,
                                      fontSize: 30))
                            ]),
                      ),
                      Text(quoteService.quote.owner.isEmpty ? "" : "\n${quoteService.quote.owner}",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18)),
                    ]):const Center(child: CircularProgressIndicator(
                  color: Colors.black,
                ),
                ),
            ),
            AppBar(
              title: const Text(
                "Motivational Quote",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 30),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
            ),
          ]),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          FloatingActionButton(
            backgroundColor: Colors.blueGrey[900],
            onPressed: quoteService.saveQuote,
            child: const Icon(Icons.add),
          ),
          FloatingActionButton(
            backgroundColor: Colors.blueGrey[900],
            onPressed: getQuote,
            child: const Icon(Icons.refresh),
          ),
          FloatingActionButton(
            backgroundColor: Colors.blueGrey[900],
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>const StoredQuotes()));

            },
            child: const Icon(Icons.sd_storage),
          ),
        ],
      ),
    );
  }
}
