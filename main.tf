terraform {
  backend "remote" {
      hostname ="app.terraform.io"
      organization="cisco-dcn-ecosystem"
      workspaces {
        name = "huyeduon-tfazure "
      }
  }
  required_providers {
    aci = {
      source = "CiscoDevNet/aci"
      version = "0.5.4"
    }
  }
}

provider "aci" {
  # cisco-aci user name
  username = var.capic_username
  password = var.capic_password
  url      = var.capic_url
  insecure = true
}

provider "azurerm" {
    subscription_id = var.azure_demo04_subs
    client_id = var.huyeduon_api_client_id
    client_secret = var.huyeduon_api_client_secret
    tenant_id = var.azure_tenant_id
    features {}
}

# Create tenant tfcloud using rest.
resource "aci_rest" "tfcloud" {
  path       = "/api/node/mo/uni.json"
  payload = <<EOF
  {
    "fvTenant": {
        "attributes": {
            "name": "tfcloud",
            "status": "created"
        },
        "children": [
            {
                "fvRsCloudAccount": {
                    "attributes": {
                        "tDn": "uni/tn-infra/act-[343fd6f5-2a74-4e53-95e3-d0766750dcc3]-vendor-azure"
                    },
                    "children": []
                }
            }
        ]
    }
  }
  EOF
}

# Add tfvrf1
resource "aci_vrf" "tfvrf1" {
  tenant_dn              = aci_tenant.tfcloud.id
  name                   = var.tfvrf1
  annotation             = var.tfvrf1
}