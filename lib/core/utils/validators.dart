class Validators {
  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Số điện thoại không được để trống'; // "Phone number cannot be empty"
    }
    if (!RegExp(r'^\d{10,11}$').hasMatch(value)) {
      return 'Số điện thoại không hợp lệ'; // "Invalid phone number"
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập email';
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Email không hợp lệ';
    }

    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Mật khẩu không được để trống'; // "Password cannot be empty"
    }
    if (value.length < 6) {
      return 'Mật khẩu phải có ít nhất 6 ký tự'; // "Password must be at least 6 characters"
    }
    return null;
  }
}
