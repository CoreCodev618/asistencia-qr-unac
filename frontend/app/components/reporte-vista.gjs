import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { action } from '@ember/object';
import { service } from '@ember/service';
import { on } from '@ember/modifier';

// Reporte por curso. El curso se escribe en el buscador,
// las filas llegan de la API. Nada precargado.
export default class ReporteVistaComponent extends Component {
  @service api;

  @tracked cursoId = '';
  @tracked filas = [];
  @tracked cargando = false;
  @tracked errorMsg = '';

  @action actualizar(e) {
    this.cursoId = e.target.value;
  }

  @action
  async buscar(event) {
    event.preventDefault();
    this.cargando = true;
    this.errorMsg = '';
    try {
      this.filas = await this.api.reporte(this.cursoId.trim());
    } catch (e) {
      this.errorMsg = e.message;
      this.filas = [];
    } finally {
      this.cargando = false;
    }
  }

  <template>
    <form {{on "submit" this.buscar}}>
      <label>Curso
        <input value={{this.cursoId}} {{on "input" this.actualizar}} required />
      </label>
      <button type="submit" disabled={{this.cargando}}>
        {{if this.cargando "Buscando…" "Ver reporte"}}
      </button>
    </form>
    {{#if this.errorMsg}}
      <p>{{this.errorMsg}}</p>
    {{/if}}
    <table>
      <thead>
        <tr><th>Alumno</th><th>Fecha/hora</th><th>Válida</th><th>Detalle</th></tr>
      </thead>
      <tbody>
        {{#each this.filas as |f|}}
          <tr>
            <td>{{f.codigoAlumno}}</td>
            <td>{{f.fechaHora}}</td>
            <td>{{if f.valida "Sí" "No"}}</td>
            <td>{{#each f.motivos as |m|}}{{m}} {{/each}}</td>
          </tr>
        {{else}}
          <tr><td colspan="4">Sin resultados.</td></tr>
        {{/each}}
      </tbody>
    </table>
  </template>
}
