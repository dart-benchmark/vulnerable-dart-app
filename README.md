# Vulnerable Dart/Flutter Application

**⚠️ WARNING: Intentionally vulnerable - NEVER deploy to production!**

## 🎯 Purpose

- **200+ dependency vulnerabilities**
- **18 code-level vulnerabilities** (OWASP Top 10)

## 📊 Vulnerabilities

### Dependencies (SCA)
- **40+ vulnerable Dart/Flutter packages** from 2019
- Flutter packages: http 0.12, dio 2.1, firebase_auth 0.15
- Expected **200+ total vulnerabilities**

### Code (SAST) - 18 Vulnerabilities

1. SQL Injection - main.dart:91
2. Command Injection - main.dart:105
3. Path Traversal - main.dart:116
4. SSRF - main.dart:132
5. Insecure Deserialization - main.dart:148
6. Hardcoded Credentials - main.dart:10-14, 156
7. Weak Cryptography - MD5 - main.dart:166
8. Insecure Randomness - main.dart:173
9. Mass Assignment - main.dart:182
10. Missing Input Validation - main.dart:201
11. Information Exposure - main.dart:209
12. Unvalidated Redirects - main.dart:223
13. XXE - main.dart:231
14. IDOR - main.dart:239
15. Missing Authentication - main.dart:256
16. Sensitive Data in Logs - main.dart:271
17. Race Condition - main.dart:279
18. Insufficient Logging - main.dart:292

## 🚀 Setup

```bash
git clone https://github.com/YOUR_USERNAME/vulnerable-dart-app.git
cd vulnerable-dart-app

flutter pub get
flutter run
```

Access: `http://localhost:8080` (or on device/emulator)

## 🔍 Testing

```bash
snyk test
# Expected: 200+ vulnerabilities
```

## 📚 Endpoints

- POST /api/login - SQL Injection
- GET /api/exec?cmd=ls - Command Injection
- GET /api/files?filename=test.txt - Path Traversal
- GET /api/proxy?url=http://example.com - SSRF
- POST /api/eval - Code Injection
- POST /api/register - Mass Assignment
- GET /api/users/:id - IDOR
- DELETE /api/admin/users/:id - Missing Auth
- GET /api/debug - Sensitive Data Exposure
- And 6 more...

## ⚠️ Security Notice

Educational use only. DO NOT deploy to production.

MIT License - Testing purposes only.
