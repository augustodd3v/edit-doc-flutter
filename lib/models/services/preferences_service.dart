class SharedPreferences {
  static final SharedPreferences _instancia = SharedPreferences._interno();
  final Map<String, dynamic> _dadosEmDisco = {};

  SharedPreferences._interno();

  static Future<SharedPreferences> getInstance() async {
    await Future.delayed(const Duration(milliseconds: 50));
    return _instancia;
  }

  Future<bool> setString(String chave, String valor) async {
    _dadosEmDisco[chave] = valor;
    return true;
  }

  Future<bool> setBool(String chave, bool valor) async {
    _dadosEmDisco[chave] = valor;
    return true;
  }

  String? getString(String chave) => _dadosEmDisco[chave] as String?;
  bool? getBool(String chave) => _dadosEmDisco[chave] as bool?;
}