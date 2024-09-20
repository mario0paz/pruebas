import 'package:cloud_firestore/cloud_firestore.dart';

class Activity {
  final String id;
  final String userId;
  String name;
  String description;
  final String category;
  final int rating;
  final int price;
  final int startTimes;
  final DateTime lastPerformed;
  final DateTime nextReminder;
  final List<String> location;
  final List<String> tags;
  final bool? isPending;

  Activity({
    required this.id,
    required this.userId,
    required this.name,
    required this.description,
    required this.category,
    required this.rating,
    required this.price,
    required this.startTimes,
    required this.lastPerformed,
    required this.nextReminder,
    required this.location,
    required this.tags,
    this.isPending = true,
  });

  // Conversión de JSON para Firestore
  Activity.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        userId = json['userId'],
        name = json['name'],
        description = json['description'],
        category = json['category'],
        rating = json['rating'],
        price = json['price'],
        startTimes = json['startTimes'],
        lastPerformed = (json['lastPerformed'] as Timestamp).toDate(),
        nextReminder = (json['nextReminder'] as Timestamp).toDate(),
        location = List<String>.from(json['location']),
        tags = List<String>.from(json['tags']),
        isPending = json['isPending'] ?? true;

  // Método para convertir el objeto Activity en un Map (para guardarlo en Firestore)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'description': description,
      'category': category,
      'rating': rating,
      'price': price,
      'startTimes': startTimes,
      'lastPerformed': Timestamp.fromDate(lastPerformed),
      'nextReminder': Timestamp.fromDate(nextReminder),
      'location': location,
      'tags': tags,
      'isPending': isPending,
    };
  }

  factory Activity.empty() {
    return Activity(
      id: '',
      userId: '',
      category: '',
      tags: [],
      location: [],
      price: 0,
      rating: 0,
      startTimes: 0,
      name: 'Cargando...',
      description: '',
      lastPerformed:
          DateTime.now(), // Puedes usar un valor predeterminado o nulo
      nextReminder: DateTime.now(), // Lo mismo aquí
    );
  }
  Activity copyWith({
    String? id,
    String? userId,
    String? name,
    String? description,
    String? category,
    int? rating,
    int? price,
    int? startTimes,
    DateTime? lastPerformed,
    DateTime? nextReminder,
    List<String>? location,
    List<String>? tags,
  }) {
    return Activity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      rating: rating ?? this.rating,
      price: price ?? this.price,
      startTimes: startTimes ?? this.startTimes,
      lastPerformed: lastPerformed ?? this.lastPerformed,
      nextReminder: nextReminder ?? this.nextReminder,
      location: location ?? this.location,
      tags: tags ?? this.tags,
    );
  }
}
