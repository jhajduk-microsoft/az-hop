resource "azurerm_network_interface" "ccportal-nic" {
  name                = "ccportal-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.admin.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "ccportal" {
  name                = "ccportal"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  vm_size                = "Standard_d2s_v3"
  network_interface_ids = [
    azurerm_network_interface.ccportal-nic.id,
  ]

  os_profile {
    computer_name  = "ccportal"
    admin_username = var.admin_username
  }

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      path     = "/home/${var.admin_username}/.ssh/authorized_keys"
      key_data = tls_private_key.internal.public_key_openssh # file("~/.ssh/id_rsa.pub")
    }
  }

  storage_os_disk {
    name              = "ccportal-osdisk"
    create_option     = "FromImage"
    caching              = "ReadWrite"
    managed_disk_type = "Standard_LRS"
  }

  storage_image_reference {
    publisher = "azurecyclecloud"
    offer     = "azure-cyclecloud"
    sku       = "cyclecloud-81"
    version   = "8.1.0"
  }

  plan {
    name = "cyclecloud-81"
    publisher = "azurecyclecloud"
    product = "azure-cyclecloud"
  }

  storage_data_disk {
    lun               = 0
    name              = "ccportal-datadisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
    disk_size_gb      = 128
  }
}
