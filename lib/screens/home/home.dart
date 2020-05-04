import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:up_depense/bloc/index.dart';
import 'package:up_depense/model/transaction.dart';
import 'package:up_depense/screens/home/drawe_home.dart';
import 'package:up_depense/screens/home/my_dialog.dart';
import 'package:up_depense/screens/home/validate.dart';
import 'package:up_depense/utils/up_depense.dart';
import 'package:up_depense/utils/util.dart';
import 'package:up_depense/utils/sliver_header.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../bloc/bloc.dart';
import '../../bloc/bloc.dart';
import 'login.dart';

class UpdepenseHome extends StatefulWidget {
  static final String routeName = "/home";
  @override
  _UpdepenseHomeState createState() => _UpdepenseHomeState();
}

class _UpdepenseHomeState extends State<UpdepenseHome> {
  AppBloc _bloc;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  GlobalKey<ScaffoldState> _scafoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    _bloc = ModalRoute.of(context).settings.arguments as AppBloc;
    return SafeArea(
      child: Scaffold(
        key: _scafoldKey,
        drawer: Container(
          width: MediaQuery.of(context).size.width * 5 / 6.5,
          child: Drawer(
            child: DrawerHome(),
            elevation: 3,
          ),
        ),
        body: BlocListener<AppBloc, AppState>(
          listener: (context, state) {
            if (state is OnLogoutState) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => AlertDialog(
                  content: Column(
                    children: <Widget>[
                      CircularProgressIndicator(),
                      Text(
                        "Déconnexion en cours",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.dmSans(
                          textStyle: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 18,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            } else if (state is LogoutSucces) {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, Login.routeName);
            }
          },
          child: BlocBuilder<AppBloc, AppState>(
              bloc: _bloc,
              builder: (context, state) {
                if (state is HomeLoading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is HomeLoaded) {
                  ResultTransaction resultTransaction = state.result;

                  return CustomScrollView(
                    slivers: <Widget>[
                      SliverAppBar(
                        floating: true,
                        flexibleSpace: custormAppBar(
                          context,
                          monthAndYear: "Mai 2020",
                          icon: Icons.menu,
                          onLeadingIconTap: () {
                            _scafoldKey.currentState.openDrawer();
                          },
                          onChevronLeftAction: () {},
                          onChevronRightAction: () {},
                        ),
                        bottom: PreferredSize(
                          preferredSize:
                              Size(MediaQuery.of(context).size.width, 40.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                height: 40,
                                width: 40,
                                child: FlatButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  padding: EdgeInsets.all(0),
                                  onPressed: () {},
                                  child: Icon(Icons.chevron_left),
                                ),
                              ),
                              Text(
                                "Le ${DateTime.parse((DateTime.now().toString())).day}",
                                style: GoogleFonts.dmSans(
                                    textStyle: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                )),
                              ),
                              Container(
                                height: 40,
                                width: 40,
                                child: FlatButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  padding: EdgeInsets.all(0),
                                  onPressed: () {},
                                  child: Icon(Icons.chevron_right),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SliverPersistentHeader(
                        pinned: true,
                        floating: true,
                        delegate: SliverAppBarDelegate(
                          PreferredSize(
                            preferredSize:
                                Size(MediaQuery.of(context).size.width, 0.0),
                            child: Container(
                              height: 0.0,
                              // color: Colors.blue,
                            ),
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        bottom: 10,
                                      ),
                                      child: Text(
                                        "Tableau de bord",
                                        style: GoogleFonts.dmSans(
                                          textStyle: TextStyle(
                                            fontWeight: FontWeight.w800,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                    ),
                                    buildDashBord(
                                      state: state,
                                      transaction: resultTransaction,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        bottom: 10,
                                        top: 10,
                                      ),
                                      child: Text(
                                        "Recente demande",
                                        style: GoogleFonts.dmSans(
                                            textStyle: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 18,
                                        )),
                                      ),
                                    ),
                                    Column(
                                      children: List.generate(
                                          resultTransaction.transactions.length,
                                          (index) {
                                        return (resultTransaction
                                                    .transactions[index].etat ==
                                                false)
                                            ? InkWell(
                                                onTap: () {
                                                  myDialog(
                                                    transactionHere:
                                                        resultTransaction
                                                                .transactions[
                                                            index],
                                                  );
                                                },
                                                child: Demande(
                                                  state: state,
                                                  transaction: resultTransaction
                                                      .transactions[index],
                                                ),
                                              )
                                            : Container();
                                      }),
                                    ),
                                  ]),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                } else {
                  return Container();
                }
              }),
        ),
      ),
    );
  }

  buildDashBord({
    state,
    ResultTransaction transaction,
  }) {
    double entry = transaction.entree;
    double out = transaction.sortie;
    String devise = UpDepense.user.devise;
    return Column(
      children: <Widget>[
        dashBoard(
          icon: Icons.monetization_on,
          libele: "Solde",
          color: Color(0xFF029FD4),
          montant: "${transaction.solde}",
          devise: devise,
        ),
        dashBoard(
          libele: "Entrée",
          icon: Icons.exit_to_app,
          color: Color(0xFF17ADA3),
          montant: "$entry",
          devise: devise,
        ),
        dashBoard(
            icon: FontAwesomeIcons.externalLinkAlt,
            libele: "Sortie",
            color: Color(0xFFFF4400),
            montant: "$out",
            devise: devise),
      ],
    );
  }

  dashBoard({
    Color color,
    String libele,
    String montant,
    String devise,
    IconData icon,
  }) {
    return Container(
      padding: EdgeInsets.only(
        left: 10,
        right: 10,
        top: 10,
        bottom: 10,
      ),
      margin: EdgeInsets.only(bottom: 10),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 35.0,
              width: 35.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                  color: Colors.white,
                  width: 1.0,
                ),
              ),
              child: Center(
                child: Icon(
                  icon,
                  size: 20,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "$libele",
                    style: GoogleFonts.dmSans(
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Text(
                    "$montant",
                    style: GoogleFonts.dmSans(
                      textStyle: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: Text(
                "$devise",
                style: GoogleFonts.dmSans(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  myDialog({Transaction transactionHere}) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => SimpleDialog(
        contentPadding: EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 0.0,
        children: <Widget>[
          HomeDialog(
            transactionHere: transactionHere,
          ),
        ],
      ),
    );
  }
}
