requiredValidator(String? value, String? fieldName) {
  if (value == null || value.isEmpty) {
    if (fieldName != null) {
      return '$fieldName is required';
    }
    return 'This field is required';
  }
  return null;
}
