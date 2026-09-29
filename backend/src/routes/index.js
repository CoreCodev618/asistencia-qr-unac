import { Router } from 'express';

export function createSalonesRoutes(controller) {
  const r = Router();
  r.get('/', controller.listar);
  r.get('/:id', controller.obtener);
  r.get('/:id/asistencias', controller.asistencias);
  return r;
}

export function createAsistenciasRoutes(controller) {
  const r = Router();
  r.post('/', controller.registrar);
  return r;
}

export function createReporteRoutes(controller) {
  const r = Router();
  r.get('/', controller.porCurso);
  return r;
}
