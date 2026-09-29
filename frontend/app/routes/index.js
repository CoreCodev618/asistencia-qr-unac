import Route from '@ember/routing/route';

// Pantalla del salón: QR + asistencias en vivo.
// El salón llega por query param (?salon=FIIS1T01) para que el link sea compartible.
export default class IndexRoute extends Route {
  queryParams = {
    salon: { refreshModel: false },
  };

  model(params) {
    return { salon: params.salon ?? '' };
  }
}
