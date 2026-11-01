# Project Verification Log

Mark each item after YOU perform it. Keep screenshots of your own test results if you wish to make them portfolio evidence.

- [ ] Read all Terraform and Python files and understand their purpose.
- [ ] Run `python3 -m unittest discover -s tests -v` locally.
- [ ] Run `terraform fmt -check -recursive` locally.
- [ ] Run `terraform init -backend=false -input=false` locally.
- [ ] Run `terraform validate` locally.
- [ ] Upload to GitHub and verify the GitHub Actions CI has a green checkmark.
- [ ] Optional: Inspect `terraform plan` in your authorized Azure subscription.
- [ ] Optional: Deploy in Azure, verify settings, and record evidence without secrets.
- [ ] Optional: Use `terraform destroy` and verify cost-bearing resources were removed.

**Prepared starter status:** Code and documentation authored; Python checks are locally executable without cloud access. Terraform validation and Azure deployment are NOT claimed until completed.
