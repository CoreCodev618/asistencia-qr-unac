import express from 'express';
import cors from 'cors';
import { env } from './config/env.js';
import { createRepository } from './repositories/index.js';
import { createAsistenciaService } from './services/asistencia.service.js';
import { createSalonesController } from './controllers/salones.controller.js';
import { createAsistenciasController } from './controllers/asistencias.controller.js';
import { createReporteController } from './controllers/reporte.controller.js';
import {
  createAsistenciasRoutes,
  createReporteRoutes,
  createSalonesRoutes,
} from './routes/index.js';

export async function createApp() {
  const repo = await createRepository();
  const service = createAsistenciaService(repo);

  const app = express();
  app.use(cors(env.corsOrigin === '*' ? { origin: true } : { origin: env.corsOrigin }));
  app.use(express.json());

  app.get('/api/health', (_req, res) => res.json({ ok: true, repo: env.repo }));

  app.use('/api/salones', createSalonesRoutes(createSalonesController(service)));
  app.use('/api/asistencias', createAsistenciasRoutes(createAsistenciasController(service)));
  app.use('/api/reporte', createReporteRoutes(createReporteController(service)));

  // eslint-disable-next-line no-unused-vars
  app.use((err, _req, res, _next) => {
    res.status(err.status ?? 500).json({ error: err.message ?? 'Error interno' });
  });

  return app;
}
