String? emailValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Email is required';
  }
  final emailRegex = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  if (!emailRegex.hasMatch(value)) {
    return 'Enter a valid email';
  }
  return null;
}

String? passwordValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Password is required';
  }

  // ignore: unused_local_variable
  final passwordRegex =
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');

  if (value.length < 8) {
    return 'Password must be at least 8 characters long';
  }

  if (!RegExp(r'(?=.*?[A-Z])').hasMatch(value)) {
    return 'Password must contain at least one uppercase letter';
  }

  if (!RegExp(r'(?=.*?[a-z])').hasMatch(value)) {
    return 'Password must contain at least one lowercase letter';
  }

  if (!RegExp(r'(?=.*?[0-9])').hasMatch(value)) {
    return 'Password must contain at least one digit';
  }

  if (!RegExp(r'(?=.*?[!@#\$&*~])').hasMatch(value)) {
    return 'Password must contain at least one special character';
  }

  return null;
}

String? confirmPasswordValidator(
    String? confirmPassword, String originalPassword) {
  if (confirmPassword == null || confirmPassword.isEmpty) {
    return 'Confirm password is required';
  }

  if (confirmPassword != originalPassword) {
    return 'Passwords do not match';
  }

  return null;
}

String? phoneNumberValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Phone number is required';
  }
  final phoneRegExp = RegExp(r'^\d{10,15}$');
  if (!phoneRegExp.hasMatch(value)) {
    return 'Phone number must be between 10 and 15 digits';
  }
  return null;
}

String? nameValidator(String? value,String itemName) {
  if (value == null || value.isEmpty) {
    return '$itemName is required';
  }
  final nameRegExp = RegExp(r'^[a-zA-Z\s]+$');
  if (!nameRegExp.hasMatch(value)) {
    return 'Name must contain only letters and spaces';
  }
  return null;
}

String? dropdownValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please select a role';
  }
  return null;
}

String? otpValidator(String? value) {
  if (value == null || value.isEmpty) {
    return "Please enter OTP";
  } else if (value.length < 4) { // Assuming a 4-digit OTP
    return "OTP must be 4 digits";
  } else if (!RegExp(r'^\d{4}$').hasMatch(value)) {
    return "Invalid OTP format";
  }
  return null; // Valid OTP
}
