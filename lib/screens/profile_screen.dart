import 'package:flutter/material.dart';

import '../controllers/locator.dart';
import '../theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _editName(BuildContext context) async {
    final name = await showDialog<String>(
      context: context,
      builder: (_) => _EditNameDialog(initial: settings.userName),
    );
    if (name != null) settings.setUserName(name);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListenableBuilder(
        listenable: settings,
        builder: (context, _) {
          final name = settings.userName;
          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Center(
                child: CircleAvatar(
                  radius: 48,
                  backgroundColor: AppTheme.green,
                  child: Text(
                    name.isNotEmpty ? name[0].toUpperCase() : '?',
                    style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  name,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              Center(
                child: TextButton.icon(
                  onPressed: () => _editName(context),
                  icon: const Icon(Icons.edit, size: 18),
                  label: const Text('Ubah nama'),
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.favorite),
                title: const Text('Lagu favorit'),
                trailing: Text(
                  '${settings.favorites.length}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              SwitchListTile(
                secondary: const Icon(Icons.dark_mode),
                title: const Text('Mode gelap'),
                value: settings.isDark,
                onChanged: settings.setDark,
              ),
              const ListTile(
                leading: Icon(Icons.info_outline),
                title: Text('Tentang aplikasi'),
                subtitle: Text('Memutar preview 30 detik dari iTunes Search API.'),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _EditNameDialog extends StatefulWidget {
  final String initial;
  const _EditNameDialog({required this.initial});

  @override
  State<_EditNameDialog> createState() => _EditNameDialogState();
}

class _EditNameDialogState extends State<_EditNameDialog> {
  late final TextEditingController _controller = TextEditingController(text: widget.initial);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Ubah nama'),
      content: TextField(
        controller: _controller,
        autofocus: true,
        decoration: const InputDecoration(labelText: 'Nama'),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
        FilledButton(
          onPressed: () => Navigator.pop(context, _controller.text),
          child: const Text('Simpan'),
        ),
      ],
    );
  }
}
