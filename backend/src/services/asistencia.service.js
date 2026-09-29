import { env } from '../config/env.js';
import { horarioVigente, validarAsistencia } from './validacion.service.js';

function httpError(status, message) {
  const e = new Error(message);
  e.status = status;
  return e;
}

function inicioDelDia(ahora = new Date()) {
  const d = new Date(ahora);
  d.setHours(0, 0, 0, 0);
  return d.toISOString();
}

function ordenarCursos(a, b) {
  if (a.enHorario !== b.enHorario) return a.enHorario ? -1 : 1;
  return a.nombre.localeCompare(b.nombre, 'es');
}

export function createAsistenciaService(repo) {
  return {
    async salones() {
      return repo.listarSalones();
    },

    async salonDetalle(salonId, ahora = new Date()) {
      const salon = await repo.getSalon(salonId);
      if (!salon) return null;

      const horarios = await repo.getHorariosPorSalon(salonId);
      const porCurso = new Map();
      for (const h of horarios) {
        if (!porCurso.has(h.cursoId)) porCurso.set(h.cursoId, []);
        porCurso.get(h.cursoId).push(h);
      }

      const cursos = [];
      for (const [cursoId, hs] of porCurso) {
        const curso = await repo.getCurso(cursoId);
        if (!curso) continue;
        cursos.push({
          ...curso,
          enHorario: Boolean(horarioVigente(hs, ahora)),
          horarios: hs
            .map((h) => ({
              diaSemana: h.diaSemana,
              horaInicio: h.horaInicio,
              horaFin: h.horaFin,
              seccion: h.seccion ?? '',
              tipo: h.tipo ?? '',
            }))
            .sort((a, b) => a.diaSemana - b.diaSemana || a.horaInicio.localeCompare(b.horaInicio)),
        });
      }
      cursos.sort(ordenarCursos);

      const horario = horarioVigente(horarios, ahora);
      const curso = horario ? await repo.getCurso(horario.cursoId) : null;
      return { salon, horario, curso, cursos };
    },

    async registrar({ salonId, cursoId, codigoAlumno, ubicacion = null, ahora = new Date() }) {
      const salon = await repo.getSalon(salonId);
      if (!salon) throw httpError(404, 'Salón no encontrado');
      const alumno = await repo.getAlumnoPorCodigo(codigoAlumno);
      if (!alumno) throw httpError(404, 'Alumno no encontrado');

      const horarios = await repo.getHorariosPorSalon(salonId);
      const horariosCurso = cursoId ? horarios.filter((h) => h.cursoId === cursoId) : horarios;
      const horario = horarioVigente(horariosCurso, ahora);
      const cursoValidado = cursoId ?? horario?.cursoId ?? null;
      const matriculado = cursoValidado
        ? await repo.estaMatriculado(alumno.id, cursoValidado)
        : false;

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
        alumnoNombres: alumno.nombres,
        cursoId: cursoValidado,
        codigoAlumno: alumno.codigo,
        fechaHora: ahora.toISOString(),
        valida,
        motivos,
        advertencias,
        ubicacionLat: ubicacion?.lat ?? null,
        ubicacionLng: ubicacion?.lng ?? null,
      });
    },

    async asistenciasHoy(salonId, ahora = new Date()) {
      const salon = await repo.getSalon(salonId);
      if (!salon) throw httpError(404, 'Salón no encontrado');
      const filas = await repo.listarAsistenciasPorSalon(salonId, inicioDelDia(ahora));
      return filas.sort((a, b) => b.fechaHora.localeCompare(a.fechaHora));
    },

    async reporte(cursoId) {
      return repo.listarAsistenciasPorCurso(cursoId);
    },
  };
}
