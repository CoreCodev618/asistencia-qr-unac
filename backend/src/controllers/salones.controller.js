export function createSalonesController(service) {
  return {
    async listar(_req, res, next) {
      try {
        return res.json(await service.salones());
      } catch (e) {
        return next(e);
      }
    },

    async obtener(req, res, next) {
      try {
        const resultado = await service.salonDetalle(req.params.id);
        if (!resultado) return res.status(404).json({ error: 'Salón no encontrado' });
        return res.json(resultado);
      } catch (e) {
        return next(e);
      }
    },

    async asistencias(req, res, next) {
      try {
        return res.json(await service.asistenciasHoy(req.params.id));
      } catch (e) {
        return next(e);
      }
    },
  };
}
