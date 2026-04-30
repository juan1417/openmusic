---
name: modular-architecture
user-invocable: true
description: "Skill para diseñar, revisar y generar artefactos de arquitectura modular (capas, features, boundaries, paquetes, y estrategias de integración)."
---

# Arquitectura Modular — SKILL

Resumen
- Esta skill guía a desarrolladores y arquitectos en la definición y adopción de una arquitectura modular para aplicaciones (monorepos o repos únicos), cubriendo separación de responsabilidades, boundaries, contratos, y prácticas de despliegue y testing.

Cuando usarla
- Rediseñar una base de código para módulos/feature-based structure.
- Crear una propuesta de paquetes/layers en un monorepo.
- Definir políticas de dependencia, versionamiento y APIs internas.

Salida esperada
- Mapa de módulos y boundaries (nombres, responsabilidades, dependencias permitidas).
- Propuesta de estructura de carpetas y layout (ej.: packages/, apps/, libs/).
- Estándares de comunicación entre módulos (interfaces, DTOs, events, pub/sub).
- Estrategia de testing por módulo y contract testing.
- Recomendaciones de CI/CD para despliegue independiente o integrado.
- Checklist de migración y criterios de aceptación.

Flujo de la skill
1. Recopilar contexto (stack tech, tamaño del equipo, monorepo vs multi-repo, requisitos de despliegue, restricciones de performance).
2. Proponer una catalogación inicial de módulos (core, shared, features, infra, platform).
3. Definir contracts y API boundaries entre módulos (interfaces, eventos, contratos HTTP/gRPC).
4. Diseñar layout de repositorio y convenciones de nombres.
5. Sugerir estrategia de versionado y publicación (single-version, independent versions, semantic-release).
6. Proponer pipeline CI/CD por módulo y pruebas necesarias (unit, integration, contract, e2e).
7. Generar checklist de migración con pasos atómicos y fallbacks.

Puntos de decisión
- Si el equipo prefiere despliegues independientes → priorizar versionado independiente y pipelines por paquete.
- Si la complejidad operacional es alta → recomendar un enfoque gradual (strangler pattern) y feature toggles.
- Si se usa monorepo con herramientas de workspace (e.g., pnpm/workspaces, Bazel) → integrar recomendaciones específicas.

Criterios de calidad
- Módulos con alta cohesión y bajo acoplamiento.
- Contratos bien definidos y documentados.
- Pipelines reproducibles y con pruebas que cubren contratos.
- Migración con pasos reversibles y métricas para validación.

Ejemplos de prompts
- "Rediseña la arquitectura de una app Flutter grande para soportar features independientes y despliegues modulares."
- "Genera la propuesta de módulos y layout para un monorepo que contiene backend Node.js y frontend Flutter."
- "Define un contrato entre el módulo de pagos y el módulo de órdenes usando gRPC y pruebas de contrato."

Plantillas y artefactos generados
- Tabla de módulos con responsabilidades y dependencias permitidas.
- Ejemplo de `package.json`/`pubspec.yaml` para cada paquete en un monorepo.
- Ejemplo de pipeline de CI para GitHub Actions con estrategia de cambios por paquete.
- Checklist de migración y tareas por sprint.

Instalación / uso
- Colocar la carpeta `modular-architecture` en `.agents/skills/` para uso con modelos locales (ya creada).
- Para hacerla disponible en tu perfil de VS Code, copiar la carpeta a `%APPDATA%\Code\User\prompts\skills\modular-architecture`.

Preguntas abiertas
- ¿Cuál es el stack (lenguajes/frameworks) principal para el que deseas la arquitectura modular?
- ¿Prefieres versionado independiente por paquete o versión única para todo el repo?

---
Generado siguiendo la plantilla de creación de skills; puedo adaptar la skill para un stack concreto (Flutter+Node, Dart-only, etc.) si me indicaslo.
