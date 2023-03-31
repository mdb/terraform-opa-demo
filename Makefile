TF_VERSION := 1.4.4
TF_PLAN := tf-plan.binary
TF_PLAN_JSON := tf-plan.json
OPA_VERSION := 0.40.0

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

.DEFAULT_GOAL := tf-init

tf-init:
	$(call terraform,"terraform init")
.PHONY: tf-init

tf-plan: tf-init
	$(call terraform,"terraform plan -out $(TF_PLAN)")
	$(call terraform,"terraform show -json $(TF_PLAN) > $(TF_PLAN_JSON)")
.PHONY: tf-plan

opa-test:
	$(call opa,test . --verbose)
.PHONY: opa-test

opa-eval: opa-test
	$(call opa,eval --data policy.rego --input $(TF_PLAN_JSON) data.terraform.analysis.has_acceptable_greeting --fail)
.PHONY: opa-eval

clean:
	rm *.binary || exit 0
	rm *.json || exit 0
	rm *.tfstate || exit 0
	rm *.sh || exit 0
	rm -rf .terraform || exit 0
	rm opa || exit 0
.PHONY: tf-init
