import 'package:flutter/material.dart';

/// Represents a single checklist item for a service
class ServiceChecklistItem {
  final String id;
  final String titulo;
  final String descripcion;
  final IconData icono;

  const ServiceChecklistItem({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.icono,
  });
}

/// Contains all service-specific checklists
/// Each service type has its own set of checklist items
class ServiceChecklistData {
  /// Default/fallback checklist for unknown service types
  static const List<ServiceChecklistItem> defaultChecklist = [
    ServiceChecklistItem(
      id: 'exterior',
      titulo: 'Exterior lavado',
      descripcion: 'Carrocería completamente limpia y sin manchas',
      icono: Icons.directions_car,
    ),
    ServiceChecklistItem(
      id: 'secado',
      titulo: 'Secado completo',
      descripcion: 'Vehículo seco sin marcas de agua',
      icono: Icons.water_drop_outlined,
    ),
    ServiceChecklistItem(
      id: 'revision_final',
      titulo: 'Revisión final',
      descripcion: 'Verificar que no quedaron áreas sin limpiar',
      icono: Icons.checklist,
    ),
  ];

  /// Lavado Exterior - Basic exterior wash
  static const List<ServiceChecklistItem> lavadoExterior = [
    ServiceChecklistItem(
      id: 'prelavado',
      titulo: 'Prelavado',
      descripcion: 'Enjuagar vehículo para quitar suciedad suelta',
      icono: Icons.shower,
    ),
    ServiceChecklistItem(
      id: 'carroceria',
      titulo: 'Carrocería lavada',
      descripcion: 'Toda la carrocería limpia con shampoo automotriz',
      icono: Icons.directions_car,
    ),
    ServiceChecklistItem(
      id: 'rines',
      titulo: 'Rines y llantas',
      descripcion: 'Rines brillantes y llantas limpias',
      icono: Icons.circle_outlined,
    ),
    ServiceChecklistItem(
      id: 'cristales',
      titulo: 'Cristales limpios',
      descripcion: 'Parabrisas, ventanas y espejos sin manchas',
      icono: Icons.window,
    ),
    ServiceChecklistItem(
      id: 'secado',
      titulo: 'Secado completo',
      descripcion: 'Vehículo seco sin marcas de agua',
      icono: Icons.water_drop_outlined,
    ),
    ServiceChecklistItem(
      id: 'revision_final',
      titulo: 'Revisión final',
      descripcion: 'Verificar que no quedaron áreas sin limpiar',
      icono: Icons.checklist,
    ),
  ];

  /// Lavado Completo - Interior + Exterior wash
  static const List<ServiceChecklistItem> lavadoCompleto = [
    ServiceChecklistItem(
      id: 'prelavado',
      titulo: 'Prelavado',
      descripcion: 'Enjuagar vehículo para quitar suciedad suelta',
      icono: Icons.shower,
    ),
    ServiceChecklistItem(
      id: 'carroceria',
      titulo: 'Carrocería lavada',
      descripcion: 'Toda la carrocería limpia con shampoo automotriz',
      icono: Icons.directions_car,
    ),
    ServiceChecklistItem(
      id: 'rines',
      titulo: 'Rines y llantas',
      descripcion: 'Rines brillantes y llantas limpias',
      icono: Icons.circle_outlined,
    ),
    ServiceChecklistItem(
      id: 'cristales_ext',
      titulo: 'Cristales exteriores',
      descripcion: 'Parabrisas y ventanas limpias por fuera',
      icono: Icons.window,
    ),
    ServiceChecklistItem(
      id: 'secado',
      titulo: 'Secado exterior',
      descripcion: 'Carrocería seca sin marcas de agua',
      icono: Icons.water_drop_outlined,
    ),
    ServiceChecklistItem(
      id: 'aspirado',
      titulo: 'Interior aspirado',
      descripcion: 'Asientos, alfombras y tapetes sin polvo ni residuos',
      icono: Icons.cleaning_services,
    ),
    ServiceChecklistItem(
      id: 'tablero',
      titulo: 'Tablero y consola',
      descripcion: 'Tablero, consola central y puertas limpias',
      icono: Icons.dashboard,
    ),
    ServiceChecklistItem(
      id: 'cristales_int',
      titulo: 'Cristales interiores',
      descripcion: 'Ventanas y espejos limpios por dentro',
      icono: Icons.flip,
    ),
    ServiceChecklistItem(
      id: 'revision_final',
      titulo: 'Revisión final',
      descripcion: 'Verificar interior y exterior completamente limpios',
      icono: Icons.checklist,
    ),
  ];

  /// Lavado Premium - Detailed premium wash
  static const List<ServiceChecklistItem> lavadoPremium = [
    ServiceChecklistItem(
      id: 'prelavado',
      titulo: 'Prelavado completo',
      descripcion: 'Enjuague a presión y descontaminación inicial',
      icono: Icons.shower,
    ),
    ServiceChecklistItem(
      id: 'carroceria',
      titulo: 'Lavado de carrocería',
      descripcion: 'Lavado con shampoo premium y guante de microfibra',
      icono: Icons.directions_car,
    ),
    ServiceChecklistItem(
      id: 'rines_detallado',
      titulo: 'Rines detallados',
      descripcion: 'Rines limpiados con cepillo especial, llantas brilladas',
      icono: Icons.circle_outlined,
    ),
    ServiceChecklistItem(
      id: 'marcos_puertas',
      titulo: 'Marcos de puertas',
      descripcion: 'Marcos y bordes de puertas limpiados',
      icono: Icons.sensor_door,
    ),
    ServiceChecklistItem(
      id: 'cristales',
      titulo: 'Cristales tratados',
      descripcion: 'Cristales limpios con tratamiento anti-lluvia',
      icono: Icons.window,
    ),
    ServiceChecklistItem(
      id: 'secado_premium',
      titulo: 'Secado con toalla premium',
      descripcion: 'Secado con microfibra de alta absorción',
      icono: Icons.water_drop_outlined,
    ),
    ServiceChecklistItem(
      id: 'aspirado_profundo',
      titulo: 'Aspirado profundo',
      descripcion: 'Todos los rincones, debajo de asientos y cajuelas',
      icono: Icons.cleaning_services,
    ),
    ServiceChecklistItem(
      id: 'tablero_acondicionado',
      titulo: 'Tablero acondicionado',
      descripcion: 'Tablero y plásticos con protector UV',
      icono: Icons.dashboard,
    ),
    ServiceChecklistItem(
      id: 'cuero_vinilo',
      titulo: 'Cuero/Vinilo tratado',
      descripcion: 'Asientos y superficies acondicionadas',
      icono: Icons.chair,
    ),
    ServiceChecklistItem(
      id: 'aromatizante',
      titulo: 'Aromatizante aplicado',
      descripcion: 'Interior con aroma fresco',
      icono: Icons.air,
    ),
    ServiceChecklistItem(
      id: 'revision_final',
      titulo: 'Revisión final detallada',
      descripcion: 'Inspección completa de todos los puntos',
      icono: Icons.checklist,
    ),
  ];

  /// Limpieza de Tapicería - Upholstery cleaning
  static const List<ServiceChecklistItem> limpiezaTapiceria = [
    ServiceChecklistItem(
      id: 'aspirado_previo',
      titulo: 'Aspirado previo',
      descripcion: 'Remover polvo y residuos sueltos de tapicería',
      icono: Icons.cleaning_services,
    ),
    ServiceChecklistItem(
      id: 'pretratamiento',
      titulo: 'Pretratamiento de manchas',
      descripcion: 'Aplicar producto en manchas difíciles',
      icono: Icons.colorize,
    ),
    ServiceChecklistItem(
      id: 'asientos',
      titulo: 'Asientos lavados',
      descripcion: 'Todos los asientos limpios con shampoo especial',
      icono: Icons.chair,
    ),
    ServiceChecklistItem(
      id: 'alfombras',
      titulo: 'Alfombras lavadas',
      descripcion: 'Alfombras y tapetes shampooeados',
      icono: Icons.grid_4x4,
    ),
    ServiceChecklistItem(
      id: 'puertas_interiores',
      titulo: 'Paneles de puertas',
      descripcion: 'Paneles interiores de puertas limpios',
      icono: Icons.sensor_door,
    ),
    ServiceChecklistItem(
      id: 'techo',
      titulo: 'Techo interior',
      descripcion: 'Cielo raso limpio sin manchas',
      icono: Icons.roofing,
    ),
    ServiceChecklistItem(
      id: 'extraccion',
      titulo: 'Extracción de humedad',
      descripcion: 'Remover exceso de humedad de tapicería',
      icono: Icons.water_drop_outlined,
    ),
    ServiceChecklistItem(
      id: 'secado',
      titulo: 'Secado de tapicería',
      descripcion: 'Tapicería seca o en proceso de secado',
      icono: Icons.wb_sunny,
    ),
    ServiceChecklistItem(
      id: 'revision_final',
      titulo: 'Revisión final',
      descripcion: 'Verificar que todas las superficies quedaron limpias',
      icono: Icons.checklist,
    ),
  ];

  /// Limpieza de Motor - Engine cleaning
  static const List<ServiceChecklistItem> limpiezaMotor = [
    ServiceChecklistItem(
      id: 'proteccion',
      titulo: 'Protección de componentes',
      descripcion: 'Cubrir alternador, caja de fusibles y conexiones eléctricas',
      icono: Icons.shield,
    ),
    ServiceChecklistItem(
      id: 'desengrasante',
      titulo: 'Desengrasante aplicado',
      descripcion: 'Aplicar desengrasante en todo el compartimento',
      icono: Icons.colorize,
    ),
    ServiceChecklistItem(
      id: 'cepillado',
      titulo: 'Cepillado de componentes',
      descripcion: 'Cepillar áreas con grasa acumulada',
      icono: Icons.brush,
    ),
    ServiceChecklistItem(
      id: 'enjuague',
      titulo: 'Enjuague controlado',
      descripcion: 'Enjuagar evitando componentes eléctricos',
      icono: Icons.shower,
    ),
    ServiceChecklistItem(
      id: 'secado_motor',
      titulo: 'Secado de motor',
      descripcion: 'Secar con aire comprimido o toallas',
      icono: Icons.air,
    ),
    ServiceChecklistItem(
      id: 'protector',
      titulo: 'Protector aplicado',
      descripcion: 'Aplicar protector/abrillantador en plásticos',
      icono: Icons.auto_awesome,
    ),
    ServiceChecklistItem(
      id: 'verificacion',
      titulo: 'Verificación de arranque',
      descripcion: 'Confirmar que el motor enciende correctamente',
      icono: Icons.power_settings_new,
    ),
    ServiceChecklistItem(
      id: 'revision_final',
      titulo: 'Revisión final',
      descripcion: 'Verificar compartimento limpio y sin fugas',
      icono: Icons.checklist,
    ),
  ];

  /// Detallado Completo - Full detail service
  static const List<ServiceChecklistItem> detalladoCompleto = [
    ServiceChecklistItem(
      id: 'lavado_exterior',
      titulo: 'Lavado exterior completo',
      descripcion: 'Carrocería, rines, llantas y cristales',
      icono: Icons.directions_car,
    ),
    ServiceChecklistItem(
      id: 'descontaminacion',
      titulo: 'Descontaminación',
      descripcion: 'Remover contaminantes adheridos con clay bar',
      icono: Icons.cleaning_services,
    ),
    ServiceChecklistItem(
      id: 'pulido',
      titulo: 'Pulido de pintura',
      descripcion: 'Remover rayones leves y swirl marks',
      icono: Icons.auto_awesome,
    ),
    ServiceChecklistItem(
      id: 'cera_sellador',
      titulo: 'Cera/Sellador aplicado',
      descripcion: 'Protección de pintura con cera o sellador',
      icono: Icons.shield,
    ),
    ServiceChecklistItem(
      id: 'interior_profundo',
      titulo: 'Limpieza interior profunda',
      descripcion: 'Aspirado, shampoo de tapicería y plásticos',
      icono: Icons.chair,
    ),
    ServiceChecklistItem(
      id: 'cuero_tratado',
      titulo: 'Cuero acondicionado',
      descripcion: 'Limpieza y acondicionamiento de cuero',
      icono: Icons.weekend,
    ),
    ServiceChecklistItem(
      id: 'cristales_tratados',
      titulo: 'Cristales con tratamiento',
      descripcion: 'Interior y exterior con hidrofóbico',
      icono: Icons.window,
    ),
    ServiceChecklistItem(
      id: 'plasticos_exteriores',
      titulo: 'Plásticos exteriores',
      descripcion: 'Molduras y plásticos restaurados',
      icono: Icons.square_outlined,
    ),
    ServiceChecklistItem(
      id: 'llantas_brilladas',
      titulo: 'Llantas brilladas',
      descripcion: 'Llantas con abrillantador aplicado',
      icono: Icons.circle_outlined,
    ),
    ServiceChecklistItem(
      id: 'motor_limpio',
      titulo: 'Compartimento de motor',
      descripcion: 'Motor limpio y protegido',
      icono: Icons.settings,
    ),
    ServiceChecklistItem(
      id: 'aromatizante',
      titulo: 'Aromatización',
      descripcion: 'Interior con aroma premium',
      icono: Icons.air,
    ),
    ServiceChecklistItem(
      id: 'revision_final',
      titulo: 'Inspección final completa',
      descripcion: 'Revisión detallada de todos los puntos',
      icono: Icons.checklist,
    ),
  ];

  /// Encerado - Waxing service
  static const List<ServiceChecklistItem> encerado = [
    ServiceChecklistItem(
      id: 'lavado_previo',
      titulo: 'Lavado previo',
      descripcion: 'Carrocería limpia y seca antes de encerar',
      icono: Icons.directions_car,
    ),
    ServiceChecklistItem(
      id: 'descontaminacion',
      titulo: 'Descontaminación',
      descripcion: 'Superficie libre de contaminantes',
      icono: Icons.cleaning_services,
    ),
    ServiceChecklistItem(
      id: 'aplicacion_cera',
      titulo: 'Aplicación de cera',
      descripcion: 'Cera aplicada en toda la carrocería',
      icono: Icons.colorize,
    ),
    ServiceChecklistItem(
      id: 'tiempo_curado',
      titulo: 'Tiempo de curado',
      descripcion: 'Esperar tiempo de curado de la cera',
      icono: Icons.timer,
    ),
    ServiceChecklistItem(
      id: 'pulido_cera',
      titulo: 'Pulido de cera',
      descripcion: 'Remover exceso y pulir hasta brillo',
      icono: Icons.auto_awesome,
    ),
    ServiceChecklistItem(
      id: 'detalles_finales',
      titulo: 'Detalles finales',
      descripcion: 'Marcos, emblemas y acabados',
      icono: Icons.star,
    ),
    ServiceChecklistItem(
      id: 'revision_brillo',
      titulo: 'Revisión de brillo',
      descripcion: 'Verificar brillo uniforme en toda la superficie',
      icono: Icons.checklist,
    ),
  ];

  /// Map of service name patterns to their checklists
  /// Uses lowercase pattern matching for flexibility
  static List<ServiceChecklistItem> getChecklistForService(String? serviceName) {
    if (serviceName == null || serviceName.isEmpty) {
      return defaultChecklist;
    }

    final lowerName = serviceName.toLowerCase();

    // Match service names to their specific checklists
    if (lowerName.contains('premium') || lowerName.contains('completo premium')) {
      return lavadoPremium;
    } else if (lowerName.contains('tapiceria') || lowerName.contains('tapicería')) {
      return limpiezaTapiceria;
    } else if (lowerName.contains('motor')) {
      return limpiezaMotor;
    } else if (lowerName.contains('detallado') || lowerName.contains('detail')) {
      return detalladoCompleto;
    } else if (lowerName.contains('encerado') || lowerName.contains('cera')) {
      return encerado;
    } else if (lowerName.contains('completo') || lowerName.contains('interior')) {
      return lavadoCompleto;
    } else if (lowerName.contains('exterior') || lowerName.contains('basico') || lowerName.contains('básico')) {
      return lavadoExterior;
    }

    // Default to lavado completo if no specific match
    return lavadoCompleto;
  }

  /// Get checklist by service type ID (for more precise matching)
  /// This can be extended as service types are added to the database
  static List<ServiceChecklistItem> getChecklistForServiceId(int? tipoServicioId, String? serviceName) {
    // First try to match by name since IDs may vary
    return getChecklistForService(serviceName);
  }
}
