class ResultTransaction {
  double sortie;
  double entree;
  double solde;
  List<Transaction> transactions;

  ResultTransaction({this.sortie, this.entree, this.solde, this.transactions});

  ResultTransaction.fromJson(Map<String, dynamic> json) {
    sortie = json['sortie'].runtimeType == int
        ? double.tryParse(json['sortie'].toString())
        : json["sortie"];

    entree = json['entree'].runtimeType == int
        ? double.tryParse(json['entree'].toString())
        : json['entree'];
    solde = json['solde'].runtimeType == int
        ? double.tryParse(json['solde'].toString())
        : json['solde'];
    if (json['transactions'] != null) {
      transactions = new List<Transaction>();
      json['transactions'].forEach((v) {
        transactions.add(new Transaction.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sortie'] = this.sortie;
    data['entree'] = this.entree;
    data['solde'] = this.solde;
    if (this.transactions != null) {
      data['transactions'] = this.transactions.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Transaction {
  int code;
  int codeEntrep;
  String psedo;
  String typeOp;
  double montant;
  String devise;
  String motif;
  String nom;
  String dateAdd;
  bool etat;
  String validateUser;
  String dateValidate;
  int suprimer;
  String ref;

  Transaction(
      {this.code,
      this.codeEntrep,
      this.psedo,
      this.typeOp,
      this.montant,
      this.devise,
      this.motif,
      this.nom,
      this.dateAdd,
      this.etat,
      this.validateUser,
      this.dateValidate,
      this.suprimer,
      this.ref});

  Transaction.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    codeEntrep = json['codeEntrep'];
    psedo = json['psedo'];
    typeOp = json['TypeOp'];
    montant = double.parse(json['Montant'].toString());
    devise = json['devise'];
    motif = json['Motif'];
    nom = json['nom'];
    dateAdd = json['dateAdd'];
    etat = json['etat'];
    validateUser = json['validateUser'];
    dateValidate = json['dateValidate'];
    suprimer = json['suprimer'];
    ref = json['ref'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['codeEntrep'] = this.codeEntrep;
    data['psedo'] = this.psedo;
    data['TypeOp'] = this.typeOp;
    data['Montant'] = this.montant;
    data['devise'] = this.devise;
    data['Motif'] = this.motif;
    data['nom'] = this.nom;
    data['dateAdd'] = this.dateAdd;
    data['etat'] = this.etat;
    data['validateUser'] = this.validateUser;
    data['dateValidate'] = this.dateValidate;
    data['suprimer'] = this.suprimer;
    data['ref'] = this.ref;
    return data;
  }
}
