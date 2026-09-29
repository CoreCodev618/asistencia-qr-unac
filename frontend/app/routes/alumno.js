import Route from '@ember/routing/route';

export default class AlumnoRoute extends Route {
  queryParams = {
    salon: { refreshModel: true },
  };

  model(params) {
    return { salonId: params.salon ?? '' };
  }
}
