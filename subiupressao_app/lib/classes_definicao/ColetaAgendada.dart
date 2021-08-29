

class Coletas {
  final List<ColetaAgendada> coletando;


  Coletas({
    this.coletando,
  });

  factory Coletas.fromJson(Map<String, dynamic> parsedJson) {

    var list = parsedJson['agendamentos'] as List;
    List<ColetaAgendada> coletasList = list.map((i) => ColetaAgendada.fromJson(i)).toList();

    //List<ColetaAgendada> col = new List<ColetaAgendada>();
    //col = parsedJson.map((i)=>ColetaAgendada.fromJson(i)).toList();
    return new Coletas(
      coletando: coletasList
    );
  }
  Map<String, dynamic> toJson() {
        List<Map<String,dynamic>> aaagenda = coletando.map((e) => e.toJson()).toList();
        return {'agendamentos': aaagenda };
   }


}

class ColetaAgendada {
  String id;
  String moradorNome;
  String enderecoColeta;
  String cooperativa;
  String diaColeta;
  String horaColeta;
  List tipoLixo;
  String statusPedido;
  String statusColeta;



  ColetaAgendada({this.id, this.moradorNome, this.enderecoColeta, this.cooperativa,this.diaColeta,this.horaColeta,this.tipoLixo,this.statusPedido, this.statusColeta});

  factory ColetaAgendada.fromJson(Map<String, dynamic> json){
    return ColetaAgendada(
      id: json['id'] as String,
      moradorNome: json['moradorNome'] as String,
      enderecoColeta: json['enderecoColeta'] as String,
      cooperativa: json['cooperativa'] as String,
      diaColeta: json['diaColeta'] as String,
      horaColeta: json['horaColeta'] as String,
      tipoLixo: json['tipoLixo'] as List,
      statusPedido: json['statusPedido'] as String,
      statusColeta: json['statusColeta'] as String,
    );
  }

  void set pedido(String currentPedido) {
    this.statusPedido = currentPedido;
  }


  Map<String, dynamic> toJson() =>
      {
        'id': id,
        'moradorNome': moradorNome,
        'enderecoColeta': enderecoColeta,
        'cooperativa': cooperativa,
        'diaColeta' : diaColeta,
        'horaColeta' : horaColeta,
        'tipoLixo' : tipoLixo,
        'statusPedido': statusPedido,
        'statusColeta' : statusColeta,
      };

}