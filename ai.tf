resource "azurerm_ai_services" "ai" {
  name                = "aai-flowise-demo"
  location            = "swedencentral"
  resource_group_name = azurerm_resource_group.rg.name
  sku_name            = "S0"

  identity {
    type = "SystemAssigned"
  }
}

# resource "azurerm_ai_foundry" "hub" {
#   name                  = "aihub-flowise-demo"
#   location              = "swedencentral"
#   resource_group_name   = azurerm_resource_group.rg.name
#   storage_account_id    = azurerm_storage_account.saai.id
#   key_vault_id          = azurerm_key_vault.kv.id
# //  storage_account_id    = azurerm_storage_account.sa.id
# //  application_insights_id = azurerm_application_insights.appi.id
#   container_registry_id = azurerm_container_registry.acr.id

# /*
#   encryption {
#     key_id = "",
#     key_vault_id = azurerm_key_vault.kv.id
#     managed_identity_id = azurerm_user_assigned_identity.uai.id
#   }
# */
#   friendly_name = "Flowise AI Foundry Hub"
#   description = "AI Foundry Hub for Flowise Demo Project"

#   managed_network {
#     isolation_mode = "AllowInternetOutbound"
#   }
# //  public_network_access = "Disabled"

#   identity {
#     type = "SystemAssigned"
#   }
# }

resource "azurerm_cognitive_deployment" "aifoundry_deployments" {
  for_each = var.model_deployments

  name                 = each.value.model_name
  cognitive_account_id = azurerm_ai_services.ai.id

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