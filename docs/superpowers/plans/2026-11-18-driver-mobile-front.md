# ShareWay Driver Mobile Front Implementation Plan

> **For agentic workers:** Implement this plan in small, reviewable steps. Preserve the passenger feature and shared authentication work.

**Goal:** Replace the starter counter screen with a navigable ShareWay driver experience for Avance 4, focused on trip progress, route changes, notifications, and emergency handling.

**Architecture:** Keep the existing Flutter dependencies and use feature folders with `data`, `domain`, and `presentation`. Views render immutable demo data through a driver repository and simple Flutter state objects; shared theme, map preview, alerts, support, and error states live under `shared`.

**Tech Stack:** Flutter/Dart already configured in the repository; Material widgets, custom-painted route preview, and in-memory data for this first frontend slice. API integration and platform map/QR packages are deferred until their contracts are confirmed.

**Spec:** ShareWay TB3 report, Sprint 3/TB4 scope; supplied driver, shared notification/support, and emergency-link mockups.

## Global Constraints

- Work on `feature/driver`, branched from `develop`.
- Keep all sample data visibly demo-oriented and behind repository interfaces.
- Do not modify microservice repositories or API Gateway in this frontend change.
- Match the supplied ShareWay color, type, spacing, and card conventions.
- Do not alter passenger flows; shared components should remain reusable.

## Files and Responsibilities

- `lib/main.dart`: application entry point.
- `lib/app.dart`: app title, theme, and initial driver shell.
- `lib/shared/theme/app_theme.dart`: palette and component styling.
- `lib/shared/widgets/`: reusable route preview, status badges, action buttons, and service-state panels.
- `lib/shared/presentation/`: notifications, help/support, and emergency public-link states.
- `lib/driver/domain/`: driver trip, proposal, stop, and repository contracts.
- `lib/driver/data/`: in-memory demo repository and example data.
- `lib/driver/presentation/`: bottom navigation, home, proposals, trips, trip detail, active trip, emergency, and profile views.
- `README.md`: local run instructions and current demo/API boundaries.
- `docs/superpowers/plans/2026-11-18-driver-mobile-front.md`: this scope and implementation plan.

## Implementation Tasks

1. Add the ShareWay theme and app shell with Inicio, Propuestas, Viajes, and Perfil navigation.
2. Add demo models and a repository for driver proposals, trips, stops, status, and earnings.
3. Build the driver home and proposal list/detail interactions.
4. Build the trip list and detail with route preview, passenger progress, cancellation/recalculation states, and live-sharing control.
5. Build the emergency action, sent/failed states, and live-link/expired-link pages.
6. Add reusable notifications, support, loading, offline, service-error, and expired-session screens.
7. Record API gaps and run static Dart analysis; do not change backend contracts in this frontend branch.
