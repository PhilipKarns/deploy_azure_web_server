provider "azurerm" {
    features {}
}

resource "azurerm_resource_group" "main"{
    name = "${var.prefix}-rg"
    location = var.location
}

resource "azurerm_virtual_network" "main" {
	name = "${var.prefix}-network"
	address_space = ["10.0.0.0/16"]
	location = azurerm_resource_group.main.location
	resource_group_name = azurerm_resource_group.main.name

	tags = {
		displayName: var.taggingPolicy	
	}
}

resource "azurerm_subnet" "internal" {
	name = "internal"
	resource_group_name = azurerm_resource_group.main.name
	virtual_network_name = azurerm_virtual_network.main.name
	address_prefixes = ["10.0.2.0/24"]
}

resource "azurerm_network_security_group" "main" {
	name = "${var.prefix}-SecurityGroup"
	location = azurerm_resource_group.main.location
	resource_group_name = azurerm_resource_group.main.name

	tags = {
		displayName: var.taggingPolicy	
	}
}

resource "azurerm_network_security_rule" "main" {
	for_each = local.nsgrules
	name = each.key
	direction = each.value.direction
	access = each.value.access
	priority = each.value.priority
	protocol = each.value.protocol
	source_port_range = each.value.source_port_range
	destination_address_prefix = each.value.destination_address_prefix
	resource_group_name = azurerm_resource_group.main.name
	network_security_group_name = azurerm_network_security_group.main.name
}

resource "azurerm_network_interface" "main" {
	name = "${var.prefix}-nic"
	location = azurerm_resource_group.main.location
	resource_group_name = azurerm_resource_group.main.name

	ip_configuration {
		name = "internal"
		subnet_id = azurerm_subnet.internal.id
		private_ip_address_allocation = "Dynamic"
	}
}

resource "azurerm_public_ip" "main" {
	name = "${var.prefix}-publicIp"
	location = azurerm_resource_group.main.location
	resource_group_name = azurerm_resource_group.main.name
	allocation_method = "Dynamic"

	tags = {
		displayName: var.taggingPolicy	
	}
}

resource "azurerm_lb" "main" {
	name = "${var.prefix}-lb"
	location = azurerm_resource_group.main.location
	resource_group_name = azurerm_resource_group.main.name

	frontend_ip_configuration {
	name = "${var.prefix}-publicIp"
	public_ip_address_id = azurerm_public_ip.main.id
	}
}

resource "azurerm_lb_backend_address_pool" "main" {
	name = "${var.prefix}-backendAddressPool"
	resource_group_name = azurerm_resource_group.main.name	
	loadbalancer_id = azurerm_lb.main.id
}

resource "azurerm_network_interface_backend_address_pool_association" "main" {
	network_interface_id = azurerm_network_interface.main.id
	ip_configuration_name = "internal"
	backend_address_pool_id = azurerm_lb_backend_address_pool.main.id
}

resource "azurerm_availability_set" "main" {
	name = "${var.prefix}-aSet"
	location = azurerm_resource_group.main.location
	resource_group_name = azurerm_resource_group.main.name

	tags = {
		displayName: var.taggingPolicy	
	}
}

#Create Linux Virtual Machine
resource "azurerm_linux_virtual_machine" "main" {
	count = var.vm_instances
	name = "${var.prefix}-vm"	
	location = azurerm_resource_group.main.location
	resource_group_name = azurerm_resource_group.main.name
	size = "Standard_F2"
	admin_username = "adminuser"
	admin_password = "P@ssw0rd1234!"
	disable_password_authentication = false
	network_interface_ids = [
		azurerm_network_interface.main.id
	]

	  os_disk {
		caching              = "ReadWrite"
		storage_account_type = "Standard_LRS"
	  }

	availability_set_id = azurerm_availability_set.main.id
	source_image_id = var.packerImageId
}

#Create a managed disk for our VMs for extra storage
resource "azurerm_managed_disk" "main" {
	name = "${var.prefix}-md"	
	location = azurerm_resource_group.main.location
	resource_group_name = azurerm_resource_group.main.name
	storage_account_type = "Standard_LRS"
	create_option = "Empty"
	disk_size_gb = "1"

	tags = {
		displayName: var.taggingPolicy	
	}
}


