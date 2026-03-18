import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../providers/group_provider.dart';
import '../../auth/providers/auth_provider.dart';
import '../../activity/providers/activity_provider.dart';
import '../../notifications/providers/notification_provider.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  final _timeController = TextEditingController(text: '18:00');
  
  String _selectedFrequency = 'Weekly';
  String _selectedDeadlineDay = 'Sunday';
  DateTime? _startDate;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _amountController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Njangi Group', style: AppTypography.h3),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Group Name',
                  hintText: 'e.g. Business Growth Circle',
                ),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'What is this group for?',
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _amountController,
                      decoration: const InputDecoration(
                        labelText: 'Amount (XAF)',
                        prefixIcon: Icon(Icons.money),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedFrequency,
                      decoration: const InputDecoration(labelText: 'Frequency'),
                      items: ['Weekly', 'Monthly']
                          .map((f) => DropdownMenuItem(value: f, child: Text(f)))
                          .toList(),
                      onChanged: (v) => setState(() => _selectedFrequency = v!),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text('Contribution Settings', style: AppTypography.h3),
              const SizedBox(height: 16),
              if (_selectedFrequency == 'Weekly')
                DropdownButtonFormField<String>(
                  value: _selectedDeadlineDay,
                  decoration: const InputDecoration(
                    labelText: 'Deadline Day of the Week',
                    prefixIcon: Icon(Icons.calendar_view_day),
                  ),
                  items: ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday']
                      .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                      .toList(),
                  onChanged: (v) => setState(() => _selectedDeadlineDay = v!),
                ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _timeController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Deadline Time',
                  prefixIcon: Icon(Icons.access_time),
                ),
                onTap: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (time != null) {
                    setState(() => _timeController.text = time.format(context));
                  }
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Start Date',
                  prefixIcon: const Icon(Icons.calendar_month),
                  hintText: _startDate == null ? 'Select date' : '${_startDate!.day}/${_startDate!.month}/${_startDate!.year}',
                ),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) {
                    setState(() => _startDate = date);
                  }
                },
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final authProvider = Provider.of<AuthProvider>(context, listen: false);
                    final groupProvider = Provider.of<GroupProvider>(context, listen: false);
                    final activityProvider = Provider.of<ActivityProvider>(context, listen: false);
                    final notificationProvider = Provider.of<NotificationProvider>(context, listen: false);

                    final userName = '${authProvider.userProfile?['firstName']} ${authProvider.userProfile?['lastName']}';
                    
                    final groupData = {
                      'name': _nameController.text,
                      'description': _descriptionController.text,
                      'amount': '${_amountController.text} XAF',
                      'frequency': _selectedFrequency,
                      'deadlineDay': _selectedDeadlineDay,
                      'deadlineTime': _timeController.text,
                      'members': 1,
                      'admin': userName,
                      'nextPayout': 'TBD',
                    };

                    groupProvider.addGroup(groupData);

                    activityProvider.addActivity({
                      'type': 'group_created',
                      'title': 'Group Created',
                      'subtitle': 'You created ${_nameController.text}',
                      'amount': '${_amountController.text} XAF',
                    });

                    notificationProvider.addNotification({
                      'title': 'Group Created Successfully',
                      'message': 'Your new Njangi group "${_nameController.text}" is ready.',
                    });

                    context.pop();
                  }
                },
                child: const Text('Create Group'),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
