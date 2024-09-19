import 'package:cloud_firestore/cloud_firestore.dart';

class Activity {
  final String id;
  final String userId;
  final String name;
  final String description;
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
}
