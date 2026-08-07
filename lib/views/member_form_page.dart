import 'package:flutter/material.dart';
import '../controllers/member_controller.dart';
import '../models/member_model.dart';

class MemberFormPage extends StatefulWidget {
  final MemberController controller;
  final Member? member;
  final VoidCallback onSave;

  const MemberFormPage({
    super.key,
    required this.controller,
    this.member,
    required this.onSave,
  });

  @override
  State<MemberFormPage> createState() => _MemberFormPageState();
}

class _MemberFormPageState extends State<MemberFormPage> {
  final _formKey = GlobalKey<FormState>();

  // Dropdown options
  final List<String> _statusOptions = ['Single', 'Married', 'Widowed', 'Separated'];
  final List<String> _occupationOptions = ['Student', 'Employed', 'Self-Employed', 'Unemployed', 'Retired', 'Other'];
  final List<String> _talentPresetOptions = [
    'Praying',
    'Singing',
    'Palangiti',
    'Pala approach',
    'Preaching',
    'Bible Study',
    'Counseling',
    'Other'
  ];

  // State variables
  late String _name;
  late String _phoneNumber;
  late String _address;
  late String _position;
  late String _status;
  late String _occupation;
  late String _selectedTalentDropdown;
  late String _customTalent;
  late String _shortSelfDescription;
  DateTime? _birthDay;
  DateTime? _baptismDate;

  @override
  void initState() {
    super.initState();
    final m = widget.member;

    _name = m?.name ?? '';
    _phoneNumber = m?.phoneNumber ?? '';
    _address = m?.address ?? '';
    _position = m?.position ?? 'Member';
    _status = (m != null && _statusOptions.contains(m.status)) ? m.status : 'Single';
    _occupation = (m != null && _occupationOptions.contains(m.occupation)) ? m.occupation : 'Student';

    // Handle spiritual talent preset vs custom text
    if (m != null && m.spiritualTalent.isNotEmpty) {
      if (_talentPresetOptions.contains(m.spiritualTalent)) {
        _selectedTalentDropdown = m.spiritualTalent;
        _customTalent = '';
      } else {
        _selectedTalentDropdown = 'Other';
        _customTalent = m.spiritualTalent;
      }
    } else {
      _selectedTalentDropdown = 'Praying';
      _customTalent = '';
    }

    _shortSelfDescription = m?.shortSelfDescription ?? '';
    _birthDay = m?.birthDay;
    _baptismDate = m?.baptismDate;
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.member != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Member' : 'Add New Member'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // --- PERSONAL DETAILS ---
              TextFormField(
                initialValue: _name,
                decoration: const InputDecoration(labelText: 'Full Name *', border: OutlineInputBorder()),
                validator: (val) => val == null || val.trim().isEmpty ? 'Required field' : null,
                onSaved: (val) => _name = val!.trim(),
              ),
              const SizedBox(height: 12),

              TextFormField(
                initialValue: _phoneNumber,
                decoration: const InputDecoration(labelText: 'Phone Number', border: OutlineInputBorder()),
                keyboardType: TextInputType.phone,
                onSaved: (val) => _phoneNumber = val?.trim() ?? '',
              ),
              const SizedBox(height: 12),

              TextFormField(
                initialValue: _address,
                decoration: const InputDecoration(labelText: 'Address', border: OutlineInputBorder()),
                onSaved: (val) => _address = val?.trim() ?? '',
              ),
              const SizedBox(height: 12),

              // --- STATUS & OCCUPATION DROPDOWNS ---
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _status,
                      decoration: const InputDecoration(labelText: 'Civil Status', border: OutlineInputBorder()),
                      items: _statusOptions
                          .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                          .toList(),
                      onChanged: (val) => setState(() => _status = val ?? 'Single'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _occupation,
                      decoration: const InputDecoration(labelText: 'Occupation', border: OutlineInputBorder()),
                      items: _occupationOptions
                          .map((o) => DropdownMenuItem(value: o, child: Text(o)))
                          .toList(),
                      onChanged: (val) => setState(() => _occupation = val ?? 'Student'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              TextFormField(
                initialValue: _position,
                decoration: const InputDecoration(labelText: 'Church Position / Role', border: OutlineInputBorder()),
                onSaved: (val) => _position = val?.trim() ?? 'Member',
              ),
              const SizedBox(height: 12),

              // --- SPIRITUAL TALENT DROPDOWN ---
              DropdownButtonFormField<String>(
                value: _selectedTalentDropdown,
                decoration: const InputDecoration(labelText: 'Spiritual Talent', border: OutlineInputBorder()),
                items: _talentPresetOptions
                    .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    _selectedTalentDropdown = val ?? 'Praying';
                  });
                },
              ),
              const SizedBox(height: 12),

              // Manual Input field if "Other" is selected
              if (_selectedTalentDropdown == 'Other') ...[
                TextFormField(
                  initialValue: _customTalent,
                  decoration: const InputDecoration(
                    labelText: 'Specify Other Talent *',
                    border: OutlineInputBorder(),
                  ),
                  validator: (val) {
                    if (_selectedTalentDropdown == 'Other' && (val == null || val.trim().isEmpty)) {
                      return 'Please specify the talent';
                    }
                    return null;
                  },
                  onSaved: (val) => _customTalent = val?.trim() ?? '',
                ),
                const SizedBox(height: 12),
              ],

              // --- DATES (BIRTHDAY & BAPTISM) ---
              Card(
                margin: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Column(
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          _birthDay == null
                              ? 'Birthday: Select Date'
                              : 'Birthday: ${_birthDay!.toLocal().toString().split(' ')[0]}',
                        ),
                        trailing: const Icon(Icons.cake),
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: _birthDay ?? DateTime(2000),
                            firstDate: DateTime(1920),
                            lastDate: DateTime.now(),
                          );
                          if (picked != null) setState(() => _birthDay = picked);
                        },
                      ),
                      const Divider(height: 1),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          _baptismDate == null
                              ? 'Baptism Date: Select Date'
                              : 'Baptism Date: ${_baptismDate!.toLocal().toString().split(' ')[0]}',
                        ),
                        trailing: const Icon(Icons.water_drop),
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: _baptismDate ?? DateTime.now(),
                            firstDate: DateTime(1920),
                            lastDate: DateTime.now(),
                          );
                          if (picked != null) setState(() => _baptismDate = picked);
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // --- SHORT SELF DESCRIPTION ---
              TextFormField(
                initialValue: _shortSelfDescription,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Short Self Description',
                  hintText: 'A brief note or bio about the member...',
                  border: OutlineInputBorder(),
                ),
                onSaved: (val) => _shortSelfDescription = val?.trim() ?? '',
              ),
              const SizedBox(height: 24),

              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
                icon: const Icon(Icons.save),
                label: Text(isEditing ? 'Update Member' : 'Save Member', style: const TextStyle(fontSize: 16)),
                onPressed: _saveForm,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Resolve actual spiritual talent string
      final finalTalent = _selectedTalentDropdown == 'Other' ? _customTalent : _selectedTalentDropdown;

      if (widget.member == null) {
        final newMember = Member(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: _name,
          phoneNumber: _phoneNumber,
          address: _address,
          position: _position,
          birthDay: _birthDay,
          baptismDate: _baptismDate,
          status: _status,
          occupation: _occupation,
          spiritualTalent: finalTalent,
          shortSelfDescription: _shortSelfDescription,
        );
        widget.controller.addMember(newMember);
      } else {
        final updatedMember = Member(
          id: widget.member!.id,
          name: _name,
          phoneNumber: _phoneNumber,
          address: _address,
          position: _position,
          birthDay: _birthDay,
          baptismDate: _baptismDate,
          status: _status,
          occupation: _occupation,
          spiritualTalent: finalTalent,
          shortSelfDescription: _shortSelfDescription,
          dateCreated: widget.member!.dateCreated,
          dateModified: DateTime.now(),
        );
        widget.controller.updateMember(widget.member!.id, updatedMember);
      }

      widget.onSave();
      Navigator.pop(context);
    }
  }
}