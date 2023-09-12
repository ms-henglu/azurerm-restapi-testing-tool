terraform {
  required_providers {
    azapi = {
      source = "Azure/azapi"
    }
  }
}

provider "azapi" {
  skip_provider_registration = false
}

variable "resource_name" {
  type    = string
  default = "acctest0001"
}

variable "location" {
  type    = string
  default = "westeurope"
}

resource "azapi_resource" "resourceGroup" {
  type                      = "Microsoft.Resources/resourceGroups@2020-06-01"
  name                      = var.resource_name
  location                  = var.location
}

resource "azapi_resource" "server" {
  type      = "Microsoft.Sql/servers@2015-05-01-preview"
  parent_id = azapi_resource.resourceGroup.id
  name      = var.resource_name
  location  = var.location
  body = jsonencode({
    properties = {
      administratorLogin         = "4dm1n157r470r"
      administratorLoginPassword = "4-v3ry-53cr37-p455w0rd"
      version                    = "12.0"
    }
  })
  schema_validation_enabled = false
  response_export_values    = ["*"]
}

resource "azapi_resource" "elasticPool" {
  type      = "Microsoft.Sql/servers/elasticPools@2014-04-01"
  parent_id = azapi_resource.server.id
  name      = var.resource_name
  location  = var.location
  body = jsonencode({
    properties = {
      dtu       = 50
      edition   = "Basic"
      storageMB = 5000
    }
  })
  schema_validation_enabled = false
  response_export_values    = ["*"]
}

