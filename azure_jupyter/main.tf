resource "tls_private_key" "example_ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "azurerm_resource_group" "terraform_demo" {
  name     = var.group_name
  location = var.locale
}

resource "azurerm_app_service_plan" "terraform_demo_appplan" {
  name                = var.app_plan_name
  location            = azurerm_resource_group.terraform_demo.location
  resource_group_name = azurerm_resource_group.terraform_demo.name
  kind                = var.system_kind
  reserved            = true

  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_linux_virtual_machine" "myterraformvm" {
  name                       = var.app_name
  location                   = var.locale
  resource_group_name        = azurerm_resource_group.terraform_demo.name
  network_interface_ids      = [azurerm_network_interface.myterraformnic.id]
  size                       = "Standard_DS1_v2"
  allow_extension_operations = true

  os_disk {
    name                 = "myOsDisk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  computer_name                   = "terraform"
  admin_username                  = "azureuser"
  admin_password                  = "SomeSecretP@SW)RD"
  disable_password_authentication = false

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.mystorageaccount.primary_blob_endpoint
  }

  provisioner "local-exec" {
    command = "echo ${azurerm_public_ip.myterraformpublicip.ip_address}"
  }

  provisioner "local-exec" {
    command = "az vm run-command invoke --name ${var.app_name} -g ${azurerm_resource_group.terraform_demo.name} --command-id RunShellScript --scripts @install_docker.sh"
  }

  tags = {
    environment = "Terraform Demo"
  }
}