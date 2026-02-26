#!/bin/bash
#
# Terragrunt v0.99.4 Wrapper Script
# Provides convenient shortcuts for common Terragrunt commands
# Works in any directory within the live tree
#

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Help text
show_help() {
    cat << 'EOF'
Terragrunt v0.99.4 Wrapper Script

USAGE:
    terragrunt-wrapper.sh [COMMAND] [OPTIONS]

SHORTCUTS:
    plan-all              Run "terragrunt run -- run-all plan"
    apply-all             Run "terragrunt run -- run-all apply --auto-approve"
    apply-all-confirm     Run "terragrunt run -- run-all apply" (requires confirmation)
    destroy-all           Run "terragrunt run -- run-all destroy --auto-approve"
    destroy-all-confirm   Run "terragrunt run -- run-all destroy" (requires confirmation)
    validate-all          Run "terragrunt run -- run-all validate"
    
    plan                  Run "terragrunt run -- plan" (current module)
    apply                 Run "terragrunt run -- apply --auto-approve" (current module)
    apply-confirm         Run "terragrunt run -- apply" (current module, requires confirmation)
    destroy               Run "terragrunt run -- destroy --auto-approve" (current module)
    destroy-confirm       Run "terragrunt run -- destroy" (current module, requires confirmation)
    validate              Run "terragrunt run -- validate" (current module)

    refresh-all           Run "terragrunt run -- run-all refresh"
    output-all            Run "terragrunt run -- run-all output"
    
    status                Show status of current directory
    help                  Show this help message

EXAMPLES:
    # Plan all modules in the live/dev environment
    $ cd live/dev
    $ terragrunt-wrapper.sh plan-all
    
    # Apply all modules with auto-approval
    $ terragrunt-wrapper.sh apply-all
    
    # Plan just the VPC module
    $ cd live/dev/vpc
    $ terragrunt-wrapper.sh plan
    
    # Destroy all with manual confirmation
    $ terragrunt-wrapper.sh destroy-all-confirm

NOTE: This script must be run from within the live directory tree.
EOF
}

# Check if we're in a live directory
check_live_directory() {
    if ! pwd | grep -q "/live"; then
        echo -e "${RED}ERROR: Must be run from within the 'live' directory tree.${NC}"
        echo "Current directory: $(pwd)"
        return 1
    fi
}

# Show status
show_status() {
    echo -e "${BLUE}Current Directory:${NC} $(pwd)"
    if [ -f "terragrunt.hcl" ]; then
        echo -e "${GREEN}✓${NC} terragrunt.hcl found"
    else
        echo -e "${YELLOW}⚠${NC} No terragrunt.hcl in current directory"
    fi
}

# Run commands
run_command() {
    local cmd="$1"
    echo -e "${BLUE}Running:${NC} $cmd"
    eval "$cmd"
}

# Main logic
case "${1:-help}" in
    plan-all)
        check_live_directory || exit 1
        run_command "terragrunt run -- run-all plan"
        ;;
    apply-all)
        check_live_directory || exit 1
        run_command "terragrunt run -- run-all apply --auto-approve"
        ;;
    apply-all-confirm)
        check_live_directory || exit 1
        run_command "terragrunt run -- run-all apply"
        ;;
    destroy-all)
        check_live_directory || exit 1
        echo -e "${RED}WARNING: About to destroy all resources with auto-approval!${NC}"
        read -p "Are you sure? (type 'yes' to continue): " confirm
        if [ "$confirm" = "yes" ]; then
            run_command "terragrunt run -- run-all destroy --auto-approve"
        else
            echo "Cancelled."
        fi
        ;;
    destroy-all-confirm)
        check_live_directory || exit 1
        run_command "terragrunt run -- run-all destroy"
        ;;
    validate-all)
        check_live_directory || exit 1
        run_command "terragrunt run -- run-all validate"
        ;;
    refresh-all)
        check_live_directory || exit 1
        run_command "terragrunt run -- run-all refresh"
        ;;
    output-all)
        check_live_directory || exit 1
        run_command "terragrunt run -- run-all output"
        ;;
    plan)
        check_live_directory || exit 1
        run_command "terragrunt run -- plan"
        ;;
    apply)
        check_live_directory || exit 1
        run_command "terragrunt run -- apply --auto-approve"
        ;;
    apply-confirm)
        check_live_directory || exit 1
        run_command "terragrunt run -- apply"
        ;;
    destroy)
        check_live_directory || exit 1
        run_command "terragrunt run -- destroy --auto-approve"
        ;;
    destroy-confirm)
        check_live_directory || exit 1
        run_command "terragrunt run -- destroy"
        ;;
    validate)
        check_live_directory || exit 1
        run_command "terragrunt run -- validate"
        ;;
    status)
        show_status
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        echo -e "${RED}Unknown command: $1${NC}"
        echo ""
        show_help
        exit 1
        ;;
esac
