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

resource "azapi_resource" "service" {
  type      = "Microsoft.ApiManagement/service@2021-08-01"
  parent_id = azapi_resource.resourceGroup.id
  name      = var.resource_name
  location  = var.location
  body = jsonencode({
    identity = {
      type = "None"
    }
    properties = {
      certificates = [
      ]
      customProperties = {
        "Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Backend.Protocols.Ssl30"                      = "false"
        "Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Backend.Protocols.Tls10"                      = "false"
        "Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Backend.Protocols.Tls11"                      = "false"
        "Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA" = "false"
        "Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA" = "false"
        "Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA"   = "false"
        "Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA"   = "false"
        "Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TLS_RSA_WITH_AES_128_CBC_SHA"         = "false"
        "Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TLS_RSA_WITH_AES_128_CBC_SHA256"      = "false"
        "Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TLS_RSA_WITH_AES_128_GCM_SHA256"      = "false"
        "Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TLS_RSA_WITH_AES_256_CBC_SHA"         = "false"
        "Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TLS_RSA_WITH_AES_256_CBC_SHA256"      = "false"
        "Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TLS_RSA_WITH_AES_256_GCM_SHA384"      = "false"
        "Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TripleDes168"                         = "false"
        "Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Protocols.Ssl30"                              = "false"
        "Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Protocols.Tls10"                              = "false"
        "Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Protocols.Tls11"                              = "false"
      }
      disableGateway      = false
      publicNetworkAccess = "Enabled"
      publisherEmail      = "pub1@email.com"
      publisherName       = "pub1"
      virtualNetworkType  = "None"
    }
    sku = {
      capacity = 1
      name     = "Developer"
    }
  })
  schema_validation_enabled = false
  response_export_values    = ["*"]
  timeouts {
    create = "180m"
    update = "180m"
    delete = "60m"
  }
}

resource "azapi_resource" "product" {
  type      = "Microsoft.ApiManagement/service/products@2021-08-01"
  parent_id = azapi_resource.service.id
  name      = var.resource_name
  body = jsonencode({
    properties = {
      description          = ""
      displayName          = "Test Product"
      state                = "published"
      subscriptionRequired = true
      terms                = ""
    }
  })
  schema_validation_enabled = false
  response_export_values    = ["*"]
}

resource "azapi_resource" "user" {
  type      = "Microsoft.ApiManagement/service/users@2021-08-01"
  parent_id = azapi_resource.service.id
  name      = var.resource_name
  body = jsonencode({
    properties = {
      email     = "azure-acctest230630032559695401@example.com"
      firstName = "Acceptance"
      lastName  = "Test"
    }
  })
  schema_validation_enabled = false
  response_export_values    = ["*"]
}

resource "azapi_resource" "subscription" {
  type      = "Microsoft.ApiManagement/service/subscriptions@2021-08-01"
  parent_id = azapi_resource.service.id
  name      = "0f393927-8f2d-499d-906f-c03943328d31"
  body = jsonencode({
    properties = {
      allowTracing = true
      displayName  = "Butter Parser API Enterprise Edition"
      ownerId      = azapi_resource.user.id
      scope        = azapi_resource.product.id
      state        = "submitted"
    }
  })
  schema_validation_enabled = false
  response_export_values    = ["*"]
}

