resource "azurerm_network_interface" "scheduler-nic" {
  name                = "scheduler-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.admin.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "scheduler" {
  name                = "scheduler"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_d2s_v3"
  admin_username      = "hpcadmin"
  network_interface_ids = [
    azurerm_network_interface.scheduler-nic.id,
  ]

  admin_ssh_key {
    username   = "hpcadmin"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "OpenLogic"
    offer     = "CentOS"
    sku       = "7.7"
    version   = "latest"
  }

#  connection {
#    type     = "ssh"
#    host     = azurerm_public_ip.jumpbox-pip.ip_address
#    user     = azurerm_linux_virtual_machine.jumpbox.admin_username
#    private_key = file("~/.ssh/id_rsa")
#  }

#  provisioner "remote-exec" {
#    inline = ["sudo yum install screen -y"]
#  }
}
