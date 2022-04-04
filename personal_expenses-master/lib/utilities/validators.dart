import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

String? validateMobile(String? value) {
  bool isParsable = value != null ? numParsable(value) : false;
  if (value == null || value.length != 10 || !isParsable) {
    return 'Tel. No 10 haneli olmalıdır.';
  } else {
    return null;
  }
}

String? validatePrice(String? value) {
  if (value != null) {
    value = value.replaceAll(",", ".");
  }
  bool isParsable = value != null ? numParsable(value) : false;
  if (value == null || !isParsable) {
    return 'Geçerli bir fiyat giriniz.';
  } else {
    return null;
  }
}

String? validateEmptiness(String? value) {
  if (value != null && value.trim().isNotEmpty) {
    return null;
  } else {
    return 'Bu alan boş bırakılamaz.';
  }
}

String? validatePassword(String? value) {
  if (value != null && value.trim().length >= 7) {
    return null;
  } else {
    return 'Şifreniz en az 7 karakter uzunluğunda olmalıdır.';
  }
}

String? validatePassCheck(String? value, TextEditingController ctr) {
  if (value != null && value.isNotEmpty && ctr.text.trim() == value.trim()) {
    return null;
  } else {
    return "Şifreler Eşleşmiyor.";
  }
}

String? validateMail(String? value) {
  if (value != null && EmailValidator.validate(value.trim())) {
    return null;
  } else {
    return "Geçerli bir e-posta adresi giriniz.";
  }
}

numParsable(String v) {
  var number = num.tryParse(v);
  return (number is num);
}
