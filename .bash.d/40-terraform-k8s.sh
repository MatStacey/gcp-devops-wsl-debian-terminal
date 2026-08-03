# ------------------------------------------
# Infrastructure as Code
# ------------------------------------------
alias tf='terraform'                                                # => Terraform: Base command
alias tfp='terraform plan'                                          # => Terraform: Plan deployment
alias tfa='terraform apply'                                         # => Terraform: Apply deployment
alias tfd='terraform destroy'                                       # => Terraform: Destroy resources
alias tff='terraform fmt -recursive'                                # => Terraform: Format all TF files recursively
alias tf-scan='checkov -d terraform/ --framework terraform --quiet' # => Checkov: Scan local terraform directory (./terraform)

terraform() { # => Terraform wrapper (preserves args)
	echo "+ terraform $*"
	command terraform "$@"
}

# ------------------------------------------
# Container Orchestration
# ------------------------------------------
kubectl() { # => Kubectl wrapper (preserves args)
	echo "+ kubectl $*" >&2
	command kubectl "$@"
}

# ------------------------------------------
# Infrastructure as Code
# ------------------------------------------
# ------------------------------------------
# Infrastructure as Code
# ------------------------------------------
tf-val-all() { # => Terraform: Recursively validate and scan all Terraform directories
	find terraform/ -type f -name "*.tf" -exec dirname {} \; | sort -u | xargs -I {} -P 8 bash -c '
        echo -e "\n🔍 Validating {}..."
        terraform -chdir="{}" init -backend=false > /dev/null 2>&1
        if terraform -chdir="{}" validate; then
            echo -e "🛡️ Scanning {} with Checkov..."
            checkov -d "{}" --framework terraform --quiet
        else
            echo -e "🚨 Validation failed for {}"
        fi
    '
}

# Bypass the custom kubectl wrapper when generating completions to prevent terminal echo
if command -v kubectl >/dev/null 2>&1; then source <(command kubectl completion bash); fi
if command -v terraform >/dev/null 2>&1; then complete -C "$(which terraform)" terraform; fi
