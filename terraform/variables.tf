variable "access_key" {
	default = "access_key-here"
}

variable "secret_key" {
	default = "secret_key"
}

variable "region" {
  default = "eu-central-1"
}

variable "public_key_path" {
  description = "Public key path"
  default = "~/.ssh/id_rsa.pub"
}

