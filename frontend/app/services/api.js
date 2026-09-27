import Service from '@ember/service';
import config from 'frontend/config/environment';

// Cliente HTTP de la API. La base sale de config (API_HOST al compilar).
// Nunca hay URLs ni IDs fijos: todo llega por argumentos.
export default class ApiService extends Service {
  get host() {
    return config.APP.API_HOST;
  }

  async #json(res) {
    const data = await res.json().catch(() => ({}));
    if (!res.ok) throw new Error(data.error || `Error ${res.status}`);
    return data;
  }

  getSalon(id) {
    return fetch(`${this.host}/api/salones/${encodeURIComponent(id)}`).then((r) => this.#json(r));
  }

  registrar({ salonId, codigoAlumno, ubicacion }) {
    return fetch(`${this.host}/api/asistencias`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ salonId, codigoAlumno, ubicacion }),
    }).then((r) => this.#json(r));
  }

  reporte(cursoId) {
    const q = new URLSearchParams({ curso_id: cursoId });
    return fetch(`${this.host}/api/reporte?${q}`).then((r) => this.#json(r));
  }
}
