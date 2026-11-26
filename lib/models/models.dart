enum Periodo { semanal, mensual }

class Categoria {
  final String id;
  final String nombre;
  final int colorValue;
  final DateTime updatedAt;
  final bool pendiente; // true = falta subir a la nube
  final bool eliminado; // borrado logico (tombstone)

  const Categoria({
    required this.id,
    required this.nombre,
    required this.colorValue,
    required this.updatedAt,
    this.pendiente = true,
    this.eliminado = false,
  });

  Categoria copyWith({String? nombre, int? colorValue, bool? pendiente, bool? eliminado}) =>
      Categoria(
        id: id,
        nombre: nombre ?? this.nombre,
        colorValue: colorValue ?? this.colorValue,
        updatedAt: DateTime.now().toUtc(),
        pendiente: pendiente ?? true,
        eliminado: eliminado ?? this.eliminado,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'nombre': nombre,
        'color': colorValue,
        'updated_at': updatedAt.toIso8601String(),
        'eliminado': eliminado,
      };

  Map<String, dynamic> toLocal() => {...toMap(), 'pendiente': pendiente};

  factory Categoria.fromMap(Map m, {bool pendiente = false}) => Categoria(
        id: m['id'] as String,
        nombre: m['nombre'] as String,
        colorValue: (m['color'] as num).toInt(),
        updatedAt: DateTime.parse(m['updated_at'] as String).toUtc(),
        pendiente: m['pendiente'] as bool? ?? pendiente,
        eliminado: m['eliminado'] as bool? ?? false,
      );
}

class Presupuesto {
  final String id;
  final String categoriaId;
  final double monto;
  final Periodo periodo;
  final DateTime updatedAt;
  final bool pendiente;
  final bool eliminado;

  const Presupuesto({
    required this.id,
    required this.categoriaId,
    required this.monto,
    required this.periodo,
    required this.updatedAt,
    this.pendiente = true,
    this.eliminado = false,
  });

  Presupuesto copyWith({double? monto, Periodo? periodo, bool? pendiente, bool? eliminado}) =>
      Presupuesto(
        id: id,
        categoriaId: categoriaId,
        monto: monto ?? this.monto,
        periodo: periodo ?? this.periodo,
        updatedAt: DateTime.now().toUtc(),
        pendiente: pendiente ?? true,
        eliminado: eliminado ?? this.eliminado,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'categoria_id': categoriaId,
        'monto': monto,
        'periodo': periodo.name,
        'updated_at': updatedAt.toIso8601String(),
        'eliminado': eliminado,
      };

  Map<String, dynamic> toLocal() => {...toMap(), 'pendiente': pendiente};

  factory Presupuesto.fromMap(Map m, {bool pendiente = false}) => Presupuesto(
        id: m['id'] as String,
        categoriaId: m['categoria_id'] as String,
        monto: (m['monto'] as num).toDouble(),
        periodo: Periodo.values.byName(m['periodo'] as String),
        updatedAt: DateTime.parse(m['updated_at'] as String).toUtc(),
        pendiente: m['pendiente'] as bool? ?? pendiente,
        eliminado: m['eliminado'] as bool? ?? false,
      );
}

class Gasto {
  final String id;
  final String categoriaId;
  final double monto;
  final String descripcion;
  final DateTime fecha;
  final String? fotoTicket; // ruta local de la foto (no se sube a la nube)
  final DateTime updatedAt;
  final bool pendiente;
  final bool eliminado;

  const Gasto({
    required this.id,
    required this.categoriaId,
    required this.monto,
    required this.descripcion,
    required this.fecha,
    required this.updatedAt,
    this.fotoTicket,
    this.pendiente = true,
    this.eliminado = false,
  });

  Gasto copyWith({
    String? categoriaId,
    double? monto,
    String? descripcion,
    DateTime? fecha,
    String? fotoTicket,
    bool? pendiente,
    bool? eliminado,
  }) =>
      Gasto(
        id: id,
        categoriaId: categoriaId ?? this.categoriaId,
        monto: monto ?? this.monto,
        descripcion: descripcion ?? this.descripcion,
        fecha: fecha ?? this.fecha,
        fotoTicket: fotoTicket ?? this.fotoTicket,
        updatedAt: DateTime.now().toUtc(),
        pendiente: pendiente ?? true,
        eliminado: eliminado ?? this.eliminado,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'categoria_id': categoriaId,
        'monto': monto,
        'descripcion': descripcion,
        'fecha': fecha.toUtc().toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
        'eliminado': eliminado,
      };

  Map<String, dynamic> toLocal() =>
      {...toMap(), 'foto_ticket': fotoTicket, 'pendiente': pendiente};

  factory Gasto.fromMap(Map m, {bool pendiente = false, String? fotoLocal}) => Gasto(
        id: m['id'] as String,
        categoriaId: m['categoria_id'] as String,
        monto: (m['monto'] as num).toDouble(),
        descripcion: m['descripcion'] as String? ?? '',
        fecha: DateTime.parse(m['fecha'] as String).toLocal(),
        fotoTicket: fotoLocal ?? m['foto_ticket'] as String?,
        updatedAt: DateTime.parse(m['updated_at'] as String).toUtc(),
        pendiente: m['pendiente'] as bool? ?? pendiente,
        eliminado: m['eliminado'] as bool? ?? false,
      );
}
