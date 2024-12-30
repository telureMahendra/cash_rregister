import 'dart:convert';

import 'package:cash_register/success.dart';
import 'package:cash_register/transactions_history.dart';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String total = '0.0';
  int tempNum = 0;
  String evalString = "0";

  final inrFormat = NumberFormat.currency(
    locale: 'hi_IN',
    name: 'INR',
    symbol: '₹',
    decimalDigits: 2,
  );

  getadaptiveTextSize(BuildContext context, dynamic value) {
    return (value / 710) * MediaQuery.of(context).size.height;
  }

  Parser p = Parser();

  void calculate() {
    Expression exp = p.parse(evalString);
    ContextModel cm = ContextModel();

    setState(() {
      total = '${exp.evaluate(EvaluationType.REAL, cm)}';
      // total = "${oCcy.format(total)}";
    });
  }


  void payBill(String method) {


    setState(() {
      // var myInt = int.parse(total);
      // assert(myInt is int);
      // print("int is ${myInt}");

      if ((total == '0') ||
          (total == 0) ||
          total == '0.00' ||
          (total == 0.00) ||
          total == '0.0' ||
          (total == 0.0) ||
          total == '00' ||
          (total == 00)) {
        // 

        showDialog<void>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Oops😬'),
            content: Text('Enter a amount'),
            actions: [
              TextButton(
                child: const Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
        
      } else {
        saveTransaction(method);
      }
    });
  }

  Future<void> saveTransaction(String method) async {
    var prefs = await SharedPreferences.getInstance();

    Map<String, dynamic> singleTransaction = {
      "key": prefs.getKeys().length + 1,
      "amount": '${inrFormat.format(double.parse(total))}',
      "Method": method,
      "dateTime": DateFormat('yMMMd').format(DateTime.now()),
      "time": DateFormat('jms').format(DateTime.now()),
      "currentDay": DateFormat('d').format(DateTime.now()),
      "currentMonth": DateFormat('MMM').format(DateTime.now()),
      "currentYear": DateFormat('y').format(DateTime.now()),
    };
    // prefs.setString('${DateFormat().format(DateTime.now())}', jsonEncode(singleTransaction));
    // prefs.getKeys().length+1;
    prefs.setString(
        '${prefs.getKeys().length + 1}', jsonEncode(singleTransaction));
    successful();
  }

  void successful() {

    Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return success();
      },
    ));
  }

  void evaluation() {
    setState(() {
      calculate();
      if (evalString[evalString.length - 1] != "+") {
        evalString += "+";
      }
    });
  }

  void backSpace() {
    setState(() {
      // evalString.
      if (evalString != null && evalString.length > 0) {
        evalString = evalString.substring(0, evalString.length - 1);
      }
      if (evalString.isEmpty) {
        evalString = '0';
        total = '0';
      }

      calculate();
    });
  }

  void addition(String number) {
    setState(() {
      if (evalString == '0') {
        evalString = number;
      } else {
        evalString += number;
      }
      calculate();
    });
  }

  void clear() {
    setState(() {
      evalString = "0";
      total = '00';
    });
  }

  var size, width, height, appBarHeight;
  var btnHeight, btnWidth;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;
    appBarHeight = AppBar().preferredSize.height;
    var heightAll = MediaQuery.of(context).padding.top;

    btnHeight = ((height - 337) / 4) - 6;
    btnWidth = ((width - (width / 4)) / 3) - 6;

    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: 'Transactions',
            onPressed: () {
              // handle the press
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return const TransactionsHistory();
                },
              ));
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'App Settings',
            onPressed: () {
              // handle the press
            },
          ),
        ],
        centerTitle: false,
      ),

      resizeToAvoidBottomInset: false,
      body: 
      
      
      Center(
        child: Column(
          children: [
            Container(
              color: Colors.amber,
              margin: EdgeInsets.only(top: 10),
              // height: 30,
              padding: EdgeInsets.all(15),
              width: width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "TOTAL AMOUNT ",
                        style: TextStyle(
                            fontSize: getadaptiveTextSize(context, 10)),
                      ),
                    ],
                  ),

                  // amount
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.end,
                          children: [
                            Row(
                              children: [
                                Text(
                                  // '$total',
                                  '${inrFormat.format(double.parse(total))}',
                                  overflow: TextOverflow.fade,
                                  softWrap: true,
                                  style: TextStyle(
                                      fontSize:
                                          getadaptiveTextSize(context, 10)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),

            // pay bill
            Container(
              height: 50,
              margin: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // CASH
                  Container(
                      width: (width / 2) - 15,
                      child: ElevatedButton(
                        onPressed: () {
                          payBill("CASH");
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.money,
                              color: Colors.white,
                            ),
                            Text(
                              'Cash',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: getadaptiveTextSize(context, 15)),
                            ),
                          ],
                        ),
                      )),

                  // UPI/QR
                  Container(
                      width: (width / 2) - 15,
                      child: ElevatedButton(
                        onPressed: () {
                          payBill("QR/UPI");
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.qr_code,
                              color: Colors.white,
                            ),
                            Text(
                              'UPI/QR',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: getadaptiveTextSize(context, 15)),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),

            // // Amount & Calculation
            Container(
              height: 100,
              margin: EdgeInsets.only(left: 5, right: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.amber[50],
                border: Border.all(
                  color: Colors.blueGrey,
                  width: 1,
                ),
              ),
              padding: EdgeInsets.all(5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Container(
                        child: Text(
                          "Amount",
                          overflow: TextOverflow.fade,
                          softWrap: true,
                          style: TextStyle(
                              fontSize: getadaptiveTextSize(context, 10)),
                        ),
                      ),
                    ],
                  ),

                  // evaluation
                  SingleChildScrollView(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: EdgeInsets.only(right: 10),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Wrap(
                                children: [
                                  Container(
                                    width: width - (width / 3),
                                    alignment: Alignment.topRight,
                                    child: Text(
                                      '$evalString',
                                      overflow: TextOverflow.fade,
                                      softWrap: true,
                                      style: TextStyle(
                                          color: Color.fromARGB(255, 214, 7, 7),
                                          fontSize:
                                              getadaptiveTextSize(context, 15)),
                                    ),
                                  )
                                ],
                              )
                            ]),
                      )
                    ],
                  )),
                ],
              ),
            ),

            // buttons
            Container(
              child: Row(
                children: [
                  Container(
                    width: width - (width / 4),
                    child: Container(
                      width: width,
                      height: height - 337,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 1-3
                          Container(
                            width: width - (width / 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                // button 1
                                Container(
                                  height: btnHeight,
                                  width: btnWidth,
                                  child: ElevatedButton(
                                    child: Text(
                                      "1",
                                      style: TextStyle(
                                          fontSize:
                                              getadaptiveTextSize(context, 40)),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color.fromARGB(
                                          255, 236, 233, 232), // background
                                      foregroundColor:
                                          Colors.black, // foreground
                                    ),
                                    onPressed: () {
                                      addition('1');
                                    },
                                  ),
                                ),

                                // button 2
                                Container(
                                  height: btnHeight,
                                  width: btnWidth,
                                  child: ElevatedButton(
                                    child: Text(
                                      "2",
                                      style: TextStyle(
                                          fontSize:
                                              getadaptiveTextSize(context, 40)),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color.fromARGB(
                                          255, 236, 233, 232), // background
                                      foregroundColor:
                                          Colors.black, // foreground
                                    ),
                                    onPressed: () {
                                      addition('2');
                                    },
                                  ),
                                ),

                                // button 3
                                Container(
                                  height: btnHeight,
                                  width: btnWidth,
                                  child: ElevatedButton(
                                    child: Text(
                                      "3",
                                      style: TextStyle(
                                          fontSize:
                                              getadaptiveTextSize(context, 40)),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color.fromARGB(
                                          255, 236, 233, 232), // background
                                      foregroundColor:
                                          Colors.black, // foreground
                                    ),
                                    onPressed: () {
                                      addition('3');
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // 4-6
                          Container(
                            width: width - (width / 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                // button 4
                                Container(
                                  height: btnHeight,
                                  width: btnWidth,
                                  child: ElevatedButton(
                                    child: Text(
                                      "4",
                                      style: TextStyle(
                                          fontSize:
                                              getadaptiveTextSize(context, 40)),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color.fromARGB(
                                          255, 236, 233, 232), // background
                                      foregroundColor:
                                          Colors.black, // foreground
                                    ),
                                    onPressed: () {
                                      addition('4');
                                    },
                                  ),
                                ),

                                // button 5
                                Container(
                                  height: btnHeight,
                                  width: btnWidth,
                                  child: ElevatedButton(
                                    child: Text(
                                      "5",
                                      style: TextStyle(
                                          fontSize:
                                              getadaptiveTextSize(context, 40)),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color.fromARGB(
                                          255, 236, 233, 232), // background
                                      foregroundColor:
                                          Colors.black, // foreground
                                    ),
                                    onPressed: () {
                                      addition('5');
                                    },
                                  ),
                                ),

                                // button 6
                                Container(
                                  height: btnHeight,
                                  width: btnWidth,
                                  child: ElevatedButton(
                                    child: Text(
                                      "6",
                                      style: TextStyle(
                                          fontSize:
                                              getadaptiveTextSize(context, 40)),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color.fromARGB(
                                          255, 236, 233, 232), // background
                                      foregroundColor:
                                          Colors.black, // foreground
                                    ),
                                    onPressed: () {
                                      addition('6');
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // 7-9
                          Container(
                            width: width - (width / 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                // button 7
                                Container(
                                  height: btnHeight,
                                  width: btnWidth,
                                  child: ElevatedButton(
                                    child: Text(
                                      "7",
                                      style: TextStyle(
                                          fontSize:
                                              getadaptiveTextSize(context, 40)),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color.fromARGB(
                                          255, 236, 233, 232), // background
                                      foregroundColor:
                                          Colors.black, // foreground
                                    ),
                                    onPressed: () {
                                      addition('7');
                                    },
                                  ),
                                ),

                                // button 8
                                Container(
                                  height: btnHeight,
                                  width: btnWidth,
                                  child: ElevatedButton(
                                    child: Text(
                                      "8",
                                      style: TextStyle(
                                          fontSize:
                                              getadaptiveTextSize(context, 40)),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color.fromARGB(
                                          255, 236, 233, 232), // background
                                      foregroundColor:
                                          Colors.black, // foreground
                                    ),
                                    onPressed: () {
                                      addition('8');
                                    },
                                  ),
                                ),

                                // button 9
                                Container(
                                  height: btnHeight,
                                  width: btnWidth,
                                  child: ElevatedButton(
                                    child: Text(
                                      "9",
                                      style: TextStyle(
                                          fontSize:
                                              getadaptiveTextSize(context, 40)),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color.fromARGB(
                                          255, 236, 233, 232), // background
                                      foregroundColor:
                                          Colors.black, // foreground
                                    ),
                                    onPressed: () {
                                      addition('9');
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // clear-0-+
                          Container(
                            width: width - (width / 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                // button clear
                                Container(
                                  height: btnHeight,
                                  width: btnWidth,
                                  child: ElevatedButton(
                                    child: Text(
                                      "C",
                                      style: TextStyle(
                                          fontSize:
                                              getadaptiveTextSize(context, 20)),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color.fromARGB(
                                          255, 236, 233, 232), // background
                                      foregroundColor:
                                          Colors.black, // foreground
                                    ),
                                    onPressed: () {
                                      clear();
                                    },
                                  ),
                                ),

                                // button 0
                                Container(
                                  height: btnHeight,
                                  width: btnWidth * 2,
                                  child: ElevatedButton(
                                    child: Text(
                                      "0",
                                      style: TextStyle(
                                          fontSize:
                                              getadaptiveTextSize(context, 40)),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color.fromARGB(
                                          255, 236, 233, 232), // background
                                      foregroundColor:
                                          Colors.black, // foreground
                                    ),
                                    onPressed: () {
                                      addition('0');
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: (width / 4),
                    height: height - 337,
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          // / back button
                          Container(
                            height: btnHeight * 2,
                            width: btnWidth,
                            color: Color.fromARGB(255, 236, 233, 232),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color.fromARGB(
                                    255, 236, 233, 232), // background
                                foregroundColor: Colors.black, // foreground
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Icon(Icons.currency_rupee_rounded, color: Colors.white,),
                                  Icon(
                                    Icons.arrow_back,
                                    color: Colors.black,
                                    size: 50,
                                  ),
                                ],
                              ),
                              onPressed: () {
                                backSpace();
                              },
                            ),
                          ),

                          // button add/addition
                          Container(
                            height: btnHeight * 2,
                            width: btnWidth,
                            color: Color.fromARGB(255, 236, 233, 232),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color.fromARGB(
                                    255, 236, 233, 232), // background
                                foregroundColor: Colors.black, // foreground
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Icon(Icons.currency_rupee_rounded, color: Colors.white,),
                                  Icon(
                                    Icons.add,
                                    color: Colors.black,
                                    size: 50,
                                  ),
                                ],
                              ),
                              onPressed: () {
                                evaluation();
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),

            // Button
          ],
        ),
      ),
    );
  }
}
