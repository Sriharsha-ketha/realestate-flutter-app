# Milestone System - Visual Design Guide

## Milestone Timeline Display

### Default State (Not Cancelled)

```
┌─────────────────────────────────────────────────┐
│  ℹ️  Current Stage: Design Planning              │
└─────────────────────────────────────────────────┘

Project Progress

✓ Land Approved          
  Completed
  
  |─────────────────── (connecting line)
  
✓ Investors Joined
  Completed
  
  |─────────────────── (connecting line)
  
✓ Design Planning
  Completed
  
  |─────────────────── (connecting line)
  
⬜ Construction Started
   Upcoming
   
   |─────────────────── (connecting line)
   
⬜ Resort Completed
   Upcoming
   
   |─────────────────── (connecting line)
   
⬜ Tourists Arriving
   Upcoming

─────────────────────────────────────────────────
Overall Progress: 50%
[████████░░░░░░░░░░░░]
```

### Cancelled State

```
┌─────────────────────────────────────────────────┐
│                                                 │
│  ⊗ Project Cancelled                            │
│                                                 │
└─────────────────────────────────────────────────┘
```

## Color Scheme

- **Completed Milestone**: Green circle (#4CAF50) with white checkmark
- **Pending Milestone**: Grey circle (#E0E0E0) with number
- **Connecting Line**: Green for completed, Grey for pending
- **Current Stage Card**: Blue background (#E3F2FD)
- **Progress Bar**: Green (#4CAF50)
- **Cancelled Container**: Red background (#FFEBEE)

## Component Specifications

### Milestone Item Container
- **Width**: Full width of parent
- **Padding**: 12px vertical
- **Layout**: Horizontal Row with:
  1. Indicator Circle (40x40px)
  2. 16px spacing
  3. Expanded text column
  4. Connecting line (last item excluded)

### Indicator Circle
- **Size**: 40x40px
- **Border Radius**: 50% (circle)
- **Content**: 
  - Checkmark icon (if completed) - 16px
  - Number text (if pending) - 14px bold

### Milestone Text
- **Name**: 16px, bold, green/grey based on status
- **Status**: 12px, grey, "Completed" or "Upcoming"

### Current Stage Card
- **Background**: Light blue (#E3F2FD)
- **Border**: 1px solid blue (#B3E5FC)
- **Border Radius**: 8px
- **Padding**: 12px all sides
- **Icon**: Info icon (blue)
- **Text**: 
  - Label: 12px grey
  - Value: 14px bold, dark blue

### Progress Bar
- **Width**: Full width
- **Height**: 8px
- **Border Radius**: 8px
- **Background**: Light grey (#E0E0E0)
- **Value**: Green (#4CAF50)

## Responsive Behavior

### Mobile (< 600px)
- Full width with margins
- Single column layout
- Connecting lines left-aligned
- Normal font sizes

### Tablet/Desktop (≥ 600px)
- Centered content with max-width
- Single column layout
- Connecting lines left-aligned
- Normal font sizes

## Interaction Behavior

### Non-Interactive (User)
- No taps or clicks trigger actions
- Timeline is view-only
- Read-only experience

### View Updates
- When investor refreshes page, latest stage is loaded
- Real-time updates require page refresh
- Admin changes stage, investor must refresh to see changes

## Spacing Guide

```
┌─────────────────────────────────┐
│ AppBar (56px)                   │
├─────────────────────────────────┤
│ Padding: 20px                   │
│                                 │
│ Current Stage Card              │
│ Margin Bottom: 24px             │
│                                 │
│ "Project Progress" Header       │
│ Margin Bottom: 16px             │
│                                 │
│ Milestone 1                      │
│ Margin: 12px vertical           │
│                                 │
│ [Connector Line - 40px height]  │
│                                 │
│ Milestone 2                      │
│ ... repeats ...                 │
│                                 │
│ Progress Section                │
│ Margin Top: 24px                │
│                                 │
└─────────────────────────────────┘
```

## Animation Considerations

Current implementation: **Static (no animations)**

Future enhancement options:
- Fade-in animation for each milestone as page loads
- Progress bar animation when stage updates
- Checkmark animation when milestone completed
- Subtle color transitions

## Accessibility

- ✓ Color contrast meets WCAG AA standards
- ✓ Icon + text labels (not icons alone)
- ✓ Readable font sizes (minimum 12px)
- ✓ Sufficient touch target sizes (40x40px minimum)
- ✓ Semantic HTML structure

## States & Variants

### Early Stage Project
```
LAND_APPROVED stage
- 1 completed milestone
- 5 pending milestones
- Progress: 17%
```

### Mid-Stage Project
```
PLANNING stage
- 3 completed milestones
- 3 pending milestones
- Progress: 50%
```

### Late-Stage Project
```
OPERATIONAL stage
- 6 completed milestones
- 0 pending milestones
- Progress: 100%
```

### Cancelled Project
```
CANCELLED stage
- Red error state displayed
- No timeline shown
- Special message shown
```

## Font Specifications

| Element | Size | Weight | Color |
|---------|------|--------|-------|
| AppBar Title | 16px | normal | White/Dark |
| Current Stage Label | 12px | normal | Blue #1976D2 |
| Current Stage Value | 14px | bold | Dark Blue #0D47A1 |
| Milestone Name | 16px | bold | Green/Grey |
| Milestone Status | 12px | normal | Grey #757575 |
| Indicator Number | 14px | bold | Grey |
| Progress Label | 14px | bold | Black |
| Progress Percentage | 14px | bold | Green |

## Error Handling

### Stage Not Found
- Defaults to 'LAND_APPROVED'
- Displays first milestone only
- User can refresh to retry

### Invalid Stage Value
- Treats as unknown stage
- Shows all milestones as pending
- No breaking UI

## Performance Considerations

- Single build per page load
- No animations (low GPU usage)
- Small widget tree (efficient)
- Recomputes only on state change
- Minimal rebuilds with Consumer scope
