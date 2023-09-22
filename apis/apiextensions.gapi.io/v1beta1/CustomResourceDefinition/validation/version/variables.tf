variable "file" {
  type = string
}
variable "metadata_name" {
  type = string
}

variable "crd_kind" {
  type = string
}

variable "crd_version" {
  type = object({
    name   = string
    served = bool
    schema = object({
      properties = map(object({
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
        # array related options
        minItems = optional(number)
        maxItems = optional(number)
        items = optional(list(object({
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
        })))
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
      }))
    })
  })
}
