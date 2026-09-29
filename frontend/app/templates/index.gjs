import { pageTitle } from 'ember-page-title';
import PantallaQr from 'frontend/components/pantalla-qr';

<template>
  {{pageTitle "AsistenciaQR"}}

  <PantallaQr @salon={{@model.salon}} />
</template>
