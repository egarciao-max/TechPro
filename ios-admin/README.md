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
2. Reemplaza los archivos generados con el contenido de esta carpeta.
3. Ejecuta en un simulador o dispositivo.

## Nota
Este código evita dependencias externas para facilitar su integración.
