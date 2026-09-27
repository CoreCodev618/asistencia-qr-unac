export function createReporteController(service) {
  return {
    async porCurso(req, res, next) {
      try {
        const cursoId = req.query.curso_id;
        if (!cursoId) return res.status(400).json({ error: 'curso_id es obligatorio' });
        return res.json(await service.reporte(cursoId));
      } catch (e) {
        return next(e);
      }
    },
  };
}
