import 'dart:convert';

// Classe Dependente
class Dependente {
  late String _nome;

  Dependente(String nome) {
    this._nome = nome;
  }

  Map<String, dynamic> toJson() {
    return {
      'nome': _nome,
    };
  }
}

// Classe Funcionario
class Funcionario {
  late String _nome;
  late List<Dependente> _dependentes;

  Funcionario(String nome, List<Dependente> dependentes) {
    this._nome = nome;
    this._dependentes = dependentes;
  }

  Map<String, dynamic> toJson() {
    return {
      'nome': _nome,
      'dependentes': _dependentes.map((d) => d.toJson()).toList(),
    };
  }
}

// Classe EquipeProjeto
class EquipeProjeto {
  late String _nomeProjeto;
  late List<Funcionario> _funcionarios;

  EquipeProjeto(String nomeprojeto, List<Funcionario> funcionarios) {
    _nomeProjeto = nomeprojeto;
    _funcionarios = funcionarios;
  }

  Map<String, dynamic> toJson() {
    return {
      'projeto': _nomeProjeto,
      'funcionarios': _funcionarios.map((f) => f.toJson()).toList(),
    };
  }
}

void main() {
  // 1. Criar vários objetos Dependentes
  var d1 = Dependente("Carlos Filho");
  var d2 = Dependente("Maria Filha");
  var d3 = Dependente("Pedro Filho");

  var d4 = Dependente("Ana Filha");
  var d5 = Dependente("Lucas Filho");

  // 2. Criar vários objetos Funcionário com dependentes
  var f1 = Funcionario("Carlos", [d1, d2, d3]);
  var f2 = Funcionario("João", [d4]);
  var f3 = Funcionario("Mariana", [d5]);

  // 3. Lista de funcionários
  var funcionarios = [f1, f2, f3];

  // 4. Criar equipe de projeto
  var equipe = EquipeProjeto("Projeto Dart", funcionarios);

  // 5. Converter para JSON formatado
  var jsonString = jsonEncode(equipe.toJson());

  // 6. Printar JSON
  print(jsonString);
}
