variable "prefix" {
    description = "The prefix to be used for all resources"
}

variable "location" {
    description = "The location to be used for all resources"
    default = "East US"
}

variable "vm_instances" {
    description = "The number of Virtual Machines to create."
    type = number
    default = 2
}

variable "packerImageId" {
	default = "/subscriptions/f5649517-0de7-4647-98bc-8ee75af010a5/resourceGroups/web-server-project1-rg/providers/Microsoft.Compute/images/ubuntuImageProject1"
}

variable "tagging-policy" {
	description = "Tag for all resources"
	default = "tagging-policy"
}

variable "servers"{
  type = list
  default = ["1","2"]
}