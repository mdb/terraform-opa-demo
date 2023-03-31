TF_VERSION := 1.4.4
TF_PLAN := tf-plan.binary
TF_PLAN_JSON := tf-plan.json
UNAME := $(shell  uname)

define terraform
	docker run \
		--volume $(shell pwd):/src \
		--workdir /src \
		--entrypoint /bin/sh \
		hashicorp/terraform:$(TF_VERSION) \
			-c \
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

opa:
	curl \
		--location \
		--output opa \
		https://openpolicyagent.org/downloads/v0.28.0/opa_$(UNAME)_amd64
	chmod +x opa

opa-test: opa
	cat $(TF_PLAN_JSON)
	./opa test \
		. \
		--verbose

opa-eval: opa-test
	cat $(TF_PLAN_JSON)
	./opa \
		eval \
			--data policy.rego \
			--input $(TF_PLAN_JSON) \
			"data.terraform.analysis.has_acceptable_greeting" \
			--fail

clean:
	rm *.binary || exit 0
	rm *.json || exit 0
	rm *.tfstate || exit 0
	rm *.sh || exit 0
	rm -rf .terraform || exit 0
	rm opa || exit 0
