enum WasteCategory {
  eWaste('E-Waste', 'Electronics & Gadgets', 0xFF8B5CF6, 0xFFEDE9FE),
  plastic('Plastic', 'Bottles, Containers & Films', 0xFF0EA5E9, 0xFFE0F2FE),
  metal('Metal', 'Iron, Aluminium & Copper', 0xFFF59E0B, 0xFFFEF3C7),
  paper('Paper', 'Books, Cartons & Cardboard', 0xFF10B981, 0xFFD1FAE5),
  glass('Glass', 'Bottles & Jars', 0xFF14B8A6, 0xFFCCFBF1),
  organic('Organic', 'Compost & Bio-waste', 0xFF84CC16, 0xFFECFCCB),
  textile('Textile', 'Clothes & Fabrics', 0xFFEC4899, 0xFFFCE7F3),
  upcycled('Upcycled', 'Crafts & Repurposed Goods', 0xFF6366F1, 0xFFEEF2FF);

  final String label;
  final String description;
  final int colorValue;
  final int bgValue;

  const WasteCategory(this.label, this.description, this.colorValue, this.bgValue);
}

enum RecyclabilityStatus {
  highlyRecyclable('Highly Recyclable', 0xFF10B981),
  partiallyRecyclable('Partially Recyclable', 0xFFF59E0B),
  hazardous('Hazardous / Special Handling', 0xFFEF4444),
  compostable('Biodegradable / Compostable', 0xFF84CC16);

  final String label;
  final int colorValue;
  const RecyclabilityStatus(this.label, this.colorValue);
}
