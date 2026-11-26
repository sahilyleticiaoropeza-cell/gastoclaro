# GastoClaro

App movil (Flutter) para registrar gastos personales, ponerles presupuesto por categoria,
adjuntar la foto del ticket y recibir avisos al acercarte al limite.

- **Stack:** Flutter (Dart) + Hive (base local cifrada) + Supabase (Auth + PostgreSQL)
- **Offline-first:** todo se guarda primero en el telefono y se sincroniza al haber conexion.

## Requisitos
- Flutter 3.22 o superior (Dart 3.3+) y un emulador o telefono
- Una cuenta gratuita en [Supabase](https://supabase.com)

## Instalacion
1. Clona el repositorio y entra a la carpeta:
   ```bash
   git clone https://github.com/<tu-usuario>/gastoclaro.git
   cd gastoclaro
   ```
2. Genera las carpetas de plataforma (si no existen) e instala dependencias:
   ```bash
   flutter create . --project-name gastoclaro --org mx.edu.gastoclaro
   flutter pub get
   ```
3. En Supabase crea un proyecto, abre **SQL Editor** y ejecuta `supabase/schema.sql`.
   (Para pruebas puedes desactivar la confirmacion de correo en Authentication > Providers > Email.)
4. Copia `env.example.json` a `env.json` y pon tu URL y la clave **anon** publica
   (`env.json` esta en `.gitignore`, nunca lo subas):
   ```json
   { "SUPABASE_URL": "https://xxxx.supabase.co", "SUPABASE_ANON_KEY": "..." }
   ```
5. Permisos:
   - **Android** (`android/app/src/main/AndroidManifest.xml`): agrega
     `<uses-permission android:name="android.permission.CAMERA"/>`,
     `<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>` y
     `<uses-permission android:name="android.permission.INTERNET"/>`.
     En `android/app/build.gradle` usa `minSdkVersion 23` y activa `coreLibraryDesugaring`
     (requerido por flutter_local_notifications; ver su README).
   - **iOS** (`ios/Runner/Info.plist`): agrega `NSCameraUsageDescription`.
6. Ejecuta:
   ```bash
   flutter run --dart-define-from-file=env.json
   ```
7. Pruebas unitarias: `flutter test`

## Funciones
Registro/inicio de sesion, CRUD de gastos, 8 categorias por defecto, presupuestos semanales o
mensuales, grafica de pastel del mes, foto del ticket con la camara, sincronizacion con
estados de carga y error, recordatorio semanal (lunes 9:00) y alerta al llegar al 80 % de un presupuesto.

## Seguridad (resumen)
Cajas Hive cifradas con AES-256 (clave en Keystore/Keychain), tokens de sesion en
almacenamiento seguro, validacion de entradas, RLS en Supabase, bloqueo temporal tras 5
intentos fallidos, secretos fuera del codigo y limpieza de datos al cerrar sesion.
Detalle en el reporte tecnico.

## Limitaciones conocidas
Las fotos de tickets son locales (no se suben). Los datos en la nube estan protegidos por TLS y RLS,
pero no cifrados de extremo a extremo. La zona horaria de los recordatorios esta fija.
