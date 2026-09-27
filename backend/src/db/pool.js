import pg from 'pg';
import { env } from '../config/env.js';

let pool = null;

// Conexión perezosa: solo se crea si REPO=postgres y hay DATABASE_URL.
// En la beta (REPO=memory) este módulo nunca conecta a nada.
export function getPool() {
  if (!env.databaseUrl) {
    throw new Error('BD no configurada en beta: define DATABASE_URL y REPO=postgres');
  }
  pool ??= new pg.Pool({ connectionString: env.databaseUrl });
  return pool;
}
