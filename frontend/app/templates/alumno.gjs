import { pageTitle } from 'ember-page-title';
import AlumnoForm from 'frontend/components/alumno-form';

<template>
  {{pageTitle "Marcar asistencia"}}

  <AlumnoForm @salon={{@model.salonId}} />
</template>
