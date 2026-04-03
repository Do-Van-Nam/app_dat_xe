class CartItem {
  const CartItem({
    required this.id,
    required this.name,
    required this.description,
    required this.unitPrice,
    required this.quantity,
    this.imageUrl,
  });

  final String id;
  final String name;
  final String description;
  final int unitPrice;   // in VND
  final int quantity;
  final String? imageUrl;

  int get total => unitPrice * quantity;

  CartItem copyWith({int? quantity}) => CartItem(
        id: id,
        name: name,
        description: description,
        unitPrice: unitPrice,
        quantity: quantity ?? this.quantity,
        imageUrl: imageUrl,
      );
}
