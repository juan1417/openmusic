---
name: git-task-branch-commit
user-invocable: true
description: "Skill para crear una rama Git y un commit por cada tarea, con nombres consistentes, mensajes claros y validación mínima antes de commitear."
---

# Git por Tarea — SKILL

Resumen
- Esta skill estandariza el flujo de trabajo para que cada tarea termine en su propia rama y su propio commit, con validación previa y mensajes consistentes.

Cuándo usarla
- Quieres separar cada cambio en una rama dedicada.
- Necesitas un commit por tarea, no commits grandes mezclados.
- Quieres seguir una convención clara para branch names y commit messages.

Salida esperada
- Nombre de rama sugerido.
- Lista corta de pasos para ejecutar la tarea.
- Commit message propuesto.
- Checklist de validación antes de hacer `git commit`.
- Recomendación de `push` / `pull request` si aplica.

Flujo de trabajo
1. Identificar la tarea exacta y el alcance mínimo.
2. Elegir un nombre de rama con convención clara.
3. Crear la rama antes de tocar archivos.
4. Implementar solo lo necesario para esa tarea.
5. Ejecutar validación mínima: tests relevantes, lint o build del área tocada.
6. Revisar el diff para asegurar que solo contiene el cambio de la tarea.
7. Crear un commit único con un mensaje descriptivo.
8. Si hay más tareas, repetir el ciclo con otra rama y otro commit.

Decisiones y ramas
- Si la tarea es bugfix → usar prefijo `fix/`.
- Si la tarea es feature → usar prefijo `feat/`.
- Si es refactor sin cambio funcional → usar `refactor/`.
- Si es documentación o tooling → usar `docs/` o `chore/`.
- Si la tarea depende de otra ya abierta → crear la rama nueva desde la base correcta y mencionar la dependencia.

Convenciones recomendadas
- Rama: `tipo/descripcion-corta` o `tipo/numero-ticket-descripcion`.
- Commit: verbo en imperativo, corto y específico.
- Un commit debe representar una unidad lógica completa.

Checklist antes de commitear
- ¿La rama corresponde a una sola tarea?
- ¿El diff está limitado al alcance esperado?
- ¿La validación relevante pasó?
- ¿El commit message explica el cambio sin ambigüedad?
- ¿No quedaron cambios de otra tarea mezclados?

Ejemplos de uso
- "Tengo tres cambios distintos; sepáralos en tres ramas y tres commits."
- "Crea una rama para este bugfix y dime el mensaje de commit apropiado."
- "Estoy por refactorizar este módulo; dame una convención de branch y validación mínima."

Plantillas rápidas
- Rama feature: `feat/add-login-validation`
- Rama fix: `fix/null-pointer-check`
- Commit: `feat: add login validation`
- Commit: `fix: handle null pointer in parser`

Notas operativas
- Antes de crear una rama, confirmar si el trabajo actual ya tiene cambios no relacionados.
- Si hay cambios mezclados, sugerir separar antes de commitear.
- Si el usuario pide el flujo completo, incluir validación, commit y recomendación de push o PR.

---
Generado para usar con agentes locales y remotos que trabajan con Git.
