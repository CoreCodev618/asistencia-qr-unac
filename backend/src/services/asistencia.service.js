import { env } from '../config/env.js';
import { horarioVigente, validarAsistencia } from './validacion.service.js';

function httpError(status, message) {
  const e = new Error(message);
  e.status = status;
  return e;
}

export function createAsistenciaService(repo) {
  return {
    async salonConCursoActual(salonId, ahora = new Date()) {
      const salon = await repo.getSalon(salonId);
      if (!salon) return null;
      const horarios = await repo.getHorariosPorSalon(salonId);
      const horario = horarioVigente(horarios, ahora);
      const curso = horario ? await repo.getCurso(horario.cursoId) : null;
      return { salon, horario, curso };
    },

    async registrar({ salonId, codigoAlumno, ubicacion = null, ahora = new Date() }) {
      const salon = await repo.getSalon(salonId);
      if (!salon) throw httpError(404, 'Salón no encontrado');
      const alumno = await repo.getAlumnoPorCodigo(codigoAlumno);
      if (!alumno) throw httpError(404, 'Alumno no encontrado');

      const horarios = await repo.getHorariosPorSalon(salonId);
      const horario = horarioVigente(horarios, ahora);
      const matriculado = horario ? await repo.estaMatriculado(alumno.id, horario.cursoId) : false;

      const { valida, motivos, advertencias } = validarAsistencia({
        horario,
        matriculado,
        salon,
        ubicacion,
        umbralMetros: env.umbralMetros,
      });

      return repo.guardarAsistencia({
        salonId,
        alumnoId: alumno.id,
        cursoId: horario?.cursoId ?? null,
        codigoAlumno: alumno.codigo,
        fechaHora: ahora.toISOString(),
        valida,
        motivos,
        advertencias,
        ubicacionLat: ubicacion?.lat ?? null,
        ubicacionLng: ubicacion?.lng ?? null,
      });
    },

    async reporte(cursoId) {
      return repo.listarAsistenciasPorCurso(cursoId);
    },
  };
}
