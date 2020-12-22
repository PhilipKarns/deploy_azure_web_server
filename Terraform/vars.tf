variable "prefix" {
    description = "The prefix to be used for all resources"
}

variable "location" {
    description = "The location to be used for all resources"
    default = "East US"
}

variable "vm_instances" {
    descirption = "The number of Virtual Machines to create."
    type = number
    default = 1
}