import 'package:flutter/material.dart';
import 'package:lavoauto/data/models/service_checklist_data.dart';
import 'package:lavoauto/theme/app_color.dart';

/// Shows a dialog with the service completion checklist
/// This helps lavadores understand what they need to verify before completing a service
class ChecklistInfoDialog {
  /// Get checklist items based on service type
  static List<ServiceChecklistItem> getChecklistItems({
    int? tipoServicioId,
    String? nombreServicio,
  }) {
    return ServiceChecklistData.getChecklistForServiceId(
      tipoServicioId,
      nombreServicio,
    );
  }

  /// Default checklist for backwards compatibility
  static List<ServiceChecklistItem> get defaultChecklistItems =>
      ServiceChecklistData.lavadoCompleto;

  static void show(
    BuildContext context, {
    int? tipoServicioId,
    String? nombreServicio,
  }) {
    final items = getChecklistItems(
      tipoServicioId: tipoServicioId,
      nombreServicio: nombreServicio,
    );

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          constraints: const BoxConstraints(maxHeight: 550),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.primaryNew,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.checklist_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            nombreServicio ?? 'Checklist de Servicio',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '${items.length} puntos a verificar',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Checklist items
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primaryNew.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          item.icono,
                          color: AppColors.primaryNew,
                          size: 20,
                        ),
                      ),
                      title: Text(
                        item.titulo,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      subtitle: Text(
                        item.descripcion,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      dense: true,
                    );
                  },
                ),
              ),
              // Footer
              Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.amber[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.amber[200]!),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Colors.amber[700],
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          const Expanded(
                            child: Text(
                              'Deberás completar todos los puntos antes de finalizar cada servicio.',
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryNew,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Entendido',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Returns an IconButton that can be added to an AppBar
  static Widget appBarButton(
    BuildContext context, {
    int? tipoServicioId,
    String? nombreServicio,
  }) {
    return IconButton(
      icon: const Icon(Icons.help_outline),
      tooltip: 'Ver checklist de servicio',
      onPressed: () => show(
        context,
        tipoServicioId: tipoServicioId,
        nombreServicio: nombreServicio,
      ),
    );
  }

  /// Returns a Card widget that can be embedded in a screen
  /// Updates dynamically based on tipoServicioId and nombreServicio
  static Widget infoCard(
    BuildContext context, {
    EdgeInsets? margin,
    int? tipoServicioId,
    String? nombreServicio,
  }) {
    final items = getChecklistItems(
      tipoServicioId: tipoServicioId,
      nombreServicio: nombreServicio,
    );

    return Card(
      margin: margin ?? EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.primaryNew.withOpacity(0.3)),
      ),
      child: InkWell(
        onTap: () => show(
          context,
          tipoServicioId: tipoServicioId,
          nombreServicio: nombreServicio,
        ),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primaryNew.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.checklist_rounded,
                      color: AppColors.primaryNew,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          nombreServicio != null
                              ? 'Checklist: $nombreServicio'
                              : 'Checklist de calidad',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'Toca para ver los ${items.length} puntos a verificar',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey[400],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Preview of first 3 items
              ...items.take(3).map((item) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      children: [
                        Icon(
                          item.icono,
                          size: 16,
                          color: AppColors.primaryNew.withOpacity(0.7),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            item.titulo,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[700],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  )),
              if (items.length > 3)
                Text(
                  '+ ${items.length - 3} más...',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.primaryNew,
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
