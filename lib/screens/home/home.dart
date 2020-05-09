import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:up_depense/bloc/index.dart';
import 'package:up_depense/model/transaction.dart';
import 'package:up_depense/screens/home/drawe_home.dart';
import 'package:up_depense/screens/home/my_dialog.dart';
import 'package:up_depense/screens/home/validate.dart';
import 'package:up_depense/utils/up_depense.dart';
import 'package:up_depense/utils/util.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../bloc/bloc.dart';

class UpdepenseHome extends StatefulWidget {
  static final String routeName = "/home";
  @override
  _UpdepenseHomeState createState() => _UpdepenseHomeState();
}

class _UpdepenseHomeState extends State<UpdepenseHome> {
  AppBloc _bloc;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  ScrollController _scrollController;
  @override
  void initState() {
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  Future<bool> onWillPop() async {
    return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => SimpleDialog(
          elevation: 0.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width - 70,
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
                      bottom: 0,
                    ),
                    child: Text(
                      "Quitter l'application",
                      style: GoogleFonts.dmSans(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: 10,
                    ),
                    child: Text(
                      "Etes-vous sur de vouloir quitter l'application?",
                      style: GoogleFonts.dmSans(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FlatButton(
                        // color: Color(0xFFFF4400),
                        color: Colors.grey[100],
                        onPressed: () {
                          Navigator.pop(context, false);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: 80.0,
                          child: Text(
                            "Non",
                            style: GoogleFonts.dmSans(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      FlatButton(
                        color: Theme.of(context).primaryColor,
                        onPressed: () {
                          Navigator.pop(context, true);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: 80.0,
                          child: Text(
                            "Oui",
                            style: GoogleFonts.dmSans(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ]),
    );
  }

  GlobalKey<ScaffoldState> _scafoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    _bloc = ModalRoute.of(context).settings.arguments as AppBloc;
    return WillPopScope(
      onWillPop: onWillPop,
      child: SafeArea(
        child: SmartRefresher(
          scrollController: _scrollController,
          enablePullDown: true,
          enablePullUp: false,
          controller: _refreshController,
          onRefresh: () async {
            _bloc.add(HomeEvent());
            await Future.delayed(Duration(microseconds: 500));
            _refreshController.refreshCompleted();
            // _refreshController.loadComplete();
          },
          child: Scaffold(
            key: _scafoldKey,
            drawer: Container(
              width: MediaQuery.of(context).size.width * 5 / 6.5,
              child: Drawer(
                child: DrawerHome(
                  appBloc: _bloc,
                ),
                elevation: 3,
              ),
            ),
            body: Column(
              children: <Widget>[
                custormAppBar(
                  context,
                  monthAndYear: "Up dépense",
                  icon: Icons.menu,
                  onLeadingIconTap: () async {
                    _scafoldKey.currentState.openDrawer();
                  },
                  onChevronLeftAction: () {},
                  onChevronRightAction: () {},
                ),
                Expanded(
                    child: Padding(
                        padding: EdgeInsets.only(top: 0, left: 10, right: 10),
                        child: SingleChildScrollView(
                          child: BlocListener<AppBloc, AppState>(
                            bloc: _bloc,
                            listener: (context, state) {},
                            child: BlocBuilder<AppBloc, AppState>(
                                bloc: _bloc,
                                builder: (context, state) {
                                  if (state is HomeLoading) {
                                    return Padding(
                                      padding: EdgeInsets.only(top: 50.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Loading(
                                            color:
                                                Theme.of(context).primaryColor,
                                            size: 40.0,
                                          ),
                                        ],
                                      ),
                                    );
                                  } else if (state is NoAccessState) {
                                    return Container(
                                        margin: EdgeInsets.only(top: 50),
                                        child: buildUIError(
                                          context,
                                          img: "assets/images/noAccess.svg",
                                          titleMessage:
                                              "Pas d'acces aux données mobiles",
                                          subTitleMessage:
                                              "Pas d'acces aux données mobiles\nveuillez verifier votre connexion.",
                                          onPressed: () {
                                            _bloc.add(HomeEvent());
                                          },
                                        ));
                                  } else if (state is NotConnected) {
                                    return Container(
                                      margin: EdgeInsets.only(top: 50),
                                      child: buildUIError(context,
                                          img: "assets/images/noAccess.svg",
                                          titleMessage: "Pas d'acces internet",
                                          subTitleMessage:
                                              "Pas d'internet\nveuillez vous connecter à internet.",
                                          onPressed: () {
                                        _bloc.add(HomeEvent());
                                      }),
                                    );
                                  } else if (state is HomeLoaded) {
                                    ResultTransaction resultTransaction =
                                        state.result;

                                    return buildData(
                                      resultTransaction: resultTransaction,
                                      state: state,
                                    );
                                  } else {
                                    return Container();
                                  }
                                }),
                          ),
                        )))
              ],
            ),
          ),
        ),
      ),
    );
  }

  buildData({state, resultTransaction}) {
    return Column(
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
              ),
            ),
          ),
        ),
        Column(
          children: List.generate(
            resultTransaction.transactions.length,
            (index) {
              return (resultTransaction.transactions[index].etat == false &&
                      resultTransaction.transactions[index].suprimer == 0)
                  ? InkWell(
                      onTap: () async {
                        var result = await myDialog(
                          transactionHere:
                              resultTransaction.transactions[index],
                        );
                        if (result != null && result == "refreshHome") {
                          _bloc.add(HomeEvent());
                        }
                      },
                      child: Demande(
                        state: state,
                        transaction: resultTransaction.transactions[index],
                      ),
                    )
                  : Container();
            },
          ),
        ),
      ],
    );
  }

  buildDashBord({
    state,
    ResultTransaction transaction,
  }) {
    var entry = transaction.entree;
    var out = transaction.sortie;
    var devise = UpDepense.user.devise;
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
