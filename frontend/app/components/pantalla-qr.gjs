import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { action } from '@ember/object';
import { service } from '@ember/service';
import { on } from '@ember/modifier';
import QRCode from 'qrcode';
import AsistenciasVivo from 'frontend/components/asistencias-vivo';

const DIAS = ['Dom', 'Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb'];

export default class PantallaQrComponent extends Component {
  @service api;

  @tracked salones = [];
  @tracked salonId = this.args.salon ?? '';
  @tracked datos = null;
  @tracked errorMsg = '';
  @tracked cargando = true;
  @tracked qr = null;
  @tracked mostrandoAvisoRed = false;

  constructor() {
    super(...arguments);
    this.mostrandoAvisoRed = ['localhost', '127.0.0.1'].includes(
      window.location.hostname,
    );
    this.iniciar();
  }

  get qrUrl() {
    return `${window.location.origin}/alumno?salon=${encodeURIComponent(this.salonId)}`;
  }

  get claveQr() {
    return this.salonId ? [this.salonId] : [];
  }

  async iniciar() {
    try {
      this.salones = await this.api.salones();
      await this.cargar(this.salonId || this.salones[0]?.id || '');
    } catch (e) {
      this.errorMsg = e.message;
      this.cargando = false;
    }
  }

  async cargar(id) {
    if (!id) return;
    this.cargando = true;
    this.errorMsg = '';
    try {
      this.salonId = id;
      this.datos = await this.api.salon(id);
      this.qr = await QRCode.toDataURL(this.qrUrl, { width: 320, margin: 1 });
      const url = new URL(window.location.href);
      url.searchParams.set('salon', id);
      window.history.replaceState({}, '', url);
    } catch (e) {
      this.errorMsg = e.message;
      this.datos = null;
      this.qr = null;
    } finally {
      this.cargando = false;
    }
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
  cambiarSalon(e) {
    const id = e.target.value;
    if (id) this.cargar(id);
  }

  mismo(a, b) {
    return a === b;
  }

  <template>
    <section class="qr-layout">
      <div class="card qr-panel">
        <h2>QR del salón</h2>

        <label>Aula
          <select {{on "change" this.cambiarSalon}}>
            {{#each this.salones as |s|}}
              <option value={{s.id}} selected={{this.mismo s.id this.salonId}}>
                {{s.nombre}}
                —
                {{s.id}}
              </option>
            {{else}}
              <option value="">Sin aulas disponibles</option>
            {{/each}}
          </select>
        </label>

        {{#if this.errorMsg}}
          <p class="error">{{this.errorMsg}}</p>
        {{/if}}

        {{#if this.cargando}}
          <p class="muted">Cargando…</p>
        {{else if this.qr}}
          <div class="qr-box">
            <img
              src={{this.qr}}
              alt="QR del salón {{this.salonId}}"
              width="320"
              height="320"
            />
            <div class="qr-meta">
              <h3>{{this.datos.salon.nombre}}</h3>
              {{#if this.datos.curso}}
                <p class="ahora">Ahora:
                  <strong>{{this.datos.curso.nombre}}</strong></p>
              {{else}}
                <p class="muted">Sin clase en este momento.</p>
              {{/if}}
              <p><small>{{this.qrUrl}}</small></p>
              <p class="muted">
                Los alumnos escanean este código desde su celular para marcar
                asistencia.
              </p>
            </div>
          </div>

          {{#if this.mostrandoAvisoRed}}
            <p class="aviso">
              Estás en
              <strong>localhost</strong>: el QR no abrirá nada desde el celular.
              Abre esta pantalla con la IP de la red (misma Wi‑Fi) y vuelve a
              mostrar el QR.
            </p>
          {{/if}}
        {{/if}}
      </div>

      <div class="card">
        <h2>Cursos del aula</h2>
        {{#if this.datos}}
          {{#if this.datos.cursos.length}}
            <ul class="cursos">
              {{#each this.datos.cursos as |c|}}
                <li class={{if c.enHorario "curso ahora" "curso"}}>
                  <strong>{{c.nombre}}</strong>
                  <small>{{this.resumenHorario c.horarios}}</small>
                  {{#if c.enHorario}}
                    <span class="chip">en horario</span>
                  {{/if}}
                </li>
              {{/each}}
            </ul>
          {{else}}
            <p class="muted">Este aula no tiene cursos en la programación.</p>
          {{/if}}
        {{/if}}
      </div>
    </section>

    {{#each this.claveQr as |id|}}
      <AsistenciasVivo @salonId={{id}} />
    {{/each}}
  </template>
}
