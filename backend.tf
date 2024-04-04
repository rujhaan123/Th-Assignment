terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "Rujhaan-Resource"

    workspaces {
      name = "Th-Assignment"
    }
  }
}
