class AuthValidate {
  validatorUser({dynamic value, int? status, bool isEnter = false}) {
    if (value!.isEmpty) {
      return isEnter ? "Re-enter  username" : "Please enter  username";
    }
    if (status != 200) {
      return "Please check username";
    }
    return null;
  }

  vadilatorPassword({dynamic value, int? status, bool isEnter = false}) {
    if (value!.isEmpty) {
      return isEnter ? "Re-enter password" : "Please enter  password";
    }
    if (status != 200) {
      return "Wrong username or passsword";
    }
    return null;
  }

  vadilatorPasswordRegister(
      {dynamic value,
      int? status,
      bool isEnter = false,
      String? errormessage}) {
    print(status.toString());
    if (value!.isEmpty) {
      return isEnter ? "Re-enter password" : "Please enter  password";
    }
    if (status != 200) {
      return errormessage;
    }
    return null;
  }

  // vadilatorPhone({dynamic value, int? status, bool isEnter = false}) {
  //   RegExp _phone = RegExp(r'(^(?:[+0]9)?[0-9]{8,12}$)');
  //   if (value!.isEmpty) {
  //     return isEnter ? "Re-enter phone number" : "Please enter phone number";
  //   }
  //   if (!_phone.hasMatch(value)) {
  //     return "Please enter new phone number valid phone number";
  //   }
  //   // if (status != 200) {
  //   //   return "Please check your phone";
  //   // }
  //   return null;
  // }

  vadilatorEmail({dynamic value, int? status, bool isEnter = false}) {
    RegExp _email = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    if (value!.isEmpty) {
      return isEnter ? "Re-enter email" : "Please enter email";
    }
    if (!_email.hasMatch(value)) {
      return "Invail email address";
    }
    return null;
  }

  validatorName(dynamic value, bool isEnter) {
    RegExp _name = RegExp('^[a-zA-Z]');
    if (value!.isEmpty) {
      return isEnter ? "Re-enter name" : "Please Enter name";
    } else if (!_name.hasMatch(value)) {
      return "Name must be character";
    } else {
      return null;
    }
  }

  validatorCode(dynamic value, int status, bool isEnter) {
    if (value!.isEmpty) {
      return isEnter ? "Re-enter code" : "Please enter code";
    }
    if (value!.length > 6) {
      return "Code has only six digit";
    }
    if (value!.length < 6) {
      return "Code has six digit";
    }
    if (status != 200) {
      return "Wrong code";
    }
    return null;
  }

  validatorDate(dynamic value) {
    if (value.isEmpty) {
      return "Please pick date";
    }
    return null;
  }

  validatorUserRe({dynamic value, bool isEnter = false}) {
    if (value!.isEmpty) {
      return isEnter ? "Re-enter  username" : "Please enter  username";
    }
    return null;
  }
}
