

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
  final String id;
  final String moradorNome;
  final String enderecoColeta;
  final String cooperativa;
  final String diaColeta;
  final String horaColeta;
  final List tipoLixo;
  final String statusPedido;
  final String statusColeta;



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