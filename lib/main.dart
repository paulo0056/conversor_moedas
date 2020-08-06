import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:intl/intl.dart';

const request = "https://api.hgbrasil.com/finance?key=dce1bb0a";

void main() async {



  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Home(),
    theme: ThemeData(
      hintColor: Colors.white,
      primaryColor: Colors.amber,
      inputDecorationTheme: InputDecorationTheme(
        enabledBorder:
        OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
        focusedBorder:
        OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        hintStyle: TextStyle(color: Colors.amber),
      )),
  ));
}

Future<Map> getData() async {
  http.Response response = await http.get(request);
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();
  final btcController = TextEditingController();
  double dolar;
  double euro;
  double btc;
 NumberFormat formatter = NumberFormat("0.00");

  void _clearAll(){
    realController.text = "";
    dolarController.text = "";
    euroController.text = "";
    btcController.text = "";
  }

  void _realChanged(String text){
    if(text.isEmpty) {
      _clearAll();
      return;
    }
    double real = double.parse(text);
    dolarController.text = (real/dolar).toStringAsFixed(2);
    euroController.text = (real/euro).toStringAsFixed(2);
    btcController.text = (real/btc).toStringAsFixed(2);
  }
  void _dolarChanged(String text){
    if(text.isEmpty) {
      _clearAll();
      return;
    }
    double dolar = double.parse(text);
    realController.text = (dolar * this.dolar).toStringAsFixed(2);
    euroController.text = (dolar * this.dolar/euro).toStringAsFixed(2);
    btcController.text = (dolar * this.dolar/btc).toStringAsFixed(2);
  }
  void _euroChanged(String text){
    if(text.isEmpty) {
      _clearAll();
      return;
    }
    double euro = double.parse(text);
    realController.text = (euro * this.euro).toStringAsFixed(2);
    dolarController.text = (euro * this.euro/dolar).toStringAsFixed(2);
    btcController.text = (euro * this.euro/btc).toStringAsFixed(2);
  }
  void _btcChanged(String text){
    if(text.isEmpty) {
      _clearAll();
      return;
    }
    double btc = double.parse(text);
    realController.text = (btc * this.btc).toStringAsFixed(2);
    dolarController.text = (btc * this.btc/dolar).toStringAsFixed(2);
    euroController.text = (btc * this.btc/euro).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("\$ Conversor \$"),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: FutureBuilder<Map>(

            future: getData(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return Center(
                    child: Text("Carregando dados..",
                      style: TextStyle(
                          color: Colors.amber,
                          fontSize: 25.0),
                      textAlign: TextAlign.center,
                    ),
                  );
                default:
                  if (snapshot.hasError) {
                    return Center(
                      child: Text("Erro ao carregar dados",
                        style: TextStyle(
                            color: Colors.amber,
                            fontSize: 25.0),
                        textAlign: TextAlign.center,
                      ),
                    );
                  } else {
                    dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                    euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];
                    btc = snapshot.data["results"]["currencies"]["BTC"]["buy"];

                    return SingleChildScrollView(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [

                          Icon(Icons.monetization_on, size: 150.0,
                              color: Colors.amber),
                          SizedBox(height: 20),
                          buildTextField("Reais", "R\$", realController,_realChanged),
                          Divider(),
                          buildTextField("Dolár", "US\$", dolarController, _dolarChanged),
                          Divider(),
                          buildTextField("Euros", "€\$", euroController, _euroChanged),
                          Divider(),
                          buildTextField("BTC", "\$", btcController, _btcChanged),
                          SizedBox(height: 30),
                          Center(
                            child: Text(
                              "Cotação Real Brasileiro:",
                              style: TextStyle(color: Colors.amber, fontSize: 20),
                            ),
                          ),
                          SizedBox(height: 30,),

                          Row(
                            children: [

                              SizedBox(width: 29,),
                              Text(
                                "1Dolar:",
                                style: TextStyle(color: Colors.amber, fontSize: 14),
                              ),
                              SizedBox(width: 5,),
                              Text(
                                formatter.format(dolar),
                                style: TextStyle(color: Colors.amber, fontSize: 14),
                              ),
                              SizedBox(width: 20,),
                              Text(
                                "1Euro:",
                                style: TextStyle(color: Colors.amber, fontSize: 14),
                              ),
                              SizedBox(width: 5,),
                              Text(
                                formatter.format(euro),
                                style: TextStyle(color: Colors.amber, fontSize: 14),
                              ),
                              SizedBox(width: 20,),
                              Text(
                                "1BitCoin:",
                                style: TextStyle(color: Colors.amber, fontSize:14),
                              ),
                              SizedBox(width: 5,),
                              Text(
                                formatter.format(btc),
                                style: TextStyle(color: Colors.amber, fontSize: 14),
                              ),

                            ],
                          )

                        ],
                      ),
                    );
                  }
              }
            }),
      );



  }
/*
* */
}
Widget buildTextField(String label, String prefix, TextEditingController controlador, Function change){
    return TextField(
      controller: controlador,
      decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
              color: Colors.amber
          ),
          border: OutlineInputBorder(),
          prefixText: prefix

      ),
      style: TextStyle(
          color: Colors.amber, fontSize: 25.0
      ),
      onChanged: change,
      keyboardType: TextInputType.number,
    );
}
