TF_PLAN = tf-plan.binary
TF_PLAN_JSON = tf-plan.json

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

tf-plan-json:
	terraform show \
		-json $(TF_PLAN) > $(TF_PLAN_JSON)

opa-eval: tf-plan-json
	opa \
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
