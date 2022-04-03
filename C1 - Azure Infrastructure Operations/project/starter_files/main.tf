provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "main" {
  name     = "${var.prefix}-rg"
  location = var.location
  tags = {
    scope = "demo"
  }

}

resource "azurerm_virtual_network" "main" {
  name                = "${var.prefix}-vn"
  address_space       = ["10.0.0.0/22"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  tags = {
    scope = "demo"
  }

}

resource "azurerm_subnet" "main" {
  name                 = "${var.prefix}-subnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.2.0/24"]

}

resource "azurerm_network_interface" "main" {
  count                = var.number_of_vms
  name                 = "${var.prefix}-${count.index}-nic"
  resource_group_name  = azurerm_resource_group.main.name
  location             = azurerm_resource_group.main.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.main.id
    private_ip_address_allocation = "Dynamic"
  }
  tags = {
    scope = "demo"
  }

}

resource "azurerm_public_ip" "main" {
  name                = "demo-publicIP"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  allocation_method   = "Static"

  tags = {
    scope = "demo"
  }
}

resource "azurerm_linux_virtual_machine" "main" {
  count                           = var.number_of_vms
  name                            = "${var.prefix}-${count.index}-vm"
  resource_group_name             = azurerm_resource_group.main.name
  location                        = azurerm_resource_group.main.location
  size                            = "Standard_D2s_v3"
  admin_username                  = "${var.username}"
  admin_password                  = "${var.password}"
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.main[count.index].id,
  ]
  source_image_id = "/subscriptions/b0ab72ae-7000-4034-80d3-600cca548bf1/resourceGroups/udacity-demo-rg/providers/Microsoft.Compute/images/demoProjectUbuntuImage"

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }
  tags = {
    scope = "demo"
  }
}

resource "azurerm_lb" "main" {
  name                = "${var.prefix}-loadBalancer"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  frontend_ip_configuration {
    name                 = "${var.prefix}-publicIPAddress"
    public_ip_address_id = azurerm_public_ip.main.id
  }
  tags = {
    scope = "demo"
  }
}

resource "azurerm_availability_set" "main" {
  name                = "${var.prefix}-aset"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  tags = {
    scope = "demo"
  }
}
