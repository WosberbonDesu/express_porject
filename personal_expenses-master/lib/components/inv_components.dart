import 'package:flutter/material.dart';
import '../constants/enums/sort_enums.dart';
import '../constants/styles/colors.dart';
import '../constants/styles/text_styles.dart';

Row buildGraphLegend() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Row(
        children: [
          Container(
            height: 10,
            width: 10,
            decoration: const BoxDecoration(
                shape: BoxShape.circle, color: PersonalColors.blue),
          ),
          const SizedBox(width: 8),
          const Text("Gelir")
        ],
      ),
      const SizedBox(width: 16),
      Row(
        children: [
          Container(
            height: 10,
            width: 10,
            decoration: const BoxDecoration(
                shape: BoxShape.circle, color: PersonalColors.orange),
          ),
          const SizedBox(width: 8),
          const Text("Gider")
        ],
      )
    ],
  );
}

Expanded buildCardRowElement(
    {required String title, required num price, required bool isExpense}) {
  return Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: PersonalTStyles.w500s12G1,
          ),
          Text(
            (isExpense ? "-" : "+") +
                " ${price.toStringAsFixed(2).replaceAll(".", ",")} ₺",
            style: isExpense
                ? PersonalTStyles.w600s14SR
                : PersonalTStyles.w600s14G,
          )
        ],
      ),
    ),
  );
}

Row buildSortingRow({required SortEnums value, required SortEnums sortValue}) {
  return Row(
    children: [
      Radio(
        value: value,
        groupValue: sortValue,
        activeColor: PersonalColors.orange,
        onChanged: (i) {},
      ),
      Text(value.rawValue),
    ],
  );
}
