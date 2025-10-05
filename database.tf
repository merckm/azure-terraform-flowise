
// database.tf

// Database instance
resource "azurerm_postgresql_flexible_server" "postgres" {
  name                          = "postgresql-${var.project_name}"
  location                      = azurerm_resource_group.rg.location
  resource_group_name           = azurerm_resource_group.rg.name
  sku_name                      = "GP_Standard_D2s_v3"
  storage_mb                    = 32768
  version                       = "14"
  delegated_subnet_id           = azurerm_subnet.dbsubnet.id
  private_dns_zone_id           = azurerm_private_dns_zone.postgres.id
  public_network_access_enabled = false
  backup_retention_days         = 7
  geo_redundant_backup_enabled  = false
  auto_grow_enabled             = false
  administrator_login           = var.db_username
  administrator_password        = var.db_password
  zone                          = "3"

  authentication {
    active_directory_auth_enabled = false
    password_auth_enabled         = true
  }
  lifecycle {
    prevent_destroy = false
  }
}

// Firewall
resource "azurerm_postgresql_flexible_server_firewall_rule" "pg_firewall" {
  for_each         = var.postgres_ip_rules
  name             = each.key
  server_id        = azurerm_postgresql_flexible_server.postgres.id
  start_ip_address = each.value
  end_ip_address   = each.value
}

// Database
resource "azurerm_postgresql_flexible_server_database" "production" {
  name      = "production"
  server_id = azurerm_postgresql_flexible_server.postgres.id
  charset   = "UTF8"
  collation = "en_US.utf8"

  # prevent the possibility of accidental data loss
  lifecycle {
    prevent_destroy = false
  }
}

// Database
resource "azurerm_postgresql_flexible_server_database" "production-vector" {
  name      = "production-vector"
  server_id = azurerm_postgresql_flexible_server.postgres.id
  charset   = "UTF8"
  collation = "en_US.utf8"

  # prevent the possibility of accidental data loss
  lifecycle {
    prevent_destroy = false
  }
}


// Transport off
resource "azurerm_postgresql_flexible_server_configuration" "postgres_config" {
  name      = "require_secure_transport"
  server_id = azurerm_postgresql_flexible_server.postgres.id
  value     = "off"
}

resource "azurerm_postgresql_flexible_server_configuration" "uuid_ossp" {
  name      = "azure.extensions"
  server_id = azurerm_postgresql_flexible_server.postgres.id
  value     = "UUID-OSSP,VECTOR,PGCRYPTO"
}