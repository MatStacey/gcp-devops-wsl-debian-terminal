alias tf='terraform'                               # => Terraform: Base command
alias tfp='terraform plan'                         # => Terraform: Plan deployment
alias tfa='terraform apply'                        # => Terraform: Apply deployment
alias tfd='terraform destroy'                      # => Terraform: Destroy resources
alias tff='terraform fmt -recursive'               # => Terraform: Format all TF files recursively
alias checkov-tf='checkov -d terraform/ --framework terraform --quiet' # => Checkov: Scan local terraform directory (./terraform)

terraform() { # => Terraform wrapper (preserves args)
    echo "+ terraform $*"
    command terraform "$@"
}
kubectl() { # => Kubectl wrapper (preserves args)
    echo "+ kubectl $*" >&2
    command kubectl "$@"
}
tf-validate-all() { # => Terraform: Recursively validate all Terraform directories
    find terraform/ -type f -name "*.tf" -exec dirname {} \; | sort -u | while read dir; do
        echo -e "\n🔍 Validating $dir..."
        terraform -chdir="$dir" init -backend=false > /dev/null 2>&1
        terraform -chdir="$dir" validate
    done
}

if command -v kubectl >/dev/null 2>&1; then source <(kubectl completion bash); fi
if command -v terraform >/dev/null 2>&1; then complete -C "$(which terraform)" terraform; fi