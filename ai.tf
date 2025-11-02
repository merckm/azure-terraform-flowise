# resource "azurerm_ai_services" "ai" {
#   name                = "aif-flowise-demo"
#   location            = "swedencentral"
#   resource_group_name = azurerm_resource_group.rg.name
#   sku_name            = "S0"

#   identity {
#     type = "SystemAssigned"
#   }
# }

resource "azurerm_cognitive_account" "hub" {
  name                = "aif-hub-flowise-demo"
  location            = "swedencentral"
  resource_group_name = azurerm_resource_group.rg.name
  kind                = "AIServices"

  identity {
    type = "SystemAssigned"
  }
  sku_name = "S0"

  # required for stateful development in Foundry including agent service
  custom_subdomain_name = "aif-hub-flowise-demo"
  project_management_enabled = true
}

resource "azurerm_cognitive_deployment" "aifoundry_deployments" {
  for_each = var.model_deployments

  name                 = each.value.model_name
  cognitive_account_id = azurerm_cognitive_account.hub.id

  sku {
    name     = each.value.sku_name
    capacity = each.value.sku_capacity
  }

  model {
    format  = "OpenAI"
    name    = each.value.model_name
    version = each.value.model_version
  }
}

# resource "azurerm_ai_foundry_project" "project" {
#   name               = "aip-flowise-demo"
#   location           = "swedencentral"
#   ai_services_hub_id = azurerm_ai_foundry.hub.id

#   identity {
#     type = "SystemAssigned" # Enable system-assigned managed identity
#   }
# }

 