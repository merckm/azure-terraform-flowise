# Create azure container registry
resource "azurerm_container_registry" "acr" {
  name                          = var.acr_name
  location                      = azurerm_resource_group.rg.location
  resource_group_name           = azurerm_resource_group.rg.name
  admin_enabled                 = true
  sku                           = var.acr_sku
  public_network_access_enabled = false
  tags                          = var.tags 
}

# Create azure container registry private endpoint
resource "azurerm_private_dns_zone" "acr_private_dns_zone" {
  name                = "privatelink.azurecr.io"
  resource_group_name =  azurerm_resource_group.rg.name
}

# Create azure private dns zone virtual network link for acr private endpoint vnet
resource "azurerm_private_dns_zone_virtual_network_link" "acr_private_dns_zone_virtual_network_link" {
  name                  = "${var.acr_name}-private-dns-zone-vnet-link"
  private_dns_zone_name = azurerm_private_dns_zone.acr_private_dns_zone.name
  resource_group_name   = azurerm_resource_group.rg.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
  tags                  = var.tags
}

# Create azure private endpoint
resource "azurerm_private_endpoint" "acr_private_endpoint" {
  name                = "${var.acr_name}-private-endpoint"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  subnet_id           = azurerm_subnet.pesubnet.id
  tags                = var.tags
  
  private_service_connection {
    name                           = "${var.acr_name}-service-connection"
    private_connection_resource_id = azurerm_container_registry.acr.id
    is_manual_connection           = false
    subresource_names = [
      "registry"
    ]
  }
  
  private_dns_zone_group {
    name = "${var.acr_name}-private-dns-zone-group"
    
    private_dns_zone_ids = [
      azurerm_private_dns_zone.acr_private_dns_zone.id
    ]  
  }
 
  depends_on = [
    azurerm_virtual_network.vnet,
    azurerm_subnet.webappsubnet,
    azurerm_container_registry.acr
  ]
}