# Asistencia QR - UNAC

Sistema de asistencia con QR desarrollado con Ember.js — Proyecto I (Programación Web II).

Propuesta completa en `docs/AsistenciaQR-propuesta.md`.

## Estructura (beta, sin BD)

- `frontend/` — app Ember.js (rutas: `/salon/:salon_id`, `/registro`, `/confirmacion`, `/reporte`).
- `backend/` — API Node.js + Express (repositorio en memoria; Postgres se conecta luego).
- `docs/` — propuesta del proyecto.

Sin valores estáticos de negocio: salón, curso y alumno llegan por URL, formulario
o variables de entorno. Ver `.env.example`.

## Cómo correr

```bash
# API
cd backend && npm install && npm start   # http://localhost:3000

# Frontend (otra terminal)
cd frontend && npm install && npm start  # http://localhost:4200
```

Con datos de ejemplo (opcional): `SEED_PATH=./scripts/seed-memory.example.json npm start`
desde `backend/`. Sin `SEED_PATH` el repo empieza vacío y la API responde 404
elegantes hasta conectar Postgres (`REPO=postgres` + `DATABASE_URL`, esquema en
`backend/src/db/schema.sql`).
