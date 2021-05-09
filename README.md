# terraform-opa-demo

A relatively simple and largely contrived example showing automated Terraform plan analysis using the [Open Policy Agent](https://www.openpolicyagent.org/) policy-as-code framework.

## Usage

First, install the [Terraform](https://www.terraform.io/downloads.html) and [OPA](https://www.openpolicyagent.org/docs/latest/#1-download-opa) CLIs.

Next, execute a `terraform plan` (see the `Makefile` for details):

```
make tf-plan
```

Evaluate the Terraform plan JSON using the policy codified in the `policy.rego` file (see the `Makefile` for details):

```
make opa-eval
```
