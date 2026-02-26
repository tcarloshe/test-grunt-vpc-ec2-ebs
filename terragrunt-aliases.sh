# Terragrunt v0.99.4 Command Aliases
# Add these to your ~/.bashrc or ~/.zshrc for convenient command shortcuts
#
# Usage:
#   tg plan-all        # Plan all modules in live tree
#   tg apply-all       # Apply all modules with auto-approval
#   tg destroy-all-confirm  # Destroy all with manual confirmation
#   tgw help           # Show wrapper script help
#

# Terragrunt wrapper script location
TERRAGRUNT_WRAPPER="${HOME}/grunt/test-grunt-vpc-ec2-ebs/terragrunt-wrapper.sh"

# Verify wrapper exists before defining aliases
if [ -f "$TERRAGRUNT_WRAPPER" ]; then
    # Shortcuts for all-in-one operations
    alias tg-plan-all="$TERRAGRUNT_WRAPPER plan-all"
    alias tg-apply-all="$TERRAGRUNT_WRAPPER apply-all"
    alias tg-apply-all-confirm="$TERRAGRUNT_WRAPPER apply-all-confirm"
    alias tg-destroy-all="$TERRAGRUNT_WRAPPER destroy-all"
    alias tg-destroy-all-confirm="$TERRAGRUNT_WRAPPER destroy-all-confirm"
    alias tg-validate-all="$TERRAGRUNT_WRAPPER validate-all"
    alias tg-refresh-all="$TERRAGRUNT_WRAPPER refresh-all"
    alias tg-output-all="$TERRAGRUNT_WRAPPER output-all"
    
    # Single module operations
    alias tg-plan="$TERRAGRUNT_WRAPPER plan"
    alias tg-apply="$TERRAGRUNT_WRAPPER apply"
    alias tg-apply-confirm="$TERRAGRUNT_WRAPPER apply-confirm"
    alias tg-destroy="$TERRAGRUNT_WRAPPER destroy"
    alias tg-destroy-confirm="$TERRAGRUNT_WRAPPER destroy-confirm"
    alias tg-validate="$TERRAGRUNT_WRAPPER validate"
    
    # Utility
    alias tg-status="$TERRAGRUNT_WRAPPER status"
    alias tg-help="$TERRAGRUNT_WRAPPER help"
    
    # Direct terraform-style commands (if in live tree)
    alias tg-run-plan-all="terragrunt run -- run-all plan"
    alias tg-run-apply-all="terragrunt run -- run-all apply --auto-approve"
    alias tg-run-destroy-all="terragrunt run -- run-all destroy --auto-approve"
fi

# Function: Quick navigation to live directory
tg-cd() {
    cd /home/tcarlos/grunt/test-grunt-vpc-ec2-ebs/live
    echo "Navigated to live directory: $(pwd)"
}

# Function: Show all available tg commands
tg-commands() {
    echo "Available Terragrunt Commands:"
    echo ""
    echo "All-in-one operations:"
    echo "  tg-plan-all              - Plan all modules"
    echo "  tg-apply-all             - Apply with auto-approval"
    echo "  tg-apply-all-confirm     - Apply with confirmation"
    echo "  tg-destroy-all           - Destroy with auto-approval"
    echo "  tg-destroy-all-confirm   - Destroy with confirmation"
    echo "  tg-validate-all          - Validate all"
    echo ""
    echo "Single module (run from module directory):"
    echo "  tg-plan                  - Plan current module"
    echo "  tg-apply                 - Apply with auto-approval"
    echo "  tg-validate              - Validate current"
    echo ""
    echo "Utility:"
    echo "  tg-status                - Show current directory status"
    echo "  tg-help                  - Show wrapper help"
    echo "  tg-cd                    - Jump to live directory"
    echo "  tg-commands              - Show this list"
}
