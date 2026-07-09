
# Frontend IP / Endpoint:new code-azurerm_cdn_frontdoor_endpoint। (ইউজাররা যে ইউআরএল-এ হিট করবে/যেখানে রিকোয়েস্ট আসে)

# Backend Pool:new code-azurerm_cdn_frontdoor_origin_group (যার ভেতরে তোর Prod এবং DR অরিজিন বা সার্ভারগুলো বসে আছে/যেখানে সার্ভারগুলো থাকে)।

# Health Probe: new code-health_probe (যা চেক করে সার্ভারগুলো বেঁচে আছে কিনা)