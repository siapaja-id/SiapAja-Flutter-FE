int parsePrice(String price) {
  return int.tryParse(price.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
}
