import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../components/inv_components.dart';
import '../../../components/main_components.dart';
import '../../../constants/enums/sort_enums.dart';
import '../../../constants/styles/text_styles.dart';
import '../../../constants/styles/themes.dart';
import '../../../models/transaction_model.dart';
import '../../../providers/appstate.dart';
import 'package:provider/provider.dart';

class AllTransactions extends StatefulWidget {
  const AllTransactions({Key? key}) : super(key: key);

  @override
  _AllTransactionsState createState() => _AllTransactionsState();
}

class _AllTransactionsState extends State<AllTransactions> {
  int index = 1;
  SortEnums sortValue = SortEnums.all;
  dynamic defaultTransactions, filteredTransactions;
  bool isLoading = false;
  changeLoading() => setState(() => isLoading = !isLoading);
  @override
  void initState() {
    initialize();
    super.initState();
  }

  initialize() async {
    changeLoading();
    var app = Provider.of<AppState>(context, listen: false);
    defaultTransactions = filteredTransactions = app.user!.transactions;
    changeLoading();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Harcamalar"),
        actions: [
          IconButton(
              onPressed: () async => await filterFunction(context),
              icon: const Icon(CupertinoIcons.slider_horizontal_3))
        ],
      ),
      body: Consumer<AppState>(
        builder: (context, app, child) {
          filteredTransactions = filterTransactions();
          return Column(
            children: [
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () => setState(() => index = 1),
                    style: index == 1
                        ? orangeBGTextButtonTheme
                        : greyTextButtonTheme,
                    child: const Text("Tüm İşlemler"),
                  ),
                  TextButton(
                    onPressed: () => setState(() => index = 2),
                    style: index == 2
                        ? orangeBGTextButtonTheme
                        : greyTextButtonTheme,
                    child: const Text("Gelir"),
                  ),
                  TextButton(
                    onPressed: () => setState(() => index = 3),
                    style: index == 3
                        ? orangeBGTextButtonTheme
                        : greyTextButtonTheme,
                    child: const Text("Gider"),
                  )
                ],
              ),
              Expanded(
                child: (filteredTransactions == null ||
                        filteredTransactions.isEmpty)
                    ? const Center(
                        child: Text("Harcamanız bulunmuyor."),
                      )
                    : ListView.separated(
                        padding:
                            const EdgeInsets.only(left: 20, right: 20, top: 24),
                        itemCount: filteredTransactions.length,
                        shrinkWrap: true,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (BuildContext context, int index) {
                          var transaction = filteredTransactions[index];
                          return buildTransactionCard(transaction);
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<dynamic> filterFunction(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(28.0),
          child: SizedBox(
            height: 250,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    "Filtrele",
                    style: PersonalTStyles.w600s20B,
                  ),
                  const SizedBox(height: 28),
                  GestureDetector(
                    onTap: () {
                      setState(
                        () => sortValue = SortEnums.all,
                      );

                      Navigator.pop(context);
                    },
                    child: buildSortingRow(
                      value: SortEnums.all,
                      sortValue: sortValue,
                    ),
                  ),
                  const Divider(),
                  GestureDetector(
                    onTap: () {
                      setState(
                        () => sortValue = SortEnums.thisWeek,
                      );

                      Navigator.pop(context);
                    },
                    child: buildSortingRow(
                      value: SortEnums.thisWeek,
                      sortValue: sortValue,
                    ),
                  ),
                  const Divider(),
                  GestureDetector(
                    onTap: () {
                      setState(
                        () => sortValue = SortEnums.thisMonth,
                      );

                      Navigator.pop(context);
                    },
                    child: buildSortingRow(
                        value: SortEnums.thisMonth, sortValue: sortValue),
                  ),
                  const Divider(),
                  GestureDetector(
                    onTap: () {
                      setState(
                        () => sortValue = SortEnums.lastThreeMonths,
                      );

                      Navigator.pop(context);
                    },
                    child: buildSortingRow(
                        value: SortEnums.lastThreeMonths, sortValue: sortValue),
                  ),
                  const Divider(),
                  GestureDetector(
                    onTap: () {
                      setState(
                        () => sortValue = SortEnums.thisYear,
                      );

                      Navigator.pop(context);
                    },
                    child: buildSortingRow(
                        value: SortEnums.thisYear, sortValue: sortValue),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  filterTransactions() {
    if (defaultTransactions is List<TransactionModel>) {
      final date = DateTime.now();
      if (index == 1) {
        return filterBySorting(date, defaultTransactions);
      } else if (index == 2) {
        return filterBySorting(
            date,
            (defaultTransactions as List<TransactionModel>)
                .where((element) => element.isExpense == false)
                .toList());
      } else {
        return filterBySorting(
            date,
            (defaultTransactions as List<TransactionModel>)
                .where((element) => element.isExpense == true)
                .toList());
      }
    } else {
      return defaultTransactions;
    }
  }

  filterBySorting(DateTime date, List<TransactionModel> defaultTransactions) {
    if (sortValue == SortEnums.all) {
      return defaultTransactions;
    } else if (sortValue == SortEnums.thisWeek) {
      return (defaultTransactions)
          .where((element) =>
              DateTime.fromMillisecondsSinceEpoch(element.date)
                  .compareTo(date.subtract(Duration(days: date.weekday - 1))) >=
              0)
          .toList();
    } else if (sortValue == SortEnums.thisMonth) {
      return (defaultTransactions)
          .where((element) =>
              ((DateTime.fromMillisecondsSinceEpoch(element.date).month ==
                      date.month) &&
                  (DateTime.fromMillisecondsSinceEpoch(element.date).year ==
                      date.year)))
          .toList();
    } else if (sortValue == SortEnums.lastThreeMonths) {
      return (defaultTransactions)
          .where((element) =>
              ((DateTime.fromMillisecondsSinceEpoch(element.date).year ==
                      date.year) &&
                  DateTime.fromMillisecondsSinceEpoch(element.date).month >=
                      date.month - 3))
          .toList();
    } else {
      return (defaultTransactions)
          .where((element) =>
              (DateTime.fromMillisecondsSinceEpoch(element.date).year ==
                  date.year))
          .toList();
    }
  }
}
