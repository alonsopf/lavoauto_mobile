# lavoauto

**lavoauto** es una aplicación de servicio de lavandería desarrollada en Flutter, diseñada para facilitar la solicitud, gestión y seguimiento de servicios de lavandería en español.

---

## Características principales

- Solicitud de servicios de lavandería a domicilio
- Selección de tipo de detergente, método de secado y método de pago
- Seguimiento de pedidos y gestión de ofertas para proveedores de servicios
- Interfaz amigable y completamente en español

---

## Requisitos

- **Flutter SDK:** >=3.10.0
- **Dart:** >=3.0.0
- **Android Studio** o **VS Code** (recomendado)
- **Dispositivo o emulador Android/iOS**

---

## Instalación y configuración

1. **Clona el repositorio:**
   ```sh
   git clone https://github.com/tu_usuario/lavoauto.git
   cd lavoauto
   ```

2. **Instala las dependencias:**
   ```sh
   flutter pub get
   ```

3. **Genera las rutas automáticas (si usas auto_route):**
   ```sh
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. **Ejecuta la aplicación:**
   ```sh
   flutter run
   ```

---

## Estructura del proyecto

- `lib/presentation/screens/` — Pantallas principales de usuario y proveedor
- `lib/widgets/` — Widgets personalizados reutilizables
- `lib/utils/` — Utilidades y controladores
- `lib/routes/` — Configuración de rutas (auto_route)

---

## Comandos útiles

- **Actualizar dependencias:**  
  `flutter pub get`

- **Generar archivos de rutas (auto_route):**  
  `flutter pub run build_runner build --delete-conflicting-outputs`

- **Ejecutar en modo debug:**  
  `flutter run`

- **Compilar para producción:**  
  `flutter build apk` (Android)  
  `flutter build ios` (iOS)

---

## Notas

- La aplicación está completamente en español.
- Asegúrate de tener configurado un emulador o dispositivo físico para pruebas.
- Si agregas nuevas rutas o modelos, recuerda ejecutar el comando de generación de rutas.

---

## Licencia

Este proyecto es de código cerrado. Para uso interno y pruebas.

---

**¡Gracias por usar lavoauto!**

cred: 
user : testusermy@yopmail.com 
worker : testworkermy@yopmail.com
worker2 : testworker2my@yopmail.com

pass : 12345678