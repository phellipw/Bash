#!/bin/bash

echo "Backups"
echo "==========================================================================================="
echo "Vault: Coloque o nome do seu VAULT de Backup"
echo ""
echo ""
echo ""
az backup item list -g RESOURCE-GROUP -v NAME-VAULT --query "sort_by([].{nome:properties.friendlyName, Politica:properties.policyName, ResourceGroup:resourceGroup}, &Politica)" -o table
echo ""
echo ""
echo ""
az backup policy list -g RESOURCE-GROUP -v NAME-VAULT --query "[].{Nome:name,
RetencaoBackupSemanal:properties.retentionPolicy.weeklySchedule.retentionDuration.count,
RetencaoBackupDiario:properties.retentionPolicy.dailySchedule.retentionDuration.count,
RetencaoBackupMensal:properties.retentionPolicy.monthlySchedule.retentionDuration.count}" -o table
echo ""
echo ""
echo ""
az backup job list -g RESOURCE-GROUP -v NAME-VAULT --query "sort_by([].{Nome:properties.entityFriendlyName, Status:properties.status, Data:properties.startTime, id:name}, &Status)" -o tsv | awk  '
{
sub(/T/," ",$3);
gsub("Failed", "\033[1;31m&\033[0m");
gsub("Completed", "\033[1;32m&\033[0m"); 
printf "%-24s %-20s %20s %50s \n",$1,$2,$3,$5}
' 

