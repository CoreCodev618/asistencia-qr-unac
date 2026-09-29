import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { service } from '@ember/service';
import { registerDestructor } from '@ember/destroyable';

const INTERVALO_MS = 5000;
const AVISO_MS = 8000;

export default class AsistenciasVivoComponent extends Component {
  @service api;

  @tracked filas = [];
  @tracked recientes = new Set();
  @tracked errorMsg = '';
  @tracked actualizadoEn = null;
  @tracked novedades = 0;
  @tracked verAviso = false;

  #conocidos = new Set();
  #timer = null;
  #aviso = null;

  constructor() {
    super(...arguments);
    this.#timer = setInterval(() => this.refrescar(), INTERVALO_MS);
    registerDestructor(this, () => {
      clearInterval(this.#timer);
      clearTimeout(this.#aviso);
    });
    this.refrescar();
  }

  async refrescar() {
    try {
      const filas = await this.api.asistencias(this.args.salonId);
      const nuevas = filas.filter((f) => !this.#conocidos.has(f.id));
      for (const f of filas) this.#conocidos.add(f.id);

      this.filas = filas;
      this.errorMsg = '';
      this.actualizadoEn = new Date();
      this.novedades = nuevas.length;
      this.recientes = new Set(nuevas.map((f) => f.id));

      clearTimeout(this.#aviso);
      if (nuevas.length) {
        this.verAviso = true;
        this.#aviso = setTimeout(() => {
          this.verAviso = false;
        }, AVISO_MS);
      }
    } catch (e) {
      this.errorMsg = e.message;
    }
  }

  hora(iso) {
    if (!iso) return '';
    return new Date(iso).toLocaleTimeString('es-PE', {
      hour: '2-digit',
      minute: '2-digit',
    });
  }

  esReciente(id) {
    return this.recientes.has(id);
  }

  motivo(f) {
    return f.motivos?.[0] ?? '';
  }

  get marcador() {
    if (!this.actualizadoEn) return 'conectando…';
    return `actualizado ${this.actualizadoEn.toLocaleTimeString('es-PE', {
      hour: '2-digit',
      minute: '2-digit',
      second: '2-digit',
    })}`;
  }

  <template>
    <section class="card">
      <div class="encabezado">
        <h2>Asistencias de hoy</h2>
        <span class="punto" aria-hidden="true"></span>
        <small class="muted">{{this.marcador}}</small>
      </div>

      {{#if this.verAviso}}
        <p class="actualizado">¡Actualizado!
          {{this.novedades}}
          marcación nueva</p>
      {{/if}}

      {{#if this.errorMsg}}
        <p class="error">{{this.errorMsg}}</p>
      {{/if}}

      <table>
        <thead>
          <tr>
            <th>Hora</th>
            <th>Código</th>
            <th>Alumno</th>
            <th>Estado</th>
          </tr>
        </thead>
        <tbody>
          {{#each this.filas as |f|}}
            <tr class={{if (this.esReciente f.id) "fila-nueva" ""}}>
              <td>{{this.hora f.fechaHora}}</td>
              <td>{{f.codigoAlumno}}</td>
              <td>{{f.alumnoNombres}}</td>
              <td>
                {{#if f.valida}}
                  <span class="ok">válida</span>
                {{else}}
                  <span class="no">{{this.motivo f}}</span>
                {{/if}}
              </td>
            </tr>
          {{else}}
            <tr>
              <td colspan="4" class="muted">
                {{#if this.errorMsg}}
                  Sin conexión con la API.
                {{else}}
                  Nadie ha marcado todavía. Esperando escaneos…
                {{/if}}
              </td>
            </tr>
          {{/each}}
        </tbody>
      </table>
    </section>
  </template>
}
