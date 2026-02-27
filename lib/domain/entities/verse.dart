import 'package:equatable/equatable.dart';

/// Entidad de dominio: Versículo bíblico
class Verse extends Equatable {
  final String id;
  final String book;
  final int chapter;
  final int verse;
  final String text;
  final String translation;
  
  const Verse({
    required this.id,
    required this.book,
    required this.chapter,
    required this.verse,
    required this.text,
    required this.translation,
  });
  
  /// Referencia formateada (ej: "Juan 3:16")
  String get reference => '$book $chapter:$verse';
  
  @override
  List<Object?> get props => [id, book, chapter, verse, text, translation];
}
