import dotenv from 'dotenv';

dotenv.config();

function numero(nombre, defecto) {
  const valor = Number(process.env[nombre] ?? defecto);
  return Number.isFinite(valor) ? valor : defecto;
}

// Toda la configuración sale de variables de entorno.
// No hay IDs ni datos de negocio aquí.
export const env = {
  port: numero('PORT', 3000),
  // '*' = refleja el origen pedido (útil en la red local; el front en dev
  // además pasa por el proxy de Vite y no depende de CORS).
  corsOrigin: process.env.CORS_ORIGIN ?? '*',
  repo: (process.env.REPO ?? 'memory').toLowerCase(),
  databaseUrl: process.env.DATABASE_URL ?? '',
  seedPath: process.env.SEED_PATH ?? '',
  umbralMetros: numero('UMBRAL_METROS', 150),
};
