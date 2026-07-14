
# Frontend IP / Endpoint:new code-#azurerm_cdn_frontdoor_endpoint (ইউজাররা যে ইউআরএল-এ হিট করবে/যেখানে রিকোয়েস্ট আসে)

# Backend Pool:new code-#azurerm_cdn_frontdoor_origin_group (যার ভেতরে তোর Prod এবং DR অরিজিন বা সার্ভারগুলো বসে আছে/যেখানে সার্ভারগুলো থাকে)।

# Health Probe: new code-#health_probe (যা চেক করে সার্ভারগুলো বেঁচে আছে কিনা)

#This is profile or virtual folder of front door
#cdn-azure Content Delivery Network
resource "azurerm_cdn_frontdoor_profile" "afd_profile" { 
  name                = "madhav-frontdoor-profile"
  resource_group_name = "rg-dev-02"
  sku_name            = "Standard_AzureFrontDoor" #or "Premium_AzureFrontDoor" for premium features
}
#Like Front ip in Azure load balancer in normal load balncer have basic ip
#but azure frontdoor is http/htts l-7 load balancer so microsoft give url-madhav-app-endpoint
#whre user will hit
resource "azurerm_cdn_frontdoor_endpoint" "afd_endpoint" {
  name                     = "madhav-app-endpoint"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.afd_profile.id
}
#In clasic code we called backend pool
#In Standard/Premium/v4.0+) we called origin_group
resource "azurerm_cdn_frontdoor_origin_group" "afd_origin_group" {
  name                     = "og-failover-group"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.afd_profile.id

 #/ its means root directory front door every 30 second he will hit website/server for helth check
 #ঘড়ি ধরে প্রতি ৩০ সেকেন্ড পর পর সে Prod এবং DR দুটো সার্ভারকেই নক করবে।
 #he direct not download the server check only the header if server given the response Http 200 ok 
 #then front door unser stood that server is healthy
  health_probe {
    path                = "/" #root directory
    protocol            = "Https"
    interval_in_seconds = 30
    request_type        = "HEAD" #header
  }

  load_balancing {
    additional_latency_in_milliseconds = 50
    sample_size                        = 4 #total 4 helth report
    successful_samples_required        = 3 #minimus 3 helth report should be pass_(HTTP 200 OK)
  }
}
resource "azurerm_cdn_frontdoor_origin" "primary_origin" {
  name                           = "origin-primary-prod"
  cdn_frontdoor_origin_group_id  = azurerm_cdn_frontdoor_origin_group.afd_origin_group.id
  enabled                        = true
  
  # তোর মেইন অ্যাপ বা গেটওয়ের আসল URL এখানে বসবে
  host_name                      = "vnt-dev-02-app.azurewebsites.net"
  origin_host_header             = "vnt-dev-02-app.azurewebsites.net"
  
  priority                       = 1 # সব ট্রাফিক প্রথমে এখানে যাবে
  weight                         = 1000
}

# ৫. তোর ক্লাসিক "backend_pool" এর ব্যাকআপ মেম্বার (DR)
resource "azurerm_cdn_frontdoor_origin" "dr_origin" {
  name                           = "origin-secondary-dr"
  cdn_frontdoor_origin_group_id  = azurerm_cdn_frontdoor_origin_group.afd_origin_group.id
  enabled                        = true
  
  # তোর DR অ্যাপ বা গেটওয়ের আসল URL এখানে বসবে
  host_name                      = "vnt-dr-02-app.azurewebsites.net"
  origin_host_header             = "vnt-dr-02-app.azurewebsites.net"
  
  priority                       = 2 # ১ নম্বর ফেইল করলে তবেই ট্রাফিক এখানে আসবে
  weight                         = 1000
}
# ৬. তোর ক্লাসিক "routing_rule" এখন এই রুট রিসোর্স
resource "azurerm_cdn_frontdoor_route" "afd_route" {
  name                          = "default-route"
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.afd_endpoint.id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.afd_origin_group.id
  cdn_frontdoor_origin_ids      = [azurerm_cdn_frontdoor_origin.primary_origin.id, azurerm_cdn_frontdoor_origin.dr_origin.id]

  supported_protocols    = ["Http", "Https"]
  patterns_to_match      = ["/*"]
  forwarding_protocol    = "MatchRequest"
  link_to_default_domain = true
}