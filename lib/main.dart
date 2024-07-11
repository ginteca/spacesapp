import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'flutter_flow/flutter_flow_theme.dart';
import 'flutter_flow/flutter_flow_util.dart';
import 'flutter_flow/internationalization.dart';
import 'flutter_flow/nav/nav.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterFlowTheme.initialize();
  //Remove this method to stop OneSignal Debugging
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;
  ThemeMode _themeMode = FlutterFlowTheme.themeMode;

  late AppStateNotifier _appStateNotifier;
  late GoRouter _router;

  @override
  void initState() {
    super.initState();
    _appStateNotifier = AppStateNotifier();
    _router = createRouter(_appStateNotifier);
    initOneSignal();
    obtenerPlayerId(); // Llama a obtenerPlayerId en initState

    // Set the status bar color
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Color.fromRGBO(3, 16, 145, 1),
    ));
  }

  void initOneSignal() async {
    print('Iniciando OneSignal...');
    await OneSignal.shared.setAppId("e001e770-59b4-4042-b0a4-7d506ec98881");
    await OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

    OneSignal.shared.setNotificationWillShowInForegroundHandler(
        (OSNotificationReceivedEvent event) {
      guardarNotificacion(event.notification);
      event.complete(event.notification);
    });

    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      manejarNotificacionAbierta(result);
    });

    print('OneSignal inicializado');
  }

  void guardarNotificacion(OSNotification notification) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> notificaciones = prefs.getStringList('notificaciones') ?? [];

    var nuevaNotificacion = json.encode({
      'titulo': notification.title ?? "Sin título",
      'cuerpo': notification.body ?? "Sin cuerpo",
      'fecha': DateTime.now().toString(),
    });

    notificaciones.add(nuevaNotificacion);
    await prefs.setStringList('notificaciones', notificaciones);
  }

  void manejarNotificacionAbierta(OSNotificationOpenedResult result) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> notificaciones = prefs.getStringList('notificaciones') ?? [];

    var nuevaNotificacion = json.encode({
      'titulo': result.notification.title ?? "Sin título",
      'cuerpo': result.notification.body ?? "Sin cuerpo",
      'fecha': DateTime.now().toString(),
    });

    notificaciones.add(nuevaNotificacion);
    prefs.setStringList('notificaciones', notificaciones);
  }

  void obtenerPlayerId({int intentosMaximos = 3}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var playerIdGuardado = prefs.getString('player_id');

    if (playerIdGuardado != null) {
      print("Player ID obtenido de SharedPreferences: $playerIdGuardado");
      return; // Si ya existe en SharedPreferences, no necesitas obtenerlo de nuevo
    }

    var contadorIntentos = 0;
    var playerId = await intentarObtenerPlayerId();

    while (playerId == null && contadorIntentos < intentosMaximos) {
      await Future.delayed(
          Duration(seconds: 2)); // Espera 2 segundos antes de reintentar
      playerId = await intentarObtenerPlayerId();
      contadorIntentos++;
    }

    if (playerId != null) {
      await guardarPlayerIdEnSharedPreferences(playerId);
      print("Player ID guardado en SharedPreferences: $playerId");
    } else {
      print(
          "No se pudo obtener el Player ID después de $intentosMaximos intentos.");
    }
  }

  Future<String?> intentarObtenerPlayerId() async {
    var status = await OneSignal.shared.getDeviceState();
    return status?.userId;
  }

  Future<void> guardarPlayerIdEnSharedPreferences(String playerId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('player_id', playerId);
    print('Player ID guardado en SharedPreferences');
  }

  void setLocale(String language) {
    setState(() => _locale = createLocale(language));
  }

  void setThemeMode(ThemeMode mode) => setState(() {
        _themeMode = mode;
        FlutterFlowTheme.saveThemeMode(mode);
      });

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'spacesclub',
      localizationsDelegates: [
        FFLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: _locale,
      supportedLocales: const [Locale('en', '')],
      theme: ThemeData(brightness: Brightness.light),
      darkTheme: ThemeData(brightness: Brightness.dark),
      themeMode: _themeMode,
      routeInformationParser: _router.routeInformationParser,
      routerDelegate: _router.routerDelegate,
    );
  }
}

// Extend StatelessWidget or StatefulWidget to set the status bar color
class BaseWidget extends StatelessWidget {
  final Widget child;

  BaseWidget({required this.child});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Color.fromRGBO(3, 16, 145, 1),
    ));

    return child;
  }
}

// Usage example in any of your views
class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Home'),
        ),
        body: Center(
          child: Text('Home View'),
        ),
      ),
    );
  }
}
