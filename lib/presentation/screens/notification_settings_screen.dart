import 'package:flutter/material.dart';
import 'dart:io';
import 'package:lavoauto/services/push_notification_service.dart';
import 'package:lavoauto/data/repositories/chat_repository.dart';

class NotificationSettingsScreen extends StatefulWidget {
  final String token;

  const NotificationSettingsScreen({
    Key? key,
    required this.token,
  }) : super(key: key);

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  late PushNotificationService _pushNotificationService;
  late ChatRepository _chatRepository;
  bool _notificationsEnabled = false;
  bool _isLoading = true;
  String? _deviceToken;

  @override
  void initState() {
    super.initState();
    _pushNotificationService = PushNotificationService();
    _chatRepository = ChatRepository(token: widget.token);
    _initializeSettings();
  }

  Future<void> _initializeSettings() async {
    try {
      final enabled =
          await _pushNotificationService.areNotificationsEnabled();
      final deviceToken = await _pushNotificationService.getDeviceToken();

      setState(() {
        _notificationsEnabled = enabled;
        _deviceToken = deviceToken;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showErrorSnackBar('Error al cargar configuración: $e');
    }
  }

  Future<void> _requestPermission() async {
    try {
      final granted =
          await _pushNotificationService.requestNotificationPermission();

      setState(() => _notificationsEnabled = granted);

      if (granted) {
        final deviceToken =
            await _pushNotificationService.getDeviceToken();
        if (deviceToken != null) {
          setState(() => _deviceToken = deviceToken);
          await _chatRepository.updateNotificationSettings(true);
          _showSuccessSnackBar('Notificaciones activadas');
        }
      } else {
        _showErrorSnackBar(
            'Permisos de notificación rechazados. Por favor, habilita en configuración.');
      }
    } catch (e) {
      _showErrorSnackBar('Error al solicitar permiso: $e');
    }
  }

  Future<void> _toggleNotifications(bool value) async {
    try {
      if (value && !_notificationsEnabled) {
        // Request permission if enabling
        await _requestPermission();
      } else if (!value && _notificationsEnabled) {
        // Disable notifications
        setState(() => _notificationsEnabled = false);
        await _chatRepository.updateNotificationSettings(false);
        _showSuccessSnackBar('Notificaciones desactivadas');
      }
    } catch (e) {
      _showErrorSnackBar('Error: $e');
      // Revert the toggle
      setState(() => _notificationsEnabled = !value);
    }
  }

  void _openSystemSettings() {
    // Platform specific navigation to settings
    if (Platform.isIOS) {
      // For iOS, we can open the app settings
      // This requires native code or a plugin
      _showInfoDialog(
        'Ir a Configuración',
        'Por favor ve a Ajustes > Lavoauto > Notificaciones y habilita las notificaciones.',
      );
    } else if (Platform.isAndroid) {
      _showInfoDialog(
        'Ir a Configuración',
        'Por favor ve a Configuración > Aplicaciones > Lavoauto > Permisos > Notificaciones y habilita las notificaciones.',
      );
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showInfoDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Entendido'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Configuración de Notificaciones')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración de Notificaciones'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        children: [
          // Main notification toggle
          SwitchListTile(
            title: const Text('Notificaciones Push'),
            subtitle: Text(
              _notificationsEnabled
                  ? 'Activadas'
                  : 'Desactivadas',
            ),
            value: _notificationsEnabled,
            onChanged: _toggleNotifications,
          ),

          const Divider(),

          // Info section
          if (!_notificationsEnabled)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  border: Border.all(color: Colors.amber.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info,
                          color: Colors.amber.shade700,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Notificaciones desactivadas',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.amber.shade700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Recibirás una notificación cuando el otro usuario te envíe un mensaje. Si rechazaste los permisos, puedes activarlos aquí.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.amber.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Device info section
          if (_deviceToken != null)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  border: Border.all(color: Colors.blue.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: Colors.blue.shade700,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Dispositivo registrado',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tu dispositivo está registrado para recibir notificaciones de chat.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Settings button
          if (!_notificationsEnabled)
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton.icon(
                onPressed: _openSystemSettings,
                icon: const Icon(Icons.settings),
                label: const Text('Abrir Configuración del Sistema'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
              ),
            ),

          const Divider(),

          // Message notifications section
          const Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sobre las notificaciones',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '• Las notificaciones se envían cuando el otro usuario te manda un mensaje\n'
                  '• Las notificaciones se desactivan cuando el servicio finaliza\n'
                  '• Puedes desactivar notificaciones en cualquier momento\n'
                  '• Si rechazaste notificaciones al instalar, puedes habilitarlas aquí',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
