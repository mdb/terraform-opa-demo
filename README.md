# terraform-opa-demo

A relatively simple and largely contrived example showing automated Terraform plan analysis using the [Open Policy Agent](https://www.openpolicyagent.org/) policy-as-code framework.

## Usage

Install the [Terraform](https://www.terraform.io/downloads.html) and [OPA](https://www.openpolicyagent.org/docs/latest/#1-download-opa) CLIs.

First, execute a `terraform plan`:

```
make tf-plan
```

Evaluate the Terraform plan JSON using the policy codified in the `policy.rego` file:

```
make opa-eval
```
