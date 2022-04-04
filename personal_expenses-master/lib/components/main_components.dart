import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import '../constants/styles/colors.dart';
import '../constants/styles/text_styles.dart';
import '../models/transaction_model.dart';

TextFormField buildTextField({
  required String? Function(String?) validator,
  required TextEditingController controller,
  required String text,
  Function(String)? onChanged,
  bool isObscure = false,
  bool isPhoneNumber = false,
}) {
  return TextFormField(
    obscureText: isObscure,
    validator: validator,
    controller: controller,
    onChanged: onChanged,
    keyboardType: isPhoneNumber ? TextInputType.number : null,
    decoration: InputDecoration(
      hintText: text,
      labelText: text,
    ),
  );
}

Widget buildCircularProgress({bool isPP = false}) {
  return Center(
    child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(
          isPP ? Colors.white : PersonalColors.blue),
    ),
  );
}

buildTransactionCard(TransactionModel transaction) {
  return Row(
    children: [
      SvgPicture.network(
        transaction.iconUrl,
        placeholderBuilder: (context) => buildCircularProgress(),
      ),
      const SizedBox(width: 20),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              transaction.title,
              style: PersonalTStyles.w600s14B,
            ),
            const SizedBox(height: 5),
            Text(
              DateFormat("dd MMMM yyyy", "tr").format(
                  DateTime.fromMillisecondsSinceEpoch(transaction.date)),
              style: PersonalTStyles.w400s12G1,
            ),
          ],
        ),
      ),
      const SizedBox(width: 20),
      Text(
        (transaction.isExpense ? "-" : "+") +
            " ${transaction.price.toDouble().toStringAsFixed(2).replaceAll(".", ",")} ₺",
        style: transaction.isExpense
            ? PersonalTStyles.w600s16B
            : PersonalTStyles.w600s16G,
      ),
    ],
  );
}
