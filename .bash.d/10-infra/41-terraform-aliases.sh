# Copyright 2017 Google Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# ------------------------------------------
# Terraform
# ------------------------------------------

#######################################
# Terraform: Base command
#######################################
alias tf='terraform'
#######################################
# Terraform: Apply deployment
#######################################
alias tfa='terraform apply'
#######################################
# Terraform: Apply deployment (auto-approve)
#######################################
alias tfay='terraform apply -auto-approve'
#######################################
# Terraform: Open interactive console
#######################################
alias tfc='terraform console'
#######################################
# Terraform: Destroy resources
#######################################
alias tfd='terraform destroy'
#######################################
# Terraform: Destroy resources (auto-approve)
#######################################
alias tfdy='terraform destroy -auto-approve'
#######################################
# Terraform: Format codebase
#######################################
alias tff='terraform fmt'
#######################################
# Terraform: Force unlock state
#######################################
alias tffu='terraform force-unlock'
#######################################
# Terraform: Generate graph
#######################################
alias tfg='terraform graph'
#######################################
# Terraform: Import resource
#######################################
alias tfim='terraform import'
#######################################
# Terraform: Initialize directory
#######################################
alias tfin='terraform init'
#######################################
# Terraform: Initialize and upgrade modules/providers
#######################################
alias tfinu='terraform init -upgrade'
#######################################
# Terraform: Read outputs
#######################################
alias tfo='terraform output'
#######################################
# Terraform: Plan deployment
#######################################
alias tfp='terraform plan'
#######################################
# Terraform: Plan destruction
#######################################
alias tfpde='terraform plan --destroy'
#######################################
# Terraform: List providers
#######################################
alias tfpr='terraform providers'
#######################################
# Terraform: Refresh state
#######################################
alias tfr='terraform refresh'
#######################################
# Terraform: Manage state
#######################################
alias tfs='terraform state'
#######################################
# Terraform: Show state
#######################################
alias tfsh='terraform show'
#######################################
# Terraform: List resources in state
#######################################
alias tfsls='terraform state list'
#######################################
# Terraform: Move resource in state
#######################################
alias tfsmv='terraform state mv'
#######################################
# Terraform: Push state
#######################################
alias tfsph='terraform state push'
#######################################
# Terraform: Pull state
#######################################
alias tfspl='terraform state pull'
#######################################
# Terraform: Remove resource from state
#######################################
alias tfsrm='terraform state rm'
#######################################
# Terraform: Show resource in state
#######################################
alias tfssw='terraform state show'
#######################################
# Terraform: Taint resource
#######################################
alias tft='terraform taint'
#######################################
# Terraform: Untaint resource
#######################################
alias tfut='terraform untaint'
#######################################
# Terraform: Validate codebase
#######################################
alias tfv='terraform validate'
#######################################
# Terraform: Manage workspaces
#######################################
alias tfw='terraform workspace'
#######################################
# Terraform: Delete workspace
#######################################
alias tfwde='terraform workspace delete'
#######################################
# Terraform: List workspaces
#######################################
alias tfwls='terraform workspace list'
#######################################
# Terraform: Create new workspace
#######################################
alias tfwnw='terraform workspace new'
#######################################
# Terraform: Select workspace
#######################################
alias tfwst='terraform workspace select'
#######################################
# Terraform: Show active workspace
#######################################
alias tfwsw='terraform workspace show'
