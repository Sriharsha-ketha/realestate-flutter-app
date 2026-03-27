# 🐛 PORTFOLIO NOT SHOWING INVESTMENTS - DIAGNOSIS & FIX

**Problem:** After investor submits EOI, "My Portfolio" still shows "No investments yet"  
**Possible Causes:** 
1. EOI submission successful, but portfolio fetch fails
2. AppState not refreshing after EOI submission  
3. Timing issue with widget rebuild
4. Backend endpoint returning empty list

---

## 🔍 Diagnosis Steps

### Step 1: Verify EOI Was Saved to Database

**Backend Check:**
```bash
# SSH to database and run:
SELECT * FROM expressions_of_interest WHERE investor_id = {investor_id};

# Should show your newly submitted EOI
# Fields: id, investor_id, project_id, status (SUBMITTED), submission_date
```

### Step 2: Test Backend Endpoint Directly

```bash
# Test the endpoint that fetches EOIs
curl -H "Authorization: Bearer {your_token}" \
  http://localhost:8080/api/eois/investor/{investor_id}

# Should return JSON array with at least one EOI object:
# [
#   {
#     "id": 1,
#     "investorId": 123,
#     "projectId": 456,
#     "status": "SUBMITTED",
#     "submissionDate": "2026-03-14T10:43:00"
#   }
# ]
```

### Step 3: Check Frontend Logs

Add debug logging to see what's happening:

**File:** `lib/shared/app_state.dart`

After line 315 in `addToPortfolio()`, add:
```dart
debugPrint('EOI submitted successfully');
debugPrint('Current user ID: $_currentUserId');
debugPrint('Fetching EOIs for user: $_currentUserId');
debugPrint('EOIs after fetch: $_userEOIs.length');
_userEOIs.forEach((eoi) {
  debugPrint('EOI: projectId=${eoi.projectId}, status=${eoi.status}');
});
notifyListeners();
```

---

## ✅ The Fix

The issue is likely that `notifyListeners()` is called, but the portfolio screen might not be automatically rebuilding. Let me implement the fix:

### Fix 1: Force Portfolio Refresh After EOI Submission

**File:** `lib/features/investor/project_details.dart`

Update the `_submitEOI` method to explicitly refresh portfolio after successful submission:

```dart
Future<void> _submitEOI() async {
  if (!_complianceAccepted) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please accept the compliance terms first')),
    );
    return;
  }

  setState(() => _isSubmitting = true);

  try {
    final appState = context.read<AppState>();
    final success = await appState.addToPortfolio(widget.project);
    
    if (success && mounted) {
      setState(() => _eoiSubmitted = true);
      
      // Force refresh of portfolio data
      await Future.delayed(const Duration(milliseconds: 500));
      await appState.fetchAll();  // ← ADD THIS LINE
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✓ Expression of Interest submitted for ${widget.project.title}'),
          backgroundColor: Colors.green,
        ),
      );
      
      // Pop back after successful submission
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) Navigator.pop(context);
      });
    }
  } on Exception catch (e) {
    if (mounted) {
      final errorMessage = e.toString().contains('already submitted')
          ? 'You have already submitted an EOI for this project'
          : 'Failed to submit EOI. Please try again.';
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
        ),
      );
      
      setState(() => _eoiSubmitted = true);
    }
  } finally {
    if (mounted) {
      setState(() => _isSubmitting = false);
    }
  }
}
```

### Fix 2: Add Explicit Refresh in Portfolio Screen

**File:** `lib/features/investor/portfolio_screen.dart`

Make sure the portfolio screen refreshes when it comes into focus:

```dart
@override
void didChangeAppLifecycleState(AppLifecycleState state) {
  if (state == AppLifecycleState.resumed) {
    // Refresh portfolio when returning to this screen
    final appState = context.read<AppState>();
    if (appState.currentUserId != null && appState.currentUserRole == 'INVESTOR') {
      // Force a complete refresh
      appState.fetchAll();  // This fetches both projects and EOIs
    }
  }
}
```

---

## 🧪 Testing the Fix

### Test Case 1: Manual Portfolio Refresh

1. Open app → Login as investor
2. Go to "Explore" screen → Click on a project
3. Submit EOI (check compliance box, click submit)
4. See success toast "✓ Expression of Interest submitted"
5. Click the refresh icon in portfolio screen (↻)
6. Portfolio should now show the invested project

### Test Case 2: Automatic Portfolio Refresh on Return

1. Login as investor
2. Go to "Explore" → Submit EOI
3. Success! Go back to Dashboard
4. Immediately click "Portfolio" tab
5. Should see the newly invested project

### Test Case 3: Backend Data Verification

```bash
# After submitting EOI, verify in database:
SELECT e.*, p.title 
FROM expressions_of_interest e 
JOIN projects p ON e.project_id = p.id 
WHERE e.investor_id = {your_id}
ORDER BY e.submission_date DESC;
```

---

## 🔧 Implementation

Replace the `_submitEOI` method in `project_details.dart`:
