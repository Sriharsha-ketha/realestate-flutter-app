# Hierarchical Tourism Filters Implementation - Complete Guide

## Overview

This document describes the complete end-to-end implementation of hierarchical tourism filters for the Real Estate Investment Platform. The system enables:

1. **Landowners** to select State/Region and Tourist Destination when submitting land
2. **Admins** to view and approve land with tourism categories, then convert to projects (categories auto-copied)
3. **Investors** to filter projects by State/Region and Tourist Destination on the Explore page

## Backend Changes

### 1. Entity Models Updated

#### `Land.java`
- Added fields: `stateCategory` (String), `destination` (String)
- Added column mapping: `@Column(name = "state_category")`
- Added getters/setters for both fields

#### `Project.java`
- Added fields: `stateCategory` (String), `destination` (String)
- Added column mapping: `@Column(name = "state_category")`
- Added getters/setters for both fields

### 2. Database Schema Updated

File: `backend/src/main/resources/postgres_schema.sql`

**Lands Table:**
```sql
ALTER TABLE lands ADD COLUMN state_category VARCHAR(255);
ALTER TABLE lands ADD COLUMN destination VARCHAR(255);
```

**Projects Table:**
```sql
ALTER TABLE projects ADD COLUMN state_category VARCHAR(255);
ALTER TABLE projects ADD COLUMN destination VARCHAR(255);
```

### 3. New Destinations Controller

File: `backend/src/main/java/com/example/realestate/controller/DestinationsController.java`

**Endpoint:** `GET /api/destinations` or `GET /api/destinations/all`

**Response:** Returns `Map<String, List<String>>` with 14 states and their destinations

```json
{
  "Tamil Nadu": ["Ooty"],
  "Uttar Pradesh": ["Ayodhya"],
  "Uttarakhand": ["Kedarnath", "Badrinath", "Nainital"],
  "West Bengal": ["Darjeeling"],
  "Jammu & Kashmir": ["Gulmarg"],
  "Andaman & Nicobar Islands": ["Andaman", "Radhanagar Beach"],
  "Goa": ["Baga Beach"],
  "Himachal Pradesh": ["Shimla", "Manali"],
  "Karnataka": ["Coorg", "South Karnataka"],
  "Kerala": ["Munnar"],
  "Maharashtra": ["Shirdi Sai Baba Temple"],
  "Odisha": ["Jagannath Temple", "Konark Sun Temple"],
  "Rajasthan": ["Jaipur"],
  "Andhra Pradesh": ["Tirumala", "Araku Valley", "Surya Lanka / Bapatla Beach"]
}
```

### 4. Admin Convert Endpoint Enhanced

File: `backend/src/main/java/com/example/realestate/controller/AdminController.java`

**Endpoint:** `POST /api/admin/convert/{landId}`

**Key Changes:**
- When converting a Land to a Project, the endpoint now automatically copies:
  - `land.stateCategory` → `project.stateCategory`
  - `land.destination` → `project.destination`
  - `land.size` → `project.landSize` (bonus: also copies land size now)

**Example Flow:**
```
Input Land:
  stateCategory = "Uttarakhand"
  destination = "Nainital"
  size = 10.5

Generated Project:
  stateCategory = "Uttarakhand"
  destination = "Nainital"
  landSize = 10.5
```

### 5. API Responses Include Tourism Fields

**GET /api/projects**
- Each ProjectResponse now includes `stateCategory` and `destination`

**POST /api/projects/create**
- Request can include `stateCategory` and `destination`
- Response includes both fields

**POST /api/admin/convert/{landId}**
- Automatically populates fields from Land entity

## Frontend Changes

### 1. ApiService Enhancement

File: `lib/services/api_service.dart`

**New Method:**
```dart
static Future<Map<String, List<String>>> getTourismFilters() async {
  final response = await http.get(Uri.parse('$baseUrl/destinations'), headers: await _getHeaders());
  // Converts JSON Map<String, dynamic> to Map<String, List<String>>
  // Returns state→destinations map
}
```

### 2. Data Models Updated

#### `lib/models/land.dart`
- Added fields: `stateCategory`, `destination`
- Updated `fromJson()` and `toJson()` to include both fields

#### `lib/models/project.dart`
- Added fields: `stateCategory`, `destination`
- Updated `fromJson()` and `toJson()` to include both fields

### 3. Landowner Add Land Screen

File: `lib/features/landowner/add_land_screen.dart`

**Changes:**
- Fetches tourism map from backend on screen init via `_loadTourismMap()`
- Shows hierarchical dropdowns:
  - **State / Region dropdown:** Lists all states fetched from backend
  - **Tourist Destination dropdown:** Appears only when state is selected; shows destinations for that state
- When destination dropdown is changed, state is reset (dependent filtering)
- Submits both `stateCategory` and `destination` with the Land

**UI Flow:**
```
1. Screen loads → calls getTourismFilters()
2. User selects state (e.g., "Uttarakhand")
3. Destination dropdown appears with ["Kedarnath", "Badrinath", "Nainital"]
4. User selects destination (e.g., "Nainital")
5. Submit → Land includes stateCategory="Uttarakhand", destination="Nainital"
```

### 4. Admin Approval View

File: `lib/features/admin/land_details_approval.dart`

**Changes:**
- When admin opens land details, displays:
  - "State / Region" with icon
  - "Tourist Destination" with icon
- Both fields shown only if populated

**Example Display:**
```
Location Details
  Location: Dharamkot, District Kangra
  State / Region: Himachal Pradesh
  Tourist Destination: Manali
  Land Size: 5.5 acres
```

### 5. Investor Explore Page Filters

File: `lib/features/investor/explore_screen.dart`

**Changes:**
- Fetches tourism map from backend on screen init
- Replaced old theme-based chips with hierarchical tourism chips:
  
  **Main Filters (States):**
  - Horizontal chip row with "All" chip + state chips
  - Selecting a state filters projects
  
  **Sub-Filters (Destinations):**
  - Appears only when a specific state is selected
  - Shows "All" + destination chips for that state
  - Selecting a destination further filters projects

**Filtering Logic:**
```dart
void _applyTourismFilter() {
  if (selectedMain == 'All') {
    // Show all projects
    _displayed = List.from(_allProjects);
    return;
  }

  final state = selectedMain;
  final sub = selectedSub == 'All' ? null : selectedSub;

  _displayed = _allProjects.where((p) {
    if (p.stateCategory?.toLowerCase() != state.toLowerCase()) return false;
    if (sub == null) return true; // Show all in state
    return p.destination?.toLowerCase() == sub.toLowerCase();
  }).toList();
}
```

**UI Example:**
```
Main Filter Chips (horizontal scroll):
  [ All ] [ Tamil Nadu ] [ Uttar Pradesh ] [ Uttarakhand ] ...

Sub-Filter Chips (shown when state selected):
  [ All ] [ Kedarnath ] [ Badrinath ] [ Nainital ]

Projects shown:
  - Only projects with stateCategory="Uttarakhand"
  - If destination selected: + destination="Nainital"
```

## Complete End-to-End Flow

### Step 1: Landowner Adds Land
```
1. Landowner navigates to "Add Land" screen
2. Fills in: Name, Location, Phone, Size, Zoning
3. App fetches tourism filters from GET /api/destinations
4. Selects State/Region (e.g., "Uttarakhand")
5. Selects Tourist Destination (e.g., "Nainital")
6. Uploads project files
7. Clicks "Submit for Evaluation"
8. POST /api/lands with:
   {
     name: "Premium Land",
     location: "Dharamkot",
     stateCategory: "Uttarakhand",
     destination: "Nainital",
     size: 10.5,
     ...
   }
```

### Step 2: Admin Approves Land
```
1. Admin navigates to "Land Approval" screen
2. Sees pending land in list
3. Clicks to open land details
4. Sees:
   - All land info
   - State / Region: "Uttarakhand"
   - Tourist Destination: "Nainital"
   - Project files uploaded
5. Clicks "Approve Land" button
6. Dialog appears: Enter financial data
7. Admin enters:
   - Estimated Project Cost: 5,000,000
   - Expected Annual Revenue: 750,000
   - Evaluation Period: 5 years
8. Clicks "Create Project"
9. Backend: POST /api/admin/convert/{landId}
   - Land→Project conversion
   - Automatically copies: stateCategory, destination, landSize
   - Calculates ROI, IRR, Payback
   - Creates Project with all fields
```

### Step 3: Project Created & Investor Filters
```
1. Project created in database with:
   stateCategory: "Uttarakhand"
   destination: "Nainital"
   investmentRequired: 5,000,000
   expectedROI: 15%
   ...

2. Investor navigates to "Explore" page
3. Page loads and fetches tourism filters from GET /api/destinations
4. Shows main filter chips: [ All ] [ Tamil Nadu ] [ Uttar Pradesh ] [ Uttarakhand ] ...
5. Investor clicks "Uttarakhand"
6. Projects filtered to show only Uttarakhand projects
7. Sub-filter chips appear: [ All ] [ Kedarnath ] [ Badrinath ] [ Nainital ]
8. Investor clicks "Nainital"
9. Projects further filtered to show only Nainital projects
10. Investor sees the newly created project
11. Clicks on project → sees details → can submit EOI
```

## Database Migration Steps

For production environments, run these migrations:

```sql
-- Add columns to lands table
ALTER TABLE lands ADD COLUMN state_category VARCHAR(255);
ALTER TABLE lands ADD COLUMN destination VARCHAR(255);

-- Add columns to projects table
ALTER TABLE projects ADD COLUMN state_category VARCHAR(255);
ALTER TABLE projects ADD COLUMN destination VARCHAR(255);

-- Optional: Add indexes for faster filtering
CREATE INDEX idx_projects_state_category ON projects(state_category);
CREATE INDEX idx_projects_destination ON projects(destination);
CREATE INDEX idx_lands_state_category ON lands(state_category);
CREATE INDEX idx_lands_destination ON lands(destination);
```

## Testing Checklist

### Backend Testing

- [ ] `GET /api/destinations` returns all 14 states with destinations
- [ ] `POST /api/lands` accepts and saves stateCategory and destination
- [ ] `GET /api/lands` returns stateCategory and destination
- [ ] `GET /api/projects` returns stateCategory and destination in each project
- [ ] `POST /api/admin/convert/{landId}` copies stateCategory/destination from Land to Project
- [ ] Converted project in database has correct stateCategory and destination

### Frontend Testing

#### Add Land Screen
- [ ] Screen loads without errors
- [ ] Fetches tourism filters on init (verify network request)
- [ ] State dropdown populated with all 14 states
- [ ] Selecting state shows destination dropdown with correct destinations
- [ ] Resetting state clears destination
- [ ] Submitting land includes both stateCategory and destination

#### Admin Approval
- [ ] Land details screen shows "State / Region" when populated
- [ ] Land details screen shows "Tourist Destination" when populated
- [ ] Admin can approve and convert land
- [ ] Conversion succeeds and creates project

#### Explore Page
- [ ] Page loads without errors
- [ ] Fetches tourism filters on init (verify network request)
- [ ] Main filter chips display all states
- [ ] Clicking state chip filters projects
- [ ] Sub-filter chips appear when state selected
- [ ] Clicking destination chip further filters projects
- [ ] Clicking "All" shows all projects again

### End-to-End Test Scenario

1. Create Land as Landowner:
   - State: "Karnataka"
   - Destination: "Coorg"
   - Submit

2. Approve as Admin:
   - View land → verify state/destination shown
   - Convert to project → verify financial calc works

3. Check Project:
   - Query `/api/projects` → verify project has stateCategory="Karnataka", destination="Coorg"

4. Filter as Investor:
   - Go to Explore
   - Click "Karnataka" chip
   - Verify only Karnataka projects shown
   - Click "Coorg" chip
   - Verify only Coorg projects shown (should include our new project)
   - Click "All" → see all projects again

## Files Modified Summary

### Backend
1. `backend/.../model/Land.java` - Added fields & getters/setters
2. `backend/.../model/Project.java` - Added fields & getters/setters
3. `backend/.../controller/ProjectResponse.java` - Added fields in constructor & getters/setters
4. `backend/.../controller/ProjectController.java` - Pass fields to response
5. `backend/.../controller/LandController.java` - Persist fields on update
6. `backend/.../controller/AdminController.java` - **NEW**: Copy fields on convert
7. `backend/.../controller/DestinationsController.java` - **NEW**: Destinations endpoint
8. `backend/src/main/resources/postgres_schema.sql` - Added columns

### Frontend
1. `lib/models/land.dart` - Added fields & JSON mapping
2. `lib/models/project.dart` - Added fields & JSON mapping
3. `lib/services/api_service.dart` - **NEW**: getTourismFilters() method
4. `lib/features/landowner/add_land_screen.dart` - Hierarchical dropdowns, fetch from backend
5. `lib/features/admin/land_details_approval.dart` - Show state/destination info
6. `lib/features/investor/explore_screen.dart` - Hierarchical chips, fetch filters from backend

## Compilation Status

✅ **No Errors Found:**
- All backend Java files compile successfully
- All Flutter Dart files compile successfully
- No syntax or import issues

## Notes

- The tourism filter map is static and centralized in the backend DestinationsController
- Frontend doesn't need to hardcode the map—it fetches from `/api/destinations`
- If tourism destinations need to be updated in future, only the backend needs modification
- The conversion logic automatically inherits parent land's tourism classification
- Filtering is client-side (optimal for current project scale; can be moved server-side if needed)
- All fields are optional (nullable) for backward compatibility

## Future Enhancements

1. **Admin Dashboard:** Allow admins to add/edit tourism destinations via UI
2. **Database Persistence:** Store tourism map in database instead of static
3. **Analytics:** Track which states/destinations have most projects/EOIs
4. **Search API:** Server-side filter endpoint for larger datasets
5. **Internationalization:** Support multiple languages for state/destination names
