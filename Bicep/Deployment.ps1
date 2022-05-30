param(
    [string] $TemplatePath
)

[string] $Location = "westeurope"
$today = Get-Date -Format "MM-dd-yyyy"
$deploymentName = "DigitalWorkplaceDeployment_"+"$today"
$Subscription = "MSOffice365"
$ResourceGroupName = "MSOffice365-POC"
$TenantId = $env:OrstedTenantID

[string] $functionAppName = 'ProvisionTest'

bicep build $TemplatePath
$TemplatePath = $TemplatePath.Replace(".bicep",".json")

Connect-AzAccount -Tenant $TenantId -Subscription $Subscription
New-AzResourceGroupDeployment -Name $deploymentName -ResourceGroupName $ResourceGroupName -TemplateFile $TemplatePath 

Remove-Item -Path $TemplatePath -Force


# Function DeployHttpTriggerFunction($ResourceGroupName, $SiteName, $FunctionName, $CodeFile, $TestData)
# {
#     $FileContent = "$(Get-Content -Path $CodeFile -Raw)"

#     $props = @{
#         config = @{
#             bindings = @(
#                 @{
#                     type = "httpTrigger"
#                     direction = "in"
#                     webHookType = ""
#                     name = "req"
#                 }
#                 @{
#                     type = "http"
#                     direction = "out"
#                     name = "res"
#                 }
#             )
#         }
#         files = @{
#             "index.js" = $FileContent
#         }
#         test_data = $TestData
#     }

#     New-AzureRmResource -ResourceGroupName $ResourceGroupName -ResourceType Microsoft.Web/sites/functions -ResourceName $SiteName/$FunctionName -PropertyObject $props -ApiVersion 2015-08-01 -Force
# }

# #=============Defining All Variables=========
# $location = 'Southeast Asia'
# $storageAccount = 'functionsasdnewqq1'
# $appInsightsName = 'appinsightnameprdad' 
# $appServicePlanName = 'functionappplan'
# $tier = 'Premium'


# #========Creating App Service Plan============
# New-AzAppServicePlan -ResourceGroupName $resourceGroupName -Name $appServicePlanName -Location $location -Tier $tier
# $functionAppSettings = @{
#     ServerFarmId="/subscriptions/$subscriptionId/resourceGroups/$resourceGroupName/providers/Microsoft.Web/serverfarms/$appServicePlanName";
#     alwaysOn=$True;
# }

# #========Creating Azure Function========
# $functionAppResource = Get-AzResource | Where-Object { $_.ResourceName -eq $functionAppName -And $_.ResourceType -eq "Microsoft.Web/Sites" }
# if ($functionAppResource -eq $null)
# {
#   New-AzResource -ResourceType 'Microsoft.Web/Sites' -ResourceName $functionAppName -kind 'functionapp' -Location $Location -ResourceGroupName $ResourceGroupName -force
# }

# # #========Retrieving Keys========
# # $keys = Get-AzStorageAccountKey -ResourceGroupName $resourceGroupName -AccountName $storageAccount
# # $accountKey = $keys | Where-Object { $_.KeyName -eq 'Key1' } | Select-Object -ExpandProperty Value
# # $storageAccountConnectionString = 'DefaultEndpointsProtocol=https;AccountName='+$storageAccount+';AccountKey='+$accountKey

# # #========Defining Azure Function Settings========
# # $AppSettings =@{}
# # $AppSettings =@{'APPINSIGHTS_INSTRUMENTATIONKEY' = $appInsightsKey;
# #                 'AzureWebJobsDashboard' = $storageAccountConnectionString;
# #                 'AzureWebJobsStorage' = $storageAccountConnectionString;
# #                 'FUNCTIONS_EXTENSION_VERSION' = '~2';
# #                 'FUNCTIONS_WORKER_RUNTIME' = 'dotnet';
# #                 'WEBSITE_CONTENTAZUREFILECONNECTIONSTRING' = $storageAccountConnectionString;
# #                 'WEBSITE_CONTENTSHARE' = $storageAccount;}
# # Set-AzWebApp -Name $functionAppName -ResourceGroupName $resourceGroupName -AppSettings $AppSettings