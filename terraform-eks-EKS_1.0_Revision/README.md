Initialize Terraform <br>
`terraform init`

Deploy DMZ Cluster in IL2  <br>
`terraform apply -var-file=environments/il2/dmz.tfvars -auto-approve`

Deploy Transit Cluster in IL2 <br>
`terraform apply -var-file=environments/il2/transit.tfvars -auto-approve`

Deploy Core Services Cluster in IL5 <br>
`terraform apply -var-file=environments/il5/core-services.tfvars -auto-approve`

Deploy DevSecOps Cluster in IL5 <br>
`terraform apply -var-file=environments/il5/devsecops.tfvars -auto-approve`

Deploy ApplicationA in DMZ and Transit Clusters <br>
`terraform apply -var-file=environments/il2/dmz.tfvars -var="application=ApplicationA" -auto-approve`
`terraform apply -var-file=environments/il2/transit.tfvars -var="application=ApplicationA" -auto-approve`

Deploy ApplicationB in Core Services Cluster <br> 
`terraform apply -var-file=environments/il2/core-services.tfvars -var="application=ApplicationB" -auto-approve`

Deploy ApplicationC in DevSecOps Cluster <br>
`terraform apply -var-file=environments/il2/devsecops.tfvars -var="application=ApplicationC" -auto-approve`

With this approach we can  <br>
*   Dynamically Deploys Applications – No need to modify main.tf for new applications <br>
*   Maintains Environment Consistency – Applications are mapped to specific clusters <br>
*   Supports Scalability – Easily extendable to IL3, IL4 etc.. or future environments