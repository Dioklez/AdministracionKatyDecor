# KatyDecor Admin — Flutter Desktop

## Contexto del proyecto
App de administración para KatyDecor Comercial & co.
Flutter Desktop (Windows) + Android (futuro).
Un solo codebase, dos plataformas.

## Backend
- **PocketBase** en Fly.io
- **URL:** https://katydecorpocketbase.fly.dev
- **Admin panel:** https://katydecorpocketbase.fly.dev/_/
- **SDK:** pocketbase (pub.dev)

## Stack
- Flutter 3.x
- Dart
- pocketbase (cliente SDK oficial)
- drift (SQLite local para offline)
- fl_chart (gráficas dashboard)

## Colores de marca
- Verde: #4CAF50 (o el que se definió previamente)
- Negro: #1A1A1A
- Naranja: #FF6F00
- Fondo: #F5F5F5

## Collections en PocketBase
- categories
- accounts
- suppliers
- projects
- project_stages
- tasks
- transactions
- quotes
- budgets
- supplier_products
- inventory_items
- inventory_movements
- account_payments
- remisiones
- facturas_emitidas

## Arquitectura
- /lib/core/ — configuración, constantes, tema
- /lib/models/ — modelos Dart
- /lib/services/ — servicios PocketBase
- /lib/screens/ — pantallas
- /lib/widgets/ — componentes reutilizables

## Notas importantes
- La app anterior usaba Flask en Render — ya no se usa
- Todo el backend es PocketBase
- Offline-first con drift + sync a PocketBase
- Estética Apple: limpia, espaciosa, esquinas redondas
- Paleta KatyDecor en detalles: hover, tabs activos, líneas