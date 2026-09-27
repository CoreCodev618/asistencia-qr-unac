# AsistenciaQR — Propuesta de Proyecto (Prototipo)

## ¿Qué es?

Un sistema web para automatizar el registro de asistencia en un salón de clases mediante un código QR fijo por salón. Cada alumno escanea el QR del salón y el sistema valida automáticamente si le corresponde estar ahí, cruzando el horario del curso con su matrícula y, opcionalmente, su ubicación.

Este proyecto se desarrolla como **prototipo personal**, con el alcance acotado a **un salón real de la facultad**, para demostrar que el flujo completo funciona de principio a fin.

## Problema que resuelve

Actualmente la asistencia se registra de forma manual (lista física o verbal), lo cual toma tiempo de clase y es fácil de falsear o de olvidar. AsistenciaQR automatiza este proceso: el alumno se autorregistra al entrar, y el sistema mismo valida que tenga derecho a estar en ese salón, a esa hora, en ese curso.

## Cómo funciona (sin entrar en código)

1. Cada salón tiene un **código QR fijo**, visible dentro del aula.
2. El alumno escanea el QR al momento de entrar a clase.
3. El sistema identifica automáticamente:
   - A qué salón pertenece ese QR.
   - Qué curso se dicta en ese salón en el horario actual.
4. Con esa información, valida:
   - **Horario:** ¿la hora actual está dentro del rango de la clase?
   - **Matrícula:** ¿el alumno está inscrito en ese curso?
   - **Ubicación (opcional):** ¿el alumno se encuentra físicamente cerca del salón?
5. Si el horario y la matrícula son correctos, la asistencia se registra como válida. La ubicación se usa como validación adicional, sin bloquear el registro si falla (por ejemplo, si el GPS pierde precisión dentro del edificio).
6. Toda la asistencia queda guardada y se puede consultar en un reporte simple por curso.

## Alcance del prototipo

Para mantenerlo simple y funcional, el prototipo cubre:

- 1 salón real de la facultad
- 1 curso con su horario definido
- Un grupo pequeño de alumnos matriculados (datos precargados directamente en la base de datos, sin necesitar un módulo de inscripción)
- Registro de asistencia validando horario y matrícula
- Validación de ubicación como capa adicional, no bloqueante
- Reporte simple de quién marcó asistencia, a qué hora y si fue válida

## Tecnologías

| Capa | Tecnología | Para qué |
|---|---|---|
| Frontend | **Ember.js** | Interfaz web: vista del QR del salón y vista para que el alumno registre su asistencia |
| Backend / API | **Node.js + Express** | Expone los endpoints (identificar salón, validar horario/matrícula/ubicación, guardar asistencia) y contiene toda la lógica de validación |
| Base de datos | **PostgreSQL** | Almacena salones, cursos, horarios, alumnos, matrículas y registros de asistencia, todos relacionados entre sí |
| Geolocalización | **Geolocation API** (nativa del navegador) | Obtiene la ubicación del alumno al marcar asistencia, sin costo ni API key |

Todo el stack usa herramientas gratuitas y estándar en la industria.

## Modelo de datos (a nivel de idea)

- **Salones:** identifican el aula y su ubicación.
- **Cursos:** qué se dicta y a quién.
- **Horarios:** qué curso se dicta en qué salón, qué día y en qué rango de hora.
- **Alumnos:** quienes pueden marcar asistencia.
- **Matrículas:** relación entre alumno y curso — es la tabla clave para validar pertenencia.
- **Asistencias:** registro final con alumno, salón, fecha/hora y si fue válida (y por qué, si fue rechazada).

## Vistas principales

Una sola aplicación web, con rutas distintas según el uso:

- Vista del salón — muestra el QR fijo del aula (pantalla o impreso).
- Vista de registro — el alumno escanea o abre el link y marca su asistencia.
- Vista de confirmación — resultado del registro (válido o motivo de rechazo).
- Vista de reporte — lista de asistencias del curso, con horario y validez de cada una.

Aplicación responsive: pensada para usarse desde el celular del alumno al momento de entrar al salón.

## Por qué este proyecto

- Resuelve un problema real y cotidiano de la propia facultad.
- Combina frontend, backend y base de datos relacional de forma genuina, no como ejercicio de CRUD.
- El alcance de un solo salón permite probarlo en condiciones reales, con horario y alumnos reales.
- Es fácil de explicar y demostrar en vivo, sin depender de servicios externos de pago.
