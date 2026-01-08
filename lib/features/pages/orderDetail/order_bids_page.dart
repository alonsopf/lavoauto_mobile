import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lavoauto/bloc/user/order_bloc.dart';
import 'package:lavoauto/data/models/request/user/accept_bid_order_modal.dart';
import 'package:lavoauto/data/models/request/user/order_bids_modal.dart';
import 'package:lavoauto/data/models/request/user/orders_modal.dart';
import 'package:lavoauto/data/models/response/user/order_bids_response_modal.dart';
import 'package:lavoauto/data/repositories/user_repo.dart';
import 'package:lavoauto/dependencyInjection/di.dart';
import 'package:lavoauto/features/widgets/custom_scaffold.dart';
import 'package:lavoauto/theme/app_color.dart';
import 'package:lavoauto/utils/utils.dart';

class OrderBidsPage extends StatefulWidget {
  final int ordenId;

  const OrderBidsPage({
    super.key,
    required this.ordenId,
  });

  @override
  State<OrderBidsPage> createState() => _OrderBidsPageState();
}

class _OrderBidsPageState extends State<OrderBidsPage> {
  late UserRepo _userRepo;
  bool _isLoading = true;
  List<OrderBid> _bids = [];
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _userRepo = AppContainer.getIt.get<UserRepo>();
    _loadBids();
  }

  Future<void> _loadBids() async {
    print('🔍 [OrderBidsPage] Iniciando carga de ofertas...');
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final token = Utils.getAuthenticationToken();
      print(
          '🔍 [OrderBidsPage] Token obtenido: ${token.isNotEmpty ? "OK" : "VACÍO"}');

      if (token.isEmpty) {
        print('❌ [OrderBidsPage] Token vacío, abortando');
        setState(() {
          _errorMessage = 'Error: No se encontró el token de autenticación';
          _isLoading = false;
        });
        return;
      }

      final request = ListOrderBidsRequest(
        token: token,
        ordenId: widget.ordenId,
      );

      print('🔍 [OrderBidsPage] Llamando API con ordenId: ${widget.ordenId}');
      final response = await _userRepo.getOrderBids(request);
      print('🔍 [OrderBidsPage] Respuesta recibida');
      print(
          '🔍 [OrderBidsPage] response.data != null: ${response.data != null}');
      print('🔍 [OrderBidsPage] response.data?.pujas: ${response.data?.pujas}');
      print(
          '🔍 [OrderBidsPage] response.errorMessage: ${response.errorMessage}');

      if (mounted) {
        if (response.data != null) {
          final bids = response.data!.pujas ?? [];
          print('✅ [OrderBidsPage] Ofertas procesadas: ${bids.length} ofertas');
          setState(() {
            _bids = bids;
            _isLoading = false;
          });
          print(
              '✅ [OrderBidsPage] Estado actualizado - _bids.length: ${_bids.length}, _isLoading: $_isLoading');
        } else {
          print('❌ [OrderBidsPage] response.data es null');
          setState(() {
            _errorMessage = response.errorMessage ?? 'Error al cargar ofertas';
            _isLoading = false;
          });
          print('❌ [OrderBidsPage] Error mostrado: $_errorMessage');
        }
      }
    } catch (e) {
      print('❌ [OrderBidsPage] Excepción capturada: $e');
      if (mounted) {
        setState(() {
          _errorMessage = 'Error: ${e.toString()}';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    print(
        '🎨 [OrderBidsPage] Build - _isLoading: $_isLoading, _errorMessage: $_errorMessage, _bids.length: ${_bids.length}');

    Widget contentWidget;

    if (_isLoading) {
      print('🎨 [OrderBidsPage] Mostrando: LOADING');
      contentWidget = const Center(
        child: CircularProgressIndicator(
          color: AppColors.primaryNew,
        ),
      );
    } else if (_errorMessage != null) {
      print('🎨 [OrderBidsPage] Mostrando: ERROR - $_errorMessage');
      contentWidget = Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 60,
              color: AppColors.primaryNew,
            ),
            const SizedBox(height: 16),
            Text(
              _errorMessage!,
              style: const TextStyle(
                fontSize: 18,
                color: AppColors.primaryNewDark,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryNew,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _loadBids,
              child: const Text(
                "Reintentar",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      );
    } else if (_bids.isEmpty) {
      print('🎨 [OrderBidsPage] Mostrando: EMPTY (No hay ofertas)');
      contentWidget = Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.inbox_outlined,
              size: 80,
              color: AppColors.primaryNew,
            ),
            const SizedBox(height: 16),
            const Text(
              "No hay ofertas disponibles\npor el momento",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryNewDark,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Los lavadores comenzarán a enviar\nsus propuestas pronto",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: AppColors.primaryNewDark,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryNew,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _loadBids,
              child: const Text(
                "Actualizar",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      );
    } else {
      print('🎨 [OrderBidsPage] Mostrando: LISTA con ${_bids.length} ofertas');
      contentWidget = Column(
        children: _bids.map((bid) => _buildBidCard(bid)).toList(),
      );
    }

    return CustomScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 28),
          const Center(
            child: Text(
              "Ofertas para tu orden",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryNewDark,
                height: 1.3,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 32),
          // Usamos ConstrainedBox en lugar de Expanded porque CustomScaffold usa SingleChildScrollView
          ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height *
                  0.5, // Mínimo 50% de la pantalla
            ),
            child: contentWidget,
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade300,
                foregroundColor: AppColors.primaryNewDark,
                elevation: 0,
                shadowColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "Atrás",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildBidCard(OrderBid bid) {
    // Usar la foto del lavador desde la API, o generar un avatar de respaldo
    final avatarUrl = bid.lavadorFotoUrl ??
        "https://ui-avatars.com/api/?name=${Uri.encodeComponent(bid.lavadorNombre ?? 'Lavador')}&background=7EB5D6&color=fff&size=128";
    final lavadorName = bid.lavadorNombre ?? "Lavador profesional";
    final rating = bid.lavadorRating ?? 0.0;
    final fullStars = rating.floor();
    final hasHalfStar = (rating - fullStars) >= 0.5;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header con foto, nombre, rating y estado
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar circular
              CircleAvatar(
                radius: 28,
                backgroundColor: AppColors.primaryNew,
                backgroundImage: NetworkImage(avatarUrl),
              ),
              const SizedBox(width: 12),
              // Nombre y rating
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lavadorName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: AppColors.black,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        ...List.generate(5, (index) {
                          if (index < fullStars) {
                            return const Icon(Icons.star,
                                size: 16, color: Colors.orange);
                          } else if (index == fullStars && hasHalfStar) {
                            return const Icon(Icons.star_half,
                                size: 16, color: Colors.orange);
                          } else {
                            return const Icon(Icons.star_border,
                                size: 16, color: Colors.orange);
                          }
                        }),
                        const SizedBox(width: 6),
                        Text(
                          rating.toStringAsFixed(1),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.black,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "• ID #${bid.lavadorId}",
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.borderGrey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Estado
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusColor(bid.status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _getStatusColor(bid.status),
                    width: 1,
                  ),
                ),
                child: Text(
                  _getStatusText(bid.status),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _getStatusColor(bid.status),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Precio destacado
          if (bid.precioPorKg != null)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primaryNew.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.primaryNew.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.attach_money,
                    color: AppColors.primaryNew,
                    size: 24,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "${bid.precioPorKg!.toStringAsFixed(2)} MXN por kg",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryNew,
                    ),
                  ),
                ],
              ),
            ),
          if (bid.nota.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.note_outlined,
                    size: 20,
                    color: AppColors.primaryNewDark,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      bid.nota,
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.primaryNewDark,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (bid.fechaRecogidaPropuesta != null ||
              bid.fechaEntregaPropuesta != null) ...[
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 8),
            if (bid.fechaRecogidaPropuesta != null)
              _buildDateRow(
                icon: Icons.calendar_today_rounded,
                label: "Recogida propuesta",
                date: bid.fechaRecogidaPropuesta!,
              ),
            if (bid.fechaRecogidaPropuesta != null &&
                bid.fechaEntregaPropuesta != null)
              const SizedBox(height: 8),
            if (bid.fechaEntregaPropuesta != null)
              _buildDateRow(
                icon: Icons.event_available_rounded,
                label: "Entrega propuesta",
                date: bid.fechaEntregaPropuesta!,
              ),
          ],
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryNew,
                elevation: 0,
                shadowColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed:
                  bid.status == 'pendiente' ? () => _acceptBid(bid) : null,
              child: Text(
                bid.status == 'pendiente'
                    ? "Aceptar oferta"
                    : "Oferta ${_getStatusText(bid.status).toLowerCase()}",
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateRow({
    required IconData icon,
    required String label,
    required String date,
  }) {
    String formattedDate = date;
    try {
      final parsedDate = DateTime.parse(date);
      formattedDate =
          "${parsedDate.day}/${parsedDate.month}/${parsedDate.year} ${parsedDate.hour.toString().padLeft(2, '0')}:${parsedDate.minute.toString().padLeft(2, '0')}";
    } catch (e) {
      // Keep original date if parsing fails
    }

    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: AppColors.primaryNew,
        ),
        const SizedBox(width: 8),
        Text(
          "$label: ",
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.primaryNewDark,
          ),
        ),
        Expanded(
          child: Text(
            formattedDate,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.primaryNewDark,
            ),
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pendiente':
        return Colors.orange;
      case 'aceptada':
        return Colors.green;
      case 'rechazada':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'pendiente':
        return 'Pendiente';
      case 'aceptada':
        return 'Aceptada';
      case 'rechazada':
        return 'Rechazada';
      default:
        return status;
    }
  }

  Future<void> _acceptBid(OrderBid bid) async {
    // Mostrar diálogo de confirmación
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Aceptar oferta'),
        content: Text(
          '¿Estás seguro de que quieres aceptar esta oferta de ${bid.lavadorNombre ?? "este lavador"}?\n\n'
          'Precio: \$${bid.precioPorKg?.toStringAsFixed(2)} MXN por kg',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryNew,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      final token = Utils.getAuthenticationToken();

      final request = AcceptBidOrderRequest(
        token: token,
        ordenId: widget.ordenId,
        pujaId: bid.pujaId,
      );

      final response = await _userRepo.acceptBid(request);

      if (mounted) {
        if (response.data != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('¡Oferta aceptada exitosamente!'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );

          // Esperar un momento para que el usuario vea el mensaje
          await Future.delayed(const Duration(milliseconds: 500));

          // Refrescar las órdenes en el home antes de navegar
          if (mounted) {
            final orderBloc = context.read<OrderBloc>();
            final token = Utils.getAuthenticationToken();
            orderBloc
                .add(FetchOrderRequestsEvent(GetOrderRequests(token: token)));

            // Navegar de regreso al home del cliente
            Navigator.of(context).popUntil((route) => route.isFirst);
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response.errorMessage ?? 'Error al aceptar oferta'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
