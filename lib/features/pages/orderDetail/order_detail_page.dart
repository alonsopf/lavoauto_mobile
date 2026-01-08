import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lavoauto/bloc/bloc/chat_bloc.dart';
import 'package:lavoauto/core/constants/assets.dart';
import 'package:lavoauto/data/models/response/user/orders_response_modal.dart';
import 'package:lavoauto/data/repositories/chat_repository.dart';
import 'package:lavoauto/features/pages/chat/chat_page.dart';
import 'package:lavoauto/features/pages/orderDetail/order_bids_page.dart';
import 'package:lavoauto/features/widgets/custom_scaffold.dart';
import 'package:lavoauto/theme/app_color.dart';
import 'package:lavoauto/utils/utils.dart';

class OrderDetailPage extends StatelessWidget {
  final UserOrder order;

  const OrderDetailPage({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Row(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: AppColors.primaryNewDark,
                    size: 24,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                const Spacer(),
              ],
            ),
            const SizedBox(height: 8),
            const Center(
              child: Text(
                "Detalles del pedido",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryNewDark,
                  height: 1.3,
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Show "Abrir chat" if offer accepted, otherwise show "Ver ofertas"
            if (order.estatus.toLowerCase() == 'puja_accepted' && order.lavadorId != null)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryNew,
                    elevation: 0,
                    shadowColor: Colors.transparent,
                    surfaceTintColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
              )
            else
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryNew,
                    elevation: 0,
                    shadowColor: Colors.transparent,
                    surfaceTintColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OrderBidsPage(ordenId: order.ordenId),
                      ),
                    );
                  },
                  child: const Text(
                    "Ver ofertas",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            const SizedBox(height: 32),
            _detailTile(
              image: Assets.hangerLocation,
              title: "Estado del pedido",
              subtitle: order.estatus,
            ),
            const SizedBox(height: 14),
            _detailTile(
              image: Assets.hangerLocation,
              title: "Tipo de servicio",
              subtitle: _getServiceType(),
            ),
            const SizedBox(height: 14),
            _detailTile(
              image: Assets.basket,
              title: "Estimado de ropa",
              subtitle: _getClothesEstimate(),
            ),
            const SizedBox(height: 14),
            _detailTile(
              image: Assets.machineSvg,
              title: "Preferencias de lavado",
              subtitle: _getWashPreferences(),
            ),
            const SizedBox(height: 14),
            _detailTile(
              image: Assets.hangerWhite,
              title: "Opción de ganchos",
              subtitle: _getIroningOption(),
            ),
            const SizedBox(height: 14),
            _detailTile(
              image: Assets.calenderSvg,
              title: "Dirección",
              subtitle: order.direccion ?? "No especificado",
            ),
            const SizedBox(height: 14),
            _detailTile(
              image: Assets.time,
              title: "Horario de recolección",
              subtitle: _getPickupTimeDisplay(),
            ),
            const SizedBox(height: 14),
            _detailTile(
              image: Assets.time,
              title: "Entrega estimada",
              subtitle: _getDeliveryTimeDisplay(),
            ),
            const SizedBox(height: 14),
            _detailTile(
              image: Assets.card,
              title: "Método de pago",
              subtitle: _getPaymentMethodDisplay(),
            ),
            if (order.instruccionesEspeciales != null && order.instruccionesEspeciales!.isNotEmpty) ...[
              const SizedBox(height: 14),
              _detailTile(
                image: Assets.basket,
                title: "Notas adicionales",
                subtitle: order.instruccionesEspeciales ?? "",
              ),
            ],
            const SizedBox(height: 30),
            Center(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade300,
                    foregroundColor: AppColors.primaryNewDark,
                    elevation: 0,
                    shadowColor: Colors.transparent,
                    surfaceTintColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "Atrás",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  String _getServiceType() {
    if (order.tipoPlanchado != null) {
      return "Lavado, Secado y Planchado";
    } else if (order.metodoSecado != null && order.metodoSecado!.isNotEmpty) {
      return "Lavado y Secado";
    }
    return "Lavado";
  }

  String _getClothesEstimate() {
    if (order.pesoAproximadoKg == null) {
      return "No especificado";
    }
    return "${order.pesoAproximadoKg!.toStringAsFixed(1)} kg";
  }

  String _getWashPreferences() {
    final detergent = order.tipoDetergente ?? "No especificado";
    final softener = (order.suavizante ?? false) ? "Con suavizante" : "Sin suavizante";
    final temp = order.metodoSecado ?? "No especificado";

    return "$detergent • $softener • $temp";
  }

  String _getIroningOption() {
    if (order.tipoPlanchado == null) {
      return "Sin gancho";
    } else if (order.tipoPlanchado == "con_gancho") {
      return "Con gancho (${order.numeroPrendasPlanchado} prendas)";
    }
    return order.tipoPlanchado ?? "No especificado";
  }

  String _getPickupTimeDisplay() {
    final fecha = order.fechaRecogidaPropuestaCliente;
    if (fecha == null || fecha.isEmpty) {
      return "No especificado";
    }
    try {
      final date = DateTime.parse(fecha);
      return "${date.day}/${date.month}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
    } catch (e) {
      return fecha;
    }
  }

  String _getDeliveryTimeDisplay() {
    final fecha = order.fechaEntregaPropuestaCliente;
    if (fecha == null || fecha.isEmpty) {
      return "No especificado";
    }
    try {
      final date = DateTime.parse(fecha);
      return "${date.day}/${date.month}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
    } catch (e) {
      return fecha;
    }
  }

  String _getPaymentMethodDisplay() {
    if (order.paymentCardLast4 != null && order.paymentCardLast4!.isNotEmpty) {
      // Card number is already formatted as "**** **** **** 1234"
      final cardType = order.paymentCardType ?? "Tarjeta";
      return "$cardType: ${order.paymentCardLast4}";
    }
    return "ID: ${order.paymentMethodId ?? 'No especificado'}";
  }

  Widget _detailTile({
    required String image,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            image,
            width: 50,
            color: AppColors.primaryNew,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 22,
                    color: AppColors.black,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
