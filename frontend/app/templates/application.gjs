import { pageTitle } from 'ember-page-title';

<template>
  {{pageTitle "AsistenciaQR"}}

  <header>
    <div class="marca">
      <strong>AsistenciaQR</strong>
      <span class="muted">UNAC · FIIS</span>
    </div>
  </header>

  <main>
    {{outlet}}
  </main>
</template>
