import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';
import '../../common_widgets/custom_drawer.dart';

@RoutePage()
class Ratings extends StatelessWidget {
  const Ratings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: CustomDrawer(
      title: AppStrings.ratings,
      ontap: () {},
    ));
  }
}
