class ExpenseCategoryModel {
  final int id;
  final String nombre;

  ExpenseCategoryModel({
    required this.id,
    required this.nombre,
  });

  factory ExpenseCategoryModel.fromJson(Map<String, dynamic> json) {
    return ExpenseCategoryModel(
      id: json['id'],
      nombre: json['nombre'],
    );
  }
}