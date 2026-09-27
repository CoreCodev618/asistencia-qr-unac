// Validaciones de la propuesta: horario + matrícula (bloqueantes),
// ubicación por GPS (adicional, nunca bloquea).
// Horario: { diaSemana: 0-6 (0=domingo), horaInicio/horaFin: 'HH:MM' }

export function aMinutos(hora) {
  const [h, m] = String(hora).split(':').map(Number);
  return h * 60 + m;
}

export function horarioVigente(horarios, ahora = new Date()) {
  const dia = ahora.getDay();
  const min = ahora.getHours() * 60 + ahora.getMinutes();
  return (
    horarios.find(
      (h) => h.diaSemana === dia && min >= aMinutos(h.horaInicio) && min <= aMinutos(h.horaFin),
    ) ?? null
  );
}

export function distanciaMetros(a, b) {
  const R = 6371000;
  const rad = (d) => (d * Math.PI) / 180;
  const dLat = rad(b.lat - a.lat);
  const dLng = rad(b.lng - a.lng);
  const s =
    Math.sin(dLat / 2) ** 2 +
    Math.cos(rad(a.lat)) * Math.cos(rad(b.lat)) * Math.sin(dLng / 2) ** 2;
  return 2 * R * Math.asin(Math.sqrt(s));
}

export function validarAsistencia({ horario, matriculado, salon, ubicacion, umbralMetros }) {
  const motivos = [];
  const advertencias = [];

  if (!horario) motivos.push('Fuera del horario de clase');
  if (!matriculado) motivos.push('El alumno no está matriculado en el curso');

  if (ubicacion && salon?.latitud != null && salon?.longitud != null) {
    const d = distanciaMetros(ubicacion, { lat: salon.latitud, lng: salon.longitud });
    if (d > umbralMetros) {
      advertencias.push(`Ubicación a ~${Math.round(d)} m del salón (no bloqueante)`);
    }
  }

  return { valida: motivos.length === 0, motivos, advertencias };
}
