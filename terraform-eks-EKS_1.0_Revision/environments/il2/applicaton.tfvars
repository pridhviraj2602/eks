region       = "us-east-1"
env          = "il2"

application_mappings = {
  "ApplicationA" = ["eks-dmz", "eks-transit"]
  "ApplicationB" = ["eks-core-services"]
  "ApplicationC" = ["eks-devsecops"]
}

application_images = {
  "ApplicationA" = "nginx:latest"
  "ApplicationB" = "myrepo/appB:latest"
  "ApplicationC" = "myrepo/appC:latest"
}