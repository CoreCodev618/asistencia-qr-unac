-- Esquema Postgres de AsistenciaQR.
-- Se aplica LUEGO (fase con BD). La beta usa repositorio en memoria
-- con estas mismas entidades y relaciones.

CREATE TABLE IF NOT EXISTS salones (
  id        TEXT PRIMARY KEY,
  nombre    TEXT NOT NULL,
  latitud   DOUBLE PRECISION,
  longitud  DOUBLE PRECISION
);

CREATE TABLE IF NOT EXISTS cursos (
  id      TEXT PRIMARY KEY,
  nombre  TEXT NOT NULL,
  codigo  TEXT,
  plan    TEXT,
  docente TEXT
);

CREATE TABLE IF NOT EXISTS horarios (
  id          TEXT PRIMARY KEY,
  salon_id    TEXT NOT NULL REFERENCES salones (id),
  curso_id    TEXT NOT NULL REFERENCES cursos (id),
  dia_semana  SMALLINT NOT NULL CHECK (dia_semana BETWEEN 0 AND 6),
  hora_inicio TIME NOT NULL,
  hora_fin    TIME NOT NULL,
  seccion     TEXT,
  tipo        TEXT,
  CHECK (hora_inicio < hora_fin)
);

CREATE TABLE IF NOT EXISTS alumnos (
  id      TEXT PRIMARY KEY,
  codigo  TEXT NOT NULL UNIQUE,
  nombres TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS matriculas (
  alumno_id TEXT NOT NULL REFERENCES alumnos (id),
  curso_id  TEXT NOT NULL REFERENCES cursos (id),
  PRIMARY KEY (alumno_id, curso_id)
);

CREATE TABLE IF NOT EXISTS asistencias (
  id            UUID PRIMARY KEY,
  salon_id      TEXT NOT NULL REFERENCES salones (id),
  alumno_id     TEXT REFERENCES alumnos (id),
  curso_id      TEXT REFERENCES cursos (id),
  codigo_alumno TEXT NOT NULL,
  fecha_hora    TIMESTAMPTZ NOT NULL DEFAULT now(),
  valida        BOOLEAN NOT NULL,
  motivos       TEXT[] NOT NULL DEFAULT '{}',
  advertencias  TEXT[] NOT NULL DEFAULT '{}',
  ubicacion_lat DOUBLE PRECISION,
  ubicacion_lng DOUBLE PRECISION
);

CREATE INDEX IF NOT EXISTS idx_asistencias_curso ON asistencias (curso_id, fecha_hora);
