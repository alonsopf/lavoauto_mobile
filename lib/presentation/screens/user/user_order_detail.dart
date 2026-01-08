import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lavoauto/bloc/bloc/chat_bloc.dart';
import 'package:lavoauto/data/models/response/user/orders_response_modal.dart';
import 'package:lavoauto/data/repositories/chat_repository.dart';
import 'package:lavoauto/features/pages/chat/chat_page.dart';
import 'package:lavoauto/presentation/common_widgets/app_bar.dart';
import 'package:lavoauto/presentation/common_widgets/custom_text.dart';
import 'package:lavoauto/presentation/common_widgets/profile_image_widget.dart';
import 'package:lavoauto/theme/app_color.dart';
import 'package:lavoauto/utils/utils.dart';

@RoutePage()
class UserOrderDetail extends StatelessWidget {
  final UserOrder order;

  const UserOrderDetail({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBackgroundColor,
      appBar: CustomAppBar.getCustomBar(
        title: "Detalles Pedido #${order.ordenId}",
        actions: [
          const HeaderProfileImage(),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order status and basic info
            _buildSection(
              title: "📋 Información General",
              children: [
                _buildInfoRow(
                  "Estado",
                  _getStatusDisplayName(order.estatus),
                  _getStatusColor(order.estatus),
                ),
                _buildInfoRow(
                  "Fecha Programada",
                  Utils.formatDateTime(order.fechaProgramada),
                ),
                _buildInfoRow(
                  "Peso Aproximado",
                  "${order.pesoAproximadoKg ?? 0.0} kg",
                ),
              ],
            ),
            const SizedBox(height: 20.0),

            // Service options
            _buildSection(
              title: "🧺 Opciones de Servicio",
              children: [
                _buildInfoRow(
                  "Tipo de Detergente",
                  order.tipoDetergente ?? "No especificado",
                ),
                _buildInfoRow(
                  "Suavizante",
                  (order.suavizante ?? false) ? "✓ Sí" : "✗ No",
                  (order.suavizante ?? false) ? Colors.green : Colors.grey,
                ),
                _buildInfoRow(
                  "Método de Secado",
                  order.metodoSecado ?? "No especificado",
                ),
                if (order.tipoPlanchado != null)
                  _buildInfoRow(
                    "Tipo de Planchado",
                    _getIroningTypeDisplayName(order.tipoPlanchado),
                  ),
                if (order.numeroPrendasPlanchado != null)
                  _buildInfoRow(
                    "Prendas a Planchar",
                    "${order.numeroPrendasPlanchado}",
                  ),
              ],
            ),
            const SizedBox(height: 20.0),

            // Urgent options
            _buildSection(
              title: "⚡ Opciones Urgentes",
              children: [
                if ((order.lavadoUrgente ?? false) ||
                    (order.lavadoSecadoUrgente ?? false) ||
                    (order.lavadoSecadoPlanchadoUrgente ?? false)) ...[
                  if (order.lavadoUrgente ?? false) _buildUrgentOptionActive("Lavado Urgente"),
                  if (order.lavadoSecadoUrgente ?? false) _buildUrgentOptionActive("Lavado + Secado Urgente"),
                  if (order.lavadoSecadoPlanchadoUrgente ?? false)
                    _buildUrgentOptionActive("Lavado + Secado + Planchado Urgente"),
                ] else ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      border: Border.all(
                        color: Colors.grey.shade400,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info,
                          color: Colors.grey.shade700,
                          size: 20.0,
                        ),
                        const SizedBox(width: 10.0),
                        Expanded(
                          child: CustomText(
                            text: "Sin urgencias",
                            fontSize: 15.0,
                            fontColor: Colors.grey.shade700,
                            fontWeight: FontWeight.w700,
                          ).setText(),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 20.0),

            // Location and dates
            if (order.direccion != null ||
                order.fechaRecogidaPropuestaCliente != null ||
                order.fechaEntregaPropuestaCliente != null ||
                order.fechaRecogidaPropuestaLavador != null ||
                order.fechaEntregaPropuestaLavador != null)
              _buildSection(
                title: "📍 Ubicación y Horarios",
                children: [
                  if (order.direccion != null) ...[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: "Dirección",
                          fontSize: 15.0,
                          fontColor: AppColors.secondary,
                          fontWeight: FontWeight.w700,
                        ).setText(),
                        const SizedBox(height: 8.0),
                        Container(
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.5),
                            border: Border.all(
                              color: AppColors.secondary.withOpacity(0.5),
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: CustomText(
                            text: order.direccion!,
                            fontSize: 15.0,
                            fontColor: AppColors.primary,
                            fontWeight: FontWeight.w500,
                          ).setText(),
                        ),
                        const SizedBox(height: 16.0),
                      ],
                    ),
                  ],
                  if (order.fechaRecogidaPropuestaCliente != null)
                    _buildInfoRow(
                      "Recogida Propuesta (Cliente)",
                      Utils.formatDateTime(order.fechaRecogidaPropuestaCliente!),
                    ),
                  if (order.fechaEntregaPropuestaCliente != null)
                    _buildInfoRow(
                      "Entrega Propuesta (Cliente)",
                      Utils.formatDateTime(order.fechaEntregaPropuestaCliente!),
                    ),
                  if (order.fechaRecogidaPropuestaLavador != null)
                    _buildInfoRow(
                      "Recogida Propuesta (Lavador)",
                      Utils.formatDateTime(order.fechaRecogidaPropuestaLavador!),
                    ),
                  if (order.fechaEntregaPropuestaLavador != null)
                    _buildInfoRow(
                      "Entrega Propuesta (Lavador)",
                      Utils.formatDateTime(order.fechaEntregaPropuestaLavador!),
                    ),
                ],
              ),
            const SizedBox(height: 20.0),

            // Special instructions
            if (order.instruccionesEspeciales != null && order.instruccionesEspeciales!.isNotEmpty)
              _buildSection(
                title: "📝 Instrucciones Especiales",
                children: [
                  Container(
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withOpacity(0.15),
                      border: Border.all(
                        color: AppColors.secondary.withOpacity(0.4),
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: CustomText(
                      text: order.instruccionesEspeciales!,
                      fontSize: 15.0,
                      fontColor: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ).setText(),
                  ),
                ],
              ),
            const SizedBox(height: 20.0),

            // Chat button - Show only if offer has been accepted
            if (order.estatus.toLowerCase() == 'puja_accepted' && order.lavadorId != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryNew,
                    elevation: 0,
                    shadowColor: Colors.transparent,
                    surfaceTintColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    final token = Utils.getAuthenticationToken();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => BlocProvider(
                          create: (context) => ChatBloc(
                            chatRepository: ChatRepository(token: token),
                          ),
                          child: ChatPage(
                            orderId: order.ordenId,
                            otherUserName: "Lavador #${order.lavadorId}",
                            otherUserPhotoUrl: order.lavadorFotoUrl,
                            currentUserType: 'client',
                          ),
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.chat_bubble_outline, color: Colors.white),
                  label: const Text(
                    "Abrir chat con lavador",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4.0, bottom: 12.0),
          child: CustomText(
            text: title,
            fontSize: 20.0,
            fontColor: AppColors.primary,
            fontWeight: FontWeight.bold,
          ).setText(),
        ),
        Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: [
              BoxShadow(
                color: AppColors.borderGrey.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children
                .expand((widget) => [
                      widget,
                      const SizedBox(height: 12.0),
                    ])
                .toList()
              ..removeLast(), // Remove the last SizedBox
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value, [Color? valueColor]) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: CustomText(
            text: label,
            fontSize: 15.0,
            fontColor: AppColors.secondary,
            fontWeight: FontWeight.w700,
          ).setText(),
        ),
        const SizedBox(width: 12.0),
        Expanded(
          flex: 1,
          child: CustomText(
            text: value,
            fontSize: 15.0,
            fontColor: valueColor ?? Colors.white,
            fontWeight: FontWeight.w700,
            textAlign: TextAlign.end,
          ).setText(),
        ),
      ],
    );
  }

  Widget _buildUrgentOptionActive(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: AppColors.secondary.withOpacity(0.2),
        border: Border.all(
          color: AppColors.secondary,
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        children: [
          Icon(
            Icons.check_circle,
            color: AppColors.secondary,
            size: 20.0,
          ),
          const SizedBox(width: 10.0),
          Expanded(
            child: CustomText(
              text: label,
              fontSize: 15.0,
              fontColor: AppColors.secondary,
              fontWeight: FontWeight.w700,
            ).setText(),
          ),
        ],
      ),
    );
  }

  String _getIroningTypeDisplayName(String? type) {
    switch (type?.toLowerCase()) {
      case 'con_gancho':
        return 'Con Gancho';
      case 'sin_gancho':
        return 'Sin Gancho';
      default:
        return type ?? 'N/A';
    }
  }

  String _getStatusDisplayName(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
      case 'pendiente':
        return 'PENDIENTE';
      case 'puja_accepted':
        return 'OFERTA ACEPTADA';
      case 'en_proceso':
        return 'EN PROCESO';
      case 'laundry_in_progress':
        return 'LAVADO EN PROGRESO';
      case 'completed':
      case 'completado':
        return 'COMPLETADO';
      case 'cancelled':
      case 'cancelado':
        return 'CANCELADO';
      default:
        return status.toUpperCase();
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
      case 'pendiente':
        return Colors.deepOrange.shade900;
      case 'puja_accepted':
        return Colors.green.shade700;
      case 'en_proceso':
        return Colors.blue.shade700;
      case 'laundry_in_progress':
        return Colors.orange.shade900;
      case 'completed':
      case 'completado':
        return Colors.purple.shade700;
      case 'cancelled':
      case 'cancelado':
        return Colors.red;
      default:
        return AppColors.secondary;
    }
  }
}
