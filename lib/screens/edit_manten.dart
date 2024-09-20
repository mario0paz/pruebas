import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../components/multi_componentes.dart';
import '../models/activity.dart';
import '../services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

class EditManten extends StatefulWidget {
  final String id;

  const EditManten({super.key, required this.id});

  @override
  // ignore: library_private_types_in_public_api
  _EditMantenState createState() => _EditMantenState();
}

class _EditMantenState extends State<EditManten> {
  final ActivityService _activityService = ActivityService();
  late Activity activity =
      Activity.empty(); // Inicializa con un valor predeterminado
  final User? user = FirebaseAuth.instance.currentUser;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = true; // Indicador de carga

  String _title = '';
  String _description = '';
  DateTime? _selectedDate;
  DateTime? _nextReminder;
  String _category = '';

  final Map<String, String> categoryIcons = {
    'motor': 'assets/icons/motor.png',
    'neumatico': 'assets/icons/tire.png',
    'aceite': 'assets/icons/engine.png',
    'frenos': 'assets/icons/brake.png',
  };

  @override
  void initState() {
    super.initState();
    _loadActivities();
  }

  void _loadActivities() {
    _activityService.getUserActivityById(widget.id).then((value) {
      setState(() {
        if (value != null) {
          activity = value;
          _title = activity.name;
          _description = activity.description;
          _selectedDate = activity.lastPerformed;
          _nextReminder = activity.nextReminder;
          _category = activity.category.isNotEmpty
              ? activity.category
              : categoryIcons.keys.first;
        } else {
          context.goNamed('home');
        }
        _isLoading = false;
      });
    });
  }

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

  Future<void> _updateActivity() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final Activity updatedActivity = activity.copyWith(
        name: _title,
        description: _description,
        category: _category,
        lastPerformed: _selectedDate!,
        nextReminder: _nextReminder!,
      );
      await _activityService.updateUserActivity(updatedActivity);
      // ignore: use_build_context_synchronously
      context.goNamed('home');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBarMenu(
          title: activity.name,
        ),
        drawer: DrawerMenu(),
        body: const Center(
            child: CircularProgressIndicator()), // Indicador de carga
      );
    }

    return Scaffold(
      appBar: AppBarMenu(
        title: 'Editar ${activity.name}',
      ),
      drawer: DrawerMenu(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                initialValue: _title.isEmpty ? 'Pendiente...' : _title,
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
                initialValue:
                    _description.isEmpty ? 'Pendiente...' : _description,
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
                value: _category.isNotEmpty ? _category : null,
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
                    _category = newValue ?? '';
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
                  onPressed: _updateActivity,
                  child: const Text('Guardar'),
                ),
              ),
            ],
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
        Text(label, style: const TextStyle(fontSize: 18)),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today),
                const SizedBox(width: 10),
                Text(
                  date != null
                      ? DateFormat('dd/MM/yyyy').format(date)
                      : 'Seleccione fecha',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
