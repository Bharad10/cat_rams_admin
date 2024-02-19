mobileNumberValidation(value, context) {
  String pattern = r'(^(?:[+0]9)?[0-9]{8,12}$)';
  RegExp regExp = new RegExp(pattern);
  if (value.length == 0) {
    return "Enter valid mobile number";
  } else if (value.length < 10) {
    return "Enter valid mobile number";
  } else if (!regExp.hasMatch(value)) {
    return "Enter valid mobile number";
  }
  return null;
}

addressValidation(value, context) {
  String pattern = r'(^[A-Za-z0-9 _-:/\]+$)';
  RegExp regExp = new RegExp(pattern);
  if (value.length == 0) {
    return "Enter valid address";
  } else if (!regExp.hasMatch(value)) {
    return "Enter valid address";
  }
  return null;
}

fullNameValidation(value, context) {
  String pattern = r'^[A-Za-z -]+$';
  RegExp regExp = new RegExp(pattern);
  if (value.length == 0) {
    return "Enter valid name";
  } else if (!regExp.hasMatch(value)) {
    return "Enter valid name";
  }
  return null;
}

emailValidation(value, context) {
  String pattern =
      r'^[a-zA-Z0-9]+(\.[a-zA-Z0-9]+)*@[a-zA-Z0-9]+(\.[a-zA-Z0-9]+)+$';
  RegExp regExp = new RegExp(pattern);
  if (value.length == 0) {
    return "Enter valid email";
  } else if (!regExp.hasMatch(value)) {
    return "Enter valid email";
  }
  return null;
}

passwordValidation(value, context) {
  if (value.length == 0) {
    return "Enter valid password";
  }
  return null;
}
