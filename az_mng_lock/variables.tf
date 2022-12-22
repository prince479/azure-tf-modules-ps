variable "az_manage_locks" {
  type = map(object({
    #Name is the key

    #Changing this forces a new resource to be created.
    scope = string

    #Possible values are CanNotDelete and ReadOnly. Changing this forces a new resource to be created.
    lock_level = string

    notes = optional(string)
  }))
  default = {}
}
