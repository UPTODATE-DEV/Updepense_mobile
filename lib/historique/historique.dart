import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:up_depense/bloc/bloc.dart';
import 'package:up_depense/bloc/index.dart';
import 'package:up_depense/model/transaction.dart';
import 'package:up_depense/utils/util.dart';

class Historique extends StatefulWidget {
  static final String routeName = "/historique";
  @override
  _HistoriqueState createState() => _HistoriqueState();
}

class _HistoriqueState extends State<Historique> with TickerProviderStateMixin {
  TabController _tabController;
  AppBloc _bloc;
  int myIndice;
  @override
  void initState() {
    myIndice = 0;
    _bloc = AppBloc();
    _bloc.add(HistoriqueEvent());
    _tabController = TabController(
      initialIndex: 0,
      length: 3,
      vsync: this,
    );
    super.initState();
  }

  String dateFormatter(DateTime date) {
    return ('${date.day}${date.month}${date.year}').trim();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Column(
            children: <Widget>[
              custormAppBar(
                context,
                icon: Icons.arrow_back,
                title: "Historique",
                onLeadingIconTap: () {
                  Navigator.pop(context);
                },
              ),
              BlocListener<AppBloc, AppState>(
                listener: (context, state) {},
                bloc: _bloc,
                child: BlocBuilder<AppBloc, AppState>(
                    bloc: _bloc,
                    builder: (context, state) {
                      print(state);

                      if (state is HistoriqueLoaded) {
                        ResultTransaction transaction = state.result;
                        return Expanded(
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 0,
                                right: 10,
                                bottom: 20,
                              ),
                              child: Column(
                                children: List.generate(
                                    transaction.transactions.length, (index) {
                                  if (myIndice == 0) {
                                    return (transaction
                                                .transactions[index].etat ==
                                            true)
                                        ? Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              (index > 0)
                                                  ? ((dateFormatter(DateTime
                                                              .parse(transaction
                                                                  .transactions[
                                                                      index]
                                                                  .dateValidate)) ==
                                                          dateFormatter(DateTime
                                                              .parse(transaction
                                                                  .transactions[
                                                                      index - 1]
                                                                  .dateValidate)))
                                                      ? Container()
                                                      : showDate(
                                                          transaction:
                                                              transaction,
                                                          index: index))
                                                  : showDate(
                                                      transaction: transaction,
                                                      index: index),
                                              HistoriqueForm(
                                                transaction: transaction
                                                    .transactions[index],
                                                state: state,
                                              ),
                                            ],
                                          )
                                        : Container();
                                  } else if (myIndice == 1) {
                                    return (transaction
                                                    .transactions[index].etat ==
                                                false &&
                                            transaction.transactions[index]
                                                    .suprimer ==
                                                0)
                                        ? Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              (index > 0)
                                                  ? ((dateFormatter(DateTime
                                                              .parse(transaction
                                                                  .transactions[
                                                                      index]
                                                                  .dateValidate)) ==
                                                          dateFormatter(DateTime
                                                              .parse(transaction
                                                                  .transactions[
                                                                      index - 1]
                                                                  .dateValidate)))
                                                      ? showDate(
                                                          transaction:
                                                              transaction,
                                                          index: index)
                                                      : showDate(
                                                          transaction:
                                                              transaction,
                                                          index: index))
                                                  : showDate(
                                                      transaction: transaction,
                                                      index: index),
                                              HistoriqueForm(
                                                transaction: transaction
                                                    .transactions[index],
                                                state: state,
                                              ),
                                            ],
                                          )
                                        : Container();
                                  } else if (myIndice == 2) {
                                    return (transaction.transactions[index]
                                                    .suprimer ==
                                                1 &&
                                            transaction
                                                    .transactions[index].etat ==
                                                false)
                                        ? Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              (index > 0)
                                                  ? ((dateFormatter(DateTime
                                                              .parse(transaction
                                                                  .transactions[
                                                                      index]
                                                                  .dateValidate)) ==
                                                          dateFormatter(DateTime
                                                              .parse(transaction
                                                                  .transactions[
                                                                      index - 1]
                                                                  .dateValidate)))
                                                      ? showDate(
                                                          transaction:
                                                              transaction,
                                                          index: index)
                                                      : showDate(
                                                          transaction:
                                                              transaction,
                                                          index: index))
                                                  : showDate(
                                                      transaction: transaction,
                                                      index: index),
                                              HistoriqueForm(
                                                transaction: transaction
                                                    .transactions[index],
                                                state: state,
                                              ),
                                            ],
                                          )
                                        : Container();
                                  } else {
                                    return Container();
                                  }
                                }),
                              ),
                            ),
                          ),
                        );
                      } else if (state is HistoriqueLoading) {
                        return Container(
                          padding: EdgeInsets.only(top: 30.0),
                          child: Loading(
                            color: Theme.of(context).primaryColor,
                            size: 30.0,
                          ),
                        );
                      } else if (state is NoAccessState) {
                        return buildUIError(
                          context,
                          img: "assets/images/noAccess.svg",
                          titleMessage: "Pas d'acces internet",
                          subTitleMessage:
                              "Pas d'acces aux données mobiles\nveuillez verifier votre connexion.",
                          onPressed: () {
                            _bloc.add(HistoriqueEvent());
                          },
                        );
                      } else if (state is NotConnected) {
                        return buildUIError(context,
                            img: "assets/images/noAccess.svg",
                            titleMessage: "Pas d'acces internet",
                            subTitleMessage:
                                "Pas d'internet\nveuillez vous connecter à internet.",
                            onPressed: () {
                          _bloc.add(HistoriqueEvent());
                        });
                      } else {
                        return Container();
                      }
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  showDate({ResultTransaction transaction, int index}) {
    String dateNoFormatter = transaction.transactions[index].dateValidate;
    DateTime date = DateTime.parse(dateNoFormatter);

    return Padding(
      padding: EdgeInsets.only(top: 15, bottom: 8),
      child: Material(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        elevation: 2,
        shadowColor: Colors.grey.withOpacity(.2),
        child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              color: Colors.white,
            ),
            padding: EdgeInsets.only(left: 10),
            height: 30.0,
            width: 100.0,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(
                  FontAwesomeIcons.calendar,
                  size: 14.0,
                  color: Theme.of(context).primaryColor,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  "${date.day}/${date.month}/${date.year}",
                  style: GoogleFonts.dmSans(
                    textStyle:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            )),
      ),
    );
  }

  tabBar() {
    return Container(
      child: TabBar(
        onTap: (indiceTab) {
          setState(() {
            myIndice = indiceTab;
          });
        },
        labelStyle: GoogleFonts.dmSans(
          textStyle: TextStyle(
            fontSize: 16,
          ),
        ),
        labelColor: Theme.of(context).primaryColor,
        unselectedLabelColor: Colors.grey[500],
        controller: _tabController,
        tabs: <Widget>[
          Tab(
            text: "Validées",
          ),
          Tab(
            text: "Non validées",
          ),
          Tab(
            text: "Supprimer",
          ),
        ],
      ),
    );
  }

  custormAppBar(
    BuildContext context, {
    String title,
    IconData icon,
    onLeadingIconTap,
  }) {
    return Material(
      shadowColor: Colors.grey.withOpacity(.5),
      elevation: 2,
      child: Container(
        decoration: BoxDecoration(),
        child: Padding(
          padding:
              const EdgeInsets.only(top: 10.0, bottom: 0, right: 0, left: 0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  SizedBox(
                    width: 5,
                  ),
                  InkWell(
                    onTap: onLeadingIconTap,
                    borderRadius: BorderRadius.circular(50),
                    child: Container(
                      padding: EdgeInsets.all(2),
                      margin: EdgeInsets.only(left: 10),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          width: 1.5,
                          color: Colors.black,
                        ),
                      ),
                      child: Icon(
                        icon,
                        size: 20,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Spacer(),
                  Text(
                    "$title",
                    style: GoogleFonts.dmSans(
                        textStyle: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.w800,
                    )),
                  ),
                  Spacer(),
                  SizedBox(
                    width: 25,
                  ),
                ],
              ),
              Divider(),
              tabBar(),
            ],
          ),
        ),
      ),
    );
  }
}

class HistoriqueForm extends StatelessWidget {
  final Transaction transaction;
  final state;
  final Function onTap;
  const HistoriqueForm({Key key, this.transaction, this.state, this.onTap})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    var hour = DateTime.parse(transaction.dateAdd).hour;
    var minute = DateTime.parse(transaction.dateAdd).minute;
    var seconde = DateTime.parse(transaction.dateAdd).second;

    return Container(
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.only(
        bottom: 5,
        left: 5,
      ),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: (transaction.typeOp == "ENTREE")
            ? Color(0xFFF5F5F5)
            : Color(0xFFFFF5F5),
      ),
      child: Stack(
        children: <Widget>[
          new Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 5.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
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
                        "${transaction.psedo.trim()}",
                        style: GoogleFonts.dmSans(
                          textStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        "${transaction.motif.trim()}",
                        style: GoogleFonts.dmSans(
                          textStyle: TextStyle(
                            color: Colors.grey[500],
                          ),
                        ),
                      ),
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
          ),
          new Positioned(
            top: 0.0,
            bottom: 0.0,
            left: 5.0,
            child: Container(
              height: double.infinity,
              width: 2.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: (transaction.typeOp == "ENTREE")
                    ? Color(0xFF17ADA3)
                    : Color(0xFFFF4400),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
