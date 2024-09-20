import 'package:equipo5/main.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../services/firestore_service.dart';
import '../components/multi_componentes.dart';
import '../models/activity.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddManten extends StatefulWidget {
  const AddManten({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddMantenState createState() => _AddMantenState();
}

class _AddMantenState extends State<AddManten> {
  final ActivityService _activityService = ActivityService();
  final User? user = FirebaseAuth.instance.currentUser;
  final _formKey = GlobalKey<FormState>();
  String _title = "";
  String _description = "";
  DateTime? _selectedDate;
  DateTime? _nextReminder;
  String _category = "";
  final Map<String, String> categoryIcons = {
    'motor': 'assets/icons/motor.png',
    'neumatico': 'assets/icons/tire.png',
    'aceite': 'assets/icons/engine.png',
    'frenos': 'assets/icons/brake.png',
  };

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectNextReminder(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _nextReminder ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _nextReminder = picked;
      });
    }
  }

  Future<void> _addNewMantinience() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final Activity newActivity = Activity(
        id: uuid.v4(),
        userId: user?.uid ?? '',
        name: _title,
        description: _description,
        category: _category,
        rating: 0,
        price: 0,
        startTimes: 0,
        lastPerformed: _selectedDate!,
        nextReminder: _nextReminder!,
        location: [],
        tags: [],
      );
      await _activityService.addUserActivity(newActivity);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarMenuOthers(
        title: 'Nuevo Mantenimiento',
      ),
      drawer: DrawerMenu(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(1.0),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Título'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Ingrese un título';
                    }
                    return null;
                  },
                  onSaved: (value) => _title = value!,
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Descripción'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Ingrese una descripción';
                    }
                    return null;
                  },
                  onSaved: (value) => _description = value!,
                ),
                const SizedBox(height: 20.0),
                _buildDateSelector(
                  label: "Último mantenimiento",
                  date: _selectedDate,
                  onTap: () => _selectDate(context),
                  color: Colors.blueAccent,
                ),
                const SizedBox(height: 20.0),
                _buildDateSelector(
                  label: "Próximo mantenimiento",
                  date: _nextReminder,
                  onTap: () => _selectNextReminder(context),
                  color: Colors.greenAccent,
                ),
                const SizedBox(height: 20.0),
                DropdownButtonFormField<String>(
                  value: _category.isEmpty ? null : _category,
                  decoration: const InputDecoration(labelText: 'Categoría'),
                  items: categoryIcons.keys.map((String key) {
                    return DropdownMenuItem<String>(
                      value: key,
                      child: Row(
                        children: [
                          Image.asset(
                            categoryIcons[key]!,
                            width: 24,
                            height: 24,
                          ),
                          const SizedBox(width: 10),
                          Text(key),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _category = newValue!;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Seleccione una categoría';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30.0),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      await _addNewMantinience();
                      // ignore: use_build_context_synchronously
                      context.goNamed('home');
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      'Guardar',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDateSelector({
    required String label,
    required DateTime? date,
    required Function() onTap,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blueGrey,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  color: Colors.blueGrey,
                ),
                const SizedBox(width: 10),
                Text(
                  date != null
                      ? DateFormat('dd/MM/yyyy').format(date)
                      : 'Seleccione fecha',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.blueGrey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
