docker run --name "terraform-aws-cli" -it --rm -v ${PWD}:/work -w /work --entrypoint /bin/sh wojtax/terraform_aws:1.0.11