import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:up_depense/bloc/bloc.dart';
import 'package:up_depense/bloc/index.dart';
import 'package:up_depense/model/transaction.dart';
import 'package:up_depense/utils/util.dart';

class HomeDialog extends StatelessWidget {
  final Transaction transactionHere;

  const HomeDialog({
    Key key,
    this.transactionHere,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var _bloc;
    _bloc = AppBloc();
    return Container(
      padding: EdgeInsets.only(
        left: 10,
        right: 10,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: SingleChildScrollView(
        child: BlocProvider(
          create: (BuildContext context) => AppBloc(),
          child: BlocBuilder<AppBloc, AppState>(
              bloc: _bloc,
              builder: (context, state) {
                print(state);
                if (state is SuccessState) {
                  return Container();
                } else {
                  return buidData(context: context, bloc: _bloc, state: state);
                }
              }),
        ),
      ),
    );
  }

  buidData({
    BuildContext context,
    state,
    bloc,
  }) {
    return IgnorePointer(
      ignoring: (state is ValidateState || state is RejeteState) ? true : false,
      child: Column(
        children: <Widget>[
          Container(
            child: Icon(
              Icons.info_outline,
              size: 80,
              color: Color(0xFF17ADA3),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              bottom: 10,
            ),
            child: Text(
              "Validation",
              style: GoogleFonts.dmSans(
                  textStyle: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 18,
              )),
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey.withOpacity(.1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 5.0),
                  child: Text(
                    "${transactionHere.psedo}",
                    style: GoogleFonts.dmSans(
                        textStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    )),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        "${transactionHere.motif}",
                        style: GoogleFonts.dmSans(
                            textStyle: TextStyle(
                          color: Colors.grey[800],
                          // fontWeight: FontWeight.w600,
                        )),
                      ),
                    ),
                  ],
                ),
                Divider(),
                Row(
                  children: <Widget>[
                    Text(
                      "Opération: ",
                      style: GoogleFonts.dmSans(
                          textStyle: TextStyle(
                        color: Colors.grey[800],
                        // fontWeight: FontWeight.w600,
                      )),
                    ),
                    Text(
                      "${transactionHere.typeOp}",
                      style: GoogleFonts.dmSans(
                          textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                      )),
                    ),
                    Spacer(),
                    Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: (transactionHere.typeOp == "ENTREE")
                              ? Color(0xFF17ADA3)
                              : Color(0xFFFF4400),
                        ),
                      ),
                      child: Text(
                          "${transactionHere.montant} ${transactionHere.devise}",
                          style: GoogleFonts.dmSans(
                            textStyle: TextStyle(
                              color: (transactionHere.typeOp == "ENTREE")
                                  ? Color(0xFF17ADA3)
                                  : Color(0xFFFF4400),
                            ),
                          )),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          FlatButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            color: Theme.of(context).primaryColor,
            onPressed: () {
              bloc.add(ValidateEvent());
            },
            child: Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(left: 3, right: 3, top: 5, bottom: 5),
              child: (state is ValidateState)
                  ? Loading(
                      size: 30,
                      color: Colors.white,
                    )
                  : Text(
                      "Validé",
                      style: GoogleFonts.dmSans(
                        textStyle: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
            ),
          ),
          FlatButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            color: Color(0xFF17ADA3),
            onPressed: () {
              bloc.add(RejeteEvent());
            },
            child: Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(left: 3, right: 3, top: 5, bottom: 5),
              child: (state is RejeteState)
                  ? Loading(
                      size: 30,
                      color: Colors.white,
                    )
                  : Text(
                      "Rejeté",
                      style: GoogleFonts.dmSans(
                        textStyle: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "Annuler",
                style: GoogleFonts.dmSans(
                    textStyle: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).primaryColor,
                )),
              ),
            ),
          ),
        ],
      ),
    );
  }

  buttonStyle(
    BuildContext context, {
    state,
    String action,
    Function onPressed,
    Color color,
  }) {
    return FlatButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      color: color,
      onPressed: onPressed,
      child: Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(left: 3, right: 3, top: 5, bottom: 5),
        child: (state is ValidateState)
            ? Loading(
                size: 30,
                color: Colors.white,
              )
            : Text(
                "$action",
                style: GoogleFonts.dmSans(
                  textStyle: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
      ),
    );
  }
}
