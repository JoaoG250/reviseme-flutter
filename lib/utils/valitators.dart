requiredValidator(String? value, [String? fieldName]) {
  if (value == null || value.isEmpty) {
    if (fieldName != null) {
      return '$fieldName is required';
    }
    return 'This field is required';
  }
  return null;
}

urlValidator(String? url, [String? fieldName]) {
  if (url == null || url.isEmpty) {
    if (fieldName != null) {
      return '$fieldName is required';
    }
    return 'This field is required';
  }

  final valid = Uri.tryParse(url)?.hasAbsolutePath ?? false;
  if (!valid) {
    return 'Please enter a valid url';
  }
  return null;
}
