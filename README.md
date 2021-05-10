[![Terraform](https://github.com/mdb/terraform-opa-demo/actions/workflows/main.yml/badge.svg)](https://github.com/mdb/terraform-opa-demo/actions/workflows/main.yml)

# terraform-opa-demo

A relatively simple and largely contrived example showing automated Terraform plan analysis using the [Open Policy Agent](https://www.openpolicyagent.org/) policy-as-code framework.

## Usage

First, install the [Terraform](https://www.terraform.io/downloads.html) CLI.

Next, execute a `terraform plan` (see the `Makefile` for details):

```
make tf-plan
```

Run tests verifying the correctness of the `policy.rego` file and evaluate the Terraform plan JSON using the expressed policy (see the `Makefile` for details):

```
make opa-eval
```
