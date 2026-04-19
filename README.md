# Spring Petclinic Flutter

Flutter mobile frontend for Spring Petclinic. This app mirrors the functional
flows of the Angular frontend and targets the same REST backend exposed by
`spring-petclinic-rest`.

## Backend

Start the backend first:

```bash
cd ~/spring-petclinic-rest
./mvnw spring-boot:run
```

The expected API is:

```text
http://localhost:9966/petclinic/api
```

## Android base URL

For Android emulators, the app defaults to:

```text
http://10.0.2.2:9966/petclinic/api
```

That value is defined in:

```text
lib/shared/config/api_config.dart
```

You can override it at runtime:

```bash
flutter run --dart-define=PETCLINIC_API_BASE_URL=http://<host>:9966/petclinic/api
```

## Run

```bash
cd ~/spring-petclinic-flutter
flutter pub get
flutter run
```

## Validation

Verified locally with:

```bash
flutter analyze
flutter test
flutter build apk --debug
```
