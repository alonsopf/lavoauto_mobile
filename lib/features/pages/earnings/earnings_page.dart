import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lavoauto/bloc/worker/services/services_bloc.dart';
import 'package:lavoauto/data/models/request/worker/earnings_request_modal.dart';
import 'package:lavoauto/theme/app_color.dart';
import 'package:lavoauto/utils/utils.dart';

class EarningsPage extends StatefulWidget {
  const EarningsPage({super.key});

  @override
  State<EarningsPage> createState() => _EarningsPageState();
}

class _EarningsPageState extends State<EarningsPage> {
  @override
  void initState() {
    super.initState();
    final token = Utils.getAuthenticationToken();
    context.read<ServicesBloc>().add(FetchEarningsEvent(EarningsRequest(token: token)));
  }

  String _formatDate(DateTime date) {
    final months = ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'];
    return '${date.day} ${months[date.month - 1]}';
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
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.primaryNew, size: 24),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Ganancias",
          style: TextStyle(
            color: AppColors.primaryNewDark,
            fontSize: 28,
            fontWeight: FontWeight.w700,
          ),
        ),
        elevation: 0,
      ),
      body: SafeArea(
        child: BlocBuilder<ServicesBloc, ServicesState>(
          builder: (context, state) {
            if (state is ServicesLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryNew),
                ),
              );
            } else if (state is EarningsSuccess) {
              final earnings = state.earningsResponse.earnings;
              final paymentHistory = state.earningsResponse.paymentHistory;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Earnings cards - Hoy, Semana, Mes
                    Row(
                      children: [
                        Expanded(
                          child: _earningCard(
                            title: "Hoy",
                            amount: earnings.today,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _earningCard(
                            title: "Semana",
                            amount: earnings.week,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _earningCard(
                            title: "Mes",
                            amount: earnings.month,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    // Historial de Pagos
                    const Text(
                      "Historial de Pagos",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryNewDark,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Payment history list
                    if (paymentHistory.isEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 40.0),
                          child: Column(
                            children: [
                              Icon(
                                Icons.inbox_outlined,
                                size: 64,
                                color: AppColors.grey.withOpacity(0.5),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                "No hay pagos registrados",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: AppColors.grey,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: paymentHistory.length,
                          separatorBuilder: (context, index) => const Divider(
                            height: 1,
                            color: AppColors.borderGrey,
                            indent: 16,
                            endIndent: 16,
                          ),
                          itemBuilder: (context, index) {
                            final payment = paymentHistory[index];
                            return _paymentHistoryItem(
                              date: payment.date,
                              amount: payment.amount,
                              status: payment.status,
                            );
                          },
                        ),
                      ),
                    const SizedBox(height: 40),
                  ],
                ),
              );
            } else if (state is ServicesFailure) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 64,
                        color: AppColors.error,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        state.errorMessage,
                        style: const TextStyle(
                          fontSize: 18,
                          color: AppColors.error,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryNew,
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                        ),
                        onPressed: () {
                          final token = Utils.getAuthenticationToken();
                          context.read<ServicesBloc>().add(
                              FetchEarningsEvent(EarningsRequest(token: token)));
                        },
                        child: const Text(
                          'Reintentar',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            return const Center(
              child: Text(
                "Cargando ganancias...",
                style: TextStyle(
                  fontSize: 20,
                  color: AppColors.primaryNewDark,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _earningCard({required String title, required double amount}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.primaryNew.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primaryNew.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: AppColors.primaryNew,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '\$${amount.toStringAsFixed(0)}',
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryNewDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _paymentHistoryItem({
    required DateTime date,
    required double amount,
    required String status,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          // Calendar icon
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primaryNew.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.calendar_today,
              color: AppColors.primaryNew,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          // Date and description
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${_formatDate(date)} - Pago recibido',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    status,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.success,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Amount
          Text(
            '\$${amount.toStringAsFixed(0)}',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.black,
            ),
          ),
        ],
      ),
    );
  }
}

