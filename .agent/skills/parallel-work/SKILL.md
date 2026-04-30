---
name: parallel-work
description: 'Skill para dividir trabajo en paralelo: separar tareas independientes, asignarlas a ramas o subagentes, validar sin cruces y recombinar cambios con orden.'
argument-hint: 'Divide una tarea grande en trabajos paralelos'
user-invocable: true
---

# Trabajo en Paralelo

## Cuándo usarla
- Cuando una tarea grande se puede separar en partes independientes.
- Cuando hay cambios que pueden avanzar sin bloquearse entre sí.
- Cuando quieres minimizar conflictos entre ediciones simultáneas.

## Objetivo
- Separar el trabajo en unidades pequeñas y compatibles.
- Ejecutar cada unidad con un alcance claro.
- Validar cada resultado antes de integrar.
- Reunir los cambios solo cuando no haya cruces funcionales.

## Procedimiento
1. Identificar el objetivo principal y dividirlo en sub-tareas independientes.
2. Marcar dependencias entre sub-tareas: qué puede hacerse en paralelo y qué debe esperar.
3. Asignar un alcance mínimo a cada sub-tarea para evitar solapamientos.
4. Si hay ramas Git, crear una rama por sub-tarea antes de editar.
5. Si hay subagentes, delegar una sub-tarea por agente con instrucciones claras y sin ambigüedad.
6. Validar cada parte con el chequeo más pequeño que confirme su comportamiento.
7. Revisar conflictos antes de integrar: archivos tocados, contratos compartidos y nombres comunes.
8. Unir solo después de confirmar que cada resultado pasa su validación.

## Reglas
- No mezclar dos tareas independientes en el mismo cambio si pueden separarse.
- No tocar archivos compartidos desde dos frentes sin definir un contrato común.
- No avanzar a integración si una subtarea aún no tiene validación mínima.
- No asumir que el resultado combinado funcionará sin revisar dependencias cruzadas.

## Criterios de calidad
- Cada subtarea tiene un dueño, un alcance y una validación.
- Los cambios no se pisan entre sí.
- Los contratos compartidos quedan estables antes de integrar.
- El resultado final conserva trazabilidad por tarea.

## Formato de salida
- Lista de subtareas paralelizables.
- Dependencias entre subtareas.
- Riesgos de conflicto.
- Orden recomendado para integrar.

## Ejemplos de uso
- 'Divide esta implementación en trabajos paralelos para dos agentes.'
- 'Separa esta refactorización en tres tareas independientes.'
- 'Organiza este bugfix para que se pueda ejecutar en paralelo sin conflictos.'

---
Si quieres, puedo adaptarla a un estilo más técnico para Git + subagentes, o más operativo para diseño/implementación de features.
