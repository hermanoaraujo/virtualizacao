provider "azurerm" {
    version = "=2.26"
    features {
      
    }
}

resource "azurerm_resource_group" "rg" {
  name     = "Virtu_IFPB"
  location = "eastus"
  tags = {
        Environment = "Turma Virtualização IFPB"
        Team = "Redes de Computadores"
    }
}
# Create a virtual network
resource "azurerm_virtual_network" "vnet" {
    name                = "vnetIfpb"
    address_space       = ["10.0.0.0/16"]
    location            = "eastus"
    resource_group_name = azurerm_resource_group.rg.name
}
# Create subnet
resource "azurerm_subnet" "subnet" {
  name                 = "subnetIfpb"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}
# Create public IP
resource "azurerm_public_ip" "publicip" {
  name                = "publicipIfpb"
  location            = "eastus"
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
}
# Create Network Security Group and rule
resource "azurerm_network_security_group" "nsg" {
  name                = "myTFNSG"
  location            = "eastus"
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Create network interface
resource "azurerm_network_interface" "nic" {
  name                      = "ifpbNIC"
  location                  = "eastus"
  resource_group_name       = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "ifpbNICConfig"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = azurerm_public_ip.publicip.id
  }
}

# Create a Linux virtual machine
resource "azurerm_virtual_machine" "vm" {
  name                  = "ifpbVM"
  location              = "eastus"
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.nic.id]
  vm_size               = "Standard_DS1_v2"

  storage_os_disk {
    name              = "myOsDisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04.0-LTS"
    version   = "latest"
  }

  os_profile {
    computer_name  = "ifpbVM"
    admin_username = var.admin_username
    admin_password = var.admin_password
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}

data "azurerm_public_ip" "ip" {
  name                = azurerm_public_ip.publicip.name
  resource_group_name = azurerm_virtual_machine.vm.resource_group_name
  depends_on          = [azurerm_virtual_machine.vm]
}
