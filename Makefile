vpn:
	 terraform apply --var-file variables.tfvars

destroy:
	terraform destroy --var-file variables.tfvars