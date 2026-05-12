#!/bin/bash
# Ejecuta esto en tu Mac para subir los cambios a GitHub

echo "🚀 PUSHING creator-template-shop v2.1 to GitHub...\n"

# Navega al repo
cd ~/Documents/GitHub/shop

# Asegúrate de estar en main
git checkout main

# Copia los archivos desde Claude Desktop
mkdir -p creator-template-shop
cp ~/Library/Application\ Support/Claude/skills/creator-template-shop/SKILL.md \
   creator-template-shop/SKILL.md
cp ~/Library/Application\ Support/Claude/skills/creator-template-shop/README.md \
   creator-template-shop/README.md
cp ~/Library/Application\ Support/Claude/skills/creator-template-shop/AGENTS-SUMMARY.md \
   creator-template-shop/AGENTS-SUMMARY.md

# Commit
git add creator-template-shop/
git commit -m "Release creator-template-shop v2.1 - 19 specialized agents

Features:
- Agentes 1-7: Construcción (51 archivos Liquid + 5 JSON)
- Agente 8: Testing & Validation
- Agente 9: Code Validator (Liquid, JSON, CSS)
- Agente 10: Composition Analyzer
- Agente 11: Theme Packager (.zip ready)
- Agente 12: Popup & Modal System (10 tipos)
- Agente 13: A/B Testing & Analytics
- Agente 14: SEO & Content Optimization
- Agente 15: Performance & Speed Optimization
- Agente 16: Shopify AI Toolkit Integration
- Agente 17: CRO Optimization
- Agente 18: Multi-Channel Integration
- Agente 19: Automation & Workflow Builder

Product Page (Agente 2): 16 secciones con tendencias 2026
Popup System (Agente 12): Welcome, exit-intent, event-triggered, mobile-first

Status: Production ready ✅"

# Push
git push origin main

echo "✅ Subido a GitHub: https://github.com/Dadne-cdm/shop"

