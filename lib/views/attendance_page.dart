import 'package:flutter/material.dart';
import '../controllers/member_controller.dart';

class AttendancePage extends StatefulWidget {
  final MemberController controller;
  const AttendancePage({super.key, required this.controller});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  DateTime _selectedDate = DateTime.now();

  String get _formattedDate =>
      "${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sabbath Attendance'),
      ),
      body: Column(
        children: [
          // Date Selector Header
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Date:', style: TextStyle(fontSize: 12, color: Colors.grey)),
                    Text(
                      _formattedDate,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2030),
                    );
                    if (picked != null) {
                      setState(() => _selectedDate = picked);
                    }
                  },
                  icon: const Icon(Icons.calendar_month),
                  label: const Text('Change Date'),
                ),
              ],
            ),
          ),

          // Attendance Summary Counter
          ListenableBuilder(
            listenable: widget.controller,
            builder: (context, _) {
              final presentCount = widget.controller.getPresentCount(_formattedDate);
              final totalMembers = widget.controller.members.length;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Present: $presentCount / $totalMembers',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      totalMembers > 0
                          ? '${((presentCount / totalMembers) * 100).toStringAsFixed(1)}%'
                          : '0%',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const Divider(height: 1),

          // Interactive Member List Checklist
          Expanded(
            child: ListenableBuilder(
              listenable: widget.controller,
              builder: (context, _) {
                final members = widget.controller.members;
                if (members.isEmpty) {
                  return const Center(child: Text('No members registered in directory.'));
                }

                return ListView.builder(
                  itemCount: members.length,
                  itemBuilder: (context, index) {
                    final member = members[index];
                    final isPresent = widget.controller.isPresent(_formattedDate, member.id);

                    return CheckboxListTile(
                      value: isPresent,
                      title: Text(member.name),
                      subtitle: Text(member.position),
                      secondary: CircleAvatar(
                        backgroundColor: isPresent ? Colors.green : Colors.grey.shade300,
                        child: Icon(
                          isPresent ? Icons.check : Icons.person,
                          color: Colors.white,
                        ),
                      ),
                      onChanged: (_) {
                        widget.controller.toggleAttendance(_formattedDate, member.id);
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}