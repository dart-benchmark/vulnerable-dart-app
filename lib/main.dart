// Intentionally Vulnerable Flutter/Dart Application
// DO NOT USE IN PRODUCTION - FOR SECURITY TESTING ONLY

import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart' hide Key;
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:crypto/crypto.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:encrypt/encrypt.dart';

// VULNERABILITY: Hardcoded Secrets (CWE-798)
const String JWT_SECRET = 'super_secret_jwt_key_12345';
const String ADMIN_PASSWORD = 'admin123';
const String DB_PASSWORD = 'password123';
const String API_KEY = 'AKIA_FAKE_DART_KEY_FOR_TESTING_ONLY';
const String AWS_SECRET_KEY = 'fake_aws_secret_key_12345678901234567890';

void main() {
  runApp(VulnerableApp());
}

class VulnerableApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vulnerable Dart App',
      home: VulnerableHomePage(),
    );
  }
}

class VulnerableHomePage extends StatefulWidget {
  @override
  _VulnerableHomePageState createState() => _VulnerableHomePageState();
}

class _VulnerableHomePageState extends State<VulnerableHomePage> {
  String _output = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vulnerable Dart App'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Intentionally Vulnerable Flutter/Dart Application',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => testSqlInjection(),
                child: Text('Test SQL Injection'),
              ),
              ElevatedButton(
                onPressed: () => testCommandInjection(),
                child: Text('Test Command Injection'),
              ),
              ElevatedButton(
                onPressed: () => testPathTraversal(),
                child: Text('Test Path Traversal'),
              ),
              ElevatedButton(
                onPressed: () => testSSRF(),
                child: Text('Test SSRF'),
              ),
              SizedBox(height: 20),
              Text('Output:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(_output),
            ],
          ),
        ),
      ),
    );
  }

  // VULNERABILITY 1: SQL Injection (CWE-89)
  Future<void> testSqlInjection() async {
    String username = "admin' OR '1'='1";
    String password = "anything";

    final database = await openDatabase(
      join(await getDatabasesPath(), 'vulnerable.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE users(id INTEGER PRIMARY KEY, username TEXT, password TEXT, email TEXT)',
        );
      },
      version: 1,
    );

    // Vulnerable: String concatenation in SQL query
    String query =
        "SELECT * FROM users WHERE username = '$username' AND password = '$password'";

    setState(() {
      _output = 'Vulnerable SQL Query: $query';
    });
  }

  // VULNERABILITY 2: Command Injection (CWE-78)
  Future<void> testCommandInjection() async {
    String cmd = 'ls; whoami';

    // Vulnerable: Direct execution of user input
    ProcessResult result = await Process.run('sh', ['-c', cmd]);

    setState(() {
      _output = 'Command Output: ${result.stdout}';
    });
  }

  // VULNERABILITY 3: Path Traversal (CWE-22)
  Future<void> testPathTraversal() async {
    String filename = '../../../etc/passwd';

    // Vulnerable: No sanitization of file path
    String path = './uploads/$filename';

    try {
      String content = await File(path).readAsString();
      setState(() {
        _output = 'File Content: $content';
      });
    } catch (e) {
      setState(() {
        _output = 'Error: $e';
      });
    }
  }

  // VULNERABILITY 4: Server-Side Request Forgery (SSRF) (CWE-918)
  Future<void> testSSRF() async {
    String url = 'http://169.254.169.254/latest/meta-data/';

    // Vulnerable: No URL validation
    try {
      final response = await http.get(Uri.parse(url));
      setState(() {
        _output = 'Response: ${response.body.substring(0, 100)}';
      });
    } catch (e) {
      setState(() {
        _output = 'Error: $e';
      });
    }
  }
}

// VULNERABILITY 5: Insecure Deserialization (CWE-502)
class VulnerableDeserializer {
  static dynamic deserialize(String data) {
    // Vulnerable: Deserializing untrusted data without validation
    return jsonDecode(data);
  }
}

// VULNERABILITY 6: Hardcoded Credentials (CWE-798)
class AuthService {
  static bool login(String username, String password) {
    // Vulnerable: Hardcoded admin credentials
    if (username == 'admin' && password == ADMIN_PASSWORD) {
      return true;
    }
    return false;
  }

  // VULNERABILITY 7: Weak Cryptography (CWE-327)
  static String hashPassword(String password) {
    // Vulnerable: Using MD5 for password hashing
    var bytes = utf8.encode(password);
    var digest = md5.convert(bytes);
    return digest.toString();
  }

  // VULNERABILITY 8: Insecure Random (CWE-330)
  static String generateToken() {
    // Vulnerable: Using predictable random
    int token = DateTime.now().millisecondsSinceEpoch % 999999999;
    return token.toString();
  }
}

// VULNERABILITY 9: Mass Assignment (CWE-915)
class User {
  int? id;
  String? username;
  String? email;
  String? role;

  User.fromJson(Map<String, dynamic> json) {
    // Vulnerable: Allows setting any field including 'role'
    id = json['id'];
    username = json['username'];
    email = json['email'];
    role = json['role']; // Attacker can set role=admin
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'role': role,
    };
  }
}

// VULNERABILITY 10: Missing Input Validation (CWE-20)
class DataProcessor {
  static String processInput(String input) {
    // Vulnerable: No input validation or sanitization
    return '<div>User input: $input</div>';
  }
}

// VULNERABILITY 11: Information Exposure (CWE-200)
class DebugService {
  static Map<String, dynamic> getDebugInfo() {
    // Vulnerable: Exposes sensitive information
    return {
      'jwt_secret': JWT_SECRET,
      'admin_password': ADMIN_PASSWORD,
      'db_password': DB_PASSWORD,
      'api_key': API_KEY,
      'aws_secret_key': AWS_SECRET_KEY,
    };
  }
}

// VULNERABILITY 12: Unvalidated Redirects (CWE-601)
class NavigationService {
  static void redirect(String url) {
    // Vulnerable: No validation of redirect URL
    // In a real app, this would navigate to the URL
    print('Redirecting to: $url');
  }
}

// VULNERABILITY 13: XML External Entity (XXE) (CWE-611)
class XmlParser {
  static void parseXml(String xmlData) {
    // Vulnerable: Would parse XML without disabling external entities
    // Dart's XML parsers are generally safe by default, but this pattern is vulnerable
    print('Parsing XML: $xmlData');
  }
}

// VULNERABILITY 14: Insecure Direct Object Reference (IDOR) (CWE-639)
class UserRepository {
  static Future<User?> getUser(int userId) async {
    // Vulnerable: No authorization check, any user can access any user's data
    final database = await openDatabase(
      join(await getDatabasesPath(), 'vulnerable.db'),
    );

    final List<Map<String, dynamic>> maps = await database.query(
      'users',
      where: 'id = ?',
      whereArgs: [userId],
    );

    if (maps.isNotEmpty) {
      return User.fromJson(maps.first);
    }
    return null;
  }

  // VULNERABILITY 15: Missing Authentication (CWE-306)
  static Future<bool> deleteUser(int userId) async {
    // Vulnerable: No authentication required to delete users
    final database = await openDatabase(
      join(await getDatabasesPath(), 'vulnerable.db'),
    );

    await database.delete(
      'users',
      where: 'id = ?',
      whereArgs: [userId],
    );

    return true;
  }
}

// VULNERABILITY 16: Sensitive Data in Logs (CWE-532)
class Logger {
  static void logUserData(String username, String password, String email) {
    // Vulnerable: Logging sensitive data
    print('User login attempt: username=$username, password=$password, email=$email');
  }
}

// VULNERABILITY 17: Race Condition (CWE-362)
class Counter {
  static int _count = 0;

  // Vulnerable: No synchronization
  static void increment() {
    _count++;
  }

  static int getCount() {
    return _count;
  }
}

// VULNERABILITY 18: Insufficient Logging (CWE-778)
class PaymentService {
  static Future<bool> processPayment(double amount) async {
    // Vulnerable: No logging of payment transactions
    // Process payment without audit trail
    return true;
  }
}

// API Endpoints Simulation (would be in a backend service)
class ApiEndpoints {
  // VULNERABILITY: SQL Injection endpoint
  static Future<Map<String, dynamic>> login(String username, String password) async {
    String query = "SELECT * FROM users WHERE username = '$username' AND password = '$password'";
    return {'query': query, 'vulnerable': true};
  }

  // VULNERABILITY: Command Injection endpoint
  static Future<Map<String, dynamic>> exec(String cmd) async {
    ProcessResult result = await Process.run('sh', ['-c', cmd]);
    return {'success': true, 'output': result.stdout};
  }

  // VULNERABILITY: Path Traversal endpoint
  static Future<Map<String, dynamic>> getFile(String filename) async {
    String path = './uploads/$filename';
    try {
      String content = await File(path).readAsString();
      return {'content': content};
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  // VULNERABILITY: SSRF endpoint
  static Future<Map<String, dynamic>> proxy(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      return {'data': response.body.substring(0, 500)};
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  // VULNERABILITY: Code Injection endpoint
  static Future<Map<String, dynamic>> eval(String code) async {
    // Dart doesn't have eval, but this pattern is vulnerable
    return {'message': 'Code evaluation endpoint (vulnerable pattern)', 'input': code};
  }

  // VULNERABILITY: Mass Assignment endpoint
  static Future<Map<String, dynamic>> register(Map<String, dynamic> data) async {
    User newUser = User.fromJson(data);
    return {'success': true, 'user': newUser.toJson()};
  }

  // VULNERABILITY: IDOR endpoint
  static Future<Map<String, dynamic>> getUser(int userId) async {
    User? user = await UserRepository.getUser(userId);
    return {'user': user?.toJson()};
  }

  // VULNERABILITY: Missing Authentication endpoint
  static Future<Map<String, dynamic>> deleteUser(int userId) async {
    await UserRepository.deleteUser(userId);
    return {'success': true, 'deleted': userId};
  }

  // VULNERABILITY: Sensitive Data Exposure endpoint
  static Future<Map<String, dynamic>> debug() async {
    return DebugService.getDebugInfo();
  }

  // VULNERABILITY: Open Redirect endpoint
  static void redirect(String url) {
    NavigationService.redirect(url);
  }

  // VULNERABILITY: Weak Cryptography endpoint
  static Future<Map<String, dynamic>> hash(String password) async {
    String hash = AuthService.hashPassword(password);
    return {'hash': hash, 'algorithm': 'MD5'};
  }

  // VULNERABILITY: Insecure Random endpoint
  static Future<Map<String, dynamic>> generateToken() async {
    String token = AuthService.generateToken();
    return {'token': token, 'algorithm': 'Predictable'};
  }

  // VULNERABILITY: Information Exposure endpoint
  static Future<Map<String, dynamic>> databaseConnect() async {
    String errorMsg =
        "Connection failed: Access denied for user 'postgres'@'localhost' using password '$DB_PASSWORD'";
    return {'error': errorMsg, 'stackTrace': 'Simulated stack trace'};
  }

  // VULNERABILITY: Missing Rate Limiting endpoint
  static Future<Map<String, dynamic>> bruteForceTarget(String password) async {
    if (password == 'correct_password') {
      return {'success': true};
    } else {
      return {'success': false};
    }
  }
}

// ============================================================================
// PLANTED VULNERABILITIES (CWE-601: URL Redirection to Untrusted Site, aka
// "Open Redirect") — benchmark ground-truth instances added on top of the
// pre-existing, documented `NavigationService`/`ApiEndpoints.redirect` code
// above. Unlike that hardcoded-literal pattern, every instance below derives
// its redirect target from a plausible request/callback shape (a deep-link
// URI, route arguments, an OAuth callback payload, a push-notification
// payload, a deferred/cached deep link) rather than a compile-time literal —
// see `./benchmarking/dart/planting-research/dart-cwe-601-planting-research.md`.
// ============================================================================

// PLANTED CWE-601 (direct): an unvalidated deep-link "redirect" query
// parameter, opened directly via url_launcher in the same function it is
// read in.
class DeepLinkRedirectHandler {
  /// Invoked by the platform's deep-link callback (e.g. an app_links/
  /// uni_links `onAppLink` stream) when the OS delivers an incoming URI
  /// such as `myapp://open?redirect=https://attacker.example/phish`.
  static Future<void> onIncomingLink(Uri incomingLink) async {
    final redirectParam = incomingLink.queryParameters['redirect'];
    if (redirectParam == null) return;

    // Vulnerable: the attacker-controlled deep-link parameter is parsed and
    // opened externally with no host/scheme allowlist check.
    await launchUrl(Uri.parse(redirectParam)); // SINK: PLANTED-Dart-HR-26
  }

  static const _trustedRedirectHosts = {
    'vulnerable-dart-app.example',
    'app.vulnerable-dart-app.example',
  };

  /// Safe twin: only ever opens the link if it resolves to one of this
  /// app's own trusted web hosts.
  static Future<void> onIncomingLinkSafe(Uri incomingLink) async {
    final redirectParam = incomingLink.queryParameters['redirect'];
    if (redirectParam == null) return;

    final target = Uri.parse(redirectParam);
    if (!_trustedRedirectHosts.contains(target.host)) {
      return; // reject anything outside the allowlist
    }
    await launchUrl(target); // SAFE_SINK: PLANTED-Dart-HR-26-safe
  }
}

// PLANTED CWE-601 (indirect): "return to where you came from" after login,
// resolved from route arguments via a private helper before reaching the
// sink -- one call hop between source and sink, both in the same class.
class PostLoginRedirector {
  /// `routeArgs` mirrors what a real screen would receive as
  /// `ModalRoute.of(context)!.settings.arguments` -- populated from a deep
  /// link or a previous screen carrying a `returnUrl` field.
  static Uri _resolveReturnTarget(Map<String, dynamic> routeArgs) {
    final raw = routeArgs['returnUrl'] as String?;
    // Vulnerable: whatever the caller supplied is treated as navigable
    // as-is, with no scheme/host check.
    return Uri.parse(raw ?? '/');
  }

  static Future<void> completeLogin(Map<String, dynamic> routeArgs) async {
    final target = _resolveReturnTarget(routeArgs);
    await launchUrl(target); // SINK: PLANTED-Dart-HR-27
  }

  static Uri? _resolveReturnTargetSafe(Map<String, dynamic> routeArgs) {
    final raw = routeArgs['returnUrl'] as String?;
    final parsed = Uri.parse(raw ?? '/');
    // Safe: only a same-app relative path is accepted -- anything that
    // parses with its own scheme or authority is rejected outright.
    if (parsed.hasScheme || parsed.hasAuthority) {
      return null;
    }
    return parsed;
  }

  static Future<void> completeLoginSafe(Map<String, dynamic> routeArgs) async {
    final target = _resolveReturnTargetSafe(routeArgs);
    if (target == null) return;
    await launchUrl(target); // SAFE_SINK: PLANTED-Dart-HR-27-safe
  }
}

// PLANTED CWE-601 (interprocedural): an OAuth "continueUrl" carried through
// the sign-in callback and forwarded, via a separate navigation-gateway
// class, to the actual external launch -- source and sink live in two
// different classes.
class OAuthCallbackService {
  /// Invoked once a google_sign_in/firebase_auth-style external provider
  /// sign-in completes and hands back the params the app started the flow
  /// with, including whatever `continueUrl` the caller asked to return to.
  static Future<void> handleSignInCallback(
      Map<String, String> callbackParams) async {
    final continueUrl = callbackParams['continueUrl'];
    if (continueUrl == null) return;
    await ExternalNavigationGateway.openExternal(continueUrl);
  }

  static Future<void> handleSignInCallbackSafe(
      Map<String, String> callbackParams) async {
    final continueUrl = callbackParams['continueUrl'];
    if (continueUrl == null) return;
    await ExternalNavigationGateway.openExternalSafe(continueUrl);
  }
}

class ExternalNavigationGateway {
  static Future<void> openExternal(String rawUrl) async {
    // Vulnerable: forwarded straight from the OAuth callback params with no
    // validation at this, the actual point of external navigation.
    await launchUrl(Uri.parse(rawUrl)); // SINK: PLANTED-Dart-HR-28
  }

  static Future<void> openExternalSafe(String rawUrl) async {
    final target = Uri.parse(rawUrl);
    if (target.scheme != 'https' ||
        !target.host.endsWith('.vulnerable-dart-app.example')) {
      return; // reject anything not on our own https subdomain tree
    }
    await launchUrl(target); // SAFE_SINK: PLANTED-Dart-HR-28-safe
  }
}

// PLANTED CWE-601 (type/polymorphism-dependent): a push-notification "tap
// action" payload can arrive in two shapes depending on which channel
// delivered it -- a structured FCM-style data map (validated) or a legacy
// raw deep-link string (not). Only the raw-string branch reaches the sink
// unsanitized: exploitability hinges on the payload's runtime type.
class NotificationTapHandler {
  static const _trustedHosts = {'vulnerable-dart-app.example'};

  static Future<void> handleTap(dynamic payload) async {
    if (payload is Map<String, dynamic>) {
      // Structured FCM-style payload: validate the target host first.
      final link = payload['link'] as String?;
      if (link == null) return;
      final target = Uri.parse(link);
      if (!_trustedHosts.contains(target.host)) return;
      await launchUrl(target); // SAFE_SINK: PLANTED-Dart-HR-29-safe
    } else if (payload is String) {
      // Legacy raw deep-link string (older notification channel): opened
      // as-is, with no validation at all.
      await launchUrl(Uri.parse(payload)); // SINK: PLANTED-Dart-HR-29
    }
  }
}

// PLANTED CWE-601 (indirect, deferred data-flow): a deep link that arrives
// before the app finishes booting is cached and opened later, once the user
// taps a "Continue" button -- the tainted value is written to a field and
// read back at a separate, later call, a genuinely different construction
// shape from the other instances above.
class PendingDeepLinkCache {
  static Uri? _pendingRedirect;

  static void cacheIncomingLink(Uri incomingLink) {
    final redirectParam = incomingLink.queryParameters['redirect'];
    if (redirectParam == null) return;
    // Vulnerable: cached verbatim, to be opened once the app is ready -- no
    // validation performed either here or at the point of use.
    _pendingRedirect = Uri.parse(redirectParam);
  }

  static Future<void> continuePendingRedirect() async {
    final target = _pendingRedirect;
    if (target == null) return;
    await launchUrl(target); // SINK: PLANTED-Dart-HR-30
  }

  static Uri? _pendingRedirectSafe;
  static const _trustedHosts = {'vulnerable-dart-app.example'};

  static void cacheIncomingLinkSafe(Uri incomingLink) {
    final redirectParam = incomingLink.queryParameters['redirect'];
    if (redirectParam == null) return;
    final parsed = Uri.parse(redirectParam);
    _pendingRedirectSafe = _trustedHosts.contains(parsed.host) ? parsed : null;
  }

  static Future<void> continuePendingRedirectSafe() async {
    final target = _pendingRedirectSafe;
    if (target == null) return;
    await launchUrl(target); // SAFE_SINK: PLANTED-Dart-HR-30-safe
  }
}

// ============================================================================
// PLANTED VULNERABILITIES (CWE-798: Use of Hard-Coded Credentials) —
// benchmark ground-truth instances added on top of the pre-existing,
// documented JWT_SECRET / ADMIN_PASSWORD / DB_PASSWORD / API_KEY /
// AWS_SECRET_KEY constants above (VULNERABILITY 6 / 11) and their existing
// usages in AuthService.login, DebugService.getDebugInfo and
// ApiEndpoints.databaseConnect. Those five constants are the project's OWN
// documented CWE-798 instances and are NOT reclaimed here — every instance
// below is new surface, deliberately varying *construction shape* (top-level
// const, widget State field initializer, default constructor parameter,
// URL-embedded literal, hardcoded comparison) rather than repeating the same
// "const declared at the top of the file, read directly" pattern already
// present — see
// `./benchmarking/dart/planting-research/dart-cwe-798-planting-research.md`.
// ============================================================================

// PLANTED CWE-798 (top-level const, read directly at the sink): an FCM
// legacy-HTTP-API server key used to authorize outbound push notifications.
const String _fcmServerKeyLiteral =
    'AAAA1B2c3D4:fake_fcm_server_key_5f8e2d9c7b1a4f6e0d3c8b5a2f9e7d1c';

class PushNotificationService {
  static Future<void> sendPush(String deviceToken, String message) async {
    // Vulnerable: the FCM server key is a compile-time literal baked into
    // the client binary rather than fetched from server-controlled config.
    await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: {
        'Authorization': 'key=$_fcmServerKeyLiteral', // SINK: PLANTED-Dart-HR-115
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'to': deviceToken,
        'notification': {'body': message},
      }),
    );
  }

  /// Safe twin: the same push path, but the server key is read from the
  /// runtime environment with only an unmistakable placeholder fallback --
  /// never a real-looking literal.
  static Future<void> sendPushSafe(String deviceToken, String message) async {
    final serverKey =
        Platform.environment['FCM_SERVER_KEY'] ?? 'CHANGE_ME_SET_VIA_ENV';
    await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: {
        'Authorization': 'key=$serverKey', // SAFE_SINK: PLANTED-Dart-HR-115-safe
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'to': deviceToken,
        'notification': {'body': message},
      }),
    );
  }
}

// PLANTED CWE-798 (widget State field initializer, one-hop indirection): the
// analytics SDK write-key is declared as a field on a real Settings screen's
// State object and consumed later from initState() -- not read directly at
// the sink call the way the top-level consts above are.
class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // Vulnerable: the analytics vendor's write-key is baked into the widget
  // itself instead of being supplied via build-time config.
  final String _analyticsWriteKey =
      'ak_live_7f3d9c2b1e4a6f8d0c5b3a2e1f9d8c7b'; // SINK: PLANTED-Dart-HR-116

  @override
  void initState() {
    super.initState();
    AnalyticsService.configure(_analyticsWriteKey);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: Center(child: Text('Analytics configured')),
    );
  }
}

class AnalyticsService {
  static String? _writeKey;

  static void configure(String writeKey) {
    _writeKey = writeKey;
  }
}

// PLANTED CWE-798 (default constructor parameter): a backup-encryption
// passphrase supplied as a default value on BackupExportService's
// constructor. A real caller in an "Export My Data" settings flow could
// override it, but nothing in this app does, so every export uses this
// literal. Exercises `package:encrypt`, an already-declared pubspec
// dependency this app never previously used anywhere in lib/.
class BackupExportService {
  final String encryptionPassphrase;

  BackupExportService({
    this.encryptionPassphrase =
        'VulnDartAppBackupPassphrase2024!', // SINK: PLANTED-Dart-HR-117
  });

  /// Encrypts a local backup archive before it's written to shared/external
  /// storage. The passphrase is hashed down to a 32-byte key so any length
  /// of [encryptionPassphrase] works with AES-256.
  Uint8List encryptBackup(String backupJson) {
    final key = Key(Uint8List.fromList(
        sha256.convert(utf8.encode(encryptionPassphrase)).bytes));
    final iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(key));
    return encrypter.encryptBytes(utf8.encode(backupJson), iv: iv).bytes;
  }
}

// PLANTED CWE-798 (embedded directly in an outbound URL, no separate
// declaration site): a crash-reporting vendor's legacy REST ingestion
// endpoint takes the project API key as a query parameter rather than a
// header.
class CrashReportingService {
  static Future<void> reportCrash(String errorSummary, String stackTrace) async {
    // Vulnerable: the project API key is embedded literally in the request
    // URL at the point of the outbound call itself.
    final url = Uri.parse(
      'https://api.crashanalytics.example/v1/report'
      '?key=ca_live_9d2f7b3e1a6c4d8f0b5e2c9a7d1f3b6e' // SINK: PLANTED-Dart-HR-118
      '&summary=${Uri.encodeComponent(errorSummary)}',
    );
    await http.post(url, body: {'stackTrace': stackTrace});
  }
}

// PLANTED CWE-798 (hardcoded comparison, "debug unlock" feature): long-press
// the version number 7 times on the About screen to reveal this prompt --
// entering the studio's internal QA code reveals a hidden diagnostics menu
// without needing a real backend feature-flag flip.
class DeveloperModeGate {
  static bool unlockDeveloperMode(String enteredCode) {
    if (enteredCode == 'QA-UNLOCK-7F3A21') { // SINK: PLANTED-Dart-HR-119
      return true;
    }
    return false;
  }
}

// PLANTED CWE-327 (AES-ECB, direct): a customer-support "find duplicate
// contact" tool needs to compare stored phone numbers for equality without
// keeping them in cleartext, so it encrypts each number with AES in ECB
// mode -- ECB has no IV and no chaining between blocks, so two customers
// who share the same phone number produce byte-for-byte identical
// ciphertext, which is exactly the "deterministic, comparable" property ECB
// was picked for here, at the cost of leaking equality (and block-level
// structure for longer values) to anyone who can read the stored column.
class ContactDedupeIndexer {
  static final Key _dedupeKey = Key(Uint8List.fromList(
      sha256.convert(utf8.encode('vuln-dart-app-dedupe-index-key')).bytes));

  /// Builds the searchable ciphertext used as a de-dup index column.
  static String buildIndexValue(String phoneNumber) {
    final encrypter = Encrypter(AES(_dedupeKey, mode: AESMode.ecb));
    final encrypted = encrypter.encrypt(phoneNumber); // SINK: PLANTED-Dart-HR-180
    return encrypted.base64;
  }

  /// Safe twin: same operation (AES-encrypting a customer phone number),
  /// but using an authenticated mode with a nonce generated fresh for this
  /// call. Ciphertext for the same input differs every time, so it can no
  /// longer be used as an equality index on its own, but it is not
  /// exploitable the way the ECB version above is.
  static String buildSecureValueSafe(String phoneNumber) {
    final encrypter = Encrypter(AES(_dedupeKey, mode: AESMode.gcm));
    final nonce = IV.fromSecureRandom(12);
    final encrypted = encrypter.encrypt(phoneNumber,
        iv: nonce); // SAFE_SINK: PLANTED-Dart-HR-180-safe
    return '${nonce.base64}:${encrypted.base64}';
  }
}

// PLANTED CWE-327 (static/reused IV, indirect): a legacy data-export path
// keeps writing archives compatible with an older desktop client that
// hardcodes this same 16-byte block on its own decrypt routine, so this
// exporter reuses that fixed IV instead of generating a fresh one per
// export. CBC's whole security proof assumes the IV is unique per message
// -- reusing it means two exports of the same (or a related) payload leak
// identical ciphertext prefixes to anyone who can compare the archives.
class LegacyArchiveExporter {
  static final Key _archiveKey = Key(Uint8List.fromList(
      sha256.convert(utf8.encode('vuln-dart-app-legacy-archive-key')).bytes));

  // Kept fixed for backward compatibility with the pre-3.0 desktop client,
  // which hardcodes this same IV on its own decrypt path.
  static final IV _legacyFixedIv = IV.fromUtf8('LEGACY_IV_1234!!');

  static Uint8List exportArchive(String archiveJson) {
    return _encryptForLegacyClient(archiveJson);
  }

  static Uint8List _encryptForLegacyClient(String payload) {
    final encrypter = Encrypter(AES(_archiveKey, mode: AESMode.cbc));
    return encrypter
        .encrypt(payload, iv: _legacyFixedIv) // SINK: PLANTED-Dart-HR-181
        .bytes;
  }

  /// Safe twin: a fresh IV generated per export call, never captured in a
  /// field a second call could observe.
  static Uint8List exportArchiveSafe(String payload) {
    return _encryptForModernClientSafe(payload);
  }

  static Uint8List _encryptForModernClientSafe(String payload) {
    final encrypter = Encrypter(AES(_archiveKey, mode: AESMode.cbc));
    final iv = IV.fromSecureRandom(16);
    final encrypted = encrypter.encrypt(payload,
        iv: iv); // SAFE_SINK: PLANTED-Dart-HR-181-safe
    return Uint8List.fromList(iv.bytes + encrypted.bytes);
  }
}

// PLANTED CWE-327 (static/reused IV across a batch loop, interprocedural):
// BulkRecordExportService generates ONE IV in its constructor and reuses it
// for every record in the export loop below -- "one IV is enough entropy
// for one short-lived export batch" is the reasoning error. CBC needs a
// fresh IV per *message*, not per *batch*, so every record exported in the
// same run leaks the same IV-derived relationship to every other record in
// that run.
class BulkRecordExportService {
  final Key _batchKey;
  final IV _batchIv; // captured once in the constructor, reused below

  BulkRecordExportService(String exportSecret)
      : _batchKey = Key(Uint8List.fromList(
            sha256.convert(utf8.encode(exportSecret)).bytes)),
        _batchIv = IV.fromLength(16);

  List<Uint8List> exportRecords(List<String> recordsJson) {
    final encrypter = Encrypter(AES(_batchKey, mode: AESMode.cbc));
    return recordsJson
        .map((record) => encrypter
            .encrypt(record, iv: _batchIv) // SINK: PLANTED-Dart-HR-182
            .bytes)
        .toList();
  }

  /// Safe twin: generates a fresh IV for each record instead of reusing one
  /// captured for the whole batch.
  List<Uint8List> exportRecordsSafe(List<String> recordsJson) {
    final encrypter = Encrypter(AES(_batchKey, mode: AESMode.cbc));
    return recordsJson.map((record) {
      final iv = IV.fromSecureRandom(16);
      final encrypted = encrypter.encrypt(record,
          iv: iv); // SAFE_SINK: PLANTED-Dart-HR-182-safe
      return Uint8List.fromList(iv.bytes + encrypted.bytes);
    }).toList();
  }
}

// PLANTED CWE-327 (type/polymorphism-dependent): ProfileSyncCipher resolves
// to one of two concrete cipher strategies depending on which sync-protocol
// version the caller reports. Legacy clients (protocolVersion < 2) get
// _LegacyProfileCipher, which caches one Salsa20 nonce in an instance field
// and reuses it for every call made through that cipher object; modern
// clients get _ModernProfileCipherSafe, which generates a fresh nonce per
// call. Only the branch whose runtime type resolves to the legacy
// implementation is exploitable -- a stream cipher used with a reused nonce
// lets an attacker recover the XOR of any two plaintexts encrypted under it
// from their ciphertexts alone.
abstract class ProfileSyncCipher {
  Uint8List encryptProfile(String profileJson);

  factory ProfileSyncCipher.forProtocolVersion(int protocolVersion, Key key) {
    if (protocolVersion < 2) {
      return _LegacyProfileCipher(key);
    }
    return _ModernProfileCipherSafe(key);
  }
}

class _LegacyProfileCipher implements ProfileSyncCipher {
  final Key _profileKey;
  final IV _sessionNonce = IV.fromUtf8('01234567');

  _LegacyProfileCipher(this._profileKey);

  @override
  Uint8List encryptProfile(String profileJson) {
    final encrypter = Encrypter(Salsa20(_profileKey));
    return encrypter
        .encrypt(profileJson, iv: _sessionNonce) // SINK: PLANTED-Dart-HR-183
        .bytes;
  }
}

class _ModernProfileCipherSafe implements ProfileSyncCipher {
  final Key _profileKey;

  _ModernProfileCipherSafe(this._profileKey);

  @override
  Uint8List encryptProfile(String profileJson) {
    final encrypter = Encrypter(Salsa20(_profileKey));
    final nonce = IV.fromSecureRandom(8);
    final encrypted = encrypter.encrypt(profileJson,
        iv: nonce); // SAFE_SINK: PLANTED-Dart-HR-183-safe
    return Uint8List.fromList(nonce.bytes + encrypted.bytes);
  }
}

// PLANTED CWE-327 (home-rolled repeating-key XOR, interprocedural): instead
// of reaching for the already-imported `package:encrypt`, this repository
// "encrypts" a driver's tax ID with a hand-rolled repeating-key XOR before
// caching it -- a home-rolled, non-standard transform that is trivially
// reversible by anyone who recovers (or brute-forces) the short fixed key,
// unlike a real block/stream cipher. Routed through a real repository-layer
// class rather than a route handler, matching the layering the project
// already uses elsewhere (e.g. BackupExportService above).
class TaxIdRepository {
  static const List<int> _xorKey = [
    0x4d, 0x65, 0x6e, 0x64, 0x21, 0x5f, 0x4b, 0x21 // "Mend!_K!"
  ];

  final Map<String, List<int>> _store = {};

  void saveEncryptedTaxId(String driverId, String taxId) {
    _store[driverId] =
        _xorEncrypt(utf8.encode(taxId)); // SINK: PLANTED-Dart-HR-184
  }

  List<int> _xorEncrypt(List<int> plaintext) {
    return List<int>.generate(
        plaintext.length, (i) => plaintext[i] ^ _xorKey[i % _xorKey.length]);
  }

  String readDecryptedTaxId(String driverId) {
    final cipher = _store[driverId];
    if (cipher == null) return '';
    final plain = List<int>.generate(
        cipher.length, (i) => cipher[i] ^ _xorKey[i % _xorKey.length]);
    return utf8.decode(plain);
  }

  static final Key _secureTaxIdKey = Key(Uint8List.fromList(
      sha256.convert(utf8.encode('vuln-dart-app-taxid-repo-key')).bytes));
  final Map<String, String> _secureStore = {};

  /// Safe twin: same repository, but the value is encrypted with a real
  /// authenticated cipher (AES-GCM, fresh nonce per call) instead of a
  /// hand-rolled XOR transform.
  void saveEncryptedTaxIdSafe(String driverId, String taxId) {
    final encrypter = Encrypter(AES(_secureTaxIdKey, mode: AESMode.gcm));
    final nonce = IV.fromSecureRandom(12);
    final encrypted = encrypter.encrypt(taxId,
        iv: nonce); // SAFE_SINK: PLANTED-Dart-HR-184-safe
    _secureStore[driverId] = '${nonce.base64}:${encrypted.base64}';
  }
}
