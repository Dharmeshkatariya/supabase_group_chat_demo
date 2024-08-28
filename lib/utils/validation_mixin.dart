mixin AuthValidationMixin {
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your email";
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!emailRegex.hasMatch(value)) {
      return "Please enter valid email";
    }

    return null;
  }

  String? validateCounty(String? value) {
    if (value == null || value.isEmpty) {
      return "Please select county";
    }
    return null;
  }

  String? validateFirstName(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your firstname";
    }
    return null;
  }

  String? validateLastName(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your lastname";
    }
    return null;
  }

  String? validatePass(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter a password";
    }
    if (value.length < 8) {
      return "Password must be at least 8 characters long";
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return "Password must contain at least one digit";
    }
    return null;
  }
}
