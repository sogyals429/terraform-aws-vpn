init:
	terraform init

vpn:
	 terraform apply --var-file variables.tfvars -auto-approve

destroy:
	terraform destroy --var-file variables.tfvars
