# Generate random value for unique resource naming
resource "random_string" "example" {
  length  = 8
  lower   = true
  numeric = false
  special = false
  upper   = false
}

# Create an Azure Storage Account
resource "azurerm_storage_account" "saai" {
  name                     = "saai${random_string.example.result}"  # Storage account name
  location                 = azurerm_resource_group.rg.location     # Location from the resource group
  resource_group_name      = azurerm_resource_group.rg.name         # Resource group name
  account_tier             = "Standard"                             # Performance tier
  account_replication_type = "LRS"                                  # Locally-redundant storage replication
}
