import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class TransactionsHistory extends StatefulWidget {
  const TransactionsHistory({super.key});

  @override
  State<TransactionsHistory> createState() => _TransactionsHistoryState();
}

class _TransactionsHistoryState extends State<TransactionsHistory> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getTransactions();
    });
  }

  // Future<void> getTransactions() async {
  //   print(DateFormat().format(DateTime.now()));
  //   SharedPreferences.getInstance().then((data) {
  //     data.getKeys().forEach((key) {
  //       String encodedTransaction = data.getString(key) ?? '';
  //       print(key);

  //       if (encodedTransaction.isNotEmpty) {
  //         Map<String, dynamic> singleTransaction =
  //             jsonDecode(encodedTransaction);

  //         transactionList.add(singleTransaction);
  //       }
  //     });

  //     print(transactionList);
  //     // numbers.reversed.toList()
  //     // transactionList = transactionList.reversed.toList();
  //     // transactionList.sort;

  //     // transactionList.sort((a, b) =>
  //     //     DateTime.parse(a['dateTime']).compareTo(DateTime.parse(b['dateTime'])));

  //     setState(() {});
  //   });
  // }

  getadaptiveTextSize(BuildContext context, dynamic value) {
    return (value / 710) * MediaQuery.of(context).size.height;
  }

  Future<void> getTransactions() async {
    SharedPreferences.getInstance().then((data) {
      List<String> keys = data.getKeys().toList();

      keys.sort((a, b) => int.parse(a).compareTo(int.parse(b)));

      keys.forEach((key) {
        String encodedTransaction = data.getString(key) ?? '';

        if (encodedTransaction.isNotEmpty) {
          Map<String, dynamic> singleTransaction =
              jsonDecode(encodedTransaction);

          transactionList.add(singleTransaction);
        }
      });

      transactionList = transactionList.reversed.toList();
      print(transactionList);

      setState(() {});
    });
  }

  var size, width, height;

  var transactionList = [];

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;
    return Scaffold(
        appBar: AppBar(
          title: Text('Transactions'),
        ),
        body: Center(
          child: ListView.builder(
            itemBuilder: (context, index) {

              return Center(
                child: Card(
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          height: height * 0.15,
                          width: width * 0.90,
                          child: Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: width * 0.60,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: width - (width / 4),
                                      // height: 130,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.only(top: 10),
                                            child: Text(
                                              '+ ${transactionList[index]["amount"]}',
                                              style: TextStyle(
                                                fontSize: getadaptiveTextSize(context, 15),
                                                color: Colors.green,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: width - (width / 4),
                                      height: height * 0.08,
                                      padding:
                                          EdgeInsets.only(top: 20, left: 26),
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                '${transactionList[index]["dateTime"]}'),
                                            Text(
                                                '${transactionList[index]["time"]}')
                                          ]),
                                    ),
                                  ],
                                ),
                              ),
                              Container(

                                  // width: (width-(width/4)*3),
                                  width: width * 0.30,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      if (transactionList[index]["Method"] ==
                                          "CASH")
                                        Icon(
                                          Icons.money,
                                          size: width * 0.10,
                                        ),
                                      if (transactionList[index]["Method"] !=
                                          "CASH")
                                        Icon(
                                          Icons.qr_code,
                                          // size: width * 0.10,
                                          size: getadaptiveTextSize(context, 30),
                                        ),
                                      Text(
                                          '${transactionList[index]["Method"]}',
                                          style: TextStyle(
                                            fontSize: getadaptiveTextSize(context, 12)
                                          ),
                                          )
                                    ],
                                  )),
                            ],
                          )),
                    )),
              );
            },
            itemCount: transactionList.length,
          ),
        ));
  }
}
