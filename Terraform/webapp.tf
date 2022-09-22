# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used
terraform {
 required_version=">=0.11"
  backend "azurerm" {
    storage_account_name = "__terraformstorageaccount__"
    container_name       = "terraform1"
    key                  = "terraform.tfstate"
    #access_key = "__storagekey__"
  }
}

 provider "azurerm" { 
      version = "=2.0.0"
   features{}
  }

# Configure the Microsoft Azure Provider


resource "azurerm_resource_group" "RG" {
    name = "${var.rg_name}"
    location ="${var.location}"
  
}
resource "azurerm_service_plan" "app1" {
    name = "App2-ASP"
    location = azurerm_resource_group.RG.location
    resource_group_name = azurerm_resource_group.RG.name
    sku_name= "B1"
    os_type= "Windows"
  
}

resource "azurerm_windows_web_app" "appservice" {
    service_plan_id = azurerm_service_plan.app1.id
    location = azurerm_resource_group.RG.location
    resource_group_name = azurerm_resource_group.RG.name
    name = "WebApp02-dhsk-dev"
    site_config {}
}

resource "azurerm_windows_web_app" "appservice1" {
    service_plan_id = azurerm_service_plan.app1.id
    location = azurerm_resource_group.RG.location
    resource_group_name = azurerm_resource_group.RG.name
    name = "WebApp02-dhsk-UAT"
    site_config {}
}

resource "azurerm_windows_web_app" "appservice2" {
    service_plan_id = azurerm_service_plan.app1.id
    location = azurerm_resource_group.RG.location
    resource_group_name = azurerm_resource_group.RG.name
    name = "WebApp02-dhsk-prod"
    site_config {}
}

variable "rg_name" {
    default ="DevOps-Pipeline-RG"
  
}
variable "location" {
    default = "EastUs"
  
}
