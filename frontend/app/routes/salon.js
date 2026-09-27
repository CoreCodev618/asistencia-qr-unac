import Route from '@ember/routing/route';
import { service } from '@ember/service';

export default class SalonRoute extends Route {
  @service api;

  async model({ salon_id }) {
    try {
      return { ...(await this.api.getSalon(salon_id)), error: null };
    } catch (e) {
      return { salon: null, horario: null, curso: null, error: e.message };
    }
  }
}
