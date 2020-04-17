class Cliente {
  int id;
  String nome;

  Cliente(this.id, this.nome);

  @override
  String toString() {
    return 'Cliente{id: $id, nome: $nome}';
  }

  Cliente.fromMap(Map map)
      : id = map['id'],
        nome = map['nome'];

  Map toMap(){
    Map clienteMap = Map();
    clienteMap['id'] = this.id;
    clienteMap['nome'] = this.nome;
    return clienteMap;
  }
}
