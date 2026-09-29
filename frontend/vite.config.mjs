import { defineConfig } from 'vite';
import { extensions, classicEmberSupport, ember } from '@embroider/vite';
import { babel } from '@rollup/plugin-babel';

export default defineConfig({
  server: {
    // La app habla con la API por /api en el mismo origen (sin CORS),
    // así funciona igual desde localhost o desde la IP de la red.
    proxy: {
      '/api': {
        target: process.env.API_PROXY ?? 'http://localhost:3000',
        changeOrigin: true,
      },
    },
  },
  plugins: [
    classicEmberSupport(),
    ember(),
    // extra plugins here
    babel({
      babelHelpers: 'runtime',
      extensions,
    }),
  ],
});
