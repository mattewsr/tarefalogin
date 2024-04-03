import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // Importe esta linha para usar json.decode
import 'item_lista.dart';

class ListaRepository {
  Future<List<ItemLista>> carregarItens(String nomeLista) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final itemList = prefs.getStringList(nomeLista) ?? [];
    final List<ItemLista> itens = itemList.map((itemJson) {
      final Map<String, dynamic> itemMap = json.decode(itemJson);
      return ItemLista.fromJson(itemMap);
    }).toList();
    return itens;
  }

  Future<void> salvarItem(ItemLista item, String nomeLista) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final itemList = await carregarItens(nomeLista);
    final index = itemList.indexWhere((element) => element.nome == item.nome);
    if (index != -1) {
      itemList[index] = item;
      final itemListJson = itemList.map((item) => json.encode(item.toJson())).toList();
      await prefs.setStringList(nomeLista, itemListJson);
    }
  }

  Future<void> adicionarItem(ItemLista item, String nomeLista) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final itemList = await carregarItens(nomeLista);
    itemList.add(item);
    final itemListJson = itemList.map((item) => json.encode(item.toJson())).toList();
    await prefs.setStringList(nomeLista, itemListJson);
  }

  Future<void> removerItem(ItemLista item, String nomeLista) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final itemList = await carregarItens(nomeLista);
    itemList.removeWhere((element) => element.nome == item.nome);
    final itemListJson = itemList.map((item) => json.encode(item.toJson())).toList();
    await prefs.setStringList(nomeLista, itemListJson);
  }
}
