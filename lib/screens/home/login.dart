import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:up_depense/utils/up_depense.dart';
import 'package:up_depense/utils/util.dart';
import 'package:up_depense/bloc/index.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:up_depense/screens/home/home.dart';

class Login extends StatefulWidget {
  static final String routeName = "/login";
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isObscureText = true;
  bool remember = false;
  var appBloc;

  TextEditingController _username = TextEditingController();
  TextEditingController _password = TextEditingController();

  @override
  void initState() {
    appBloc = AppBloc();
    appBloc.add(InitialLoginEvent());

    super.initState();
  }

  void _rememberMe(bool value) {
    setState(() {
      remember = !remember;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.only(
            top: 15,
            left: 15,
            right: 15,
          ),
          child: Center(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(bottom: 5),
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/icons/updepenseIcon.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: Text(
                      "Up dépense",
                      style: GoogleFonts.dmSans(
                        textStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  ),
                  builLogin(),
                  buildImage(),
                  slogant(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  builLogin() {
    return BlocListener<AppBloc, AppState>(
      bloc: appBloc,
      listener: (context, state) {
        if (state is LoginSucces) {
          setMobileToken(remember ? state.user.token : '');
          UpDepense.token = state.user.token;
          appBloc.add(HomeEvent());
        } else if (state is HomeLoaded) {
          Navigator.of(context).pushReplacementNamed(
            UpdepenseHome.routeName,
            arguments: appBloc,
          );
        }
      },
      child: BlocBuilder<AppBloc, AppState>(
          bloc: appBloc,
          builder: (context, state) {
            if (state is ErrorUIState) {
              return buildUIError(
                context,
                img: "assets/images/loginError.svg",
                titleMessage: "Erreur de connexion",
                subTitleMessage:
                    "Nom d'utilisateur ou mot de passe incorrect\nveuillez entrer des bonnes donnée.",
                onPressed: () {
                  appBloc.add(InitialLoginEvent());
                },
              );
            } else if (state is NoAccessState) {
              return buildUIError(
                context,
                img: "assets/images/noAccess.svg",
                titleMessage: "Pas d'acces internet",
                subTitleMessage:
                    "Pas d'acces aux données mobiles\nveuillez verifier votre connexion.",
                onPressed: () {
                  if (_username.text.trim().isNotEmpty ||
                      _password.text.trim().isNotEmpty) {
                    FocusScope.of(context).requestFocus(new FocusNode());
                    appBloc.add(
                      LoginEvent(
                        username: _username.text,
                        password: _password.text,
                        remember: remember,
                      ),
                    );
                  }
                },
              );
            } else if (state is NotConnected) {
              return buildUIError(context,
                  img: "assets/images/noAccess.svg",
                  titleMessage: "Pas d'acces internet",
                  subTitleMessage:
                      "Pas d'internet\nveuillez vous connecter à internet.",
                  onPressed: () {
                if (_username.text.trim().isNotEmpty ||
                    _password.text.trim().isNotEmpty) {
                  FocusScope.of(context).requestFocus(new FocusNode());
                  appBloc.add(
                    LoginEvent(
                      username: _username.text,
                      password: _password.text,
                      remember: remember,
                    ),
                  );
                }
              });
            } else {
              return IgnorePointer(
                ignoring: state is OnLoadingState || state is HomeLoading,
                child: Container(
                  margin: EdgeInsets.all(5),
                  width: MediaQuery.of(context).size.width,
                  child: Material(
                    shadowColor: Colors.grey.withOpacity(.1),
                    elevation: 5,
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3),
                              color: Colors.grey.withOpacity(.1),
                            ),
                            child: Row(
                              children: <Widget>[
                                SizedBox(
                                  width: 10,
                                ),
                                Icon(
                                  Icons.account_circle,
                                  color: Colors.grey[500],
                                ),
                                Expanded(
                                  child: TextField(
                                    controller: _username,
                                    decoration: InputDecoration(
                                      contentPadding:
                                          EdgeInsets.only(left: 10.0),
                                      border: InputBorder.none,
                                      hintText: "Nom d'utilisateur",
                                      hintStyle: GoogleFonts.dmSans(
                                        textStyle: TextStyle(
                                          color: Colors.grey[500],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3),
                              color: Colors.grey.withOpacity(.1),
                            ),
                            child: Row(
                              children: <Widget>[
                                SizedBox(
                                  width: 10,
                                ),
                                Icon(
                                  Icons.lock,
                                  color: Colors.grey[500],
                                ),
                                Expanded(
                                  child: TextField(
                                    onSubmitted: (value) {},
                                    controller: _password,
                                    obscureText: isObscureText,
                                    decoration: InputDecoration(
                                      contentPadding:
                                          EdgeInsets.only(left: 10.0),
                                      border: InputBorder.none,
                                      hintText: "Mot de passe",
                                      hintStyle: GoogleFonts.dmSans(
                                        textStyle: TextStyle(
                                          color: Colors.grey[500],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                IconButton(
                                  icon: Icon(
                                    isObscureText
                                        ? FontAwesomeIcons.eye
                                        : FontAwesomeIcons.eyeSlash,
                                    size: 16,
                                    color: Colors.grey[500],
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      isObscureText = !isObscureText;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              Checkbox(
                                value: remember,
                                onChanged: _rememberMe,
                              ),
                              Text(
                                "Sauvegarder le mot de passe",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.dmSans(
                                  decoration: TextDecoration.underline,
                                  textStyle: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          (state is OnLoadingState || state is HomeLoading)
                              ? Loading(
                                  color: Theme.of(context).primaryColor,
                                  size: 40.0)
                              : FlatButton(
                                  onPressed: () {
                                    if (_username.text.trim().isNotEmpty ||
                                        _password.text.trim().isNotEmpty) {
                                      FocusScope.of(context)
                                          .requestFocus(new FocusNode());
                                      appBloc.add(
                                        LoginEvent(
                                          username: _username.text,
                                          password: _password.text,
                                          remember: remember,
                                        ),
                                      );
                                    }
                                  },
                                  color: Theme.of(context).primaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    width: MediaQuery.of(context).size.width,
                                    child: Center(
                                      child: Text(
                                        "Connexion",
                                        style: GoogleFonts.dmSans(
                                          textStyle: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }
          }),
    );
  }

  slogant() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Text(
        "Recevez votre rapport journalier des activités\nde votre entreprise",
        textAlign: TextAlign.center,
        style: GoogleFonts.dmSans(
            textStyle: TextStyle(
          fontSize: 12,
          color: Colors.grey[500],
        )),
      ),
    );
  }

  buildImage() {
    return Container(
      margin: EdgeInsets.only(
        top: 20,
        left: 10,
        right: 10,
        bottom: 0,
      ),
      height: 120,
      width: MediaQuery.of(context).size.width,
      child: SvgPicture.asset(
        "assets/images/login.svg",
        fit: BoxFit.contain,
      ),
    );
  }
}
