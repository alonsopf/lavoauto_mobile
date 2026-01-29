import 'package:flutter/material.dart';
import 'package:lavoauto/data/models/service_checklist_data.dart';
import 'package:lavoauto/theme/app_color.dart';

/// Checklist item model with mutable completion state
class ChecklistItem {
  final String id;
  final String titulo;
  final String descripcion;
  final IconData icono;
  bool completado;

  ChecklistItem({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.icono,
    this.completado = false,
  });

  /// Create from ServiceChecklistItem
  factory ChecklistItem.fromServiceItem(ServiceChecklistItem item) {
    return ChecklistItem(
      id: item.id,
      titulo: item.titulo,
      descripcion: item.descripcion,
      icono: item.icono,
      completado: false,
    );
  }
}

/// Page that shows a checklist before completing a car wash service
class ChecklistCompletarServicioPage extends StatefulWidget {
  final String vehiculoInfo;
  final String clienteNombre;
  final VoidCallback onChecklistCompleted;
  final int? tipoServicioId;
  final String? nombreServicio;

  const ChecklistCompletarServicioPage({
    super.key,
    required this.vehiculoInfo,
    required this.clienteNombre,
    required this.onChecklistCompleted,
    this.tipoServicioId,
    this.nombreServicio,
  });

  @override
  State<ChecklistCompletarServicioPage> createState() =>
      _ChecklistCompletarServicioPageState();
}

class _ChecklistCompletarServicioPageState
    extends State<ChecklistCompletarServicioPage> {
  late List<ChecklistItem> _checklistItems;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _initChecklist();
  }

  void _initChecklist() {
    // Load service-specific checklist based on the service type
    final serviceItems = ServiceChecklistData.getChecklistForServiceId(
      widget.tipoServicioId,
      widget.nombreServicio,
    );

    // Convert to mutable ChecklistItem list
    _checklistItems = serviceItems
        .map((item) => ChecklistItem.fromServiceItem(item))
        .toList();
  }

  bool get _allItemsCompleted =>
      _checklistItems.every((item) => item.completado);

  int get _completedCount =>
      _checklistItems.where((item) => item.completado).length;

  void _toggleItem(String id) {
    setState(() {
      final item = _checklistItems.firstWhere((i) => i.id == id);
      item.completado = !item.completado;
    });
  }

  void _markAllComplete() {
    setState(() {
      for (var item in _checklistItems) {
        item.completado = true;
      }
    });
  }

  Future<void> _confirmarComplecion() async {
    if (!_allItemsCompleted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Debes completar todos los items del checklist'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green[700], size: 28),
            const SizedBox(width: 12),
            const Text('Confirmar Finalización'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '¿Confirmas que has completado todos los puntos del checklist?',
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.amber[200]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.amber[700], size: 20),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Se procesará el cobro automáticamente al cliente.',
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Revisar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            child: const Text(
              'Finalizar Servicio',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() {
        _isProcessing = true;
      });
      widget.onChecklistCompleted();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        toolbarHeight: 80,
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.black, size: 24),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Checklist de Servicio",
              style: TextStyle(
                color: AppColors.primaryNewDark,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            if (widget.nombreServicio != null)
              Text(
                widget.nombreServicio!,
                style: TextStyle(
                  color: AppColors.primaryNew,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
          ],
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Header with vehicle info and progress
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primaryNew.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.local_car_wash,
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
                            widget.vehiculoInfo,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryNewDark,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Cliente: ${widget.clienteNombre}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Progress bar
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Progreso: $_completedCount de ${_checklistItems.length}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryNewDark,
                          ),
                        ),
                        if (!_allItemsCompleted)
                          TextButton(
                            onPressed: _markAllComplete,
                            child: const Text(
                              'Marcar todos',
                              style: TextStyle(fontSize: 13),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: _completedCount / _checklistItems.length,
                        minHeight: 10,
                        backgroundColor: AppColors.borderGrey.withOpacity(0.3),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          _allItemsCompleted ? Colors.green : AppColors.primaryNew,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Checklist items
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _checklistItems.length,
              itemBuilder: (context, index) {
                final item = _checklistItems[index];
                return _buildChecklistItem(item);
              },
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: ElevatedButton(
            onPressed: (_isProcessing || !_allItemsCompleted)
                ? null
                : _confirmarComplecion,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              disabledBackgroundColor: AppColors.grey.withOpacity(0.3),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: _isProcessing
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _allItemsCompleted
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _allItemsCompleted
                            ? 'Finalizar Servicio'
                            : 'Completa el checklist (${_checklistItems.length - _completedCount} pendientes)',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildChecklistItem(ChecklistItem item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _toggleItem(item.id),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: item.completado
                  ? Colors.green
                  : AppColors.borderGrey.withOpacity(0.5),
              width: item.completado ? 2 : 1,
            ),
            boxShadow: item.completado
                ? [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            children: [
              // Checkbox
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: item.completado
                      ? Colors.green
                      : Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: item.completado ? Colors.green : AppColors.grey,
                    width: 2,
                  ),
                ),
                child: item.completado
                    ? const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 20,
                      )
                    : null,
              ),
              const SizedBox(width: 16),
              // Icon
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: item.completado
                      ? Colors.green.withOpacity(0.1)
                      : AppColors.primaryNew.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  item.icono,
                  color: item.completado ? Colors.green : AppColors.primaryNew,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              // Text content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.titulo,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: item.completado
                            ? Colors.green[700]
                            : AppColors.primaryNewDark,
                        decoration: item.completado
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.descripcion,
                      style: TextStyle(
                        fontSize: 13,
                        color: item.completado
                            ? AppColors.grey
                            : AppColors.grey,
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
}
