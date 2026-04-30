---
name: context7-flutter
user-invocable: true
description: "Skill para usar Context7 y obtener documentación y ejemplos actuales sobre Flutter (API, widgets, patterns y migraciones)."
---

# Context7 — Flutter helper SKILL

Resumen
- Usa Context7 para resolver `libraryId` y obtener documentación actualizada sobre Flutter, paquetes comunes (e.g., `flutter`, `provider`, `riverpod`, `flutter_bloc`) y ejemplos de código.

Cuándo usarla
- Preguntas de implementación concretas: "¿Cómo usar ListView.builder en Flutter 3.10?"
- Migraciones de versión: "¿Qué cambió en Flutter 3.7 a 3.10 para navegación?"
- Búsqueda de ejemplos oficiales y snippets.

Flujo recomendado (pasos de la skill)
1. Resolver `libraryId` llamando a `resolve-library-id` con `libraryName: flutter` y `query: <pregunta completa del usuario>`.
2. Seleccionar el mejor match (preferir repos oficiales como `flutter/flutter` o paquetes con alta calificación).
3. Llamar a `query-docs` con `libraryId` y `query` (pregunta completa).
4. Si la respuesta no es satisfactoria, reintentar `query-docs` con `researchMode: true`.
5. Entregar una respuesta que incluya:
   - Resumen de la documentación encontrada
   - Fragmentos de código relevantes y verificables
   - Referencia a la versión si se menciona

Pautas y mejores prácticas
- Pasa la pregunta completa como `query` para mayor relevancia.
- Si el usuario menciona versión, inclúyela en la resolución del `libraryId`.
- Si la respuesta requiere estudio más profundo, usa `researchMode: true` antes de responder desde entrenamiento.

Ejemplos de prompts
- "¿Cómo implementar pull-to-refresh en una lista con Riverpod en Flutter 3.10?"
- "¿Qué cambios en la API de Navigator se introdujeron en Flutter 3.7?"
- "Dame un snippet para un `CustomPainter` que dibuje una curva fluida y explique performance considerations."

Salida esperada
- Explicación clara paso a paso
- Snippet de Dart listo para copiar
- Links a la documentación oficial o al fragmento de código usado

Instalación / uso global
- Colocar la carpeta `context7-flutter` en la carpeta de prompts del usuario o en el repositorio central de skills para que sea accesible globalmente a los agentes.
- Ruta de ejemplo de usuario: `%APPDATA%\\Code\\User\\prompts\\skills\\context7-flutter`

---
Generado siguiendo las pautas de `context7-mcp` para Flutter.
