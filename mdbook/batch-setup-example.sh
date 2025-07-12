#!/bin/bash
set -euo pipefail

# Example script for setting up mdbook logos across multiple projects
# This demonstrates how to use the mdbook-logo-setup.sh script with templates

# Configuration
readonly SETUP_SCRIPT="./mdbook-logo-setup.sh"
readonly CSS_TEMPLATE="./templates/mdbook-logo.css"
readonly BOOK_CONFIG_TEMPLATE="./templates/book-config-addition.toml"

# Color codes
readonly GREEN='\033[0;32m'
readonly BLUE='\033[0;34m'
readonly RED='\033[0;31m'
readonly NC='\033[0m'

# Project configurations
# Format: "project_path:logo_path"
PROJECTS=(
    "/path/to/project1:/path/to/logos/company1-logo.png"
    "/path/to/project2:/path/to/logos/company2-logo.svg"
    "/path/to/project3:/path/to/logos/company3-logo.png"
    "/path/to/project4:/path/to/logos/company4-logo.jpg"
    "/path/to/project5:/path/to/logos/company5-logo.png"
    # Add your remaining 15 projects here...
    # "/path/to/project6:/path/to/logos/company6-logo.png"
    # "/path/to/project7:/path/to/logos/company7-logo.svg"
    # ... etc
)

# Alternative: All projects use the same logo
# SHARED_LOGO="/path/to/shared/company-logo.png"
# PROJECTS=(
#     "/path/to/project1"
#     "/path/to/project2"
#     "/path/to/project3"
#     # ... etc
# )

log_info() {
    echo -e "${BLUE}[INFO]${NC} $*"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $*"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $*"
}

# Validate prerequisites
validate_setup() {
    log_info "Validating setup..."
    
    if [[ ! -f "$SETUP_SCRIPT" ]]; then
        log_error "Setup script not found: $SETUP_SCRIPT"
        exit 1
    fi
    
    if [[ ! -x "$SETUP_SCRIPT" ]]; then
        log_error "Setup script is not executable: $SETUP_SCRIPT"
        log_info "Run: chmod +x $SETUP_SCRIPT"
        exit 1
    fi
    
    if [[ ! -f "$CSS_TEMPLATE" ]]; then
        log_error "CSS template not found: $CSS_TEMPLATE"
        exit 1
    fi
    
    if [[ ! -f "$BOOK_CONFIG_TEMPLATE" ]]; then
        log_error "Book config template not found: $BOOK_CONFIG_TEMPLATE"
        exit 1
    fi
    
    log_success "All prerequisites validated"
}

# Process a single project
setup_project() {
    local project_path="$1"
    local logo_path="$2"
    local project_name=$(basename "$project_path")
    
    log_info "Setting up project: $project_name"
    log_info "Project path: $project_path"
    log_info "Logo path: $logo_path"
    
    # Validate project directory
    if [[ ! -d "$project_path" ]]; then
        log_error "Project directory does not exist: $project_path"
        return 1
    fi
    
    # Validate logo file
    if [[ ! -f "$logo_path" ]]; then
        log_error "Logo file does not exist: $logo_path"
        return 1
    fi
    
    # Change to project directory
    local original_dir=$(pwd)
    cd "$project_path" || {
        log_error "Failed to change to project directory: $project_path"
        return 1
    }
    
    # Run the setup script
    if LOGO_PATH="$logo_path" \
       CSS_TEMPLATE_PATH="$CSS_TEMPLATE" \
       BOOK_CONFIG_TEMPLATE_PATH="$BOOK_CONFIG_TEMPLATE" \
       "$original_dir/$SETUP_SCRIPT"; then
        log_success "Successfully set up $project_name"
    else
        log_error "Failed to set up $project_name"
        cd "$original_dir"
        return 1
    fi
    
    # Return to original directory
    cd "$original_dir"
    return 0
}

# Main execution
main() {
    local success_count=0
    local failure_count=0
    local failed_projects=()
    
    echo "mdbook Logo Batch Setup"
    echo "======================="
    echo ""
    
    validate_setup
    
    log_info "Processing ${#PROJECTS[@]} projects..."
    echo ""
    
    for project_config in "${PROJECTS[@]}"; do
        # Parse project configuration
        if [[ "$project_config" == *":"* ]]; then
            # Format: "project_path:logo_path"
            local project_path="${project_config%:*}"
            local logo_path="${project_config#*:}"
        else
            # Format: "project_path" (using shared logo)
            local project_path="$project_config"
            local logo_path="${SHARED_LOGO:-}"
            
            if [[ -z "$logo_path" ]]; then
                log_error "No logo specified for $project_path and SHARED_LOGO not set"
                ((failure_count++))
                failed_projects+=("$project_path")
                continue
            fi
        fi
        
        echo "----------------------------------------"
        if setup_project "$project_path" "$logo_path"; then
            ((success_count++))
        else
            ((failure_count++))
            failed_projects+=("$(basename "$project_path")")
        fi
        echo ""
    done
    
    # Print summary
    echo "========================================"
    echo "Batch Setup Complete!"
    echo "========================================"
    echo ""
    echo "Results:"
    echo "  Successful: $success_count"
    echo "  Failed: $failure_count"
    echo "  Total: ${#PROJECTS[@]}"
    echo ""
    
    if [[ $failure_count -gt 0 ]]; then
        echo "Failed projects:"
        for project in "${failed_projects[@]}"; do
            echo "  - $project"
        done
        echo ""
    fi
    
    if [[ $success_count -gt 0 ]]; then
        log_success "Setup completed for $success_count projects"
        echo ""
        echo "Next steps:"
        echo "1. Test each project by running 'mdbook build' in project directories"
        echo "2. Adjust templates if needed and re-run this script"
        echo "3. Commit your changes to version control"
    fi
    
    if [[ $failure_count -gt 0 ]]; then
        exit 1
    fi
}

# Show usage information
usage() {
    cat << EOF
Usage: $0

This script sets up mdbook logos across multiple projects using template files.

Prerequisites:
1. mdbook-logo-setup.sh script (executable)
2. CSS template file: $CSS_TEMPLATE
3. Book config template file: $BOOK_CONFIG_TEMPLATE

Configuration:
Edit the PROJECTS array in this script to specify your projects and logos.

Two formats are supported:
1. Individual logos: "project_path:logo_path"
2. Shared logo: Set SHARED_LOGO variable and list only project paths

Examples:
  # Individual logos per project
  PROJECTS=(
    "/home/user/docs/project1:/assets/logo1.png"
    "/home/user/docs/project2:/assets/logo2.svg"
  )
  
  # Shared logo for all projects
  SHARED_LOGO="/assets/company-logo.png"
  PROJECTS=(
    "/home/user/docs/project1"
    "/home/user/docs/project2"
  )

The script will:
- Validate all prerequisites
- Process each project individually  
- Provide detailed success/failure reporting
- Continue processing even if some projects fail
EOF
}

# Handle help flags
if [[ "${1:-}" == "-h" ]] || [[ "${1:-}" == "--help" ]]; then
    usage
    exit 0
fi

# Run main function
main "$@"