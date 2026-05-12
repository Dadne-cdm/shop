# 🎨 creator-template-shop

> **Skill para Claude Desktop** que construye temas Shopify premium completos con 19 agentes especializados

---

## ✨ ¿QUÉ HACE?

En lugar de escribir cientos de archivos Liquid a mano, este skill automatiza todo el proceso:

- ✅ Genera **51 archivos Liquid** listos para Shopify
- ✅ **19 agentes** construyen, validan y optimizan cada sección
- ✅ Popups, SEO, analytics y automations **incluidos**
- ✅ Tiempo de construcción: **30-45 minutos**

---

## 📋 REQUISITOS

Antes de instalar necesitas:

1. **Claude Desktop** — [Descargar aquí](https://claude.ai/download)
2. **Mac o Windows** con Claude Desktop instalado
3. El archivo **SKILL.md** de este repositorio

---

## 📥 INSTALACIÓN

### Paso 1: Descarga el SKILL.md

Descarga el archivo `SKILL.md` desde este repositorio (botón **Download raw file** arriba a la derecha).

### Paso 2: Crea la carpeta del skill

**En Mac:**
```bash
mkdir -p ~/Library/Application\ Support/Claude/skills/creator-template-shop
```

**En Windows:**
```
C:\Users\TU_USUARIO\AppData\Roaming\Claude\skills\creator-template-shop\
```

### Paso 3: Copia el archivo

**En Mac:**
```bash
cp ~/Downloads/SKILL.md ~/Library/Application\ Support/Claude/skills/creator-template-shop/SKILL.md
```

**En Windows:**
Copia `SKILL.md` a la carpeta que creaste en el paso anterior.

### Paso 4: Activa el skill en Claude Desktop

1. Abre Claude Desktop
2. Ve a **Settings → Skills**
3. Busca `creator-template-shop`
4. Activa el toggle ✅

---

## 🚀 CÓMO USAR

Una vez instalado, abre Claude Desktop y escribe algo como:

```
Construye un tema Shopify premium para mi tienda de suplementos deportivos.

- Nicho: Proteínas y suplementos
- Colores: Azul #0099FF + Negro #1A1A1A  
- Idiomas: Español e Inglés
- Incluye: Popups de bienvenida, exit-intent y recuperación de carrito
```

Claude activará automáticamente los 19 agentes y construirá tu tema paso a paso.

---

## 📊 LOS 19 AGENTES

| Fase | Agentes | Qué construyen |
|------|---------|----------------|
| **Construcción** | 1–7 | Secciones Liquid (home, producto, colecciones, carrito) |
| **Calidad** | 8–11 | Validación de código + empaquetado .zip |
| **Conversión** | 12–17 | Popups, A/B testing, SEO, performance, CRO |
| **Expansión** | 18–19 | Multi-channel + Shopify Flow automations |

Ver [AGENTS-SUMMARY.md](./AGENTS-SUMMARY.md) para detalles de cada agente.

---

## 📦 QUÉ RECIBES AL FINAL

```
tema-shopify-v1.0.0.zip
├── sections/          ← 51 archivos Liquid
├── snippets/          ← 6 componentes reutilizables
├── assets/            ← CSS, JS, fuentes
├── config/            ← settings_schema.json
├── layout/            ← theme.liquid
├── templates/         ← 5 templates JSON
├── locales/           ← ES, EN, FR
├── popups/            ← 10 tipos de popups
└── automations/       ← Shopify Flow JSONs
```

**Listo para subir directamente a Shopify** desde el panel de administración.

---

## 🌟 CARACTERÍSTICAS DESTACADAS

### Product Page con tendencias 2026 🏆
- Nutritional information accordion
- Allergen badges (Contains/Free from)
- Stock indicator + Delivery timeline
- FAQ anti-objeciones
- Sticky mobile ATC (+30% conversión)
- Bundle deals + cross-sell
- Before/After slider

### Popup System completo 🎯
10 tipos: Welcome, Exit-intent, Time-triggered, Scroll, WhatsApp, Video, Survey y más.

### Shopify Flow Automations 🤖
- Recuperación de carrito abandonado
- Solicitud de reseñas post-compra
- Programa VIP de clientes
- Alertas de bajo stock
- Cross-sell post-compra

---

## ❓ PREGUNTAS FRECUENTES

**¿Funciona en claude.ai web?**
No, este skill requiere **Claude Desktop** instalado en tu ordenador.

**¿Es compatible con cualquier tienda Shopify?**
Sí, genera código Liquid estándar compatible con cualquier plan de Shopify.

**¿Puedo personalizar los colores y estilos?**
Sí, en el Agente 6 (CONFIG & LOCALES) defines los colores, tipografías y configuración global.

**¿Qué pasa si tengo un error?**
Abre un [Issue en GitHub](https://github.com/Dadne-cdm/shop/issues) y lo resolvemos.

---

## 📌 VERSIÓN

| Campo | Info |
|-------|------|
| Versión | 2.1 |
| Agentes | 19 |
| Archivos Liquid | 51 |
| Última actualización | Mayo 2026 |
| Estado | ✅ Production ready |

---

## 🤝 CONTRIBUIR

¿Tienes ideas para mejorar el skill? 
1. Haz un **Fork** del repositorio
2. Crea una rama con tu mejora
3. Abre un **Pull Request**

---

**GitHub:** [github.com/Dadne-cdm/shop](https://github.com/Dadne-cdm/shop)

