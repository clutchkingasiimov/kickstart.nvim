#!/bin/bash

# ==============================================================================
# CONFIGURATION & FILLER VARIABLES
# ==============================================================================
# Programmers: Fill these in to point to your specific Databricks Bundle keys or Job IDs
# ==============================================================================

# The target environment defined in your databricks.yml (e.g., 'test', 'staging')
TEST_ENV="test"
PROD_ENV="prod"
CI_CLUSTER="enter cluster name"

# Default Job Key (from databricks.yml resources) for Integration Tests
DEFAULT_INT_JOB_KEY="my_etl_job"
DEFAULT_INT_TASK_KEY="ingest_task"

# List of E2E Pipelines (Bundle keys) to offer in the menu
E2E_PIPELINE_OPTIONS=("full_daily_pipeline" "audit_pipeline" "ml_training_pipeline")

# ==============================================================================
# UI HELPERS (GUM)
# ==============================================================================

function header() {
    clear
    gum style \
        --border normal \
        --margin "1" \
        --padding "1 2" \
        --border-foreground 212 \
        "So now we shall break production" \
}

function log_step() {
    gum style --foreground 212 "👉 $1"
}

function log_success() {
    gum style --foreground 82 "✅ $1"
}

function log_error() {
    gum style --foreground 196 "❌ $1"
}

# Check if gum is installed
if ! command -v gum &> /dev/null; then
    echo "Error: 'gum' is not installed. Please install it first."
    exit 1
fi

header

# ==============================================================================
# STEP 1, 2 & 3: STATIC ANALYSIS & LINTING (Ruff + Mypy)
# ==============================================================================
log_step "Phase 1: Code Quality Gate"

REPORT_FILE="quality_report.txt"
rm -f "$REPORT_FILE"

# Run checks inside a spinner
gum spin --spinner dot --title "Running Static Analysis & Linting..." -- show_output=false bash -c "
    echo '--- STATIC ANALYSIS OUTPUT ---' > $REPORT_FILE
    mypy . >> $REPORT_FILE 2>&1
    MYPY_EXIT=\$?
    
    echo -e '\n--- LINTER OUTPUT ---' >> $REPORT_FILE
    ruff check . >> $REPORT_FILE 2>&1
    RUFF_CHECK_EXIT=\$?

    echo -e '\n--- FORMATTER OUTPUT ---' >> $REPORT_FILE
    ruff format --check . >> $REPORT_FILE 2>&1
    RUFF_FMT_EXIT=\$?

    if [ \$MYPY_EXIT -ne 0 ] || [ \$RUFF_CHECK_EXIT -ne 0 ] || [ \$RUFF_FMT_EXIT -ne 0 ]; then
        exit 1
    fi
    exit 0
"

STATUS=$?

if [ $STATUS -eq 0 ]; then
    log_success "Static Analysis & Linting Passed!"
else
    log_error "Quality Checks Failed. Generating Report..."
    gum style --border double --padding "1" --border-foreground 196 "Check $REPORT_FILE below:"
    
    # Show report in pager
    gum pager < "$REPORT_FILE"
    
    # Ask if user wants to abort
    if gum confirm "Abort pipeline due to quality issues?"; then
        exit 1
    fi
fi

# ==============================================================================
# STEP 4 & 5: UNIT TESTS
# ==============================================================================
log_step "Phase 2: Unit Testing"

TEST_OUTPUT_FILE="unit_test_output.txt"

# Assuming tests/unit exists. 
# Using gum spin to hide output unless it fails, but capturing output to file just in case.
if gum spin --spinner points --title "Executing Unit Tests..." -- bash -c "pytest tests/unit > $TEST_OUTPUT_FILE 2>&1"; then
    log_success "Unit Tests Passed!"
    rm -f "$TEST_OUTPUT_FILE" # Clean up if passed
else
    log_error "Unit Tests Failed!"
    gum style --foreground 196 "Output:"
    cat "$TEST_OUTPUT_FILE"
    rm -f "$TEST_OUTPUT_FILE"
    exit 1
fi

# ==============================================================================
# STEP 6: UV CHECKS (Dependency Management)
# ==============================================================================
log_step "Phase 3: Dependency Verification"

if gum spin --spinner hamburger --title "Checking Lockfile & Dependencies..." -- bash -c "
    uv lock --check && uv sync --frozen
"; then
    log_success "Dependencies are locked and synced."
else
    log_error "Dependency check failed. Run 'uv lock' locally to fix."
    exit 1
fi

# ==============================================================================
# STEP 7: INFRA VALIDATION & DEPLOYMENT
# ==============================================================================
log_step "Phase 4: Databricks Bundle Validation"

if gum spin --spinner globe --title "Validating Databricks Bundle..." -- bash -c "databricks bundle validate -t $TARGET_ENV"; then
    log_success "Bundle Configuration is Valid."
else
    log_error "Bundle Validation Failed!"
    exit 1
fi

log_step "Phase 5: Bundle Plan Tree($TARGET_ENV)"
gum spin --spinner meteor --title "Bundle execution plan" -- bash -c "databricks bundle plan -t $TARGET_ENV"

log_step "Phase 6: Deploying to Staging ($TARGET_ENV)"

if gum spin --spinner meteor --title "Pushing code to Databricks..." -- bash -c "databricks bundle deploy -t $TARGET_ENV"; then
    log_success "Code successfully deployed to $TARGET_ENV!"
else
    log_error "Deployment failed."
    exit 1
fi


# Need to refactor integration test part

# ==============================================================================
# STEP 8 & 9: INTEGRATION TEST (Specific Task/Job)
# ==============================================================================
echo ""
gum style --foreground 212 "Phase 6: Integration Testing"

if gum confirm "Do you want to run an Integration Test (Single Task)?"; then
    
    # Ask for Job/Task names, pre-filled with variables defined at top
    JOB_KEY=$(gum input --placeholder "Job Key" --value "$DEFAULT_INT_JOB_KEY" --header "Enter Job Resource Key:")
    TASK_KEY=$(gum input --placeholder "Task Key" --value "$DEFAULT_INT_TASK_KEY" --header "Enter Task Key (optional):")

    CMD="databricks bundle run -t $TARGET_ENV $JOB_KEY"
    
    # If a task key is provided, we might need to adjust logic. 
    # 'bundle run' runs the whole job resource. 
    # For specific tasks, we pass arguments if the job accepts them, 
    # or we rely on 'databricks jobs run-now' if we had the ID. 
    # For this script, we will run the bundle resource.
    
    log_step "Triggering Job: $JOB_KEY..."
    
    # We stream the output directly here so the user can see logs
    $CMD
    
    INT_STATUS=$?
    if [ $INT_STATUS -eq 0 ]; then
        log_success "Integration Test Passed."
    else
        log_error "Integration Test Failed."
        if gum confirm "Abort pipeline?"; then exit 1; fi
    fi
else
    gum style --faint "Skipping Integration Tests."
fi

# ==============================================================================
# STEP 10 & 11: E2E TESTING (Full Pipelines)
# ==============================================================================
echo ""
gum style --foreground 212 "Phase 7: E2E Testing"

if gum confirm "Do you want to run an E2E Pipeline?"; then
    
    log_step "Select Pipeline to execute:"
    SELECTED_PIPELINE=$(gum choose "${E2E_PIPELINE_OPTIONS[@]}")
    
    log_step "Running E2E Pipeline: $SELECTED_PIPELINE on $TARGET_ENV..."
    
    # Execute and stream output
    databricks bundle run -t "$TARGET_ENV" "$SELECTED_PIPELINE"
    
    E2E_STATUS=$?
    if [ $E2E_STATUS -eq 0 ]; then
        log_success "E2E Test Passed."
    else
        log_error "E2E Test Failed."
        exit 1
    fi
else
    gum style --faint "Skipping E2E Tests."
fi

# ==============================================================================
# STEP 12: COMPLETION
# ==============================================================================
echo ""
gum style \
    --border double \
    --margin "1" \
    --padding "1 4" \
    --border-foreground 82 \
    --foreground 82 \
    --bold \
    "🎉 SUCCESS! Good to go for PROD!"

exit 0
