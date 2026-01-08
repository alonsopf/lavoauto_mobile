import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lavoauto/bloc/worker/jobsearch/jobsearch_bloc.dart';
import 'package:lavoauto/core/constants/app_strings.dart';
import 'package:lavoauto/data/models/response/worker/orders_response_modal.dart';
import 'package:lavoauto/presentation/common_widgets/custom_text.dart';
import 'package:lavoauto/presentation/common_widgets/image_.dart';
import 'package:lavoauto/presentation/common_widgets/primary_button.dart';
import 'package:lavoauto/presentation/common_widgets/profile_image_widget.dart';
import 'package:lavoauto/theme/app_color.dart';
import 'package:lavoauto/utils/loadersUtils/LoaderClass.dart';
import 'package:lavoauto/utils/utils.dart';
import 'package:lavoauto/presentation/router/router.gr.dart' as routeFiles;

import '../../../core/constants/assets.dart';
import '../../../data/models/request/worker/availableOrdersRequest_modal.dart';
import '../../../utils/marginUtils/margin_imports.dart';
import '../../common_widgets/app_bar.dart';
import '../../common_widgets/custom_drawer.dart';

@RoutePage()
class JobSearch extends StatefulWidget {
  const JobSearch({super.key});

  @override
  State<JobSearch> createState() => _JobSearchState();
}

class _JobSearchState extends State<JobSearch> {
  @override
  void initState() {
    super.initState();
    String token = Utils.getAuthenticationToken() ?? '';
    debugPrint("token of the user $token");
    context.read<JobsearchBloc>().add(
          FetchAvailableOrdersEvent(ListAvailableOrdersRequest(token: token)),
        );
  }

  @override
  Widget build(BuildContext context) {
    dynamic loader = Loader.getLoader(context);
    return Scaffold(
      backgroundColor: AppColors.screenBackgroundColor,
      appBar: CustomAppBar.getCustomBar(
        title: AppStrings.searchJobs,
        actions: [
          const HeaderProfileImage(),
        ],
      ),
      drawer: CustomDrawer(
        title: AppStrings.searchJobs,
        ontap: () {},
      ),
      body: BlocConsumer<JobsearchBloc, JobsearchState>(
        listener: (context, state) {
          if (state is JobsearchLoading) {
            Loader.insertLoader(context, loader);
          } else if (state is JobsearchFailure) {
            Loader.hideLoader(loader);
            Utils.showSnackbar(
              duration: 3000,
              msg: state.errorMessage,
              context: context,
            );
          } else if (state is JobsearchSuccess) {
            Loader.hideLoader(loader);
          }
        },
        buildWhen: (previous, current) =>
            current is! JobsearchLoading,
        builder: (context, state) {
          if (state is JobsearchSuccess) {
            if (state.workerOrdersResponse.orders?.isEmpty == true) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText(
                        text: "Por el momento, no hay trabajos disponibles",
                        fontSize: 18.0,
                        fontColor: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        textAlign: TextAlign.center,
                      ).setText(),
                      const SizedBox(height: 20.0),
                      PrimaryButton.primarybutton(
                        text: "Ir a mis servicios",
                        onpressed: () {
                          context.router.push(const routeFiles.MyServices());
                        },
                      ),
                    ],
                  ),
                ),
              );
            }
            return _buildJobList(
                context, state.workerOrdersResponse.orders ?? []);
          } else if (state is JobsearchFailure) {
            return Center(
              child: CustomText(
                text: state.errorMessage,
                fontSize: 18.0,
                fontColor: AppColors.primary,
                fontWeight: FontWeight.bold,
              ).setText(),
            );
          }
          return Center(
            child: CustomText(
              text: "Coming Soon",
              fontSize: 20.0,
              fontColor: AppColors.primary,
              fontWeight: FontWeight.bold,
            ).setText(),
          );
          ;
        },
      ),
    );
  }

  Widget _buildJobList(BuildContext context, List<WorkerOrder> orders) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return _buildCustomCard(context, order);
      },
    );
  }

  Widget _buildCustomCard(BuildContext context, WorkerOrder order) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: const BorderRadius.all(Radius.circular(16.0)),
        boxShadow: [
          BoxShadow(
            color: AppColors.borderGrey.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      width: Utils.getScreenSize(context).width,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12.0),
              topRight: Radius.circular(12.0),
            ),
            child: ColoredBox(
              color: AppColors.tertiary,
              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
                titleAlignment: ListTileTitleAlignment.bottom,
                subtitle: CustomText(
                  text: "Cliente ID: ${order.clienteId}",
                  fontSize: 22.0,
                  fontColor: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ).setText(),
                horizontalTitleGap: 10.0,
                leading: CircleAvatar(
                  radius: 26,
                  backgroundColor: AppColors.screenBackgroundColor,
                  child: Image.asset(
                    Assets.placeholderUserPhoto,
                    height: 45.0,
                    width: 45.0,
                  ),
                ),
              ),
            ),
          ),
          ColoredBox(
            color: AppColors.greyNormalColor,
            child: ListTile(
              minTileHeight: 30.0,
              dense: true,
              minVerticalPadding: 0.0,
              horizontalTitleGap: 5.0,
              title: CustomText(
                text: Utils.formatDateTime(order.fechaProgramada),
                fontSize: 18.0,
                fontColor: AppColors.primary,
                fontWeight: FontWeight.w400,
              ).setText(),
              leading: CustomText(
                text: "${AppStrings.requestDate}:",
                fontSize: 18.0,
                fontColor: AppColors.primary,
                fontWeight: FontWeight.bold,
              ).setText(),
            ),
          ),
          ColoredBox(
            color: AppColors.white,
            child: ListTile(
              dense: true,
              minTileHeight: 30.0,
              minVerticalPadding: 0.0,
              horizontalTitleGap: 5.0,
              title: CustomText(
                text: "${order.pesoAproximadoKg ?? 0.0} kg",
                fontSize: 18.0,
                fontColor: AppColors.primary,
                fontWeight: FontWeight.w400,
              ).setText(),
              leading: CustomText(
                text: "${AppStrings.approxWeight}:",
                fontSize: 18.0,
                fontColor: AppColors.primary,
                fontWeight: FontWeight.bold,
              ).setText(),
            ),
          ),
          ColoredBox(
            color: AppColors.greyNormalColor,
            child: ListTile(
              minTileHeight: 30.0,
              dense: true,
              minVerticalPadding: 0.0,
              horizontalTitleGap: 5.0,
              title: CustomText(
                text: order.estatus.toUpperCase(),
                fontSize: 18.0,
                fontColor: AppColors.primary,
                fontWeight: FontWeight.w400,
              ).setText(),
              leading: CustomText(
                text: "Estado:",
                fontSize: 18.0,
                fontColor: AppColors.primary,
                fontWeight: FontWeight.bold,
              ).setText(),
            ),
          ),
          ColoredBox(
            color: AppColors.white,
            child: ListTile(
              minTileHeight: 30.0,
              dense: true,
              minVerticalPadding: 0.0,
              horizontalTitleGap: 5.0,
              title: CustomText(
                text: order.tipoDetergente ?? "No especificado",
                fontSize: 18.0,
                fontColor: AppColors.primary,
                fontWeight: FontWeight.w400,
              ).setText(),
              leading: CustomText(
                text: "Detergente:",
                fontSize: 18.0,
                fontColor: AppColors.primary,
                fontWeight: FontWeight.bold,
              ).setText(),
            ),
          ),
          ColoredBox(
            color: AppColors.greyNormalColor,
            child: ListTile(
              minTileHeight: 30.0,
              dense: true,
              minVerticalPadding: 0.0,
              horizontalTitleGap: 5.0,
              title: CustomText(
                text: order.metodoSecado ?? "No especificado",
                fontSize: 18.0,
                fontColor: AppColors.primary,
                fontWeight: FontWeight.w400,
              ).setText(),
              leading: CustomText(
                text: "Secado:",
                fontSize: 18.0,
                fontColor: AppColors.primary,
                fontWeight: FontWeight.bold,
              ).setText(),
            ),
          ),
          if (order.instruccionesEspeciales?.isNotEmpty == true)
          ColoredBox(
            color: AppColors.white,
            child: ListTile(
              minTileHeight: 30.0,
              dense: true,
              minVerticalPadding: 0.0,
              horizontalTitleGap: 5.0,
              title: CustomText(
                text: order.instruccionesEspeciales!,
                fontSize: 18.0,
                fontColor: AppColors.primary,
                fontWeight: FontWeight.w400,
              ).setText(),
              leading: CustomText(
                text: "Instrucciones:",
                fontSize: 18.0,
                fontColor: AppColors.primary,
                fontWeight: FontWeight.bold,
              ).setText(),
            ),
          ),
          ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(12.0),
              bottomRight: Radius.circular(12.0),
            ),
            child: ColoredBox(
              color: AppColors.greyColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: PrimaryButton.secondaryIconbutton(
                      color: AppColors.secondary,
                      text: AppStrings.viewDetail,
                      onpressed: () {
                        // Navigate to available order details
                        context.router.push(routeFiles.LavadorOrderDetail(orderId: order.ordenId));
                      },
                    ),
                  ),
                  const XMargin(10.0),
                  PrimaryButton.secondaryIconbutton(
                    color: AppColors.primary,
                    text: AppStrings.offer,
                    onpressed: () {
                      // Navigate to create an offer
                      context.router.push(routeFiles.MyBids(order: order));
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
