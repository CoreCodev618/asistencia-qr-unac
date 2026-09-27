import { createApp } from './app.js';
import { env } from './config/env.js';

const app = await createApp();

app.listen(env.port, () => {
  console.log(`AsistenciaQR API beta en http://localhost:${env.port} (repo=${env.repo})`);
});
