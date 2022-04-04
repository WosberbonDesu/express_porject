import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import '../../components/home_cmp.dart';
import '../../components/main_components.dart';
import '../../constants/enums/dialog_enums.dart';
import '../../constants/styles/colors.dart';
import '../../constants/styles/text_styles.dart';
import '../../providers/appstate.dart';
import 'add_invoice.dart';
import '../../utilities/routes.dart';

import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AppState>(
        builder: (context, app, child) => Stack(
          clipBehavior: Clip.none,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Image.asset(
                  "./dev_assets/top.png",
                  fit: BoxFit.fill,
                  height: app.queryHeight * 0.25,
                ),
                Positioned(
                  top: 60,
                  left: 20,
                  right: 20,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Mevcut Durum",
                            style: PersonalTStyles.w500s16W,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            app.user!.currentBudget.toStringAsFixed(2) + " ₺",
                            style: PersonalTStyles.w700s24W,
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () => DialogEnum.limit
                            .dialogMethod(context: context, app: app),
                        icon: const Icon(
                          FeatherIcons.bell,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                ),
                Positioned(
                  bottom: -50,
                  right: 20,
                  left: 20,
                  child: Container(
                    height: 100,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        buildColButton(
                            color: PersonalColors.orange,
                            title: "Harcama Gir",
                            onTap: () => navigateToPage(
                                context,
                                const AddInvoice(
                                  backgroundColor: PersonalColors.orange,
                                  title: "Harcama Gir",
                                  isExpense: true,
                                )),
                            icon: FeatherIcons.plus),
                        // buildColButton(
                        //     color: PersonalColors.purple,
                        //     title: "Borç Gir",
                        //     onTap: () {},
                        //     icon: FeatherIcons.arrowUp),
                        buildColButton(
                            color: PersonalColors.softRed,
                            title: "Gelen Gir",
                            onTap: () => navigateToPage(
                                context,
                                const AddInvoice(
                                  backgroundColor: PersonalColors.softRed,
                                  title: "Gelen Gir",
                                  isExpense: false,
                                )),
                            icon: FeatherIcons.arrowDown),
                      ],
                    ),
                  ),
                )
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: app.queryHeight * 0.25 + 100),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      "Son Harcamalar",
                      style: PersonalTStyles.w600s20B,
                    ),
                    Expanded(
                      child: (app.user!.transactions == null ||
                              app.user!.transactions!.isEmpty)
                          ? const Center(
                              child: Text("Harcamanız bulunmuyor."),
                            )
                          : ListView.separated(
                              itemCount: app.user!.transactions!.length < 5
                                  ? app.user!.transactions!.length
                                  : 5,
                              shrinkWrap: true,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 10),
                              itemBuilder: (BuildContext context, int index) {
                                var transaction =
                                    app.user!.transactions![index];
                                return buildTransactionCard(transaction);
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
