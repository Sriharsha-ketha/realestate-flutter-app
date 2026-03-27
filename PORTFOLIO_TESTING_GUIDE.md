# 📋 PORTFOLIO FIX - TESTING GUIDE

## ✅ Quick Test (5 minutes)

### Setup
1. Backend running: `mvn spring-boot:run`
2. Frontend running: `flutter run`
3. Logged in as INVESTOR

### Test Steps

```
STEP 1: Go to Explore Screen
  └─ Tap "Explore" tab at bottom

STEP 2: Select Any Project
  └─ Tap any project card

STEP 3: Accept Terms & Submit EOI
  ├─ Scroll down to "Compliance Agreement"
  ├─ Check the checkbox "I accept the terms"
  └─ Tap "Submit Expression of Interest" button

STEP 4: See Success Message
  └─ Toast appears: "✓ Expression of Interest submitted"

STEP 5: Return to Portfolio
  ├─ Tap back arrow (or wait for auto-pop)
  ├─ App returns to Dashboard
  └─ Tap "Portfolio" tab

STEP 6: Verify Investment Shows
  └─ Project should appear in My Portfolio list ✅
```

---

## Expected Results

### ✅ SUCCESS
```
My Portfolio
├─ [Project Card]
│  ├─ Title: [Project Name]
│  ├─ Location: [City, State]
│  ├─ ROI: [%]
│  └─ Status: [SUBMITTED]
└─ [More projects...]
```

### ❌ FAILURE (What NOT to see)
```
My Portfolio
├─ [Empty state icon]
├─ "No investments yet"
└─ [Empty list]
```

---

## Troubleshooting

### If Portfolio Still Empty

**Quick Fix:**
1. Tap the refresh button (↻) in portfolio top-right corner
2. Wait 2 seconds
3. Investment should appear

**If Still Empty:**

#### Check 1: Verify Backend Data
```bash
# SSH to database or use psql:
SELECT * FROM expressions_of_interest 
WHERE investor_id = {your_investor_id}
ORDER BY submission_date DESC;

# Should show your recently submitted EOI
```

#### Check 2: Test Backend Endpoint
```bash
curl -H "Authorization: Bearer {token}" \
  http://localhost:8080/api/eois/investor/{investor_id}

# Should return JSON array with your EOI
```

#### Check 3: Check Console Logs
```
# Look for in Flutter console:
"EOI submitted successfully"
"Fetching EOIs for user: {id}"
"EOIs after fetch: 1"
```

---

## Advanced Testing

### Test: Submit Multiple EOIs

```
1. Submit EOI for Project A
2. Verify it shows in Portfolio
3. Go to Explore
4. Submit EOI for Project B
5. Check Portfolio - should show both A and B
```

### Test: Navigate Away and Back

```
1. Submit EOI for Project C
2. See success message
3. Navigate to Dashboard (don't wait for auto-pop)
4. Click Portfolio tab
5. Should see Project C immediately ✅
```

### Test: Cold Start

```
1. Close app completely
2. Reopen app
3. Login as investor
4. Go to Portfolio
5. Previous EOI submissions should be visible ✅
```

---

## Success Criteria

| Criteria | Status |
|----------|--------|
| EOI submitted successfully | ✅ Toast shows |
| Portfolio updates immediately | ✅ No manual refresh needed |
| Investment visible in list | ✅ Showing project card |
| Data persists on reload | ✅ Still showing after restart |
| Multiple investments work | ✅ All show in portfolio |

---

## 🎯 What to Verify

✅ After submission, success toast appears  
✅ Auto-pops back to previous screen  
✅ Portfolio screen loads automatically  
✅ Investment appears in "My Portfolio" list  
✅ Project details match what was submitted  
✅ Multiple investments show correctly  

---

**Once all pass: Feature is WORKING ✅**

If any fail → Check troubleshooting section above.
