export AWS_PROFILE := terraform
.PHONY: bootstrap bootstrap-destroy init plan apply destroy fmt fmt-check validate

BOOTSTRAP_DIR := bootstrap
INFRA_DIR     := infra
BACKEND_FILE  := backend.hcl

# Bootstrap

bootstrap:
	@echo "Initializing bootstrap"
	cd $(BOOTSTRAP_DIR) && terraform init
	@echo "Applying bootstrap (S3 + DynamoDB)"
	cd $(BOOTSTRAP_DIR) && terraform apply -auto-approve
	@echo "Bootstrap complete. Dont forget to fill in $(BACKEND_FILE)"

bootstrap-destroy:
	@echo "Destroying bootstrap resources"
	cd $(BOOTSTRAP_DIR) && terraform destroy

# Infra

init:
	@echo "Initializing infra backend"
	cd $(INFRA_DIR) && terraform init -backend-config=../$(BACKEND_FILE)

plan:
	cd $(INFRA_DIR) && terraform plan -out=tfplan

apply:
	cd $(INFRA_DIR) && terraform apply tfplan

destroy:
	cd $(INFRA_DIR) && terraform destroy

# Helpers

fmt:
	terraform fmt -recursive

fmt-check:
	terraform fmt -check -recursive

validate:
	cd $(INFRA_DIR) && terraform validate