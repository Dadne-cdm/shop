---
name: creator-template-shop
description: Skill para construir temas Shopify premium completos desde cero, con calidad Pipeline + Impulse
---

# Creator Template Shop — SKILL.md
> Skill para construir temas Shopify premium completos desde cero, con calidad Pipeline + Impulse.

## Cuándo usar este skill
Usar cuando el usuario quiera:
- Crear un tema Shopify completo desde cero
- Generar secciones Liquid (.liquid) para cualquier página
- Configurar schemas JSON de secciones y bloques
- Crear snippets reutilizables y theme blocks
- Construir templates (.json) para Online Store 2.0
- Producir archivos listos para subir a Shopify via Theme Editor o Shopify CLI
- **Clonar/replicar una sección o página a partir de una captura de pantalla** ← Modo Agente Visual
- Integrar apps externas (Loox, Appstle, Klaviyo, Judge.me, Yotpo, etc.) en el tema

Nicho de referencia principal: **suplementos / health & wellness** (pero aplica a cualquier tienda).
Referentes de calidad: Pipeline (Groupthought) + Impulse (Archetype Themes).

---

## 🤖 MODO AGENTE — "Clona esta sección"

Cuando el usuario envía una captura de pantalla de cualquier página Shopify, activar este flujo:

### Paso 1 — Análisis visual de la imagen
Identificar y listar:
1. **Tipo de sección** (hero, product grid, testimonials, features strip, etc.)
2. **Layout** (columnas, full-width, contenido centrado, split left/right)
3. **Componentes** presentes: imagen, texto, botones, badges, iconos, video, formulario
4. **Tipografía** aproximada: tamaño heading vs body, peso, alineación
5. **Colores** dominantes: fondo, texto, botones, acentos
6. **Espaciado** visual: compact / normal / spacious
7. **Comportamiento** inferido: sticky, parallax, slider/carousel, acordeón, tabs

### Paso 2 — Preguntar lo necesario (máximo 2 preguntas)
Antes de generar código preguntar:
- "¿Qué app de reviews usas? (Loox, Judge.me, Yotpo, Okendo, otro)" — si hay stars/reviews en la imagen
- "¿El carrusel debe ser automático o con flechas manuales?"
- Solo preguntar lo que NO se puede inferir de la imagen.

### Paso 3 — Generar sección Liquid completa
Producir archivo `.liquid` listo para subir con:
- HTML semántico fiel al diseño de la captura
- CSS inline con variables CSS (`--color-primary`, etc.) para respetar el tema
- Schema JSON con todos los settings editables desde el Theme Editor
- Presets con valores por defecto que replicen el diseño visto
- Integración de app si hay reviews/suscripciones/upsells en la imagen

### Reglas del Modo Agente
- Si la captura muestra una grilla de reviews con fotos → usar el snippet de integración de la app indicada
- Si la captura muestra un carrusel → implementar con CSS scroll-snap + JS mínimo
- Si hay un selector "Subscribe & Save" → añadir bloque de suscripción (Appstle-compatible)
- Si hay un contador de stock → añadir bloque urgency con `product.variants.first.inventory_quantity`
- Nunca inventar funcionalidades que no se ven en la imagen
- Siempre producir un archivo `.liquid` completo y funcional, no fragmentos

---

## INTEGRACIÓN DE APPS EXTERNAS

### Principio: el tema es app-agnostic
El tema debe funcionar con o sin apps. Usar **feature detection** mediante settings del schema:

```liquid
{% comment %} En el schema de la section: {% endcomment %}
{
  "type": "select",
  "id": "reviews_app",
  "label": "Reviews app",
  "options": [
    { "value": "none", "label": "None" },
    { "value": "loox", "label": "Loox" },
    { "value": "judgeme", "label": "Judge.me" },
    { "value": "yotpo", "label": "Yotpo" },
    { "value": "okendo", "label": "Okendo" },
    { "value": "stamped", "label": "Stamped.io" }
  ],
  "default": "loox"
}
```

```liquid
{% comment %} En el Liquid de la section: {% endcomment %}
{%- case section.settings.reviews_app -%}
  {%- when 'loox' -%}
    {% render 'loox-reviews', product: product %}
  {%- when 'judgeme' -%}
    {% render 'judgeme_widgets', widget_type: 'product_review', id: product.id %}
  {%- when 'yotpo' -%}
    <div class="yotpo yotpo-main-widget" data-product-id="{{ product.id }}"></div>
  {%- when 'okendo' -%}
    {% render 'okendo-reviews-widget', product: product %}
  {%- when 'stamped' -%}
    <div id="stamped-main-widget" data-widget-type="main" data-product-id="{{ product.id }}"></div>
  {%- else -%}
    {% comment %} Fallback: no reviews app {% endcomment %}
{%- endcase -%}
```

---

## LOOX — Integración completa

Loox es la app de reviews recomendada para esta tienda. Integración en 3 niveles:

### 1. Widget de reviews en Product Page
```liquid
{% comment %} snippets/reviews-loox.liquid {% endcomment %}
{% comment %}
  Renders Loox reviews widget.
  Usage: {% render 'reviews-loox', product: product, widget_type: 'main' %}
  widget_type: 'main' | 'rating' | 'carousel' | 'grid'
{% endcomment %}

{%- case widget_type -%}
  {%- when 'rating' -%}
    {%- comment -%} Inline star rating (near title / in product card) {%- endcomment -%}
    <div data-loox-aggregate></div>

  {%- when 'main' -%}
    {%- comment -%} Full reviews section en product page {%- endcomment -%}
    <div id="loox"></div>

  {%- when 'carousel' -%}
    {%- comment -%} Carrusel de reviews con fotos para homepage / cualquier página {%- endcomment -%}
    <div data-loox-carousel="{{ product.id }}"></div>

  {%- when 'grid' -%}
    {%- comment -%} Grid de reviews con fotos (para colecciones o landing pages) {%- endcomment -%}
    <div data-loox-photo-reviews-grid></div>
{%- endcase -%}
```

### 2. Stars en Product Cards (collection grid)
```liquid
{% comment %} Dentro de snippets/product-card.liquid {% endcomment %}
<div class="product-card__rating">
  <div data-loox-aggregate data-product-id="{{ product.id }}"></div>
</div>
```

### 3. Reviews Grid en Homepage o Landing Page
```liquid
{% comment %} sections/reviews-grid-loox.liquid {% endcomment %}
<section class="reviews-grid-section section-{{ section.id }}">
  <div class="container">
    {%- if section.settings.heading != blank -%}
      <h2 class="reviews-grid-section__heading">{{ section.settings.heading }}</h2>
    {%- endif -%}
    
    {%- case section.settings.display_type -%}
      {%- when 'grid' -%}
        <div data-loox-photo-reviews-grid></div>
      {%- when 'carousel' -%}
        <div data-loox-carousel></div>
      {%- when 'badge' -%}
        <div data-loox-badge></div>
    {%- endcase -%}
  </div>
</section>

{% schema %}
{
  "name": "Reviews Grid (Loox)",
  "settings": [
    {
      "type": "text",
      "id": "heading",
      "label": "Heading",
      "default": "What our customers say"
    },
    {
      "type": "select",
      "id": "display_type",
      "label": "Display type",
      "options": [
        { "value": "grid", "label": "Photo reviews grid" },
        { "value": "carousel", "label": "Reviews carousel" },
        { "value": "badge", "label": "Trust badge" }
      ],
      "default": "grid"
    },
    {
      "type": "select",
      "id": "section_width",
      "label": "Section width",
      "options": [
        { "value": "full", "label": "Full width" },
        { "value": "contained", "label": "Contained" }
      ],
      "default": "contained"
    }
  ],
  "presets": [
    {
      "name": "Reviews Grid (Loox)",
      "settings": {
        "heading": "Real results from real customers",
        "display_type": "grid"
      }
    }
  ]
}
{% endschema %}
```

### 4. Inline star rating en collection page (junto a precio)
Loox requiere que su script esté cargado en el layout. Confirmar que en `layout/theme.liquid` dentro del `<head>` esté incluido el script de Loox (se añade automáticamente al instalar la app).

---

## JUDGE.ME — Integración alternativa

```liquid
{% comment %} snippets/reviews-judgeme.liquid {% endcomment %}
{%- case widget_type -%}
  {%- when 'rating' -%}
    {% render 'judgeme_widgets', widget_type: 'product_badge', id: product.id, product: product %}

  {%- when 'main' -%}
    {% render 'judgeme_widgets', widget_type: 'product_review', id: product.id, product: product %}

  {%- when 'carousel' -%}
    {% render 'judgeme_widgets', widget_type: 'carousel', id: product.id, product: product %}

  {%- when 'all_reviews' -%}
    {% render 'judgeme_widgets', widget_type: 'all_reviews_rating', id: '', product: '' %}
{%- endcase -%}
```

---

## APPSTLE — Integración en tema

Con Appstle instalado, el widget se inyecta automáticamente. Para integrarlo limpiamente en el theme:

```liquid
{% comment %} Dentro de sections/main-product.liquid, bloque 'subscription_selector' {% endcomment %}
{%- when 'subscription_selector' -%}
  <div class="product-subscription" {{ block.shopify_attributes }}>
    {%- comment -%}
      Appstle inyecta el widget aquí automáticamente.
      El div con class 'appstle-subscribe' es el hook:
    {%- endcomment -%}
    <div class="appstle-subscribe" 
         data-product-id="{{ product.id }}"
         data-variant-id="{{ product.selected_or_first_available_variant.id }}">
    </div>
    
    {%- comment -%} Fallback si Appstle no está instalado: {%- endcomment -%}
    {%- unless product.selling_plan_groups.size > 0 -%}
      {%- if block.settings.show_one_time_only -%}
        <p class="product-subscription__unavailable">
          {{ block.settings.one_time_label | default: 'One-time purchase' }}
        </p>
      {%- endif -%}
    {%- endunless -%}
  </div>
```

---

## KLAVIYO — Snippets de integración

```liquid
{% comment %} snippets/klaviyo-backinstock.liquid {% endcomment %}
{%- if product.available == false -%}
  <div class="klaviyo-bis-trigger">
    <p class="klaviyo-bis-trigger__label">{{ 'products.product.sold_out' | t }}</p>
    <button
      type="button"
      class="btn btn--secondary klaviyo-bis-trigger__btn"
      data-product-id="{{ product.id }}"
      data-variant-id="{{ product.selected_or_first_available_variant.id }}"
      onclick="klaviyoShowBackInStockModal()"
    >
      Notify me when available
    </button>
  </div>
{%- endif -%}
```

---

## PROTOCOLO COMPLETO — Preguntas al iniciar una sección nueva

Cuando el usuario pide crear una sección sin captura de pantalla, hacer estas preguntas (máximo 2 a la vez):

**Ronda 1:**
1. ¿Qué app de reviews usas? → Loox / Judge.me / Yotpo / Okendo / Ninguna
2. ¿Usas Appstle para suscripciones? → Sí / No / Todavía no

**Ronda 2 (si aplica):**
3. ¿Quieres el carrito como drawer (slide-out) o página de carrito?
4. ¿El tema tendrá versión en español, inglés, o ambos?

Con estas respuestas, todas las secciones generadas incluirán los snippets correctos de reviews y los hooks de Appstle automáticamente.

---

## Estructura obligatoria de un tema Shopify OS 2.0

```
theme/
├── assets/              # CSS, JS, imágenes, fuentes
│   ├── theme.css
│   ├── theme.js
│   └── component-*.css  # CSS por componente
├── blocks/              # Theme Blocks reutilizables con schema propio
├── config/
│   ├── settings_schema.json   # Configuración global del tema
│   └── settings_data.json     # Valores por defecto
├── layout/
│   └── theme.liquid           # OBLIGATORIO — layout base
├── locales/
│   └── en.default.json        # Traducciones i18n
├── sections/            # Componentes editables por el merchant
├── snippets/            # Fragmentos Liquid reutilizables (sin schema)
└── templates/           # JSON templates (OS 2.0) o .liquid
    ├── index.json
    ├── product.json
    ├── collection.json
    ├── cart.json
    ├── page.json
    ├── blog.json
    ├── article.json
    └── customers/
        ├── login.json
        └── account.json
```

**Regla crítica:** Solo `layout/theme.liquid` es estrictamente obligatorio para subir el tema. Todo lo demás es necesario para una tienda funcional.

---

## Jerarquía de componentes (de mayor a menor)

| Nivel | Tipo | Editable por merchant | Tiene schema |
|-------|------|----------------------|--------------|
| 1 | **Template (.json)** | Sí, añade/reordena secciones | No |
| 2 | **Section (.liquid)** | Sí, configura settings | Sí (`{% schema %}`) |
| 3 | **Block** | Sí, dentro de la sección | Sí (dentro del schema) |
| 4 | **Theme Block (.liquid en /blocks)** | Sí, reutilizable entre secciones | Sí (archivo propio) |
| 5 | **Snippet (.liquid)** | No (invisible en editor) | No |

**Regla arquitectónica (Pipeline/Impulse style):**
- Section = idea completa standalone ("Hero", "Featured Collection", "Ingredients Table")
- Snippet = código HTML reutilizado en múltiples sections (ej: `product-card.liquid`)
- Theme Block = componente configurable reutilizable entre sections (ej: `button.liquid`, `badge.liquid`)

---

## Secciones obligatorias por página (tienda suplementos)

### HOME (`templates/index.json`)
| Sección | Archivo | Prioridad |
|---------|---------|-----------|
| Announcement bar | `sections/announcement-bar.liquid` | Alta |
| Header con mega menu | `sections/header.liquid` | Alta |
| Hero banner / slideshow | `sections/hero-banner.liquid` | Alta |
| Featured collections | `sections/featured-collections.liquid` | Alta |
| Benefits/iconos (por qué elegirnos) | `sections/benefits-strip.liquid` | Alta |
| Featured product | `sections/featured-product.liquid` | Media |
| Testimonials / reviews | `sections/testimonials.liquid` | Alta |
| Trust badges strip | `sections/trust-badges.liquid` | Alta |
| Newsletter / Quiz CTA | `sections/newsletter.liquid` | Media |
| Before/After o comparativa | `sections/comparison.liquid` | Media |
| Blog posts recientes | `sections/blog-posts.liquid` | Baja |
| Footer | `sections/footer.liquid` | Alta |

### PRODUCT (`templates/product.json`)
| Sección | Archivo | Prioridad |
|---------|---------|-----------|
| Product main (media + ATC) | `sections/main-product.liquid` | Crítica |
| Sticky ATC bar (mobile) | `sections/sticky-atc.liquid` | Alta |
| Ingredients / Supplement Facts | `sections/product-ingredients.liquid` | Alta (suplementos) |
| How to use / Usage guide | `sections/product-how-to-use.liquid` | Alta |
| Benefits detallados | `sections/product-benefits.liquid` | Alta |
| Trust badges (near ATC) | `sections/product-trust-badges.liquid` | Alta |
| Reviews / Social proof | `sections/product-reviews.liquid` | Alta |
| FAQ acordeón | `sections/product-faq.liquid` | Alta |
| Certifications / Lab results | `sections/product-certifications.liquid` | Alta (suplementos) |
| Related products / Upsell | `sections/related-products.liquid` | Media |
| Subscribe & Save block | bloque dentro de main-product | Alta |

### COLLECTION (`templates/collection.json`)
| Sección | Archivo | Prioridad |
|---------|---------|-----------|
| Collection banner | `sections/collection-banner.liquid` | Alta |
| Collection grid con filtros | `sections/main-collection.liquid` | Crítica |
| Promo tile entre productos | bloque dentro de collection | Media |

### CART (`templates/cart.json`)
| Sección | Archivo | Prioridad |
|---------|---------|-----------|
| Cart main (items + totales) | `sections/main-cart.liquid` | Crítica |
| Upsell / cross-sell en cart | `sections/cart-upsell.liquid` | Alta |
| Trust badges en cart | `sections/cart-trust.liquid` | Media |
| Free shipping progress bar | bloque dentro de cart | Media |

---

## Anatomía de una Section correcta

```liquid
{% comment %} sections/hero-banner.liquid {% endcomment %}

<section
  class="hero-banner"
  style="
    --hero-height: {{ section.settings.height }}px;
    --hero-overlay: {{ section.settings.overlay_opacity | divided_by: 100.0 }};
  "
>
  {%- if section.settings.image != blank -%}
    <div class="hero-banner__media">
      {{
        section.settings.image
        | image_url: width: 1920
        | image_tag:
          loading: 'eager',
          fetchpriority: 'high',
          class: 'hero-banner__img'
      }}
    </div>
  {%- endif -%}

  <div class="hero-banner__content">
    {%- for block in section.blocks -%}
      {%- case block.type -%}
        {%- when 'heading' -%}
          <h1 class="hero-banner__heading" {{ block.shopify_attributes }}>
            {{ block.settings.heading | escape }}
          </h1>
        {%- when 'subheading' -%}
          <p class="hero-banner__subheading" {{ block.shopify_attributes }}>
            {{ block.settings.subheading | escape }}
          </p>
        {%- when 'button' -%}
          <a
            href="{{ block.settings.button_url }}"
            class="btn btn--{{ block.settings.button_style }}"
            {{ block.shopify_attributes }}
          >
            {{ block.settings.button_label | escape }}
          </a>
      {%- endcase -%}
    {%- endfor -%}
  </div>
</section>

{% schema %}
{
  "name": "Hero Banner",
  "tag": "section",
  "class": "section-hero-banner",
  "settings": [
    {
      "type": "image_picker",
      "id": "image",
      "label": "Background image"
    },
    {
      "type": "range",
      "id": "height",
      "min": 400,
      "max": 900,
      "step": 50,
      "unit": "px",
      "label": "Section height",
      "default": 650
    },
    {
      "type": "range",
      "id": "overlay_opacity",
      "min": 0,
      "max": 80,
      "step": 5,
      "unit": "%",
      "label": "Overlay opacity",
      "default": 30
    }
  ],
  "blocks": [
    {
      "type": "heading",
      "name": "Heading",
      "limit": 1,
      "settings": [
        {
          "type": "text",
          "id": "heading",
          "label": "Heading",
          "default": "Welcome to our store"
        }
      ]
    },
    {
      "type": "subheading",
      "name": "Subheading",
      "limit": 1,
      "settings": [
        {
          "type": "textarea",
          "id": "subheading",
          "label": "Subheading"
        }
      ]
    },
    {
      "type": "button",
      "name": "Button",
      "limit": 2,
      "settings": [
        {
          "type": "text",
          "id": "button_label",
          "label": "Button label",
          "default": "Shop now"
        },
        {
          "type": "url",
          "id": "button_url",
          "label": "Button link"
        },
        {
          "type": "select",
          "id": "button_style",
          "label": "Button style",
          "options": [
            { "value": "primary", "label": "Primary" },
            { "value": "secondary", "label": "Secondary" },
            { "value": "outline", "label": "Outline" }
          ],
          "default": "primary"
        }
      ]
    }
  ],
  "presets": [
    {
      "name": "Hero Banner",
      "blocks": [
        { "type": "heading" },
        { "type": "subheading" },
        { "type": "button" }
      ]
    }
  ]
}
{% endschema %}
```

---

## Anatomía de un Template JSON (OS 2.0)

```json
{
  "sections": {
    "main": {
      "type": "main-product",
      "blocks": {
        "title": { "type": "title", "order": 0 },
        "price": { "type": "price", "order": 1 },
        "variant_picker": { "type": "variant_picker", "order": 2 },
        "quantity": { "type": "quantity_selector", "order": 3 },
        "buy_buttons": { "type": "buy_buttons", "order": 4 },
        "trust_badges": { "type": "trust_badges", "order": 5 },
        "description": { "type": "description", "order": 6 }
      },
      "block_order": ["title","price","variant_picker","quantity","buy_buttons","trust_badges","description"]
    },
    "ingredients": {
      "type": "product-ingredients",
      "disabled": false
    },
    "how_to_use": {
      "type": "product-how-to-use"
    },
    "reviews": {
      "type": "product-reviews"
    },
    "faq": {
      "type": "product-faq"
    },
    "related": {
      "type": "related-products",
      "settings": { "products_to_show": 4 }
    }
  },
  "order": ["main","ingredients","how_to_use","reviews","faq","related"]
}
```

---

## Snippet: product-card.liquid

Usado en: `featured-collections.liquid`, `main-collection.liquid`, `related-products.liquid`, `search-results.liquid`.

```liquid
{% comment %}
  Renders a product card.
  Usage: {% render 'product-card', product: product, show_quick_buy: true %}
{% endcomment %}

<div class="product-card" data-product-id="{{ product.id }}">
  <a href="{{ product | link_to }}" class="product-card__media-wrapper">
    {%- if product.featured_media -%}
      {{
        product.featured_media
        | image_url: width: 600
        | image_tag:
          loading: 'lazy',
          class: 'product-card__img',
          alt: product.featured_media.alt | escape
      }}
      {%- if product.media[1] != blank -%}
        {{
          product.media[1]
          | image_url: width: 600
          | image_tag:
            loading: 'lazy',
            class: 'product-card__img product-card__img--hover',
            alt: product.title | escape
        }}
      {%- endif -%}
    {%- else -%}
      {{ 'product-1' | placeholder_svg_tag: 'product-card__img' }}
    {%- endif -%}

    {%- if product.compare_at_price > product.price -%}
      {%- assign discount = product.compare_at_price | minus: product.price | times: 100 | divided_by: product.compare_at_price -%}
      <span class="product-card__badge product-card__badge--sale">-{{ discount }}%</span>
    {%- endif -%}
  </a>

  <div class="product-card__info">
    <h3 class="product-card__title">
      <a href="{{ product.url }}">{{ product.title | escape }}</a>
    </h3>

    <div class="product-card__price">
      {%- if product.compare_at_price > product.price -%}
        <s class="product-card__price--compare">{{ product.compare_at_price | money }}</s>
      {%- endif -%}
      <span class="product-card__price--current">{{ product.price | money }}</span>
    </div>

    {%- if show_quick_buy -%}
      {%- if product.variants.size == 1 -%}
        <button
          type="button"
          class="btn btn--primary btn--sm product-card__atc"
          data-product-id="{{ product.variants.first.id }}"
        >
          Add to cart
        </button>
      {%- else -%}
        <a href="{{ product.url }}" class="btn btn--secondary btn--sm">
          Choose options
        </a>
      {%- endif -%}
    {%- endif -%}
  </div>
</div>
```

---

## Secciones críticas para suplementos

### 1. `sections/product-ingredients.liquid`
Muestra tabla de Supplement Facts + lista de ingredientes con descripción.
- Settings: `heading`, `image` (foto del panel de nutrición), `disclaimer`
- Blocks: `ingredient` (nombre, cantidad, % DV, descripción, icono)
- Schema type: `"product-ingredients"`

### 2. `sections/trust-badges.liquid`
Strip horizontal de iconos de confianza.
- Badges recomendados para suplementos: GMP Certified, Third-Party Tested, Non-GMO, FDA Registered Facility, Free Shipping, 30-Day Guarantee
- Blocks: `badge` (icono SVG inline, label, sublabel)
- Colocar: debajo del ATC button en product page + footer

### 3. `sections/product-certifications.liquid`
Logos de certificaciones + COAs (Certificates of Analysis).
- Settings: heading, disclaimer_text
- Blocks: `certification` (logo image, nombre, descripción, link a PDF del COA)

### 4. `sections/product-faq.liquid`
Acordeón de preguntas frecuentes.
- Blocks: `faq_item` (pregunta, respuesta richtext)
- Implementar con `<details>/<summary>` nativo (sin JS externo = más rápido)

### 5. Sección Subscribe & Save (bloque dentro de `main-product.liquid`)
- Block type: `subscription_selector`
- Settings: one_time_label, subscribe_label, discount_percentage, savings_badge_text
- Requiere integración con Recharge, Skio, o Stay (apps externas)

---

## layout/theme.liquid — estructura mínima obligatoria

```liquid
<!doctype html>
<html lang="{{ request.locale.iso_code }}">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="theme-color" content="{{ settings.color_background }}">

    <title>
      {{ page_title }}
      {%- if current_tags %} &ndash; tagged "{{ current_tags | join: ', ' }}"{% endif %}
      {%- if current_page != 1 %} &ndash; Page {{ current_page }}{% endif %}
      {%- unless page_title contains shop.name %} &ndash; {{ shop.name }}{% endunless %}
    </title>

    {% if page_description %}
      <meta name="description" content="{{ page_description | escape }}">
    {% endif %}

    {{ content_for_header }}  {%- comment -%} OBLIGATORIO: scripts de Shopify {%- endcomment -%}

    {{ 'theme.css' | asset_url | stylesheet_tag }}
  </head>

  <body class="template-{{ template.name | handle }}">
    {% sections 'header-group' %}

    <main id="MainContent" role="main" tabindex="-1">
      {{ content_for_layout }}  {%- comment -%} OBLIGATORIO: renderiza templates {%- endcomment -%}
    </main>

    {% sections 'footer-group' %}

    {{ 'theme.js' | asset_url | script_tag }}
  </body>
</html>
```

**Variables críticas obligatorias:**
- `{{ content_for_header }}` — dentro de `<head>`, incluye scripts de Shopify Analytics, pixels, etc.
- `{{ content_for_layout }}` — dentro de `<body>`, renderiza el template activo

---

## config/settings_schema.json — estructura para suplementos

Secciones obligatorias del schema global:

```json
[
  {
    "name": "theme_info",
    "theme_name": "SupplStore Theme",
    "theme_version": "1.0.0",
    "theme_author": "La Media Social",
    "theme_documentation_url": "",
    "theme_support_url": ""
  },
  { "name": "Colors", "settings": [
    { "type": "color", "id": "color_primary", "label": "Primary color", "default": "#1a1a2e" },
    { "type": "color", "id": "color_secondary", "label": "Secondary / Accent", "default": "#e94560" },
    { "type": "color", "id": "color_background", "label": "Background", "default": "#ffffff" },
    { "type": "color", "id": "color_text", "label": "Body text", "default": "#1a1a1a" }
  ]},
  { "name": "Typography", "settings": [
    { "type": "font_picker", "id": "font_heading", "label": "Heading font", "default": "assistant_n4" },
    { "type": "font_picker", "id": "font_body", "label": "Body font", "default": "assistant_n4" }
  ]},
  { "name": "Cart", "settings": [
    { "type": "select", "id": "cart_type", "label": "Cart type",
      "options": [
        { "value": "drawer", "label": "Drawer (slide-out)" },
        { "value": "page", "label": "Page" },
        { "value": "notification", "label": "Notification" }
      ],
      "default": "drawer"
    }
  ]},
  { "name": "Badges & Trust", "settings": [
    { "type": "checkbox", "id": "show_trust_badges", "label": "Show trust badges globally", "default": true },
    { "type": "text", "id": "trust_badge_1", "label": "Badge 1 text", "default": "GMP Certified" },
    { "type": "text", "id": "trust_badge_2", "label": "Badge 2 text", "default": "Third-Party Tested" }
  ]}
]
```

---

## Performance: buenas prácticas inspiradas en Pipeline

1. **Lazy loading en todas las imágenes** excepto LCP (above-the-fold hero): usar `loading: 'eager'` + `fetchpriority: 'high'` en hero, `loading: 'lazy'` en todo lo demás.

2. **image_url con width correcto** — nunca cargar imágenes más grandes de lo necesario:
   ```liquid
   {{ product.featured_media | image_url: width: 800 | image_tag: loading: 'lazy' }}
   ```

3. **CSS por componente** — no un solo archivo monolítico. Usar `{{ 'component-product-card.css' | asset_url | stylesheet_tag }}` dentro de cada section que lo necesite.

4. **JS mínimo y nativo** — para acordeones/FAQ usar `<details>/<summary>`, para tabs usar CSS + checkbox hack. Solo JS cuando sea imprescindible.

5. **No usar `{% javascript %}` en sections** salvo si es estrictamente necesario — Shopify los concatena pero penaliza en Lighthouse. Preferir un `theme.js` modular con imports.

6. **SVG inline para iconos** — no cargar icon fonts. Usar snippets: `{% render 'icon-check' %}`.

7. **section_id para CSS scoping:**
   ```liquid
   <style>
     #shopify-section-{{ section.id }} { --color: {{ section.settings.color }}; }
   </style>
   ```

---

## Flujo de trabajo para generar un tema completo

### Paso 1 — Scaffold (estructura de carpetas + archivos base)
Generar: `layout/theme.liquid`, `config/settings_schema.json`, `config/settings_data.json`, `locales/en.default.json`, `assets/theme.css`, `assets/theme.js`

### Paso 2 — Snippets base
Generar primero los snippets más usados:
- `snippets/product-card.liquid`
- `snippets/icon-*.liquid` (check, star, shield, leaf, truck, etc.)
- `snippets/price.liquid`
- `snippets/pagination.liquid`

### Paso 3 — Sections globales
- `sections/announcement-bar.liquid`
- `sections/header.liquid`
- `sections/footer.liquid`

### Paso 4 — Templates + sections por página
Orden: Home → Product → Collection → Cart → Page genérica

### Paso 5 — Validación
Usar `shopify-dev-mcp` para validar Liquid y schemas antes de subir.

### Paso 6 — Empaquetado
Zip de la carpeta con estructura correcta → subir via Shopify Admin > Online Store > Themes > Add theme > Upload zip file.

---

## Errores comunes a evitar

| Error | Corrección |
|-------|-----------|
| Olvidar `{{ content_for_header }}` | SIEMPRE en `<head>` — sin esto el checkout no funciona |
| Olvidar `{{ content_for_layout }}` | SIEMPRE en `<body>` — sin esto no renderiza nada |
| Templates .liquid en vez de .json (OS 2.0) | Usar `.json` para poder añadir secciones en cualquier página |
| Schema sin `"presets"` | Sin presets, la section no aparece en "Add section" del editor |
| Imágenes sin `image_url: width:` | Carga imagen a tamaño original — mata el performance |
| CSS inline en cada section | Extraer a `assets/component-*.css` |
| Hardcodear textos en Liquid | Siempre via `section.settings` para que sea editable |
| Bloques sin `{{ block.shopify_attributes }}` | Sin esto, drag & drop en editor no funciona |

---

## Checklist antes de subir a Shopify

- [ ] `layout/theme.liquid` existe y tiene `content_for_header` + `content_for_layout`
- [ ] Todos los templates .json tienen al menos 1 section con preset
- [ ] `config/settings_schema.json` tiene bloque `theme_info` como primer elemento
- [ ] Todas las sections tienen `{% schema %}` con `"presets"` definidos
- [ ] Todos los bloques tienen `{{ block.shopify_attributes }}`
- [ ] Imágenes usan `image_url: width: X` + lazy loading correcto
- [ ] No hay rutas absolutas hardcodeadas — todo usa `| asset_url`
- [ ] `locales/en.default.json` existe (puede estar vacío: `{}`)
- [ ] Validado con `shopify-dev-mcp:validate_theme` si disponible

---

---

## PÁGINA DE PRODUCTO — Anatomía completa alta conversión (suplementos)

### Estructura visual: orden de secciones de arriba a abajo

```
┌─────────────────────────────────────────────┐
│  ZONA ABOVE THE FOLD (sin scroll)           │
│  ├─ Galería media (imágenes + video)        │
│  ├─ Título (benefit-led, no feature-led)    │
│  ├─ Rating stars + número de reviews        │
│  ├─ Precio + precio tachado + % descuento   │
│  ├─ Selector variante (sabor, tamaño, pack) │
│  ├─ Subscribe & Save toggle ← CRÍTICO       │
│  ├─ Selector cantidad + ATC button          │
│  └─ Trust badges (3-4 máx, bajo el botón)  │
├─────────────────────────────────────────────┤
│  ZONA 2 — Educación del producto            │
│  ├─ Benefits strip (iconos + texto)         │
│  ├─ "How it works" / How to use (3 pasos)  │
│  ├─ Ingredients / Supplement Facts table   │
│  ├─ "What we never include" (diferenciador)│
│  └─ Certifications (COA, GMP, NSF, etc.)  │
├─────────────────────────────────────────────┤
│  ZONA 3 — Prueba social                     │
│  ├─ Star rating summary + breakdown         │
│  ├─ Review carousel (foto + texto)          │
│  ├─ Before/After o stats ("94% agree…")    │
│  └─ Press / media mentions                 │
├─────────────────────────────────────────────┤
│  ZONA 4 — Objeciones y conversión final     │
│  ├─ FAQ acordeón (5-8 preguntas)           │
│  ├─ Guarantee / Returns policy visual       │
│  ├─ ATC button REPETIDO (reduce scroll)    │
│  └─ Related products / "Complete the stack"│
└─────────────────────────────────────────────┘
```

### Elementos obligatorios por zona

**ABOVE THE FOLD (lo que ve el usuario sin hacer scroll)**
- Título benefit-led: "Boost Energy & Focus Naturally" NO "Pre-workout Formula X200"
- Rating + número prominente debajo del título (trust inmediato)
- Precio con ahorro visible si hay descuento
- **Subscribe & Save toggle** — selector one-time vs subscription con % ahorro visible
- ATC button de alto contraste, tamaño ≥48px altura
- 3-4 trust badges: Dinero-back guarantee, Free shipping, Certified, Third-party tested

**GALERÍA DE MEDIOS**
- 5-8 imágenes mínimo: hero en uso (lifestyle), producto solo, ingredientes, certificados, packaging detalle
- 1 video de 30-90 segundos (UGC o demo) convierte 16-28% mejor para productos >$50
- Zoom funcional en desktop
- Mobile: swipe nativo

**SUPPLEMENT FACTS / INGREDIENTS TABLE**
- Tabla visual del panel nutricional (imagen del label real + HTML accesible)
- Lista de ingredientes con descripción de beneficio para cada uno
- Sección "What we never include" (diferenciador de competencia)
- Disclaimer FDA/EFSA al final

**TRUST BADGES para suplementos** (posición: debajo del ATC)
```
[🏭 GMP Certified] [🔬 Third-Party Tested] [💰 30-Day Guarantee] [🚚 Free Shipping]
```
Máximo 4 badges. Más de 5 reduce conversión (-4% según estudios).

**SUBSCRIBE & SAVE — Selector de suscripción nativo en product page**
```liquid
<div class="purchase-type-selector">
  <label class="purchase-option">
    <input type="radio" name="purchase_type" value="one_time"> 
    One-time purchase — {{ product.price | money }}
  </label>
  <label class="purchase-option purchase-option--highlighted">
    <input type="radio" name="purchase_type" value="subscribe" checked>
    Subscribe & Save 15% — {{ product.price | times: 0.85 | money }}/mo
    <span class="savings-badge">BEST VALUE</span>
  </label>
</div>
```
⚠️ Este selector es visual en el tema — la lógica de cobro recurrente REQUIERE una app externa (ver sección Suscripciones más abajo).

---

## CARRITO — Drawer Cart con Cross-sell

### Anatomía del Cart Drawer (slide-out cart)

```
┌──────────────────────────────────┐
│  CART DRAWER                     │
│  ├─ Header: "Tu carrito (2)"    │
│  ├─ Free shipping progress bar  │  ← "Añade $12 más para envío gratis"
│  ├─ Items list                   │
│  │   ├─ Imagen + título + qty   │
│  │   ├─ Precio / precio suscr.  │
│  │   └─ Remove button           │
│  ├─ ─────────────────────────   │
│  ├─ CROSS-SELL / FBT SECTION    │  ← "Frequently Bought Together"
│  │   ├─ "Completa tu stack:"    │
│  │   ├─ Product card 1 + ATC   │
│  │   └─ Product card 2 + ATC   │
│  ├─ ─────────────────────────   │
│  ├─ Descuento code input        │
│  ├─ Subtotal                    │
│  ├─ Trust badges (mini)         │
│  └─ [CHECKOUT BUTTON]           │
└──────────────────────────────────┘
```

### Cross-sell en Cart: implementación Liquid nativa

```liquid
{% comment %} snippets/cart-cross-sell.liquid {% endcomment %}
{% comment %}
  Muestra productos complementarios basados en colecciones o metafields.
  Usage: {% render 'cart-cross-sell', cart: cart %}
{% endcomment %}

{%- assign cross_sell_products = collections['complementos'].products | limit: 2 -%}
{%- assign cart_product_ids = cart.items | map: 'product_id' -%}

{%- assign has_cross_sell = false -%}
{%- for product in cross_sell_products -%}
  {%- unless cart_product_ids contains product.id -%}
    {%- assign has_cross_sell = true -%}
  {%- endunless -%}
{%- endfor -%}

{%- if has_cross_sell -%}
  <div class="cart-cross-sell">
    <p class="cart-cross-sell__heading">Completa tu stack</p>
    <div class="cart-cross-sell__products">
      {%- for product in cross_sell_products -%}
        {%- unless cart_product_ids contains product.id -%}
          <div class="cart-cross-sell__item">
            {{
              product.featured_media
              | image_url: width: 80
              | image_tag: loading: 'lazy', class: 'cart-cross-sell__img'
            }}
            <div class="cart-cross-sell__info">
              <p class="cart-cross-sell__title">{{ product.title | truncate: 30 }}</p>
              <p class="cart-cross-sell__price">{{ product.price | money }}</p>
            </div>
            <button
              type="button"
              class="btn btn--sm btn--outline cart-cross-sell__atc"
              data-variant-id="{{ product.variants.first.id }}"
            >
              + Añadir
            </button>
          </div>
        {%- endunless -%}
      {%- endfor -%}
    </div>
  </div>
{%- endif -%}
```

### Free Shipping Progress Bar (Liquid nativo)

```liquid
{% comment %} snippets/free-shipping-bar.liquid {% endcomment %}
{%- assign free_shipping_threshold = 50 | times: 100 -%} {%- comment -%} $50 en centavos {%- endcomment -%}
{%- assign cart_total = cart.total_price -%}
{%- assign remaining = free_shipping_threshold | minus: cart_total -%}
{%- assign progress = cart_total | times: 100 | divided_by: free_shipping_threshold -%}
{%- if progress > 100 -%}{%- assign progress = 100 -%}{%- endif -%}

<div class="free-shipping-bar">
  {%- if remaining > 0 -%}
    <p class="free-shipping-bar__text">
      Añade <strong>{{ remaining | money }}</strong> más para envío gratis 🚚
    </p>
  {%- else -%}
    <p class="free-shipping-bar__text free-shipping-bar__text--unlocked">
      ✅ ¡Envío gratis desbloqueado!
    </p>
  {%- endif -%}
  <div class="free-shipping-bar__track">
    <div class="free-shipping-bar__fill" style="width: {{ progress }}%"></div>
  </div>
</div>
```

---

## SUSCRIPCIONES — Decisión de app

### Respuesta directa: SÍ necesitas una app

Shopify tiene **Shopify Subscriptions nativa** (gratis) pero es muy limitada. Para suplementos DTC se necesita más funcionalidad. Aquí la comparativa honesta para una tienda nueva:

| App | Precio | Para quién | Pros clave | Contras |
|-----|--------|------------|------------|---------|
| **Shopify Subscriptions** (nativa) | Gratis | Test inicial | Sin coste, integrada | Muy limitada, sin portal avanzado, sin retención |
| **Appstle** ⭐ RECOMENDADA | Gratis hasta $500/mes, luego $10/mes | Tienda nueva/media | Free tier, 4.9★/4355 reviews, 0% transaction fee, bundles, portal avanzado | Menos potente que Recharge en retención avanzada |
| **Seal Subscriptions** | Gratis (plan básico) | Starter | Muy ligera, fácil setup | Pocas funciones avanzadas |
| **Loop Subscriptions** | Desde $99/mes | Marcas con subscribers establecidos | Retención + gamification, analytics | Caro para empezar |
| **Skio** | Desde $299-$499/mes | High-growth DTC ($500K+/año) | Passwordless login, UX premium | Precio prohibitivo para lanzamiento |
| **Recharge** | Desde $99/mes | Enterprise | El más completo, mejor Klaviyo integration | Complejo, caro, curva de aprendizaje |

### ✅ Recomendación para tienda nueva de suplementos

**Fase 1 (lanzamiento):** Appstle gratis → hasta $500/mes en revenue de suscripciones
**Fase 2 (crecimiento):** Appstle Starter $10/mes → hasta $5,000/mes, añade loyalty + passwordless login
**Fase 3 ($30K+/mes subscriptions):** Appstle Business $30/mes O migrar a Loop/Recharge

**¿Por qué Appstle?**
- 40,000+ merchants, 4.9★ con 4,355 reviews verificados
- **0% transaction fee** (Recharge cobra 1.25% + $0.19/orden)
- Plan gratis funcional para validar el modelo
- Integra con Appstle Bundles (misma empresa = sin fricción)
- Compatible con Shopify OS 2.0, Shopify Payments, Authorize.net, PayPal
- Soporte 24/7 en minutos (reportado consistentemente)
- El widget es customizable y se integra en el tema sin código

### Flujo Subscribe & Save en la product page

Con Appstle instalado, el widget reemplaza/complementa el selector manual que puedes tener en el tema:

```
[Compra única — $39.99]
[● Subscribe & Save 15% — $33.99/mes] ← Appstle inyecta esto
     └ Entrega: [Mensual ▼]
     └ Cancela cuando quieras · Pausa o salta envíos
```

El widget de Appstle es configurable en posición, colores y texto desde el admin.

---

## APPS STACK RECOMENDADO para tienda suplementos nueva

### Apps necesarias (funcionalidades que el tema NO puede hacer solo)

| Función | App recomendada | Precio | ¿Imprescindible? |
|---------|----------------|--------|-----------------|
| **Suscripciones** | Appstle Subscriptions | Gratis → $10/mes | ✅ SÍ |
| **Reviews con fotos** | Loox | ~$9.99/mes | ✅ SÍ |
| **Upsell/Cross-sell avanzado** | Selleasy o Essential Upsell | Gratis → $9.99/mes | ⚡ Recomendada |
| **Cart Drawer + Cross-sell** | Amp Slide Cart / Opus Cart | Gratis → $19.99/mes | ⚡ Recomendada (si no lo construyes en tema) |
| **Bundles / FBT** | Appstle Bundles | Gratis → $12/mes | ⚡ Si vendes packs |
| **Email + SMS** | Klaviyo | Gratis hasta 250 subs | ✅ SÍ |
| **Traducciones** | Translify o Langify | ~$17.50/mes | Si venta internacional |
| **SEO técnico** | TinyIMG o Booster SEO | Gratis → $9.99/mes | Recomendada |

### Lo que SÍ puedes construir en el tema (sin app)

| Función | Implementación |
|---------|---------------|
| Free shipping progress bar | Liquid nativo (snippet) |
| Cross-sell básico en cart | Liquid nativo (colección complementos) |
| Trust badges | Liquid + SVG inline |
| Sticky ATC bar | CSS position:sticky + JS mínimo |
| FAQ acordeón | `<details>/<summary>` HTML nativo |
| Announcement bar | Section + schema |
| Product comparison table | Metafields + Liquid |
| "Frequently bought together" básico | Liquid con colección relacionada |

### Veredicto: Cart Drawer con Cross-sell

**Opción A — Tema propio (más control, mejor performance):**
Construir `sections/cart-drawer.liquid` con snippet `cart-cross-sell.liquid` usando colecciones de Shopify o metafields para definir los productos relacionados. Requiere JS para abrir/cerrar el drawer y AJAX para añadir productos sin reload.

**Opción B — App (más rápido, menos código):**
Amp Slide Cart o Opus Cart (ambos free tier disponible). Se integran en cualquier tema OS 2.0 en minutos. Incluyen FBT, free shipping bar, trust badges, countdown timer. Recomendado para lanzar rápido.

**Para el tema personalizado que estamos construyendo:** construir el cart drawer en el tema (Opción A) y dejar los hooks de integración para Appstle Subscriptions.

---

## Integración con shopify-dev-mcp (disponible en este entorno)

Antes de entregar cualquier archivo Liquid, ejecutar:
```
shopify-dev-mcp:validate_theme               → valida Liquid + schemas
shopify-dev-mcp:validate_graphql_codeblocks  → si usas Storefront API
shopify-dev-mcp:search_docs_chunks           → para buscar documentación oficial
```

---

## Descriptor del skill (para activación automática)

**Nombre oficial:** `creator-template-shop`

**Triggers de activación:**
- "crea una sección de…"
- "quiero una plantilla de Shopify…"
- "replica esta página" + imagen adjunta
- "copia esta sección" + captura de pantalla
- "tema Shopify para suplementos"
- "product page con subscribe and save"
- "cart drawer con cross-sell"
- "integra Loox en…"
- "genera el Liquid de…"
- cualquier solicitud con imagen de una tienda Shopify

**Capacidades clave:**
1. Genera temas Shopify OS 2.0 completos
2. Clona secciones a partir de capturas de pantalla (Modo Agente Visual)
3. Integra Loox, Judge.me, Yotpo, Okendo, Appstle, Klaviyo
4. Produce código Liquid validable con shopify-dev-mcp
5. Arquitectura modular estilo Pipeline + Impulse
6. Especialización en suplementos / health & wellness DTC
