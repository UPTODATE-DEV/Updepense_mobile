import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:up_depense/model/transaction.dart';

class Demande extends StatelessWidget {
  final Transaction transaction;
  final state;
  final Function onTap;
  const Demande({Key key, this.transaction, this.state, this.onTap})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    var hour = DateTime.parse(transaction.dateAdd).hour;
    var minute = DateTime.parse(transaction.dateAdd).minute;
    var seconde = DateTime.parse(transaction.dateAdd).second;
    return Container(
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.only(bottom: 5),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: (transaction.typeOp == "ENTREE")
            ? Color(0xFFF5F5F5)
            : Color(0xFFFFF5F0),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 5),
            width: 3,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(0),
              color: (transaction.typeOp == "ENTREE")
                  ? Color(0xFF17ADA3)
                  : Color(0xFFFF4400),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 5),
            child: Material(
              shadowColor: Colors.grey.withOpacity(.3),
              borderRadius: BorderRadius.circular(5),
              elevation: 2,
              child: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(0),
                        child: Text("${hour}h",
                            style: GoogleFonts.dmSans(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
                              ),
                            )),
                      ),
                      Text("$minute' $seconde",
                          style: GoogleFonts.dmSans(
                            textStyle: TextStyle(
                              fontSize: 12,
                              // fontWeight: FontWeight.w800,
                            ),
                          )),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "${transaction.psedo}",
                  style: GoogleFonts.dmSans(
                    textStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text("${transaction.motif}",
                    style: GoogleFonts.dmSans(
                      textStyle: TextStyle(
                        color: Colors.grey[500],
                      ),
                    )),
              ],
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: (transaction.typeOp == "ENTREE")
                    ? Color(0xFF17ADA3)
                    : Color(0xFFFF4400),
              ),
            ),
            child: Text("${transaction.montant} ${transaction.devise}",
                style: GoogleFonts.dmSans(
                  textStyle: TextStyle(
                    color: (transaction.typeOp == "ENTREE")
                        ? Color(0xFF17ADA3)
                        : Color(0xFFFF4400),
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
