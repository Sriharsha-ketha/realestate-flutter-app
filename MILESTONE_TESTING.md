# Milestone System - Testing Guide

## Pre-Testing Setup

### Requirements
- ✓ Backend running (mvn spring-boot:run)
- ✓ Frontend running (flutter run)
- ✓ Projects created with different stages
- ✓ Admin account access
- ✓ Investor account access

### Test Projects to Create
1. **Project A**: Stage = LAND_APPROVED
2. **Project B**: Stage = PLANNING
3. **Project C**: Stage = OPERATIONAL
4. **Project D**: Stage = CANCELLED (optional)

---

## Test Suite 1: Milestone Display Accuracy

### Test 1.1: Early Stage Project
**Goal**: Verify early-stage project shows only first milestone completed

**Steps**:
1. Navigate to Project with stage = LAND_APPROVED
2. Click "View Milestones"

**Expected Result**:
```
Current Stage: Land Approved

✓ Land Approved (Completed - Green)
⬜ Investors Joined (Upcoming - Grey)
⬜ Design Planning (Upcoming - Grey)
⬜ Construction Started (Upcoming - Grey)
⬜ Resort Completed (Upcoming - Grey)
⬜ Tourists Arriving (Upcoming - Grey)

Overall Progress: 17%
[████░░░░░░░░░░░░░░░░]
```

**Acceptance**: ✓ if exactly 1 completed, 5 upcoming, 17% progress

---

### Test 1.2: Mid-Stage Project
**Goal**: Verify mid-stage project shows correct milestone completion

**Steps**:
1. Navigate to Project with stage = PLANNING
2. Click "View Milestones"

**Expected Result**:
```
Current Stage: Design Planning

✓ Land Approved (Completed - Green)
✓ Investors Joined (Completed - Green)
✓ Design Planning (Completed - Green)
⬜ Construction Started (Upcoming - Grey)
⬜ Resort Completed (Upcoming - Grey)
⬜ Tourists Arriving (Upcoming - Grey)

Overall Progress: 50%
[████████░░░░░░░░░░░░]
```

**Acceptance**: ✓ if exactly 3 completed, 3 upcoming, 50% progress

---

### Test 1.3: Late-Stage Project
**Goal**: Verify late-stage project shows most milestones completed

**Steps**:
1. Navigate to Project with stage = OPERATIONAL
2. Click "View Milestones"

**Expected Result**:
```
Current Stage: Tourists Arriving

✓ Land Approved (Completed - Green)
✓ Investors Joined (Completed - Green)
✓ Design Planning (Completed - Green)
✓ Construction Started (Completed - Green)
✓ Resort Completed (Completed - Green)
✓ Tourists Arriving (Completed - Green)

Overall Progress: 100%
[████████████████████]
```

**Acceptance**: ✓ if all 6 completed, 0 upcoming, 100% progress

---

### Test 1.4: Construction Stage
**Goal**: Verify CONSTRUCTION stage shows correct progress

**Steps**:
1. Navigate to Project with stage = CONSTRUCTION
2. Click "View Milestones"

**Expected Result**:
```
Current Stage: Construction Started

✓ Land Approved (Completed)
✓ Investors Joined (Completed)
✓ Design Planning (Completed)
✓ Construction Started (Completed)
⬜ Resort Completed (Upcoming)
⬜ Tourists Arriving (Upcoming)

Overall Progress: 67%
[████████████░░░░░░░░]
```

**Acceptance**: ✓ if exactly 4 completed, 2 upcoming, ~67% progress

---

## Test Suite 2: Stage Update Propagation

### Test 2.1: Admin Updates Stage
**Goal**: Verify stage update is reflected when viewing milestones

**Steps**:
1. As ADMIN, go to "Manage Projects"
2. Select Project A (currently LAND_APPROVED)
3. Change stage to FUNDING
4. Navigate to Milestones page
5. Verify display updates

**Expected Result**:
- Current Stage shows "Investors Joined"
- Second milestone marked as completed
- Progress shows 2/6 (33%)

**Acceptance**: ✓ if stage change reflected in timeline

---

### Test 2.2: Real-time Stage Update (Multi-user)
**Goal**: Verify stage change appears when investor refreshes

**Steps**:
1. Open Milestones page on Investor account
2. In separate browser/device, Admin changes stage (PLANNING → CONSTRUCTION)
3. Investor refreshes page (pull-down or button)
4. Check if milestones update

**Expected Result**:
- New stage "Construction Started" displayed
- 4 milestones marked as completed
- Progress shows 67%

**Acceptance**: ✓ if refresh shows new stage

---

### Test 2.3: Sequential Stage Updates
**Goal**: Verify multiple stage updates work correctly

**Steps**:
1. Start with Project at LAND_APPROVED
2. Admin updates to FUNDING
3. View milestones, verify display
4. Admin updates to PLANNING
5. Investor refreshes, verify display
6. Admin updates to CONSTRUCTION
7. Investor refreshes, verify display
8. Admin updates to COMPLETED
9. Investor refreshes, verify display
10. Admin updates to OPERATIONAL
11. Investor refreshes, verify display

**Expected Result**:
- Each stage change correctly updates milestone display
- Progress percentage increases with each stage
- All transitions smooth without errors

**Acceptance**: ✓ if all 6 stages display correctly

---

## Test Suite 3: Visual Display

### Test 3.1: Milestone Indicators
**Goal**: Verify visual indicators are correct

**Steps**:
1. View milestones for project at PLANNING stage
2. Check each milestone:
   - Completed milestones: Green circle with white checkmark
   - Pending milestones: Grey circle with number (1-6)

**Expected Result**:
- Completed (1-3): ✓ Green
- Pending (4-6): 4️⃣ Grey, 5️⃣ Grey, 6️⃣ Grey

**Acceptance**: ✓ if all indicators correct

---

### Test 3.2: Connecting Lines
**Goal**: Verify vertical connecting lines between milestones

**Steps**:
1. View milestones for project at PLANNING stage
2. Observe connecting lines between milestone items

**Expected Result**:
- Lines between completed milestones: Green
- Lines between pending milestones: Grey
- Line connecting completed to pending: Mixed colors
- No line after last milestone

**Acceptance**: ✓ if all lines correct

---

### Test 3.3: Current Stage Card
**Goal**: Verify current stage indicator card displays

**Steps**:
1. View milestones for project at FUNDING stage
2. Look at top of milestone list

**Expected Result**:
- Blue info card at top
- Text "Current Stage"
- Value shows "Investors Joined"
- Info icon visible
- Card has blue border

**Acceptance**: ✓ if card displays correctly

---

### Test 3.4: Progress Bar
**Goal**: Verify progress bar displays correctly

**Steps**:
1. View milestones for projects at different stages
2. Check progress bar and percentage

**Expected Results**:
| Stage | Expected % | Bar Filled |
|-------|-----------|-----------|
| LAND_APPROVED | 17% | 1/6 |
| FUNDING | 33% | 2/6 |
| PLANNING | 50% | 3/6 |
| CONSTRUCTION | 67% | 4/6 |
| COMPLETED | 83% | 5/6 |
| OPERATIONAL | 100% | 6/6 |

**Acceptance**: ✓ if all percentages accurate

---

## Test Suite 4: Cancelled Project State

### Test 4.1: Cancelled Project Display
**Goal**: Verify cancelled projects show special UI

**Steps**:
1. Create or set project to stage = CANCELLED
2. View milestones

**Expected Result**:
- Red container displayed instead of timeline
- Message "Project Cancelled"
- Cancel icon visible
- No milestone timeline shown
- No progress bar shown

**Acceptance**: ✓ if special state displayed

---

### Test 4.2: Stage Change to Cancelled
**Goal**: Verify stage change to CANCELLED works

**Steps**:
1. Start with project at PLANNING (timeline visible)
2. Admin changes stage to CANCELLED
3. Investor refreshes milestones page

**Expected Result**:
- Timeline disappears
- Red cancel state shown
- "Project Cancelled" message displayed

**Acceptance**: ✓ if transition correct

---

## Test Suite 5: Navigation & Integration

### Test 5.1: From Portfolio View
**Goal**: Verify milestone access from investor portfolio

**Steps**:
1. Login as Investor
2. Navigate to Portfolio
3. Select a project
4. Click "View Milestones" button

**Expected Result**:
- MilestonesPage opens
- Correct project name in AppBar
- Milestone timeline displays
- Current stage matches project stage

**Acceptance**: ✓ if navigation works

---

### Test 5.2: From Admin Panel
**Goal**: Verify milestone access from admin project management

**Steps**:
1. Login as Admin
2. Navigate to "Manage Projects"
3. Select a project
4. Click "View Progress" button

**Expected Result**:
- MilestonesPage opens
- Correct project name in AppBar
- Milestone timeline displays
- Current stage matches project stage

**Acceptance**: ✓ if navigation works

---

### Test 5.3: Back Navigation
**Goal**: Verify back button works correctly

**Steps**:
1. View milestones for a project
2. Tap back button (Android) or swipe back (iOS)

**Expected Result**:
- Returns to previous screen
- Previous state maintained
- No errors or crashes

**Acceptance**: ✓ if navigation smooth

---

## Test Suite 6: Error Handling

### Test 6.1: Project Not Found
**Goal**: Verify graceful handling of missing project

**Steps**:
1. Navigate to MilestonesPage with non-existent projectId
2. Observe page behavior

**Expected Result**:
- Page loads without crashing
- Uses default stage (LAND_APPROVED)
- Shows milestone timeline
- No error messages to user

**Acceptance**: ✓ if handled gracefully

---

### Test 6.2: Invalid Stage Value
**Goal**: Verify handling of unknown stage

**Steps**:
1. Manually update project stage to "INVALID_STAGE" in database
2. View milestones for this project

**Expected Result**:
- Page loads without crashing
- All milestones shown as pending
- Progress shows 0%
- No error messages

**Acceptance**: ✓ if handled gracefully

---

## Test Suite 7: Responsive Design

### Test 7.1: Mobile Display (320px)
**Goal**: Verify milestones display on small phones

**Steps**:
1. Open milestone page on device/emulator with 320px width
2. Check layout:
   - All milestones visible without horizontal scroll
   - Text readable
   - Indicators properly sized
   - Progress bar visible

**Expected Result**:
- Everything visible without truncation
- Touch targets > 40x40px
- No overlapping elements

**Acceptance**: ✓ if mobile-responsive

---

### Test 7.2: Tablet Display (768px)
**Goal**: Verify milestones display on tablets

**Steps**:
1. Open milestone page on tablet/emulator
2. Check layout and spacing

**Expected Result**:
- Content centered (not stretched to edges)
- Proper spacing maintained
- All elements visible

**Acceptance**: ✓ if tablet-friendly

---

## Test Suite 8: Performance

### Test 8.1: Page Load Time
**Goal**: Verify milestones page loads quickly

**Steps**:
1. Open milestones page
2. Measure load time

**Expected Result**:
- Page visible within 500ms
- No noticeable lag or stutter
- Smooth animations (if any)

**Acceptance**: ✓ if load time < 1s

---

### Test 8.2: Multiple Views
**Goal**: Verify no memory leaks with repeated access

**Steps**:
1. Open milestones page
2. Go back
3. Open different project milestones
4. Repeat 5 times
5. Check memory usage

**Expected Result**:
- App remains responsive
- Memory usage doesn't spike
- No stuttering or slowdown

**Acceptance**: ✓ if performance stable

---

## Test Results Template

```
Test Suite: [Name]
Date: ___________
Tester: _________

Test Cases:
[ ] Test X.1: [Result] - PASS/FAIL
[ ] Test X.2: [Result] - PASS/FAIL
[ ] Test X.3: [Result] - PASS/FAIL

Notes:
_________________________________
_________________________________

Overall Suite Result: PASS/FAIL
```

---

## Regression Testing (Before Each Release)

- [ ] All stage transitions work
- [ ] Milestones update when stage changes
- [ ] Visual indicators correct at each stage
- [ ] Progress percentage accurate
- [ ] Cancelled state displays correctly
- [ ] Navigation to/from milestones works
- [ ] No crashes on edge cases
- [ ] Mobile layout responsive
- [ ] Backend stage updates still work
- [ ] Investors can view (but not edit) milestones

---

## Known Issues & Workarounds

| Issue | Workaround | Status |
|-------|-----------|--------|
| Stage change requires page refresh | Refresh to see latest stage | Expected behavior |
| Cancelled project shows no timeline | This is by design | Not an issue |

---

## Sign-Off

- [ ] All critical tests passed
- [ ] All normal tests passed  
- [ ] No P0 or P1 bugs found
- [ ] Mobile/tablet tested
- [ ] Ready for production

**Tested By**: ________________  
**Date**: ________________  
**Approved By**: ________________
