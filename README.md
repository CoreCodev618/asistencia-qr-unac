# Asistencia QR - UNAC

Sistema de asistencia con QR para la Universidad Nacional del Centro del Perú (UNAC), Facultad de Ingeniería de Sistemas e Informática (FIIS). Desarrollado con Ember.js + Node.js/Express.

## Características

- **QR fijo por salón** — Cada aula tiene un código QR único que los alumnos escanean al entrar
- **Validación automática** — Verifica horario, matrícula y ubicación (GPS) del alumno
- **Asistencias en vivo** — La pantalla del salón se actualiza cada 5 segundos
- **Programación horaria real** — Incluye la programación oficial 2026B (22 aulas, 58 cursos, 165 horarios)
- **API REST** — Backend con Node.js + Express, listo para conectar a PostgreSQL

## Vistas

| Ruta | Usuario | Descripción |
|------|---------|-------------|
| `/` | Profesor | QR del aula + cursos + asistencias en vivo (polling cada 5s) |
| `/alumno?salon=ID` | Alumno | Formulario para marcar asistencia con su código |

## Estructura del proyecto

```
AsistenciaQR/
├── frontend/          # App Ember.js + Vite
│   └── app/
│       ├── components/
│       │   ├── pantalla-qr.gjs      # Vista del salón (QR + cursos)
│       │   ├── asistencias-vivo.gjs  # Componente de polling
│       │   └── alumno-form.gjs       # Formulario del alumno
│       ├── routes/
│       │   ├── index.js             # Ruta del salón
│       │   └── alumno.js            # Ruta del alumno
│       └── styles/
│           └── app.css              # Estilos globales
├── backend/           # API Node.js + Express
│   ├── src/
│   │   ├── controllers/  # Controladores de API
│   │   ├── services/     # Lógica de negocio
│   │   ├── repositories/ # Acceso a datos (memoria/Postgres)
│   │   └── routes/       # Definición de rutas
│   └── scripts/
│       └── seed-horario-2026b.json  # Programación horaria oficial
└── docs/              # Documentación del proyecto
```

## API Endpoints

| Método | Ruta | Descripción |
|--------|------|-------------|
| GET | `/api/health` | Estado del servidor |
| GET | `/api/salones` | Lista de aulas |
| GET | `/api/salones/:id` | Detalle del aula con cursos |
| GET | `/api/salones/:id/asistencias` | Asistencias del día |
| POST | `/api/asistencias` | Registrar asistencia |
| GET | `/api/reporte/:cursoId` | Reporte por curso |

## Cómo ejecutar

### Requisitos

- Node.js 18+
- npm

### Backend

```bash
cd backend
npm install
SEED_PATH=./scripts/seed-horario-2026b.json npm start
# API disponible en http://localhost:3000
```

### Frontend

```bash
cd frontend
npm install
npm start -- --host
# App disponible en http://localhost:4200
# Usa --host para exponer la IP de red (necesario para QR)
```

### Probar el flujo

1. Abre la pantalla del salón con la IP de red: `http://<IP>:4200/`
2. Selecciona un aula (ej. `FIIS1T01`)
3. Escanea el QR con tu celular o abre `http://<IP>:4200/alumno?salon=FIIS1T01`
4. Elige tu curso y escribe tu código de alumno (ej. `20260001`)
5. La pantalla del salón se actualiza automáticamente

## Próximos pasos

- [ ] Conectar PostgreSQL para persistencia real
- [ ] Dashboard del profesor con estadísticas
- [ ] Asistente IA integrado
- [ ] Mejorar diseño UI/UX
- [ ] Notificaciones en tiempo real (WebSocket)
- [ ] PWA para funcionar offline
