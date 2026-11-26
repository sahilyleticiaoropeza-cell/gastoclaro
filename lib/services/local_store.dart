import 'dart:convert';
import 'dart:math';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/models.dart';

/// Base de datos local con Hive. Las 3 "tablas" (cajas) se cifran con AES-256
/// (HiveAesCipher). La clave de 256 bits se genera con un generador seguro la
/// primera vez y se guarda en Keystore (Android) / Keychain (iOS).
class LocalStore {
  static const _claveNombre = 'gastoclaro_hive_key';
  static const _secure = FlutterSecureStorage();

  late final Box<Map> _gastos;
  late final Box<Map> _categorias;
  late final Box<Map> _presupuestos;

  Future<void> init() async {
    await Hive.initFlutter();
    final cipher = HiveAesCipher(await _obtenerClave());
    _gastos = await Hive.openBox<Map>('gastos', encryptionCipher: cipher);
    _categorias = await Hive.openBox<Map>('categorias', encryptionCipher: cipher);
    _presupuestos = await Hive.openBox<Map>('presupuestos', encryptionCipher: cipher);
  }

  Future<List<int>> _obtenerClave() async {
    final guardada = await _secure.read(key: _claveNombre);
    if (guardada != null) return base64Url.decode(guardada);
    final rnd = Random.secure();
    final clave = List<int>.generate(32, (_) => rnd.nextInt(256));
    await _secure.write(key: _claveNombre, value: base64Url.encode(clave));
    return clave;
  }

  // ---------- Categorias ----------
  List<Categoria> categorias({bool incluirEliminadas = false}) => _categorias.values
      .map((m) => Categoria.fromMap(Map<String, dynamic>.from(m)))
      .where((c) => incluirEliminadas || !c.eliminado)
      .toList()
    ..sort((a, b) => a.nombre.compareTo(b.nombre));

  Future<void> guardarCategoria(Categoria c) => _categorias.put(c.id, c.toLocal());
  Future<void> borrarFisicoCategoria(String id) => _categorias.delete(id);

  // ---------- Presupuestos ----------
  List<Presupuesto> presupuestos({bool incluirEliminados = false}) => _presupuestos.values
      .map((m) => Presupuesto.fromMap(Map<String, dynamic>.from(m)))
      .where((p) => incluirEliminados || !p.eliminado)
      .toList();

  Future<void> guardarPresupuesto(Presupuesto p) => _presupuestos.put(p.id, p.toLocal());
  Future<void> borrarFisicoPresupuesto(String id) => _presupuestos.delete(id);

  // ---------- Gastos ----------
  List<Gasto> gastos({bool incluirEliminados = false}) => _gastos.values
      .map((m) => Gasto.fromMap(Map<String, dynamic>.from(m)))
      .where((g) => incluirEliminados || !g.eliminado)
      .toList()
    ..sort((a, b) => b.fecha.compareTo(a.fecha));

  Future<void> guardarGasto(Gasto g) => _gastos.put(g.id, g.toLocal());
  Future<void> borrarFisicoGasto(String id) => _gastos.delete(id);

  /// Cierre de sesion: no deja datos de la cuenta anterior en el telefono.
  Future<void> limpiarTodo() async {
    await _gastos.clear();
    await _categorias.clear();
    await _presupuestos.clear();
  }
}
