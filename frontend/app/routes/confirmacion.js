import Route from '@ember/routing/route';
import { service } from '@ember/service';

export default class ConfirmacionRoute extends Route {
  @service registroState;

  model() {
    return this.registroState.ultimoResultado;
  }
}
