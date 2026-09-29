export function createAsistenciasController(service) {
  return {
    async registrar(req, res, next) {
      try {
        const { salonId, cursoId, codigoAlumno, ubicacion } = req.body ?? {};
        if (!salonId || !codigoAlumno) {
          return res.status(400).json({ error: 'salonId y codigoAlumno son obligatorios' });
        }
        const resultado = await service.registrar({ salonId, cursoId, codigoAlumno, ubicacion });
        return res.status(201).json(resultado);
      } catch (e) {
        return next(e);
      }
    },
  };
}
