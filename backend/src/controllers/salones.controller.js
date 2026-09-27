export function createSalonesController(service) {
  return {
    async obtener(req, res, next) {
      try {
        const resultado = await service.salonConCursoActual(req.params.id);
        if (!resultado) return res.status(404).json({ error: 'Salón no encontrado' });
        return res.json(resultado);
      } catch (e) {
        return next(e);
      }
    },
  };
}
