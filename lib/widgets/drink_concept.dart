
final drinks = List.generate(
    _names.length,
    (index) => Drink(
        image: 'assets/${index + 1}.png',
        name: _names[index],
        price: _prices[index]));
class Drink {
  Drink({
    required this.name,
    required this.image,
    required this.price,
  });
  final String name, image;
  final String price;
}

final _names = ["Coca cola", "Pepsi", "Sprite", "Fanta"];
final _prices = ["12", "13", "14", "20"];
