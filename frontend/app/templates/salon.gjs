import { pageTitle } from 'ember-page-title';
import SalonQr from 'frontend/components/salon-qr';

<template>
  {{pageTitle "QR del salón"}}

  {{#if @model.error}}
    <p>{{@model.error}}</p>
  {{else}}
    <h1>{{@model.salon.nombre}}</h1>
    <SalonQr @salonId={{@model.salon.id}} />
    {{#if @model.curso}}
      <p>Ahora: {{@model.curso.nombre}}</p>
    {{else}}
      <p>Sin clase en este momento.</p>
    {{/if}}
  {{/if}}
</template>
