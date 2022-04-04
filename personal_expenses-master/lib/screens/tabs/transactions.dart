import 'package:flutter/material.dart';
import '../../components/inv_components.dart';
import '../../components/main_components.dart';
import '../../constants/styles/text_styles.dart';
import '../../constants/styles/themes.dart';
import '../../providers/appstate.dart';
import 'transaction/all_transactions.dart';
import '../../utilities/routes.dart';
import 'package:provider/provider.dart';

class Transactions extends StatefulWidget {
  const Transactions({Key? key}) : super(key: key);

  @override
  _TransactionsState createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Consumer<AppState>(
      builder: (context, app, child) => Padding(
        padding: const EdgeInsets.only(left: 24, right: 24, top: 45),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    "./dev_assets/top.png",
                    fit: BoxFit.fill,
                    height: 180,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  height: 132,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          const Text(
                            "Mevcut Bakiye",
                            style: PersonalTStyles.w500s12LB,
                          ),
                          Text(
                            "${app.user!.currentBudget.toStringAsFixed(2)} ₺",
                            style: PersonalTStyles.w600s24W,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          buildCardRowElement(
                              title: "Gelir (Bu Ay)",
                              price: app.user!.monthlyIncome,
                              isExpense: false),
                          const SizedBox(width: 20),
                          buildCardRowElement(
                              title: "Gider (Bu Ay)",
                              price: app.user!.monthlyOutcome,
                              isExpense: true),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 36),
            // const Text(
            //   "Gelir Gider Grafiği",
            //   style: PersonalTStyles.w600s20B,
            // ),
            // const SizedBox(height: 24),
            // Container(height: 165, color: PersonalColors.darkBlue),
            // const SizedBox(height: 24),
            // buildGraphLegend(),
            // const SizedBox(height: 36),
            const Text(
              "Harcama Geçmişi",
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
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (BuildContext context, int index) {
                        var transaction = app.user!.transactions![index];
                        return buildTransactionCard(transaction);
                      },
                    ),
            ),
            SizedBox(
              width: app.queryWidth - 48,
              child: TextButton(
                onPressed: () =>
                    navigateToPage(context, const AllTransactions()),
                child: const Text("Tümünü Gör"),
                style: secondaryTextButtonTheme,
              ),
            ),
            const SizedBox(
              height: 36,
            )
          ],
        ),
      ),
    ));
  }
}
