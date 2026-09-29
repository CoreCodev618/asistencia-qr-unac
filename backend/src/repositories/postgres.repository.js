import { getPool } from '../db/pool.js';

// Stub del repositorio Postgres para la fase con BD.
// Misma interfaz que memory.repository.js. En beta cada método falla
// con un mensaje claro; el SQL real va en comentarios listo para usar.
function noDb() {
  throw new Error('BD no configurada en beta: define DATABASE_URL y REPO=postgres');
}

export function createPostgresRepository() {
  return {
    async listarSalones() {
      // SELECT id, nombre, latitud, longitud FROM salones ORDER BY id
      getPool();
      return noDb();
    },

    async getSalon() {
      // SELECT id, nombre, latitud, longitud FROM salones WHERE id = $1
      getPool();
      return noDb();
    },

    async getCurso() {
      // SELECT id, nombre, codigo, plan, docente FROM cursos WHERE id = $1
      getPool();
      return noDb();
    },

    async getHorariosPorSalon() {
      // SELECT id, salon_id AS "salonId", curso_id AS "cursoId",
      //        dia_semana AS "diaSemana",
      //        to_char(hora_inicio,'HH24:MI') AS "horaInicio",
      //        to_char(hora_fin,'HH24:MI') AS "horaFin",
      //        seccion, tipo
      //   FROM horarios WHERE salon_id = $1
      getPool();
      return noDb();
    },

    async getAlumnoPorCodigo() {
      // SELECT id, codigo, nombres FROM alumnos WHERE codigo = $1
      getPool();
      return noDb();
    },

    async estaMatriculado() {
      // SELECT 1 FROM matriculas WHERE alumno_id = $1 AND curso_id = $2
      getPool();
      return noDb();
    },

    async guardarAsistencia() {
      // INSERT INTO asistencias (...) VALUES (...) RETURNING *
      getPool();
      return noDb();
    },

    async listarAsistenciasPorCurso() {
      // SELECT * FROM asistencias WHERE curso_id = $1 ORDER BY fecha_hora
      getPool();
      return noDb();
    },

    async listarAsistenciasPorSalon() {
      // SELECT * FROM asistencias
      //  WHERE salon_id = $1 AND fecha_hora >= $2
      //  ORDER BY fecha_hora DESC
      getPool();
      return noDb();
    },
  };
}
