import { Router } from 'express';

export function createSalonesRoutes(controller) {
  const r = Router();
  r.get('/:id', controller.obtener);
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
