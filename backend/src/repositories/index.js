import { readFile } from 'node:fs/promises';
import { env } from '../config/env.js';
import { createMemoryRepository } from './memory.repository.js';
import { createPostgresRepository } from './postgres.repository.js';

// El seed solo se carga si SEED_PATH apunta a un archivo JSON.
// Sin SEED_PATH el repositorio en memoria empieza vacío.
async function cargarSeed() {
  if (!env.seedPath) return {};
  const texto = await readFile(env.seedPath, 'utf8');
  return JSON.parse(texto);
}

export async function createRepository() {
  if (env.repo === 'postgres') return createPostgresRepository();
  return createMemoryRepository(await cargarSeed());
}
