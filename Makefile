TF_PLAN := tf-plan.binary
TF_PLAN_JSON := tf-plan.json
#UNAME := $(shell echo $(shell uname) | awk '{print tolower($0)}')
UNAME := $(shell  uname)

.PHONY: tf-init \
	tf-plan \
	tf-plan-json \
	opa-eval \
	clean

.DEFAULT_GOAL := tf-init

tf-init:
	terraform init

tf-plan: tf-init
	terraform plan \
		--out $(TF_PLAN)
	terraform show \
		-json $(TF_PLAN) > $(TF_PLAN_JSON)
	cat $(TF_PLAN_JSON)

opa:
	curl \
		--location \
		--output opa \
		https://openpolicyagent.org/downloads/v0.28.0/opa_$(UNAME)_amd64
	chmod +x opa

opa-test: opa
	./opa test \
		. \
		--verbose

opa-eval: opa-test
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
