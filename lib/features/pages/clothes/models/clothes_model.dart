class ClothesModel {
  final String quantity;
  final bool ropaDiaria;
  final bool ropaDelicada;
  final bool blancos;
  final bool ropaTrabajo;
  final String note;

  const ClothesModel({
    this.quantity = "Poca",
    this.ropaDiaria = true,
    this.ropaDelicada = true,
    this.blancos = true,
    this.ropaTrabajo = false,
    this.note = "",
  });

  ClothesModel copyWith({
    String? quantity,
    bool? ropaDiaria,
    bool? ropaDelicada,
    bool? blancos,
    bool? ropaTrabajo,
    String? note,
  }) {
    return ClothesModel(
      quantity: quantity ?? this.quantity,
      ropaDiaria: ropaDiaria ?? this.ropaDiaria,
      ropaDelicada: ropaDelicada ?? this.ropaDelicada,
      blancos: blancos ?? this.blancos,
      ropaTrabajo: ropaTrabajo ?? this.ropaTrabajo,
      note: note ?? this.note,
    );
  }
}
