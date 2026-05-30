import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/auth_service.dart';
import '../../services/sync_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/sync_toast.dart';
import '../shell/shell_screen.dart';
import '../login/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static const _mensajes = [
    'Conectando con el servidor...',
    'Verificando credenciales...',
    'Cargando proyectos...',
    'Sincronizando proveedores...',
    'Actualizando presupuestos...',
    'Preparando bitácora...',
    'Cargando transacciones...',
    'Casi listo...',
  ];

  int _mensajeIndex = 0;
  String _estado = _mensajes[0];
  bool _offline = false;
  bool _conectando = true;
  Timer? _mensajeTimer;
  Timer? _reconexionTimer;

  @override
  void initState() {
    super.initState();
    _iniciarMensajesRotativos();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initApp());
  }

  @override
  void dispose() {
    _mensajeTimer?.cancel();
    _reconexionTimer?.cancel();
    super.dispose();
  }

  void _iniciarMensajesRotativos() {
    _mensajeTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!_offline && mounted) {
        setState(() {
          _mensajeIndex = (_mensajeIndex + 1) % _mensajes.length;
          _estado = _mensajes[_mensajeIndex];
        });
      }
    });
  }

  Future<void> _initApp() async {
    final auth = context.read<AuthService>();

    // Sin token guardado → ir directo a LoginScreen
    if (!auth.hasToken) {
      _irALogin();
      return;
    }

    // Hasta 3 intentos de auto-login
    for (int intento = 1; intento <= 3; intento++) {
      final exito = await auth.tryAutoLogin();
      if (exito) {
        // Disparar sync en background — no bloquea la navegación
        if (mounted) {
          context.read<SyncService>().fullSync().then((_) {}, onError: (_) {});
        }
        _irAShell();
        return;
      }

      if (!mounted) return;

      if (intento < 3) {
        setState(() => _estado = 'Sin conexión, reintentando ($intento/3)...');
        await Future.delayed(const Duration(seconds: 5));
        if (!mounted) return;
        setState(() {
          _mensajeIndex = 0;
          _estado = _mensajes[0];
        });
      }
    }

    // 3 intentos fallidos → modo offline
    if (mounted) {
      _mensajeTimer?.cancel();
      setState(() {
        _offline = true;
        _conectando = false;
      });
      _iniciarTimerReconexion();
    }
  }

  void _iniciarTimerReconexion() {
    _reconexionTimer = Timer.periodic(const Duration(seconds: 60), (_) async {
      final auth = context.read<AuthService>();
      final exito = await auth.tryAutoLogin();
      if (exito && mounted) {
        _reconexionTimer?.cancel();
        SyncToast.show(context, 'Conexión restaurada. Sincronizando...');
        context.read<SyncService>().fullSync().then((_) {}, onError: (_) {});
        await Future.delayed(const Duration(milliseconds: 500));
        _irAShell();
      }
    });
  }

  void _irAShell() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const ShellScreen()),
    );
  }

  void _irALogin() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  Future<void> _reintentar() async {
    _reconexionTimer?.cancel();
    setState(() {
      _offline = false;
      _conectando = true;
      _mensajeIndex = 0;
      _estado = _mensajes[0];
    });
    _iniciarMensajesRotativos();
    await _initApp();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.colorFondo,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ── Logo K en círculo dorado ──────────────────────────────────
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppTheme.colorPrimario,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.colorPrimario.withAlpha(51),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  'K',
                  style: GoogleFonts.inter(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // ── Nombre de la app ──────────────────────────────────────────
            Text(
              'KatyDecor Admin',
              style: GoogleFonts.inter(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: AppTheme.colorTexto,
              ),
            ),
            const SizedBox(height: 32),

            // ── Estado: conectando o offline ──────────────────────────────
            if (_conectando) ...[
              SizedBox(
                width: 260,
                child: LinearProgressIndicator(
                  backgroundColor: AppTheme.colorBorde,
                  color: AppTheme.colorPrimario,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                _estado,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: AppTheme.colorTextoSecundario,
                ),
              ),
            ] else ...[
              // ── UI offline ───────────────────────────────────────────────
              const Icon(Icons.wifi_off_rounded,
                  size: 40, color: Color(0xFFE07A2A)),
              const SizedBox(height: 16),
              Text(
                'Sin conexión a internet',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.colorTexto,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Trabajando con datos guardados',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: AppTheme.colorTextoSecundario,
                ),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: 220,
                height: 40,
                child: ElevatedButton(
                  onPressed: _irAShell,
                  child: const Text('Continuar sin conexión'),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: 220,
                height: 40,
                child: OutlinedButton(
                  onPressed: _reintentar,
                  child: const Text('Reintentar'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
