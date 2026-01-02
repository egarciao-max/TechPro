# TechPro Admin iOS (SwiftUI)

Esta carpeta contiene una app SwiftUI enfocada **solo al administrador** del portal de TechPro.
Se inspiró en el flujo del `admin-kelowna-tp-92x1.html` y consume la misma API.

## Estructura
- `TechProAdminAppApp.swift`: punto de entrada de la app.
- `Views/`: pantallas de login y dashboard.
- `Models/`: modelos de datos (tickets, sesión, staff).
- `Services/`: cliente de red para el portal de administración.

## API
Se utiliza el endpoint existente:
```
https://booking-handler.techprokelowna.workers.dev
```

## Cómo usar en Xcode
1. Crea un nuevo proyecto iOS (SwiftUI) en Xcode.
2. Borra `ContentView.swift` y el `App` generado por Xcode.
3. Arrastra la carpeta `TechProAdminApp/` dentro del proyecto (marca el target).
4. Asegúrate de que `TechProAdminAppApp.swift` sea el único archivo con `@main`.
3. Ejecuta en un simulador o dispositivo.

## Inbox y Email Forwarding
- La app incluye una sección informativa para el inbox compartido.
- El correo principal que se usa en el sitio es `info@techprokelowna.com`.
- Si necesitas mostrar reglas específicas de forwarding, añade el texto en `Views/DashboardView.swift`.

## Nota
Este código evita dependencias externas para facilitar su integración.
