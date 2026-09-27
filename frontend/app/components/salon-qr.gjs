import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import QRCode from 'qrcode';

// Muestra el QR fijo del salón. La URL nace del navegador (origin actual)
// + el ID que llega por argumento. Nada hardcodeado.
export default class SalonQrComponent extends Component {
  @tracked dataUrl = null;
  @tracked error = null;

  url = '';

  constructor(...args) {
    super(...args);
    this.url = `${window.location.origin}/registro?salon=${encodeURIComponent(this.args.salonId)}`;
    QRCode.toDataURL(this.url, { width: 256 }).then(
      (dataUrl) => {
        this.dataUrl = dataUrl;
      },
      (e) => {
        this.error = e?.message ?? 'No se pudo generar el QR';
      },
    );
  }

  <template>
    {{#if this.dataUrl}}
      <img src={{this.dataUrl}} alt="QR del salón" width="256" height="256" />
    {{else if this.error}}
      <p>{{this.error}}</p>
    {{else}}
      <p>Generando QR…</p>
    {{/if}}
    <p><small>{{this.url}}</small></p>
  </template>
}
