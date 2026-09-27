import { pageTitle } from 'ember-page-title';
import { LinkTo } from '@ember/routing';

<template>
  {{pageTitle "AsistenciaQR"}}

  <header>
    <nav>
      <LinkTo @route="registro">Registro</LinkTo>
      <LinkTo @route="reporte">Reporte</LinkTo>
    </nav>
  </header>

  <main>
    {{outlet}}
  </main>
</template>
