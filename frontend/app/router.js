import EmberRouter from '@embroider/router';
import config from 'frontend/config/environment';

export default class Router extends EmberRouter {
  location = config.locationType;
  rootURL = config.rootURL;
}

Router.map(function () {
  this.route('salon', { path: '/salon/:salon_id' });
  this.route('registro');
  this.route('confirmacion');
  this.route('reporte');
});
