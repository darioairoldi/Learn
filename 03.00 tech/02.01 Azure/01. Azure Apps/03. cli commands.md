
az login -t b92a0fb8-931a-44be-85ba-09c887a3ad01
az account set --subscription "Contoso Subscription"


az webapp show --resource-group diginsighttools-testmc-rg-itn-01 --name diginsighttools-testmc-job-itn-01
az webapp show --resource-group diginsighttools-testmc-rg-itn-01 --name diginsighttools-testmc-job-itn-01 --query outboundIpAddresses --output tsv


az webapp list-runtimes --os-type linux
az webapp list-runtimes --os-type  windows


az webapp up --name diginsighttools-testmc-job-itn-01 --resource-group diginsighttools-testmc-rg-itn-01 --runtime "dotnet:8" --location "italynorth"

az webapp config appsettings set --resource-group diginsighttools-testmc-rg-itn-01 --name diginsighttools-testmc-job-itn-01 --settings key1=value1 key2=value2