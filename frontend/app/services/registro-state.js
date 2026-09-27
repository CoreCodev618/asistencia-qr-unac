import Service from '@ember/service';
import { tracked } from '@glimmer/tracking';

// Guarda el último resultado del registro para mostrarlo en /confirmacion
// sin pasar datos sensibles por la URL.
export default class RegistroStateService extends Service {
  @tracked ultimoResultado = null;
}
