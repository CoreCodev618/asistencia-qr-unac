import { LinkTo } from '@ember/routing';

<template>
  <h1>Resultado del registro</h1>
  {{#if @model}}
    {{#if @model.valida}}
      <p>Asistencia válida ✔</p>
    {{else}}
      <p>Asistencia rechazada:</p>
      <ul>
        {{#each @model.motivos as |motivo|}}
          <li>{{motivo}}</li>
        {{/each}}
      </ul>
    {{/if}}
    {{#if @model.advertencias.length}}
      <ul>
        {{#each @model.advertencias as |adv|}}
          <li>{{adv}}</li>
        {{/each}}
      </ul>
    {{/if}}
    <p><small>{{@model.fechaHora}}</small></p>
  {{else}}
    <p>Aún no marcas asistencia.</p>
  {{/if}}
  <LinkTo @route="registro">Volver al registro</LinkTo>
</template>
