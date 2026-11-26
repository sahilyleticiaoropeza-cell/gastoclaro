import 'package:flutter_test/flutter_test.dart';
import 'package:gastoclaro/models/models.dart';
import 'package:gastoclaro/utils/periodo_utils.dart';

void main() {
  test('semana va de lunes a lunes', () {
    final r = rangoDe(Periodo.semanal, DateTime(2026, 11, 25)); // miercoles
    expect(r.inicio, DateTime(2026, 11, 23));
    expect(r.fin, DateTime(2026, 11, 30));
  });
  test('mes completo', () {
    final r = rangoDe(Periodo.mensual, DateTime(2026, 11, 25));
    expect(r.inicio, DateTime(2026, 11, 1));
    expect(r.fin, DateTime(2026, 12, 1));
  });
  test('cambio de anio', () {
    final r = rangoDe(Periodo.mensual, DateTime(2026, 12, 15));
    expect(r.fin, DateTime(2027, 1, 1));
  });
}
