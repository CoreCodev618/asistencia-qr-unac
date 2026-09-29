import { randomUUID } from 'node:crypto';

// Repositorio en memoria para la beta. Empieza VACÍO.
// Solo contiene datos si SEED_PATH apunta a un JSON (ver repositories/index.js).
// Misma interfaz que usará el repositorio Postgres.
export function createMemoryRepository(seed = {}) {
  const state = {
    salones: new Map((seed.salones ?? []).map((s) => [s.id, s])),
    cursos: new Map((seed.cursos ?? []).map((c) => [c.id, c])),
    horarios: new Map((seed.horarios ?? []).map((h) => [h.id, h])),
    alumnosPorCodigo: new Map((seed.alumnos ?? []).map((a) => [a.codigo, a])),
    matriculas: new Set((seed.matriculas ?? []).map((m) => `${m.alumnoId}|${m.cursoId}`)),
    asistencias: [],
  };

  return {
    async listarSalones() {
      return [...state.salones.values()].sort((a, b) => a.id.localeCompare(b.id));
    },

    async getSalon(id) {
      return state.salones.get(id) ?? null;
    },

    async getCurso(id) {
      return state.cursos.get(id) ?? null;
    },

    async getHorariosPorSalon(salonId) {
      return [...state.horarios.values()].filter((h) => h.salonId === salonId);
    },

    async getAlumnoPorCodigo(codigo) {
      return state.alumnosPorCodigo.get(codigo) ?? null;
    },

    async estaMatriculado(alumnoId, cursoId) {
      return state.matriculas.has(`${alumnoId}|${cursoId}`);
    },

    async guardarAsistencia(registro) {
      const guardado = { id: randomUUID(), ...registro };
      state.asistencias.push(guardado);
      return guardado;
    },

    async listarAsistenciasPorCurso(cursoId) {
      return state.asistencias.filter((a) => a.cursoId === cursoId);
    },

    async listarAsistenciasPorSalon(salonId, desde = null) {
      return state.asistencias.filter(
        (a) => a.salonId === salonId && (!desde || a.fechaHora >= desde),
      );
    },
  };
}
