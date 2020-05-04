class ResultUser {
  String token;
  User user;

  ResultUser({this.token, this.user});

  ResultUser.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    return data;
  }
}

class User {
  int code;
  String psedo;
  String sexe;
  String tel;
  String fonction;
  int level;
  String exp;
  int codeEntrep;
  String license;
  int reste;
  String lincenceExp;
  String nom;
  String telEntreprise;
  String emailEntrep;
  String adresse;
  String rccm;
  String logo;
  String cle;
  int durree;
  String devise;
  String emailUser;
  int codeVal;
  String infos;

  User(
      {this.code,
      this.psedo,
      this.sexe,
      this.tel,
      this.fonction,
      this.level,
      this.exp,
      this.codeEntrep,
      this.license,
      this.reste,
      this.lincenceExp,
      this.nom,
      this.telEntreprise,
      this.emailEntrep,
      this.adresse,
      this.rccm,
      this.logo,
      this.cle,
      this.durree,
      this.devise,
      this.emailUser,
      this.codeVal,
      this.infos});

  User.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    psedo = json['psedo'];
    sexe = json['sexe'];
    tel = json['tel'];
    fonction = json['fonction'];
    level = json['level'];
    exp = json['exp'];
    codeEntrep = json['codeEntrep'];
    license = json['License'];
    reste = json['reste'];
    lincenceExp = json['lincenceExp'];
    nom = json['nom'];
    telEntreprise = json['TelEntreprise'];
    emailEntrep = json['EmailEntrep'];
    adresse = json['Adresse'];
    rccm = json['rccm'];
    logo = json['logo'];
    cle = json['cle'];
    durree = json['durree'];
    devise = json['devise'];
    emailUser = json['emailUser'];
    codeVal = json['codeVal'];
    infos = json['Infos'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['psedo'] = this.psedo;
    data['sexe'] = this.sexe;
    data['tel'] = this.tel;
    data['fonction'] = this.fonction;
    data['level'] = this.level;
    data['exp'] = this.exp;
    data['codeEntrep'] = this.codeEntrep;
    data['License'] = this.license;
    data['reste'] = this.reste;
    data['lincenceExp'] = this.lincenceExp;
    data['nom'] = this.nom;
    data['TelEntreprise'] = this.telEntreprise;
    data['EmailEntrep'] = this.emailEntrep;
    data['Adresse'] = this.adresse;
    data['rccm'] = this.rccm;
    data['logo'] = this.logo;
    data['cle'] = this.cle;
    data['durree'] = this.durree;
    data['devise'] = this.devise;
    data['emailUser'] = this.emailUser;
    data['codeVal'] = this.codeVal;
    data['Infos'] = this.infos;
    return data;
  }
}
