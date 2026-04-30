---
name: ui-ux-flutter
user-invocable: true
description: "Skill para guiar y generar artefactos de UI/UX para aplicaciones Flutter: wireframes, componentes, layouts responsivos, accesibilidad y código de widgets reutilizables."
---

# UI/UX Flutter — SKILL

Resumen
- Esta skill ayuda a diseñadores y desarrolladores a convertir requisitos productivos en propuestas de UI/UX y artefactos prácticos para Flutter (wireframes, especificaciones, componentes, y snippets de código).

Cuando usarla
- Necesitas una propuesta visual o estructura de pantallas para Flutter.
- Quieres convertir mockups en widgets reutilizables.
- Requieres checklist de accesibilidad y rendimiento para interfaces móviles.

Salida esperada
- Resumen de requerimientos y restricciones.
- Wireframe textual y árbol de widgets (estructura de pantalla).
- Especificaciones de diseño (tipografías, colores, espaciados, tokens).
- Snippets de `Dart/Flutter` para widgets principales (stateless/stateful), con comentarios sobre integración.
- Checklist de accesibilidad y rendimiento.

Paso a paso (flujo de la skill)
1. Extraer y confirmar requisitos (objetivos, pantallas, plataformas, público, constraints).
2. Proponer 1–3 variantes de layout (compacto, cómodo, expandido) y justificar su uso.
3. Generar wireframe textual y árbol de widgets por pantalla (nombres de widgets, props principales).
4. Producir tokens de diseño (color primary/secondary, tipografía, tamaños, radios, spacing scale).
5. Generar snippets de `Flutter` para los widgets clave con comentarios de uso.
6. Revisar accesibilidad (contraste, tamaño táctil, lector de pantalla) y proponer ajustes.
7. Entregar una lista de tareas para implementar y pruebas de aceptación.

Puntos de decisión y ramas
- Si el usuario aporta mockups/figma → mapa de componentes desde Figma (instruir extracción de assets).
- Si el objetivo es rendimiento extremo → priorizar layouts simples y lazy-loading.
- Si hay soporte multiplataforma (Web/Desktop) → añadir consideraciones de responsive y breakpoints.

Criterios de calidad / checklist antes de finalizar
- ¿Cada pantalla tiene árbol de widgets claro y nombrado?
- ¿Tokens de diseño son coherentes y reutilizables?
- ¿Los snippets compilan conceptualmente y siguen buenas prácticas (nombres claros, separación de concerns)?
- ¿Se incluyeron notas de accesibilidad y pruebas sugeridas?

Ejemplos de prompts de usuario (uso rápido)
- "Necesito una pantalla de onboarding para una app de meditación: 3 pantallas, tono calmado, soporte iOS/Android, target 25-45 años."
- "Convierte este mockup (imagen adjunta) en un árbol de widgets y genera el código del header y footer en Flutter."
- "Diseña un componente de tarjeta de producto con imagen, título, precio y botón CTA. Incluye variantes para lista y grid."

Plantillas rápidas internas
- Requisito inicial: "Objetivo, usuarios, pantallas, constraints (ej. offline, low-memory), tono visual".
- Wireframe textual: "[Screen Name] -> Column: Header, Content, Footer; Content -> ListView -> CardWidget(title, image, subtitle, cta)".

Instalación y uso (local vs global)
- Para uso por proyecto (compartido en el repo): colocar la carpeta de la skill en `.github/skills/ui-ux-flutter/` (ya creada).
- Para uso global por tu perfil de VS Code (disponible a todos los agentes del usuario): copiar la carpeta a la ruta de prompts del usuario. En este sistema la variable es `{{VSCODE_USER_PROMPTS_FOLDER}}` (ejemplo real: `C:\Users\juani\AppData\Roaming\Code\User\prompts`). Ejemplo PowerShell:

```powershell
# Crear carpeta de skills de usuario
$dest = "$env:APPDATA\\Code\\User\\prompts\\skills\\ui-ux-flutter"
New-Item -ItemType Directory -Force -Path $dest
# Copiar archivos de la skill del repo al folder de usuario
Copy-Item -Path ".github\skills\ui-ux-flutter\*" -Destination $dest -Recurse -Force
```

Notas para hacerla verdaderamente global (para todos los agentes en el equipo)
- Copiar la carpeta de la skill a la ubicación central que el orquestador de agentes consulte, por ejemplo un directorio compartido de skills en la configuración del servidor de agentes.
- Alternativamente, publicar la skill en un repositorio git central y clonar ese repositorio en las ubicaciones de skills de cada entorno. Ejemplo:

```powershell
# Clonar repo central (ejemplo)
git clone https://github.com/nextlevelbuilder/ui-ux-pro-max-skill.git C:\shared\skills\ui-ux-pro-max
```

Preguntas abiertas
- ¿Quieres que la skill incluya integración automática con Figma (API) o solo instrucciones manuales para exportar assets?
- ¿Deseas plantillas de código más detalladas (tests, provider/state management), y si es así, qué preferencia de state management (Provider, Riverpod, Bloc)?

---
Generado por la guía de `agent-customization`. Si quieres, puedo ajustar el contenido para agregar ejemplos concretos de componentes o incluir integración con Figma y generar código más completo según una librería de estado preferida.
