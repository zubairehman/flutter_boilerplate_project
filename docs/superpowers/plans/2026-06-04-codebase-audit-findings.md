# Codebase Audit Findings Remediation Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Remediate every finding from the read-only Flutter boilerplate audit without broad rewrites or behavior drift.

**Architecture:** Keep the existing Clean Architecture shape: presentation talks to MobX stores, stores call use cases, use cases call repositories, repositories own persistence and network access. Use TDD for behavioral fixes and keep configuration-only fixes paired with analyzer/build checks.

**Tech Stack:** Flutter, Dart, MobX, GetIt, Dio, Sembast, SharedPreferences, Flutter Secure Storage, Android Gradle.

---

## Execution Order

1. Security blockers: HTTPS/log redaction, cleartext disablement, crypto secret removal.
2. Auth correctness: real reactive auth state, no direct preferences in UI, mock auth clearly isolated.
3. Architecture/reliability: domain mapping cleanup, post cache, store lifecycle, localization safety.
4. Platform/config cleanup: Android package alignment, release signing guardrails, dependency/lint cleanup.
5. Test expansion and final verification.

## File Structure Map

### Network Security
- Modify: `lib/data/network/constants/endpoints.dart`
- Modify: `lib/core/data/network/constants/network_constants.dart` or delete after consolidation
- Modify: `android/app/src/main/AndroidManifest.xml`
- Modify: `lib/core/data/network/dio/interceptors/logging_interceptor.dart`
- Modify: `lib/data/di/module/network_module.dart`
- Test: `test/data/network/constants/endpoints_test.dart`
- Test: `test/core/data/network/dio/interceptors/logging_interceptor_test.dart`

### Local Crypto / DB Key
- Modify or delete: `lib/core/data/local/crypto_service.dart`
- Modify: `lib/data/di/module/local_module.dart`
- Modify: `lib/data/secure_storage/secure_storage_helper.dart`
- Modify: `lib/data/secure_storage/constants/secure_storage_keys.dart`
- Test: `test/data/secure_storage/secure_storage_helper_test.dart`

### Auth Flow
- Modify: `lib/domain/entity/user/user.dart`
- Modify: `lib/domain/usecase/user/login_usecase.dart`
- Modify: `lib/data/repository/user/user_repository_impl.dart`
- Modify: `lib/presentation/login/store/login_store.dart`
- Run generator: `dart run build_runner build --delete-conflicting-outputs`
- Modify: `lib/presentation/login/login.dart`
- Modify: `lib/presentation/home/home.dart`
- Modify: `lib/presentation/my_app.dart`
- Test: `test/presentation/login/store/login_store_test.dart`
- Test: `test/data/repository/user/user_repository_impl_test.dart`

### Post Cache / Domain Mapping
- Create: `lib/data/network/dto/post_dto.dart`
- Create: `lib/data/mapper/post_mapper.dart`
- Modify: `lib/domain/entity/post/post.dart`
- Modify: `lib/domain/entity/post/post_list.dart`
- Modify: `lib/data/network/apis/posts/post_api.dart`
- Modify: `lib/data/local/datasources/post/post_datasource.dart`
- Modify: `lib/data/repository/post/post_repository_impl.dart`
- Test: `test/data/repository/post/post_repository_impl_test.dart`

### DI / Dead Code / Store Lifecycle
- Modify: `lib/presentation/di/module/store_module.dart`
- Modify: screen `dispose()` methods where stores become scoped factories
- Delete or quarantine: `lib/data/network/rest_client.dart`
- Delete or wire: `lib/data/network/interceptors/error_interceptor.dart`
- Delete or wire: unused `ConnectivityService`, `DeviceInfoService`, `NetworkConstants`
- Test: `test/di/service_locator_test.dart`

### Localization / Routes / Android / Tooling
- Modify: `lib/utils/locale/app_localization.dart`
- Modify: `lib/presentation/home/store/language/language_store.dart`
- Modify: `lib/utils/routes/routes.dart`
- Modify: `android/app/build.gradle`
- Modify/move: `android/app/src/main/kotlin/.../MainActivity.kt`
- Modify: `analysis_options.yaml`
- Modify: `pubspec.yaml`
- Test: `test/utils/locale/app_localization_test.dart`

---

## Task 1: Enforce HTTPS and Safe Network Logging

**Findings covered:** cleartext HTTP, Android cleartext enabled, body-level request logging, token leakage risk.

**Files:** see Network Security map.

- [ ] **Step 1: Write endpoint security test**

```dart
// test/data/network/constants/endpoints_test.dart
import 'package:boilerplate/data/network/constants/endpoints.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('baseUrl uses HTTPS', () {
    expect(Uri.parse(Endpoints.baseUrl).scheme, 'https');
  });
}
```

- [ ] **Step 2: Run test and verify RED**

Run: `flutter test test/data/network/constants/endpoints_test.dart`

Expected: FAIL because current `Endpoints.baseUrl` uses `http`.

- [ ] **Step 3: Switch endpoint constants to HTTPS and consolidate duplicates**

Change `lib/data/network/constants/endpoints.dart`:

```dart
class Endpoints {
  Endpoints._();

  static const String baseUrl = 'https://jsonplaceholder.typicode.com';
  static const int receiveTimeout = 15000;
  static const int connectionTimeout = 30000;
  static const String getPosts = '$baseUrl/posts';
}
```

Then either delete `lib/core/data/network/constants/network_constants.dart` if unused, or make it re-export/call into `Endpoints` so only one source owns the values.

- [ ] **Step 4: Add logging redaction test**

```dart
// test/core/data/network/dio/interceptors/logging_interceptor_test.dart
import 'package:boilerplate/core/data/network/dio/interceptors/logging_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('redacts sensitive headers and request fields', () async {
    final logs = <Object>[];
    final interceptor = LoggingInterceptor(logPrint: logs.add);

    final options = RequestOptions(
      path: '/login',
      headers: {'Authorization': 'Bearer secret', 'Cookie': 'sid=secret'},
      data: {'username': 'a@example.com', 'password': 'secret'},
    );

    interceptor.onRequest(options, RequestInterceptorHandler());

    final output = logs.join('\n');
    expect(output, isNot(contains('Bearer secret')));
    expect(output, isNot(contains('sid=secret')));
    expect(output, isNot(contains('password: secret')));
    expect(output, contains('<redacted>'));
  });
}
```

- [ ] **Step 5: Run test and verify RED**

Run: `flutter test test/core/data/network/dio/interceptors/logging_interceptor_test.dart`

Expected: FAIL because the interceptor prints raw headers/data.

- [ ] **Step 6: Implement minimal redaction and debug-only registration**

Add redaction helpers inside `LoggingInterceptor`:

```dart
static const _sensitiveKeys = {'authorization', 'cookie', 'set-cookie', 'password', 'token'};

Object? _redactValue(String key, Object? value) {
  return _sensitiveKeys.contains(key.toLowerCase()) ? '<redacted>' : value;
}

Map<dynamic, dynamic> _redactMap(Map<dynamic, dynamic> input) {
  return input.map((key, value) => MapEntry(key, _redactValue(key.toString(), value)));
}
```

Use `_redactValue()` when printing headers and `_redactMap()` when printing request maps.

In `NetworkModule`, register logging only in debug mode:

```dart
if (kDebugMode) {
  dio.interceptors.add(LoggingInterceptor(level: Level.basic, logPrint: debugPrint));
}
```

- [ ] **Step 7: Disable Android cleartext traffic**

Change `android/app/src/main/AndroidManifest.xml`:

```xml
<application
    android:icon="@mipmap/ic_launcher"
    android:label="Boilerplate Project"
    android:usesCleartextTraffic="false">
```

- [ ] **Step 8: Verify GREEN**

Run:

```bash
flutter test test/data/network/constants/endpoints_test.dart test/core/data/network/dio/interceptors/logging_interceptor_test.dart
flutter analyze
```

Expected: tests pass and analyzer does not introduce new diagnostics.

- [ ] **Step 9: Commit**

```bash
git add lib/data/network/constants/endpoints.dart lib/core/data/network/constants/network_constants.dart lib/core/data/network/dio/interceptors/logging_interceptor.dart lib/data/di/module/network_module.dart android/app/src/main/AndroidManifest.xml test/data/network/constants/endpoints_test.dart test/core/data/network/dio/interceptors/logging_interceptor_test.dart
git commit -m "fix: secure network defaults"
```

---

## Task 2: Remove Unsafe Homemade Crypto and Source-Code Secret

**Findings covered:** custom AES-like crypto, weak IV, hardcoded encryption secret.

- [ ] **Step 1: Write secure-storage DB key test**

```dart
// test/data/secure_storage/secure_storage_helper_test.dart
import 'package:boilerplate/data/secure_storage/secure_storage_helper.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('database encryption key is generated once and reused', () async {
    FlutterSecureStorage.setMockInitialValues({});
    final helper = SecureStorageHelper(const FlutterSecureStorage());

    final first = await helper.getOrCreateDatabaseEncryptionKey();
    final second = await helper.getOrCreateDatabaseEncryptionKey();

    expect(first, isNotEmpty);
    expect(second, first);
    expect(first, isNot('your-app-secret-key-change-in-production'));
  });
}
```

- [ ] **Step 2: Run test and verify RED**

Run: `flutter test test/data/secure_storage/secure_storage_helper_test.dart`

Expected: FAIL because `getOrCreateDatabaseEncryptionKey()` does not exist.

- [ ] **Step 3: Add secure-storage key support**

Modify `lib/data/secure_storage/constants/secure_storage_keys.dart`:

```dart
class SecureStorageKeys {
  SecureStorageKeys._();

  static const String authToken = 'authToken';
  static const String databaseEncryptionKey = 'databaseEncryptionKey';
}
```

Modify `SecureStorageHelper`:

```dart
import 'dart:convert';
import 'dart:math';

Future<String> getOrCreateDatabaseEncryptionKey() async {
  final existing = await _secureStorage.read(key: SecureStorageKeys.databaseEncryptionKey);
  if (existing != null && existing.isNotEmpty) return existing;

  final random = Random.secure();
  final bytes = List<int>.generate(32, (_) => random.nextInt(256));
  final key = base64UrlEncode(bytes);
  await _secureStorage.write(key: SecureStorageKeys.databaseEncryptionKey, value: key);
  return key;
}
```

- [ ] **Step 4: Use generated DB key in local DI**

Modify `lib/data/di/module/local_module.dart` so `SembastClient.provideDatabase()` receives the generated key:

```dart
final dbEncryptionKey = await getIt<SecureStorageHelper>().getOrCreateDatabaseEncryptionKey();

getIt.registerSingletonAsync<SembastClient>(
  () async => SembastClient.provideDatabase(
    databaseName: DBConstants.dbName,
    databasePath: kIsWeb ? '/assets/db' : (await getApplicationDocumentsDirectory()).path,
    encryptionKey: dbEncryptionKey,
  ),
);
```

- [ ] **Step 5: Delete or quarantine `CryptoService`**

If no references remain, delete `lib/core/data/local/crypto_service.dart`. If retained for non-encryption hashing, rename it to a hashing helper and remove misleading AES comments and encryption methods.

- [ ] **Step 6: Verify GREEN**

Run:

```bash
flutter test test/data/secure_storage/secure_storage_helper_test.dart
flutter analyze
```

Expected: test passes; no unused `CryptoService` registration remains.

- [ ] **Step 7: Commit**

```bash
git add lib/data/secure_storage lib/data/di/module/local_module.dart lib/core/data/local/crypto_service.dart test/data/secure_storage/secure_storage_helper_test.dart
git commit -m "fix: remove hardcoded database secret"
```

---

## Task 3: Make Auth State Observable and Bootstrap Safely

**Findings covered:** non-reactive `isLoggedIn`, wrong initial screen risk, direct auth state mutation.

- [ ] **Step 1: Write store bootstrap test**

```dart
// test/presentation/login/store/login_store_test.dart
import 'package:boilerplate/presentation/login/store/login_store.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('auth bootstrap exposes loading then logged-in state', () async {
    final store = buildUserStoreForTest(initialLoggedIn: true);

    expect(store.isAuthBootstrapped, isFalse);
    await store.bootstrapAuth();

    expect(store.isAuthBootstrapped, isTrue);
    expect(store.isLoggedIn, isTrue);
  });
}
```

Add a small test helper in the same file that supplies fake use cases. Keep it local to the test file.

- [ ] **Step 2: Run test and verify RED**

Run: `flutter test test/presentation/login/store/login_store_test.dart`

Expected: FAIL because `isAuthBootstrapped` and `bootstrapAuth()` do not exist and `isLoggedIn` is not observable.

- [ ] **Step 3: Update `UserStore` state**

Modify `lib/presentation/login/store/login_store.dart`:

```dart
@observable
bool isLoggedIn = false;

@observable
bool isAuthBootstrapped = false;

@action
Future<void> bootstrapAuth() async {
  isLoggedIn = await _isLoggedInUseCase.call(params: null);
  isAuthBootstrapped = true;
}
```

Remove the constructor `.then()` bootstrap and call `bootstrapAuth()` from app startup or `MyApp` initialization.

- [ ] **Step 4: Gate routing on auth bootstrap**

Modify `lib/presentation/my_app.dart` to render a loading screen while `!_userStore.isAuthBootstrapped`, then choose login/home based on `isLoggedIn`.

```dart
if (!_userStore.isAuthBootstrapped) {
  return const MaterialApp(home: Scaffold(body: Center(child: CircularProgressIndicator())));
}
```

- [ ] **Step 5: Regenerate MobX code**

Run: `dart run build_runner build --delete-conflicting-outputs`

Expected: `login_store.g.dart` includes atoms for `isLoggedIn` and `isAuthBootstrapped`.

- [ ] **Step 6: Verify GREEN**

Run:

```bash
flutter test test/presentation/login/store/login_store_test.dart
flutter analyze
```

- [ ] **Step 7: Commit**

```bash
git add lib/presentation/login/store lib/presentation/my_app.dart test/presentation/login/store/login_store_test.dart
git commit -m "fix: make auth state reactive"
```

---

## Task 4: Route Login and Logout Through Domain/Store Only

**Findings covered:** presentation writes `SharedPreferences` directly; inconsistent login/logout state.

- [ ] **Step 1: Write UI/static boundary test**

```dart
// test/architecture/presentation_boundaries_test.dart
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('presentation does not import SharedPreferences or preference keys', () {
    final files = Directory('lib/presentation')
        .listSync(recursive: true)
        .whereType<File>()
        .where((file) => file.path.endsWith('.dart'));

    for (final file in files) {
      final content = file.readAsStringSync();
      expect(content, isNot(contains('package:shared_preferences/shared_preferences.dart')), reason: file.path);
      expect(content, isNot(contains('data/sharedpref/constants/preferences.dart')), reason: file.path);
    }
  });
}
```

- [ ] **Step 2: Run test and verify RED**

Run: `flutter test test/architecture/presentation_boundaries_test.dart`

Expected: FAIL for `login.dart` and `home.dart`.

- [ ] **Step 3: Remove direct preference write from login navigation**

Modify `lib/presentation/login/login.dart`: delete lines that call `SharedPreferences.getInstance()` in `navigate()`. `UserStore.login()` already persists login state.

- [ ] **Step 4: Route logout through `UserStore.logout()`**

Modify `lib/presentation/home/home.dart`:

```dart
onPressed: () async {
  await _userStore.logout();
  if (!mounted) return;
  Navigator.of(context).pushReplacementNamed(Routes.login);
},
```

Inject/resolve `UserStore` in `HomeScreen` if not already available.

- [ ] **Step 5: Verify GREEN**

Run:

```bash
flutter test test/architecture/presentation_boundaries_test.dart
flutter analyze
```

- [ ] **Step 6: Commit**

```bash
git add lib/presentation/login/login.dart lib/presentation/home/home.dart test/architecture/presentation_boundaries_test.dart
git commit -m "fix: keep auth persistence out of UI"
```

---

## Task 5: Make Mock Auth Explicit or Implement Token Persistence

**Findings covered:** fake login always succeeds, empty `User`, unused `SecureStorageHelper`, analyzer warning.

- [ ] **Step 1: Decide mode**

Choose one path before coding:

1. Template/demo mode: rename implementation to make the mock explicit.
2. Real auth mode: add an API endpoint and persist returned token.

For this boilerplate, use template/demo mode unless a real backend exists.

- [ ] **Step 2: Write repository test for demo auth constraints**

```dart
// test/data/repository/user/user_repository_impl_test.dart
import 'package:boilerplate/domain/usecase/user/login_usecase.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('demo login returns a non-empty demo user and saves no auth token', () async {
    final repo = buildUserRepositoryForTest();

    final user = await repo.login(LoginParams(username: 'demo@example.com', password: 'password'));

    expect(user?.id, 'demo-user');
    expect(user?.email, 'demo@example.com');
  });
}
```

- [ ] **Step 3: Run test and verify RED**

Run: `flutter test test/data/repository/user/user_repository_impl_test.dart`

Expected: FAIL because `User` has no fields.

- [ ] **Step 4: Add minimal immutable `User` fields**

Modify `lib/domain/entity/user/user.dart`:

```dart
class User {
  const User({required this.id, required this.email});

  final String id;
  final String email;
}
```

- [ ] **Step 5: Return explicit demo user and remove unused secure storage injection if demo mode**

Modify `UserRepositoryImpl.login()`:

```dart
Future<User?> login(LoginParams params) async {
  await Future<void>.delayed(const Duration(seconds: 2));
  return User(id: 'demo-user', email: params.username);
}
```

If token storage is not used in demo mode, remove `_secureStorageHelper` from constructor and DI to clear the analyzer warning. If real auth mode is chosen, keep it and write/read/remove the token in login/logout.

- [ ] **Step 6: Verify GREEN**

Run:

```bash
flutter test test/data/repository/user/user_repository_impl_test.dart
flutter analyze
```

- [ ] **Step 7: Commit**

```bash
git add lib/domain/entity/user/user.dart lib/data/repository/user/user_repository_impl.dart lib/data/di/module/repository_module.dart test/data/repository/user/user_repository_impl_test.dart
git commit -m "fix: make demo auth explicit"
```

---

## Task 6: Move Serialization Out of Domain Entities

**Findings covered:** domain imports `json_annotation`; `Post`/`PostList` parse maps/JSON; password DTO serializes in domain.

- [ ] **Step 1: Add architecture boundary test**

```dart
// test/architecture/domain_boundaries_test.dart
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('domain layer does not import data serialization packages', () {
    final files = Directory('lib/domain')
        .listSync(recursive: true)
        .whereType<File>()
        .where((file) => file.path.endsWith('.dart'));

    for (final file in files) {
      final content = file.readAsStringSync();
      expect(content, isNot(contains('json_annotation')), reason: file.path);
      expect(content, isNot(contains('fromJson')), reason: file.path);
      expect(content, isNot(contains('toJson')), reason: file.path);
      expect(content, isNot(contains('fromMap')), reason: file.path);
      expect(content, isNot(contains('toMap')), reason: file.path);
    }
  });
}
```

- [ ] **Step 2: Run test and verify RED**

Run: `flutter test test/architecture/domain_boundaries_test.dart`

Expected: FAIL for `login_usecase.dart`, `post.dart`, and `post_list.dart`.

- [ ] **Step 3: Make domain models immutable and mapping-free**

Modify `lib/domain/entity/post/post.dart`:

```dart
class Post {
  const Post({required this.userId, required this.id, required this.title, required this.body});

  final int userId;
  final int id;
  final String title;
  final String body;
}
```

Modify `PostList`:

```dart
class PostList {
  const PostList({required this.posts});

  final List<Post> posts;
}
```

- [ ] **Step 4: Create DTO/mapper in data layer**

```dart
// lib/data/network/dto/post_dto.dart
class PostDto {
  const PostDto({required this.userId, required this.id, required this.title, required this.body});

  final int userId;
  final int id;
  final String title;
  final String body;

  factory PostDto.fromJson(Map<String, dynamic> json) => PostDto(
        userId: json['userId'] as int,
        id: json['id'] as int,
        title: json['title'] as String,
        body: json['body'] as String,
      );

  Map<String, dynamic> toJson() => {'userId': userId, 'id': id, 'title': title, 'body': body};
}
```

```dart
// lib/data/mapper/post_mapper.dart
import 'package:boilerplate/data/network/dto/post_dto.dart';
import 'package:boilerplate/domain/entity/post/post.dart';

extension PostDtoMapper on PostDto {
  Post toDomain() => Post(userId: userId, id: id, title: title, body: body);
}

extension PostDomainMapper on Post {
  PostDto toDto() => PostDto(userId: userId, id: id, title: title, body: body);
}
```

- [ ] **Step 5: Remove JSON serialization from `LoginParams`**

Modify `login_usecase.dart` to remove `json_annotation`, `part`, `fromJson`, and `toJson`.

- [ ] **Step 6: Update API/data source call sites**

Update `PostApi`, `PostDataSource`, and `PostRepositoryImpl` to map raw JSON to `PostDto`, then domain `Post`.

- [ ] **Step 7: Verify GREEN**

Run:

```bash
flutter test test/architecture/domain_boundaries_test.dart
flutter analyze
```

- [ ] **Step 8: Commit**

```bash
git add lib/domain lib/data/network/dto lib/data/mapper lib/data/network/apis/posts lib/data/local/datasources/post test/architecture/domain_boundaries_test.dart
git commit -m "refactor: keep domain models transport agnostic"
```

---

## Task 7: Make Post Cache Awaited, Deduplicated, and Useful Offline

**Findings covered:** unawaited cache writes, duplicate local rows, no offline fallback.

- [ ] **Step 1: Write repository cache tests**

```dart
// test/data/repository/post/post_repository_impl_test.dart
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('getPosts upserts remote posts into cache once', () async {
    final repo = buildPostRepositoryForTest(remotePosts: [samplePost(id: 1)]);

    await repo.getPosts();
    await repo.getPosts();

    expect(await repo.cachedPostCountForTest(), 1);
  });

  test('getPosts returns cached posts when remote request fails', () async {
    final repo = buildPostRepositoryForTest(
      remotePosts: [samplePost(id: 1)],
      failSecondRemoteCall: true,
    );

    await repo.getPosts();
    final posts = await repo.getPosts();

    expect(posts.posts.single.id, 1);
  });
}
```

- [ ] **Step 2: Run test and verify RED**

Run: `flutter test test/data/repository/post/post_repository_impl_test.dart`

Expected: FAIL because inserts are not awaited/upserted and fallback does not exist.

- [ ] **Step 3: Add upsert method in `PostDataSource`**

```dart
Future<void> upsert(Post post) async {
  final finder = Finder(filter: Filter.equals(DBConstants.fieldId, post.id));
  final existing = await _postStore.findFirst(_db, finder: finder);
  if (existing == null) {
    await insert(post);
  } else {
    await _postStore.record(existing.key).update(_db, post.toMap());
  }
}
```

If Task 6 removed `toMap()` from domain, use `post.toDto().toJson()` instead.

- [ ] **Step 4: Await cache writes and fallback**

Modify `PostRepositoryImpl.getPosts()`:

```dart
Future<PostList> getPosts() async {
  try {
    final postsList = await _postApi.getPosts();
    for (final post in postsList.posts) {
      await _postDataSource.upsert(post);
    }
    return postsList;
  } catch (_) {
    final cached = await _postDataSource.getPostsFromDb();
    if (cached.isNotEmpty) return PostList(posts: cached);
    rethrow;
  }
}
```

- [ ] **Step 5: Verify GREEN**

Run:

```bash
flutter test test/data/repository/post/post_repository_impl_test.dart
flutter analyze
```

- [ ] **Step 6: Commit**

```bash
git add lib/data/repository/post/post_repository_impl.dart lib/data/local/datasources/post/post_datasource.dart test/data/repository/post/post_repository_impl_test.dart
git commit -m "fix: make post cache reliable"
```

---

## Task 8: Rationalize Store Lifetimes and Disposal

**Findings covered:** singleton feature stores retain stale state; disposers exist but screens do not own lifecycle.

- [ ] **Step 1: Choose lifecycle rule**

Use this rule: app-wide stores (`ThemeStore`, `LanguageStore`, `UserStore`) may be singletons; feature/screen stores (`PostStore`, `FormStore`, `ErrorStore`) should be factories/scoped and disposed by owners when they create reactions.

- [ ] **Step 2: Write DI registration test**

```dart
// test/di/store_module_test.dart
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('feature stores are not shared singleton instances', () async {
    await configureTestServiceLocator();

    final first = getIt<PostStore>();
    final second = getIt<PostStore>();

    expect(identical(first, second), isFalse);
  });
}
```

- [ ] **Step 3: Run test and verify RED**

Run: `flutter test test/di/store_module_test.dart`

Expected: FAIL because `PostStore` is currently a singleton.

- [ ] **Step 4: Change feature stores to factories**

Modify `lib/presentation/di/module/store_module.dart`:

```dart
getIt.registerFactory<PostStore>(() => PostStore(getIt<GetPostUseCase>(), getIt<ErrorStore>()));
```

Keep `ThemeStore`, `LanguageStore`, and `UserStore` as singletons if they represent app-wide state.

- [ ] **Step 5: Dispose factory stores in screen state classes**

For screens that create stores with reactions, call their `dispose()` from `State.dispose()`.

- [ ] **Step 6: Verify GREEN**

Run:

```bash
flutter test test/di/store_module_test.dart
flutter analyze
```

- [ ] **Step 7: Commit**

```bash
git add lib/presentation/di/module/store_module.dart lib/presentation/post test/di/store_module_test.dart
git commit -m "refactor: scope feature stores"
```

---

## Task 9: Remove or Wire Unused Infrastructure

**Findings covered:** unused `RestClient`, duplicate clients/interceptors, unused `EventBus` error events, unused `ConnectivityService`, `DeviceInfoService`, `NetworkConstants`.

- [ ] **Step 1: Write unused-infrastructure guard test**

```dart
// test/architecture/no_dead_infrastructure_test.dart
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('removed sample infrastructure is not registered in DI', () {
    final networkModule = File('lib/data/di/module/network_module.dart').readAsStringSync();
    expect(networkModule, isNot(contains('RestClient')));
    expect(networkModule, isNot(contains('EventBus')));
  });
}
```

- [ ] **Step 2: Run test and verify RED**

Run: `flutter test test/architecture/no_dead_infrastructure_test.dart`

Expected: FAIL while unused services remain registered.

- [ ] **Step 3: Delete unused second HTTP client path**

Remove `RestClient` registration. Delete `lib/data/network/rest_client.dart` if no imports remain.

- [ ] **Step 4: Delete or wire EventBus error handling**

Preferred YAGNI path: remove `ErrorInterceptor`, `ErrorEvent`, and `EventBus` DI registration if no UI consumes it.

- [ ] **Step 5: Delete duplicate constants and unused service registrations**

Remove `NetworkConstants` if Task 1 consolidated it. Remove `ConnectivityService` and `DeviceInfoService` registrations unless a repository or feature consumes them now.

- [ ] **Step 6: Verify references are gone**

Run:

```bash
flutter test test/architecture/no_dead_infrastructure_test.dart
flutter analyze
```

- [ ] **Step 7: Commit**

```bash
git add lib/data/di/module lib/data/network lib/core/data/network/constants test/architecture/no_dead_infrastructure_test.dart
git commit -m "refactor: remove unused infrastructure"
```

---

## Task 10: Make Localization and Language Selection Safe

**Findings covered:** missing translation force-unwrap crash; language lookup may index `-1`.

- [ ] **Step 1: Write localization fallback test**

```dart
// test/utils/locale/app_localization_test.dart
import 'package:boilerplate/utils/locale/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('translate returns key when translation is missing', () {
    final localizations = AppLocalizations(const Locale('en'));
    localizations.localizedStrings = {'known': 'Known'};

    expect(localizations.translate('missing_key'), 'missing_key');
  });
}
```

- [ ] **Step 2: Run test and verify RED**

Run: `flutter test test/utils/locale/app_localization_test.dart`

Expected: FAIL because `translate()` force-unwraps missing key.

- [ ] **Step 3: Add safe fallback**

Modify `AppLocalizations.translate()`:

```dart
String translate(String key) => localizedStrings[key] ?? key;
```

- [ ] **Step 4: Guard missing language code**

Modify `LanguageStore.changeLanguage(String value)`:

```dart
final index = supportedLanguages.indexWhere((language) => language.locale == value);
if (index == -1) {
  errorStore.errorMessage = 'Unsupported language: $value';
  return;
}
```

- [ ] **Step 5: Verify GREEN**

Run:

```bash
flutter test test/utils/locale/app_localization_test.dart
flutter analyze
```

- [ ] **Step 6: Commit**

```bash
git add lib/utils/locale/app_localization.dart lib/presentation/home/store/language/language_store.dart test/utils/locale/app_localization_test.dart
git commit -m "fix: add localization fallbacks"
```

---

## Task 11: Align Android Package and Release Signing Guardrails

**Findings covered:** package/activity mismatch, release build uses debug signing.

- [ ] **Step 1: Choose canonical package**

Use `com.iotecksolutions.todoapp` because it already appears in `namespace`, `applicationId`, and manifest.

- [ ] **Step 2: Move/fix `MainActivity` package**

Move file to:

`android/app/src/main/kotlin/com/iotecksolutions/todoapp/MainActivity.kt`

Contents:

```kotlin
package com.iotecksolutions.todoapp

import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity()
```

Delete the old mismatched file path.

- [ ] **Step 3: Add release signing guardrail**

For template safety, either document debug signing clearly or require real signing properties for release. Preferred production-safe Gradle shape:

```gradle
release {
    if (project.hasProperty('RELEASE_STORE_FILE')) {
        signingConfig signingConfigs.release
    } else {
        throw new GradleException('Release signing is not configured. Set RELEASE_STORE_FILE and related properties.')
    }
}
```

- [ ] **Step 4: Verify Android build configuration**

Run:

```bash
flutter build apk --debug
flutter analyze
```

Expected: debug APK builds; analyzer passes. Do not run release build until signing properties exist.

- [ ] **Step 5: Commit**

```bash
git add android/app/build.gradle android/app/src/main/kotlin
git commit -m "fix: align Android application package"
```

---

## Task 12: Tighten Analyzer and Dependency Configuration

**Findings covered:** thin lints, runtime codegen deps, pinned analyzer risk, current analyzer warning.

- [ ] **Step 1: Update analyzer options**

Modify `analysis_options.yaml`:

```yaml
include: package:flutter_lints/flutter.yaml

analyzer:
  exclude:
    - "**/*.g.dart"
  language:
    strict-casts: true
    strict-inference: true
    strict-raw-types: true

linter:
  rules:
    avoid_print: true
    unawaited_futures: true
    prefer_final_fields: true
    prefer_single_quotes: true
    use_super_parameters: true
```

- [ ] **Step 2: Move codegen deps**

Modify `pubspec.yaml`:

```yaml
dependencies:
  json_annotation: ^4.12.0

dev_dependencies:
  json_serializable: ^6.6.1
  mobx_codegen: ^2.2.0
  build_runner: ^2.3.3
```

Remove `analyzer` unless a concrete `build_runner` conflict requires it.

- [ ] **Step 3: Resolve new diagnostics in small commits**

Run: `flutter analyze`

Expected: strict rules may reveal additional issues. Fix them in focused commits without changing behavior.

- [ ] **Step 4: Verify dependency graph**

Run:

```bash
flutter pub get
flutter analyze
flutter test
```

- [ ] **Step 5: Commit**

```bash
git add analysis_options.yaml pubspec.yaml pubspec.lock
git commit -m "chore: tighten Dart analysis"
```

---

## Task 13: Expand Test Coverage for Core Flows

**Findings covered:** only two test files; no tests for repositories, stores, DI, interceptors, auth flow, cache flow, localization.

- [ ] **Step 1: Add test folders**

Create:

```text
test/architecture/
test/core/data/network/dio/interceptors/
test/data/repository/post/
test/data/repository/user/
test/di/
test/presentation/login/store/
test/utils/locale/
```

- [ ] **Step 2: Keep tests created by Tasks 1-12**

Do not collapse tests into one large file. Keep each test close to its layer and behavior.

- [ ] **Step 3: Fix misleading widget test name**

Modify `test/widget_test.dart` test name from counter wording to app bootstrap wording:

```dart
testWidgets('app renders without crashing', (WidgetTester tester) async {
  await tester.pumpWidget(MyApp());
  await tester.pump();
});
```

- [ ] **Step 4: Add DI smoke test**

```dart
// test/di/service_locator_test.dart
import 'package:boilerplate/di/service_locator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('service locator configures without throwing', () async {
    await setUpServiceLocator();
    expect(getIt.isRegistered<UserStore>(), isTrue);
  });
}
```

Adjust imports and setup teardown to match the actual service-locator API.

- [ ] **Step 5: Verify full test suite**

Run:

```bash
flutter test
flutter analyze
```

- [ ] **Step 6: Commit**

```bash
git add test
git commit -m "test: cover core app flows"
```

---

## Task 14: Final Verification Pass

**Findings covered:** integration risk across all prior changes.

- [ ] **Step 1: Regenerate code**

Run: `dart run build_runner build --delete-conflicting-outputs`

Expected: generated MobX/JSON files are up to date.

- [ ] **Step 2: Format**

Run: `dart format lib test`

Expected: no formatting errors.

- [ ] **Step 3: Analyze**

Run: `flutter analyze`

Expected: no errors or warnings.

- [ ] **Step 4: Test**

Run: `flutter test`

Expected: all tests pass.

- [ ] **Step 5: Build Android debug**

Run: `flutter build apk --debug`

Expected: debug APK builds successfully.

- [ ] **Step 6: Review dependency and source diff**

Run:

```bash
git status --short
git diff --stat
git diff -- lib test android pubspec.yaml analysis_options.yaml
```

Expected: changes match this plan; no generated secrets or local files are committed.

- [ ] **Step 7: Final commit**

```bash
git add .
git commit -m "chore: complete audit remediation"
```

---

## Self-Review Checklist

- Spec coverage: all audit findings are mapped to Tasks 1-14.
- Security coverage: HTTPS, logging redaction, cleartext disablement, crypto secret removal, token/auth posture.
- Architecture coverage: UI persistence boundary, domain serialization boundary, DI/store lifecycle, dead infrastructure cleanup.
- Reliability coverage: auth bootstrap, post cache fallback, localization fallback, Android launch package alignment.
- Test coverage: every behavior change has a RED/GREEN test step before implementation.
- No broad rewrites: each task is independently testable and committable.
