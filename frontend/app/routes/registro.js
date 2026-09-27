import Route from '@ember/routing/route';

export default class RegistroRoute extends Route {
  queryParams = {
    salon: { refreshModel: true },
  };

  model(params) {
    return { salonId: params.salon ?? '' };
  }
}
