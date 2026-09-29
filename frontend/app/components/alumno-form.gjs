import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { action } from '@ember/object';
import { service } from '@ember/service';
import { on } from '@ember/modifier';

const CLAVE_CODIGO = 'asistenciaqr.codigo';
const DIAS = ['Dom', 'Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb'];

export default class AlumnoFormComponent extends Component {
  @service api;

  @tracked datos = null;
  @tracked cursoId = '';
  @tracked codigo = '';
  @tracked resultado = null;
  @tracked errorMsg = '';
  @tracked cargando = true;
  @tracked enviando = false;

  constructor() {
    super(...arguments);
    this.codigo = localStorage.getItem(CLAVE_CODIGO) ?? '';
    this.iniciar();
  }

  async iniciar() {
    const salon = this.args.salon;
    if (!salon) {
      this.cargando = false;
      this.errorMsg = 'Escanea el QR del salón para marcar asistencia.';
      return;
    }
    try {
      this.datos = await this.api.salon(salon);
      const enHorario = this.datos.cursos.find((c) => c.enHorario);
      this.cursoId = (enHorario ?? this.datos.cursos[0])?.id ?? '';
    } catch (e) {
      this.errorMsg = e.message;
    } finally {
      this.cargando = false;
    }
  }

  get salon() {
    return this.datos?.salon?.id ?? this.args.salon ?? '';
  }

  mismo(a, b) {
    return a === b;
  }

  resumenHorario(horarios) {
    if (!horarios?.length) return '';
    return horarios
      .map(
        (h) =>
          `${DIAS[h.diaSemana] ?? ''} ${h.horaInicio}-${h.horaFin}${h.tipo ? ` (${h.tipo})` : ''}`,
      )
      .join(' · ');
  }

  @action
  cambiarCurso(e) {
    this.cursoId = e.target.value;
  }

  @action
  cambiarCodigo(e) {
    this.codigo = e.target.value;
  }

  @action
  async enviar(event) {
    event.preventDefault();
    this.enviando = true;
    this.errorMsg = '';
    try {
      const codigo = this.codigo.trim();
      const resultado = await this.api.registrar({
        salonId: this.salon,
        cursoId: this.cursoId,
        codigoAlumno: codigo,
      });
      localStorage.setItem(CLAVE_CODIGO, codigo);
      this.resultado = resultado;
    } catch (e) {
      this.errorMsg = e.message;
    } finally {
      this.enviando = false;
    }
  }

  <template>
    {{#if this.cargando}}
      <p class="muted">Cargando…</p>
    {{else if this.datos}}
      <section class="card alumno-card">
        <p class="aula">{{this.datos.salon.nombre}}</p>

        <form {{on "submit" this.enviar}}>
          <label>¿Qué curso estás tomando?
            <select {{on "change" this.cambiarCurso}}>
              {{#each this.datos.cursos as |c|}}
                <option
                  value={{c.id}}
                  selected={{this.mismo c.id this.cursoId}}
                >
                  {{#if c.enHorario}}[Ahora] {{/if}}{{c.nombre}}
                  —
                  {{this.resumenHorario c.horarios}}
                </option>
              {{/each}}
            </select>
          </label>

          <label>Tu código de alumno
            <input
              value={{this.codigo}}
              {{on "input" this.cambiarCodigo}}
              inputmode="numeric"
              autocomplete="off"
              placeholder="20260001"
              required
            />
          </label>

          <button type="submit" disabled={{this.enviando}}>
            {{if this.enviando "Registrando…" "Marcar asistencia"}}
          </button>
        </form>

        {{#if this.errorMsg}}
          <p class="error">{{this.errorMsg}}</p>
        {{/if}}
      </section>

      {{#if this.resultado}}
        <section class="card">
          {{#if this.resultado.valida}}
            <p class="resultado ok">Asistencia registrada</p>
            <p>
              {{this.resultado.alumnoNombres}}
              ·
              {{this.resultado.codigoAlumno}}
              ·
              {{this.resultado.fechaHora}}
            </p>
          {{else}}
            <p class="resultado no">No se registró</p>
            <ul>
              {{#each this.resultado.motivos as |m|}}
                <li>{{m}}</li>
              {{/each}}
            </ul>
          {{/if}}

          {{#if this.resultado.advertencias.length}}
            <ul class="avisos">
              {{#each this.resultado.advertencias as |a|}}
                <li>{{a}}</li>
              {{/each}}
            </ul>
          {{/if}}
        </section>
      {{/if}}
    {{else}}
      <section class="card">
        <p class="error">{{this.errorMsg}}</p>
      </section>
    {{/if}}
  </template>
}
