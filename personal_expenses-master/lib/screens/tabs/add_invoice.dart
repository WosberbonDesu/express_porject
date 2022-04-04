import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../components/main_components.dart';
import '../../constants/styles/colors.dart';
import '../../constants/styles/text_styles.dart';
import '../../constants/styles/themes.dart';
import '../../models/category_model.dart';
import '../../providers/appstate.dart';
import '../../utilities/routes.dart';

import '../../utilities/snackbar.dart';
import 'package:provider/provider.dart';

class AddInvoice extends StatefulWidget {
  const AddInvoice({
    Key? key,
    required this.backgroundColor,
    required this.title,
    required this.isExpense,
  }) : super(key: key);

  final Color backgroundColor;
  final String title;
  final bool isExpense;

  @override
  _AddInvoiceState createState() => _AddInvoiceState();
}

class _AddInvoiceState extends State<AddInvoice> {
  int intValue = 0;
  int decimalValue = 00;
  DateTime transactionDate = DateTime.now();
  bool switchDesimal = false;
  bool isLoading = false;
  changeLoading() => setState(() => isLoading = !isLoading);
  bool isSending = false;
  changeSendLoading() => setState(() => isSending = !isSending);
  List<CategoryModel> categories = [];
  CategoryModel? selectedCategory;
  @override
  void initState() {
    initialize();
    super.initState();
  }

  initialize() async {
    changeLoading();
    var app = Provider.of<AppState>(context, listen: false);

    categories = app.categories!
        .where((element) => element.isExpense == widget.isExpense)
        .toList();
    changeLoading();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: widget.backgroundColor,
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: isLoading
          ? buildCircularProgress()
          : Consumer<AppState>(
              builder: (context, app, child) => SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                        height: app.queryHeight * 0.3,
                        child: Container(
                          color: widget.backgroundColor,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text("₺ Cinsinden Harcamanız:",
                                      style: PersonalTStyles.w400s14W)
                                ],
                              ),
                              Text(
                                "$intValue" "." "$decimalValue" " ₺",
                                style: PersonalTStyles.w600s32W,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                width: 300,
                                height: 75,
                                child: CupertinoTheme(
                                  data: const CupertinoThemeData(
                                      textTheme: CupertinoTextThemeData(
                                          dateTimePickerTextStyle:
                                              PersonalTStyles.w600s24W)),
                                  child: CupertinoDatePicker(
                                    minimumYear: DateTime.now().year - 1,
                                    maximumYear: DateTime.now().year + 1,
                                    mode: CupertinoDatePickerMode.date,
                                    onDateTimeChanged: (value) =>
                                        setState(() => transactionDate = value),
                                    initialDateTime: transactionDate,
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(
                                    left: 24, bottom: 24, right: 24),
                                height: 40,
                                width: app.queryWidth,
                                child: ListView.separated(
                                  itemCount: categories.length,
                                  shrinkWrap: true,
                                  separatorBuilder:
                                      (BuildContext context, int index) =>
                                          const SizedBox(
                                    width: 12,
                                  ),
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder:
                                      (BuildContext context, int index) =>
                                          tagItem(
                                    category: categories[index],
                                    onTap: () => setState(() =>
                                        selectedCategory = categories[index]),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                    SizedBox(
                        height: app.queryHeight * 0.6,
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 16,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                NumpadItem(
                                  numpadValue: "1",
                                  onPressed: () => writeNumber("1"),
                                ),
                                NumpadItem(
                                  numpadValue: "2",
                                  onPressed: () => writeNumber("2"),
                                ),
                                NumpadItem(
                                  numpadValue: "3",
                                  onPressed: () => writeNumber("3"),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                NumpadItem(
                                  numpadValue: "4",
                                  onPressed: () => writeNumber("4"),
                                ),
                                NumpadItem(
                                  numpadValue: "5",
                                  onPressed: () => writeNumber("5"),
                                ),
                                NumpadItem(
                                  numpadValue: "6",
                                  onPressed: () => writeNumber("6"),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                NumpadItem(
                                  numpadValue: "7",
                                  onPressed: () => writeNumber("7"),
                                ),
                                NumpadItem(
                                  numpadValue: "8",
                                  onPressed: () => writeNumber("8"),
                                ),
                                NumpadItem(
                                  numpadValue: "9",
                                  onPressed: () => writeNumber("9"),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                    margin: const EdgeInsets.all(16),
                                    width: 64,
                                    height: 64,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: const Color(0xFFD7D7D7)),
                                        borderRadius:
                                            BorderRadius.circular(16)),
                                    child: InkWell(
                                      onTap: () => setState(
                                          () => switchDesimal = !switchDesimal),
                                      child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          child: const Center(
                                            child: Text(","),
                                          )),
                                    )),
                                NumpadItem(
                                  numpadValue: "0",
                                  onPressed: () => writeNumber("0"),
                                ),
                                Container(
                                    margin: const EdgeInsets.all(16),
                                    width: 64,
                                    height: 64,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: const Color(0xFFD7D7D7)),
                                        borderRadius:
                                            BorderRadius.circular(16)),
                                    child: InkWell(
                                      onTap: () {
                                        onBackspaceTapped();
                                      },
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(16),
                                        child: const Center(
                                            child: Icon(Icons.backspace)),
                                      ),
                                    ))
                              ],
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            isSending
                                ? CircularProgressIndicator(
                                    color: widget.backgroundColor,
                                  )
                                : SizedBox(
                                    width: app.queryWidth - 40,
                                    child: TextButton(
                                      onPressed: selectedCategory == null
                                          ? () => showSnackBar(
                                              context, "Kategori Seçiniz.",
                                              backgroundColor:
                                                  PersonalColors.red)
                                          : () async {
                                              if (decimalValue
                                                      .toString()
                                                      .length ==
                                                  1) {
                                                decimalValue = int.parse(
                                                    decimalValue.toString() +
                                                        "0");
                                              }
                                              changeSendLoading();
                                              await app.addTransaction(
                                                  intValue +
                                                      (decimalValue / 100),
                                                  selectedCategory!.type,
                                                  transactionDate);
                                              changeSendLoading();
                                              navigatePop(context);
                                            },
                                      child: Text(widget.title),
                                      style: widget.backgroundColor ==
                                              PersonalColors.orange
                                          ? secondaryTextButtonTheme
                                          : softRedTextButtonTheme,
                                    ),
                                  ),
                          ],
                        ))
                  ],
                ),
              ),
            ),
    );
  }

  void onBackspaceTapped() {
    setState(() {
      if (switchDesimal == false) {
        if (intValue.toString().length == 1) {
          intValue = 0;
        } else {
          final String intValueString;
          intValueString =
              intValue.toString().substring(0, intValue.toString().length - 1);
          intValue = int.parse(intValueString);
        }
      } else {
        if (decimalValue.toString().length == 1) {
          decimalValue = 0;
          switchDesimal = false;
        } else {
          final String decimalValueString;
          decimalValueString = decimalValue
              .toString()
              .substring(0, decimalValue.toString().length - 1);
          decimalValue = int.parse(decimalValueString);
        }
      }
    });
  }

  void writeNumber(String selectedNumber) {
    setState(() {
      if (switchDesimal == false) {
        intValue = int.parse(intValue.toString() + selectedNumber);
      } else {
        if (decimalValue.toString().length < 2) {
          decimalValue = int.parse(decimalValue.toString() + selectedNumber);
        }
      }
    });
  }

  tagItem({required CategoryModel category, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
            color: selectedCategory == category
                ? Colors.white
                : const Color(0x1AFFFFFF),
            borderRadius: BorderRadius.circular(100)),
        child: Center(
          child: Text(category.title,
              style: selectedCategory == category
                  ? PersonalTStyles.w600s14Or
                      .copyWith(color: widget.backgroundColor)
                  : PersonalTStyles.w600s14W),
        ),
      ),
    );
  }
}

class NumpadItem extends StatelessWidget {
  final Function() onPressed;
  final String numpadValue;
  const NumpadItem({
    Key? key,
    required this.onPressed,
    required this.numpadValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(16),
        width: 64,
        height: 64,
        decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFD7D7D7)),
            borderRadius: BorderRadius.circular(16)),
        child: InkWell(
          onTap: onPressed,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Center(
              child: Text(numpadValue),
            ),
          ),
        ));
  }
}
