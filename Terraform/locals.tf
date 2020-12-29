locals {
	nsgrules = {
		toSubnetAllow = {
			name = "toSubnetAllow"
			priority = 100
			direction = "Outbound"
			access = "Allow"
			protocol = "*"
			source_port_range = "*"
			destination_port_range = "*"
			source_address_prefix = "*"
			destination_address_prefix = "VirtualNetwork"			
		}

		fromInternetDeny = {
			name = "fromInternetDeny"
			priority = 101
			direction = "Outbound"
			access = "Allow"
			protocol = "*"
			source_port_range = "*"
			destination_port_range = "*"
			source_address_prefix = "*"
			destination_address_prefix = "*"			
		}		
	}
}