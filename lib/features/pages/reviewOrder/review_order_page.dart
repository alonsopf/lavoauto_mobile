import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lavoauto/core/constants/assets.dart';
import 'package:lavoauto/data/models/order/order_model.dart';
import 'package:lavoauto/data/models/request/order/create_order_request.dart';
import 'package:lavoauto/data/repositories/order_repo.dart';
import 'package:lavoauto/dependencyInjection/di.dart';
import 'package:auto_route/auto_route.dart';
import 'package:lavoauto/presentation/router/router.gr.dart' as routeFiles;
import 'package:lavoauto/features/pages/service/date_time_picker_page.dart';
import 'package:lavoauto/features/pages/pickUp/pickup_schedule_page.dart';
import 'package:lavoauto/features/pages/Gancho/gancho_page.dart';
import 'package:lavoauto/features/pages/washPreferences/wash_preferences_page.dart';
import 'package:lavoauto/features/widgets/custom_button.dart';
import 'package:lavoauto/features/widgets/custom_scaffold.dart';
import 'package:lavoauto/theme/app_color.dart';
import 'package:lavoauto/utils/utils.dart';

class ReviewOrderPage extends StatefulWidget {
  final OrderModel? orderData;

  const ReviewOrderPage({
    super.key,
    this.orderData,
  });

  @override
  State<ReviewOrderPage> createState() => _ReviewOrderPageState();
}

class _ReviewOrderPageState extends State<ReviewOrderPage> {
  late OrderRepo _orderRepo;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _orderRepo = AppContainer.getIt.get<OrderRepo>();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 28),
            const Center(
              child: Text(
                "Revisa tu orden",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryNewDark,
                  height: 1.3,
                ),
              ),
            ),
            const SizedBox(height: 32),
            _reviewTile(
              image: Assets.hangerLocation,
              title: "Tipo de servicio",
              subtitle: widget.orderData?.selectedService ?? "",
            ),
            const SizedBox(height: 14),
            _reviewTile(
              image: Assets.basket,
              title: "Estimado de ropa",
              subtitle: _getClothesEstimate(),
            ),
            const SizedBox(height: 14),
            _reviewTile(
              context: context,
              image: Assets.machineSvg,
              title: "Preferencias de lavado",
              subtitle: _getWashPreferences(),
              editable: true,
              onEdit: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const WashPreferencesPage(),
                  ),
                );
              },
            ),
            const SizedBox(height: 14),
            _reviewTile(
              context: context,
              image: Assets.hangerWhite,
              title: "Opción de ganchos",
              subtitle: widget.orderData?.ganchoOption ?? "",
              editable: true,
              onEdit: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const GanchoPage(),
                  ),
                );
              },
            ),
            const SizedBox(height: 14),
            _reviewTile(
              context: context,
              image: Assets.calenderSvg,
              title: "Dirección",
              subtitle: widget.orderData?.selectedAddressTitle ?? "",
              editable: true,
              onEdit: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const PickupSchedulePage(),
                  ),
                );
              },
            ),
            const SizedBox(height: 14),
            _reviewTile(
              context: context,
              image: Assets.time,
              title: "Horario de recolección",
              subtitle: _getPickupTimeDisplay(),
              editable: true,
              onEdit: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const DateTimePickerPage(),
                  ),
                );
              },
            ),
            const SizedBox(height: 14),
            _reviewTile(
              context: context,
              image: Assets.time,
              title: "Entrega estimada",
              subtitle: widget.orderData?.selectedDeliveryTime ?? "",
              editable: true,
              onEdit: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const DateTimePickerPage(),
                  ),
                );
              },
            ),
            const SizedBox(height: 14),
            _reviewTile(
              image: Assets.card,
              title: "Método de pago",
              subtitle: widget.orderData?.paymentMethodId ?? "No seleccionado",
            ),
            if (widget.orderData?.clothesNote.isNotEmpty ?? false) ...[
              const SizedBox(height: 14),
              _reviewTile(
                image: Assets.basket,
                title: "Notas adicionales",
                subtitle: widget.orderData?.clothesNote ?? "",
              ),
            ],
            const SizedBox(height: 30),
            const Text(
              "Si todo está bien, publicaremos tu orden para\nque los lavadores te hagan ofertas.",
              style: TextStyle(fontSize: 22),
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    title: "Atrás",
                    isPrimary: false,
                    onTap: () => Navigator.pop(context),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: CustomButton(
                    title: "Publicar orden",
                    isPrimary: true,
                    onTap: () {
                      if (!_isLoading) {
                        _submitOrder();
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  String _getClothesEstimate() {
    if (widget.orderData == null) return "";

    final quantity = widget.orderData!.clothesQuantity;
    switch (quantity) {
      case "Poca":
        return "Poca (hasta 5 kg)";
      case "Normal":
        return "Normal (5–10 kg)";
      case "Mucha":
        return "Mucha (más de 10 kg)";
      default:
        return quantity;
    }
  }

  String _getWashPreferences() {
    if (widget.orderData == null) return "";

    final detergent = widget.orderData!.selectedDetergent;
    final softener = widget.orderData!.softener ? "Con suavizante" : "Sin suavizante";
    final temp = widget.orderData!.temperature;

    return "$detergent • $softener • Agua $temp";
  }

  String _getPickupTimeDisplay() {
    if (widget.orderData == null) return "";

    final date = widget.orderData!.selectedPickupTime;
    final timeRange = widget.orderData!.selectedPickupTimeRange;

    return "$date\n$timeRange";
  }

  String _convertToRFC3339(String dateString) {
    try {
      // If it's already a date-time string, parse and return as RFC3339
      if (dateString.contains('T')) {
        DateTime dt = DateTime.parse(dateString);
        return dt.toUtc().toString().replaceAll(' ', 'T') + 'Z';
      }

      // Default to current date at midnight if parsing fails
      DateTime now = DateTime.now();
      return DateTime(now.year, now.month, now.day).toIso8601String() + 'Z';
    } catch (e) {
      // Fallback to current date-time
      return DateTime.now().toUtc().toIso8601String() + 'Z';
    }
  }

  Future<void> _submitOrder() async {
    if (widget.orderData == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: No data available for the order')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final token = Utils.getAuthenticationToken();
      if (token.isEmpty) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error: Authentication token not found')),
        );
        setState(() => _isLoading = false);
        return;
      }

      final orderData = widget.orderData!;

      // Map ganchoOption to tipo_planchado
      String? tipoPlanchado;
      if (orderData.ganchoOption == "Sin gancho") {
        tipoPlanchado = null;
      } else if (orderData.ganchoOption == "Gancho nuevo" ||
          orderData.ganchoOption == "Gancho del cliente") {
        tipoPlanchado = "con_gancho";
      }

      final request = CreateOrderRequest(
        token: token,
        fecha_programada: _convertToRFC3339(orderData.selectedDate),
        peso_aproximado_kg: orderData.pesoAproximadoKg ?? 7.0,
        tipo_detergente: orderData.selectedDetergent,
        suavizante: orderData.softener,
        metodo_secado: orderData.temperature,
        tipo_planchado: tipoPlanchado,
        numero_prendas_planchado: orderData.numeroPrendasPlanchado,
        instrucciones_especiales: orderData.clothesNote,
        payment_method_id: orderData.paymentMethodId,
        lat: orderData.lat ?? 0.0,
        lon: orderData.lon ?? 0.0,
        direccion: orderData.direccion ?? orderData.selectedAddressTitle,
        fecha_recogida_propuesta_cliente: _convertToRFC3339(orderData.selectedPickupTime),
        fecha_entrega_propuesta_cliente: _convertToRFC3339(orderData.selectedDeliveryTime),
        lavado_urgente: orderData.lavadoUrgente,
        lavado_secado_urgente: orderData.lavadoSecadoUrgente,
        lavado_secado_planchado_urgente: orderData.lavadoSecadoPlanchadoUrgente,
      );

      final response = await _orderRepo.createOrder(request);

      if (!mounted) return;

      if (response.data != null) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('¡Orden publicada exitosamente!'),
            backgroundColor: AppColors.success,
            duration: Duration(seconds: 2),
          ),
        );
        
        // Navigate back to home, clearing all previous routes
        await Future.delayed(const Duration(milliseconds: 500));
        if (!mounted) return;
        
        // Pop all screens and go back to HomePage
        Navigator.of(context).popUntil((route) => route.isFirst);
        context.router.replace(const routeFiles.HomePage());
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.errorMessage ?? 'Error creating order'),
          ),
        );
        setState(() => _isLoading = false);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
      setState(() => _isLoading = false);
    }
  }

  Widget _reviewTile({
    required String image,
    required String title,
    required String subtitle,
    bool editable = false,
    BuildContext? context,
    VoidCallback? onEdit,
  }) {
    final child = Container(
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
                  style: const TextStyle(fontSize: 22, color: AppColors.black, fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
          if (editable)
            const Text(
              "Editar",
              style: TextStyle(
                color: AppColors.primaryNew,
                fontSize: 20,
                fontWeight: FontWeight.w400,
              ),
            ),
        ],
      ),
    );

    if (editable && onEdit != null) {
      return GestureDetector(
        onTap: onEdit,
        child: child,
      );
    }

    return child;
  }
}
