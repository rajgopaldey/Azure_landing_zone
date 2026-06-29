variable "rg_name" {
    type = string     #if type not availableTerraform any type ধরে।
}
variable "rg_location" {
    type = string
}
variable "rg_tags" {
    type = map(string)
}



#map → key Value pair।
# rg_tags = {
#   Environment = "Dev"
#   Owner       = "Rajgopal"
#   Project     = "LandingZone"
# }

# Key	           Value
# Environment	    Dev
# Owner	       Rajgopal
# Project        LandingZone