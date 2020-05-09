import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:up_depense/bloc/http_helper.dart';
import 'package:up_depense/historique/historique.dart';
import 'package:up_depense/model/user.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:up_depense/screens/home/login.dart';
import 'package:up_depense/utils/util.dart';

import '../../bloc/index.dart';

class DrawerHome extends StatefulWidget {
  final appBloc;

  const DrawerHome({Key key, this.appBloc}) : super(key: key);
  @override
  _DrawerHomeState createState() => _DrawerHomeState();
}

class _DrawerHomeState extends State<DrawerHome> {
  User user;

  @override
  void initState() {
    var data = jsonDecode(getUserID());
    user = User.fromJson(data);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppBloc, AppState>(
      bloc: widget.appBloc,
      listener: (BuildContext context, state) {
        if (state is OnLogoutState) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => SimpleDialog(
                elevation: 0.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                children: <Widget>[
                  buildLogoutProgress(
                    context,
                    titleMessage: "Deconnexion en cours",
                    img: "assets/images/deconnexion.svg",
                  ),
                ]),
          );
        } else if (state is LogoutSucces) {
          Navigator.pop(context);
          Navigator.pushReplacementNamed(
            context,
            Login.routeName,
          );
        }
      },
      child: BlocBuilder<AppBloc, AppState>(
          bloc: widget.appBloc,
          builder: (context, state) {
            return Container(
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: buildData(),
            );
          }),
    );
  }

  buildData() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 30.0,
        ),
        Row(
          children: <Widget>[
            buildProfile(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "${user.nom}",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.dmSans(
                        textStyle: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Text(
                      "${user.nom}",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.dmSans(
                        textStyle: TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    Text(
                      "${user.fonction}",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.dmSans(
                        textStyle: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: SizedBox(
            height: 45.0,
            width: MediaQuery.of(context).size.width,
            child: FlatButton(
              color: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Row(
                children: <Widget>[
                  Icon(FontAwesomeIcons.stackExchange,
                      size: 20.0, color: Colors.white),
                  SizedBox(width: 8.0),
                  Text(
                    "Historique",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.dmSans(
                      textStyle: TextStyle(
                        fontSize: 17,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  Historique.routeName,
                );
              },
            ),
          ),
        ),
        Spacer(),
        Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            color: Colors.grey[200],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              buildDetail(title: 'RCCM', value: '${user.rccm}'),
              buildDetail(title: 'License', value: '${user.license}'),
              buildDetail(title: 'Exp', value: '${user.lincenceExp}'),
              Divider(),
              Text(
                "Build by Uptodate Developers",
                textAlign: TextAlign.center,
                style: GoogleFonts.dmSans(
                  textStyle: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: buildLogOutButton(),
        ),
      ],
    );
  }

  Widget buildLogOutButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
        height: 50.0,
        width: 50.0,
        child: FlatButton(
          color: Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Icon(Icons.exit_to_app, size: 20.0, color: Colors.white),
          onPressed: () {
            buildRequest();
            // widget.appBloc.add(LogoutRequestEvent());
          },
        ),
      ),
    );
  }

  buildRequest() {
    return showDialog(
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
                      "Déconnexion",
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
                      "Etes-vous sur de vouloir vous déconnecter?",
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
                        color: Colors.grey[100],
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: 80.0,
                          child: Text(
                            "Annuler",
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
                          Navigator.pop(context);
                          widget.appBloc.add(LogoutEvent());
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

  Widget buildDetail({String title, String value}) {
    return Text.rich(
      TextSpan(
        text: "$title :\n",
        children: [
          TextSpan(
            text: '$value',
            style: GoogleFonts.dmSans(
              textStyle: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          )
        ],
        style: GoogleFonts.dmSans(
          textStyle: TextStyle(
            fontSize: 14,
            color: Colors.black54,
          ),
        ),
      ),
    );
  }

  buildProfile() {
    return Container(
      width: 50,
      height: 50,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          width: 2,
          color: Colors.grey[200],
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/icons/updepenseIcon.png"),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
