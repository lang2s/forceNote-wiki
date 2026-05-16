# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**나의 버킷 리스트** (My Bucket List) is a single-page web application for managing personal life goals. It's built with vanilla JavaScript (no framework), uses LocalStorage for data persistence, and Tailwind CSS for styling.

## Architecture

### Two-Module Design

The application follows a clear separation of concerns:

#### `js/storage.js` - Data Layer (Model)
- Singleton pattern using object literal `BucketStorage`
- Single source of truth for all CRUD operations
- Manages LocalStorage persistence and data transformations
- Key methods: `load()`, `save()`, `addItem()`, `updateItem()`, `deleteItem()`, `toggleComplete()`, `getStats()`, `getFilteredList()`
- Never directly manipulates DOM

#### `js/app.js` - UI Layer (Controller/View)
- Class-based controller `BucketListApp` 
- Lifecycle: `constructor()` → `init()` → `cacheElements()` → `bindEvents()` → `render()`
- All event handlers and DOM manipulation happen here
- Always calls `BucketStorage` methods, never reads/writes LocalStorage directly
- `render()` is the single source of truth for DOM state — call after any data change

### Data Flow

```
User Action (HTML)
    ↓
Event Handler (app.js)
    ↓
Storage Method (storage.js)
    ↓
LocalStorage (browser)
    ↓
render() called (app.js)
    ↓
DOM Updated (HTML)
```

### Data Structure

Each bucket list item:
```javascript
{
  id: "1730880000000",           // Timestamp-based unique ID
  title: "세계 일주하기",          // Goal title
  completed: false,               // Completion status
  createdAt: "2025-11-06T...",   // ISO 8601 creation time
  completedAt: null               // ISO 8601 completion time (null if not completed)
}
```

## Development

### Running the Project

Since this is a vanilla JavaScript project with no build step, just open in browser:

1. **Direct**: Double-click `index.html` in file explorer
2. **Live Server** (VS Code): Right-click `index.html` → "Open with Live Server"
3. **Python server**: `python -m http.server 8000` then visit `http://localhost:8000`

### No Build Process

- No npm scripts, no webpack, no bundler
- Tailwind CSS loaded from CDN (development mode)
- For production, consider self-hosting Tailwind or using CSS purge

### Key Files to Modify

- **Add feature**: Likely need changes in both `storage.js` (data layer) and `app.js` (UI layer)
- **Styling**: `css/styles.css` for custom CSS, `index.html` for Tailwind classes
- **HTML structure**: `index.html` — be careful with IDs used by JavaScript

## Important Notes

- **LocalStorage only**: Data lives only in browser, not synced across devices
- **No validation framework**: Input validation is minimal (trim, empty checks)
- **XSS protection**: User input is escaped via `escapeHtml()` before rendering
- **Event handlers**: Inline `onclick` attributes used for simplicity (acceptable for this small project)
- **Responsive design**: Mobile-first with custom breakpoints in `css/styles.css`

## Testing

No automated tests. To manually verify changes:
1. Add new items
2. Toggle completion status
3. Edit and delete items
4. Test filters (all/active/completed)
5. Verify stats update correctly
6. Check mobile responsiveness (DevTools device mode)
7. Reload page to verify LocalStorage persistence
