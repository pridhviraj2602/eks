```markdown
## Usage Instructions

### Build the Universal AMI with Packer

In the repository root, run:

```bash
cd packer
packer init universal-ami.pkr.hcl
packer build universal-ami.pkr.hcl
```

Note the resulting AMI ID and pass it to Terraform (or set it in your variables).

---

### Run Terraform

From the root of the repository, run:

```bash
terraform init
terraform apply -auto-approve -var="universal_ami_id=ami-XXXXXXXXXXXX"
```

This will provision:

- A VPC with subnets for your cloud clusters.
- The chosen EKS Cloud cluster (e.g., `eks-core-services` if set in variables) with the proper instance type and 3 worker nodes if it is `core-services`; otherwise, 1 node.
- Three on-prem EKS Anywhere clusters:
  - `core-services` with 3 nodes
  - `devsecops` and `dmz` with 1 node each
- Additional modules (e.g., `app-keycloak`, EC2 for Gitaly)

---

### Deploy Kubernetes Manifests with ArgoCD

After your cluster is ready and ArgoCD is installed (either manually or via Terraform/Helm), apply the ArgoCD application manifests from the `argocd/applications/` folder:

```bash
kubectl apply -f argocd/applications/il2-core-services.yaml
kubectl apply -f argocd/applications/il2-devsecops.yaml
kubectl apply -f argocd/applications/il2-dmz.yaml
```

ArgoCD will pull the Kustomize overlays from your Git repository and sync them to the designated namespaces.

---

### CI/CD

If you’re using GitLab CI/CD, pushing changes will trigger the pipeline defined in `.gitlab-ci.yml` that rebuilds the AMI (if necessary) and then runs Terraform.
```
