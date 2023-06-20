<#
.SYNOPSIS
    Example Script for restricting Navigation Properties using the 
    ODataAuthorization library.
.DESCRIPTION
    This script obtains a valid token and proceeds to perform requests to
    the API.
.NOTES
    File Name      : ODataQueries.ps1
    Author         : Philipp Wagner
    Prerequisite   : PowerShell
    Copyright 2023 - MIT License
#>

# Perform /Auth/login to obtain the JWT with Requested Scopes
$authRequestBody = @{
    Email = "admin@admin.com"
    Password = "123456"
    RequestedScopes = "Products.Read Products.ReadByKey"
}

$authRequestParameters = @{
    Method = "POST"
    Uri = "http://localhost:5124/Auth/login"
    Body = ($authRequestBody | ConvertTo-Json) 
    ContentType = "application/json"
}

# Invoke the Rest API
$authRequestResponse = Invoke-RestMethod @authRequestParameters

# Extract JWT from the JSON Response 
$authToken = $authRequestResponse.token

# The Auth Header needs to be sent for any additional OData request
$authHeader = @{
    Authorization = "Bearer $authToken"
}

# OData Query 1: All Products
$allProductsResponse = Invoke-RestMethod -Uri "http://localhost:5124/odata/Products" -Headers $authHeader 

Write-Host "===================================================================================="
Write-Host "OData Query #1: http://localhost:5124/odata/Products"
Write-Host $allProductsResponse.value | ConvertTo-Json
Write-Host " "
Write-Host "===================================================================================="
Write-Host " "
Write-Host "===================================================================================="
Write-Host "OData Query #2: http://localhost:5124/odata/Products(`$expand=Address)"
try {
    # OData Query 1: All Products
    $customersWithAddressResponse = Invoke-RestMethod -Uri "http://localhost:5124/odata/Products?`$expand=Address" -Headers $authHeader 
} catch {
    Write-Host "Request failed with StatusCode:" $_.Exception.Response.StatusCode.value__ 
}
Write-Host "===================================================================================="
Write-Host " "

# Perform /Auth/login with additional Products.ReadAddress Scope
$authRequestBody = @{
    Email = "admin@admin.com"
    Password = "123456"
    RequestedScopes = "Products.Read Products.ReadByKey Products.ReadAddress"
}

$authRequestParameters = @{
    Method = "POST"
    Uri = "http://localhost:5124/Auth/login"
    Body = ($authRequestBody | ConvertTo-Json) 
    ContentType = "application/json"
}

# Invoke the Rest API
$authRequestResponse = Invoke-RestMethod @authRequestParameters

# Extract JWT from the JSON Response 
$authToken = $authRequestResponse.token

# The Auth Header needs to be sent for any additional OData request
$authHeader = @{
    Authorization = "Bearer $authToken"
}

Write-Host "===================================================================================="
Write-Host "OData Query #3: http://localhost:5124/odata/Products(`$expand=Address)"
$customersWithAddressResponse = Invoke-RestMethod -Uri "http://localhost:5124/odata/Products?`$expand=Address" -Headers $authHeader 
Write-Host $customersWithAddressResponse.value | ConvertTo-Json
Write-Host "===================================================================================="
Write-Host " "