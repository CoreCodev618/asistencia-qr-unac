import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { action } from '@ember/object';
import { service } from '@ember/service';
import { on } from '@ember/modifier';

// Formulario de autorregistro. Salón y código vienen del usuario/QR,
// ubicación del GPS del navegador. Nada precargado.
export default class RegistroFormComponent extends Component {
  @service api;
  @service router;
  @service registroState;

  @tracked salonId = this.args.salonId;
  @tracked codigoAlumno = '';
  @tracked enviando = false;
  @tracked errorMsg = '';

  ubicacionActual() {
    return new Promise((resolve) => {
      if (!('geolocation' in navigator)) return resolve(null);
      navigator.geolocation.getCurrentPosition(
        (pos) => resolve({ lat: pos.coords.latitude, lng: pos.coords.longitude }),
        () => resolve(null),
        { timeout: 8000 },
      );
    });
  }

  @action actualizarSalon(e) {
    this.salonId = e.target.value;
  }

  @action actualizarCodigo(e) {
    this.codigoAlumno = e.target.value;
  }

  @action
  async enviar(event) {
    event.preventDefault();
    this.enviando = true;
    this.errorMsg = '';
    try {
      const ubicacion = await this.ubicacionActual();
      const resultado = await this.api.registrar({
        salonId: this.salonId.trim(),
        codigoAlumno: this.codigoAlumno.trim(),
        ubicacion,
      });
      this.registroState.ultimoResultado = resultado;
      this.router.transitionTo('confirmacion');
    } catch (e) {
      this.errorMsg = e.message;
    } finally {
      this.enviando = false;
    }
  }

  <template>
    <form {{on "submit" this.enviar}}>
      <label>Salón
        <input value={{this.salonId}} {{on "input" this.actualizarSalon}} required />
      </label>
      <label>Código de alumno
        <input value={{this.codigoAlumno}} {{on "input" this.actualizarCodigo}} required />
      </label>
      <button type="submit" disabled={{this.enviando}}>
        {{if this.enviando "Registrando…" "Marcar asistencia"}}
      </button>
      {{#if this.errorMsg}}
        <p>{{this.errorMsg}}</p>
      {{/if}}
    </form>
  </template>
}
