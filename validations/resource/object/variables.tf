variable "file" {
  type = string
}

variable "metadata_name" {
  type = string
}

variable "property_path" {
  type = string
}

variable "property" {
  type = object({
    type         = string
    description  = optional(string)
    externalDocs = optional(string)
    required     = optional(bool, true)
    default      = optional(any)
    # object related options
    properties = optional(map(object({
      type         = string
      description  = optional(string)
      externalDocs = optional(string)
      required     = optional(bool, true)
      default      = optional(any)
      # string related options
      pattern   = optional(string)
      minLength = optional(number)
      maxLength = optional(number)
      # integer related options
      minimum    = optional(number)
      maximum    = optional(number)
      multipleOf = optional(number)
    })))
  })
}

variable "manifest_value" {
  type = any
}
