TF_VERSION := 1.4.4
TF_PLAN := tf-plan.binary
TF_PLAN_JSON := tf-plan.json
OPA_VERSION := 0.28.0

define terraform
	docker run \
		--volume $(shell pwd):/src \
		--workdir /src \
		--entrypoint /bin/sh \
		hashicorp/terraform:$(TF_VERSION) \
			-c \
				$(1)
endef

define opa
	docker run \
		--volume $(shell pwd):/src \
		--workdir /src \
		openpolicyagent/opa:$(OPA_VERSION) \
			$(1)
endef

.PHONY: tf-init \
	tf-plan \
	opa-test \
	opa-eval \
	clean

.DEFAULT_GOAL := tf-init

tf-init:
	$(call terraform,"terraform init")

tf-plan: tf-init
	$(call terraform,"terraform plan -out $(TF_PLAN)")
	$(call terraform,"terraform show -json $(TF_PLAN) > $(TF_PLAN_JSON)")

opa-test: opa
	$(call opa,test . --verbose)

opa-eval: opa-test
	$(call opa,eval --data policy.rego --input $(TF_PLAN_JSON) data.terraform.analysis.has_acceptable_greeting --fail)

clean:
	rm *.binary || exit 0
	rm *.json || exit 0
	rm *.tfstate || exit 0
	rm *.sh || exit 0
	rm -rf .terraform || exit 0
	rm opa || exit 0
