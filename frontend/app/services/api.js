import Service from '@ember/service';
import config from 'frontend/config/environment';

/* eslint-disable warp-drive/no-external-request-patterns */
// La API propia devuelve JSON plano (no JSON:API): fetch directo, sin store.
export default class ApiService extends Service {
  get host() {
    return config.APP.API_HOST;
  }

  async #json(res) {
    const data = await res.json().catch(() => ({}));
    if (!res.ok) throw new Error(data.error || `Error ${res.status}`);
    return data;
  }

  salones() {
    return fetch(`${this.host}/api/salones`).then((r) => this.#json(r));
  }

  salon(id) {
    return fetch(`${this.host}/api/salones/${encodeURIComponent(id)}`).then(
      (r) => this.#json(r),
    );
  }

  asistencias(salonId) {
    return fetch(
      `${this.host}/api/salones/${encodeURIComponent(salonId)}/asistencias`,
    ).then((r) => this.#json(r));
  }

  registrar({ salonId, cursoId, codigoAlumno, ubicacion }) {
    return fetch(`${this.host}/api/asistencias`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ salonId, cursoId, codigoAlumno, ubicacion }),
    }).then((r) => this.#json(r));
  }
}
