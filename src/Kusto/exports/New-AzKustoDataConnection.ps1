
# ----------------------------------------------------------------------------------
#
# Copyright Microsoft Corporation
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# http://www.apache.org/licenses/LICENSE-2.0
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ----------------------------------------------------------------------------------

<#
.Synopsis
Creates or updates a data connection.
.Description
Creates or updates a data connection.
.Example
PS C:\> New-AzKustoDataConnection -ResourceGroupName "testrg" -ClusterName "testnewkustocluster" -DatabaseName "mykustodatabase" -DataConnectionName "myeventhubdc" -Location="East US" -Kind "EventHub" -EventHubResourceId "/subscriptions/$subscriptionId/resourcegroups/testrg/providers/Microsoft.EventHub/namespaces/myeventhubns/eventhubs/myeventhub" -DataFormat "JSON" -ConsumerGroup '$Default' -Compression "None" -TableName "Events" -MappingRuleName "EventsMapping"

Kind     Location Name                                             Type
----     -------- ----                                             ----
EventHub East US  testnewkustocluster/mykustodatabase/myeventhubdc Microsoft.Kusto/Clusters/Databases/DataConnections
.Example
PS C:\> New-AzKustoDataConnection -ResourceGroupName "testrg" -ClusterName "testnewkustocluster" -DatabaseName "mykustodatabase" -DataConnectionName "myeventgriddc" -Location="East US" -Kind "EventGrid" -EventHubResourceId "/subscriptions/$subscriptionId/resourcegroups/testrg/providers/Microsoft.EventHub/namespaces/myeventhubns/eventhubs/myeventhub" -StorageAccountResourceId $storageAccountResourceId "/subscriptions/$subscriptionId/resourcegroups/testrg/providers/Microsoft.Storage/storageAccounts/mystorage" -DataFormat "JSON" -ConsumerGroup '$Default' -TableName "Events" -MappingRuleName "EventsMapping" -IgnoreFirstRecord "false" -BlobStorageEventType "Microsoft.Storage.BlobRenamed"

Kind      Location Name                                              Type
----      -------- ----                                              ----
EventGrid East US  testnewkustocluster/mykustodatabase/myeventgriddc Microsoft.Kusto/Clusters/Databases/DataConnections
.Example
PS C:\> New-AzKustoDataConnection -ResourceGroupName "testrg" -ClusterName "testnewkustocluster" -DatabaseName "mykustodatabase" -DataConnectionName "myiothubdc" -Location="East US" -Kind "IotHub" -IotHubResourceId "/subscriptions/$subscriptionId/resourcegroups/testrg/providers/Microsoft.Devices/IotHubs/myiothub" -SharedAccessPolicyName "myiothubpolicy" -DataFormat "JSON" -ConsumerGroup '$Default' -TableName "Events" -MappingRuleName "EventsMapping"

Kind      Location Name                                        Type
----      -------- ----                                        ----
IotHub East US  testnewkustocluster/mykustodatabase/myiothubdc Microsoft.Kusto/Clusters/Databases/DataConnections

.Outputs
Microsoft.Azure.PowerShell.Cmdlets.Kusto.Models.Api20200918.IDataConnection
.Link
https://docs.microsoft.com/en-us/powershell/module/az.kusto/new-azkustodataconnection
#>
function New-AzKustoDataConnection {
[OutputType([Microsoft.Azure.PowerShell.Cmdlets.Kusto.Models.Api20200918.IDataConnection])]
[CmdletBinding(DefaultParameterSetName='CreateExpandedEventHub', PositionalBinding=$false, SupportsShouldProcess, ConfirmImpact='Medium')]
param(
    [Parameter(Mandatory)]
    [Microsoft.Azure.PowerShell.Cmdlets.Kusto.Category('Path')]
    [System.String]
    # The name of the Kusto cluster.
    ${ClusterName},

    [Parameter(Mandatory)]
    [Microsoft.Azure.PowerShell.Cmdlets.Kusto.Category('Path')]
    [System.String]
    # The name of the database in the Kusto cluster.
    ${DatabaseName},

    [Parameter(Mandatory)]
    [Alias('DataConnectionName')]
    [Microsoft.Azure.PowerShell.Cmdlets.Kusto.Category('Path')]
    [System.String]
    # The name of the data connection.
    ${Name},

    [Parameter(Mandatory)]
    [Microsoft.Azure.PowerShell.Cmdlets.Kusto.Category('Path')]
    [System.String]
    # The name of the resource group containing the Kusto cluster.
    ${ResourceGroupName},

    [Parameter()]
    [Microsoft.Azure.PowerShell.Cmdlets.Kusto.Category('Path')]
    [Microsoft.Azure.PowerShell.Cmdlets.Kusto.Runtime.DefaultInfo(Script='(Get-AzContext).Subscription.Id')]
    [System.String]
    # Gets subscription credentials which uniquely identify Microsoft Azure subscription.
    # The subscription ID forms part of the URI for every service call.
    ${SubscriptionId},

    [Parameter(Mandatory)]
    [ArgumentCompleter({ param ( $CommandName, $ParameterName, $WordToComplete, $CommandAst, $FakeBoundParameters ) return @('EventHub', 'EventGrid', 'IoTHub') })]
    [Microsoft.Azure.PowerShell.Cmdlets.Kusto.Category('Body')]
    [Microsoft.Azure.PowerShell.Cmdlets.Kusto.Support.Kind]
    # Kind of the endpoint for the data connection
    ${Kind},

    [Parameter(Mandatory)]
    [Microsoft.Azure.PowerShell.Cmdlets.Kusto.Category('Body')]
    [System.String]
    # The event/iot hub consumer group.
    ${ConsumerGroup},

    [Parameter(Mandatory)]
    [Microsoft.Azure.PowerShell.Cmdlets.Kusto.Category('Body')]
    [System.String]
    # Resource location.
    ${Location},

    [Parameter(ParameterSetName='CreateExpandedEventHub', Mandatory)]
    [Parameter(ParameterSetName='CreateExpandedEventGrid', Mandatory)]
    [Microsoft.Azure.PowerShell.Cmdlets.Kusto.Category('Body')]
    [System.String]
    # The resource ID of the event hub to be used to create a data connection / event grid is configured to send events.
    ${EventHubResourceId},

    [Parameter()]
    [Microsoft.Azure.PowerShell.Cmdlets.Kusto.Category('Body')]
    [Microsoft.Azure.PowerShell.Cmdlets.Kusto.Support.EventGridDataFormat]
    # The data format of the message.
    # Optionally the data format can be added to each message.
    ${DataFormat},

    [Parameter(ParameterSetName='CreateExpandedEventHub')]
    [Parameter(ParameterSetName='CreateExpandedIotHub')]
    [Microsoft.Azure.PowerShell.Cmdlets.Kusto.Category('Body')]
    [System.String[]]
    # System properties of the event/iot hub.
    ${EventSystemProperty},

    [Parameter()]
    [Microsoft.Azure.PowerShell.Cmdlets.Kusto.Category('Body')]
    [System.String]
    # The mapping rule to be used to ingest the data.
    # Optionally the mapping information can be added to each message.
    ${MappingRuleName},

    [Parameter()]
    [Microsoft.Azure.PowerShell.Cmdlets.Kusto.Category('Body')]
    [System.String]
    # The table where the data should be ingested.
    # Optionally the table information can be added to each message.
    ${TableName},

    [Parameter(ParameterSetName='CreateExpandedEventHub')]
    [Microsoft.Azure.PowerShell.Cmdlets.Kusto.Category('Body')]
    [Microsoft.Azure.PowerShell.Cmdlets.Kusto.Support.Compression]
    # The event hub messages compression type.
    ${Compression},

    [Parameter(ParameterSetName='CreateExpandedEventGrid', Mandatory)]
    [Microsoft.Azure.PowerShell.Cmdlets.Kusto.Category('Body')]
    [System.String]
    # The resource ID of the storage account where the data resides.
    ${StorageAccountResourceId},

    [Parameter(ParameterSetName='UpdateViaIdentityExpandedEventGrid')]
    [Parameter(ParameterSetName='UpdateExpandedEventGrid')]
    [Microsoft.Azure.PowerShell.Cmdlets.Kusto.Category('Body')]
    [Microsoft.Azure.PowerShell.Cmdlets.Kusto.Support.BlobStorageEventType]
    # The name of blob storage event type to process.
    ${BlobStorageEventType},

    [Parameter(ParameterSetName='UpdateViaIdentityExpandedEventGrid')]
    [Parameter(ParameterSetName='UpdateExpandedEventGrid')]
    [Microsoft.Azure.PowerShell.Cmdlets.Kusto.Category('Body')]
    [System.Management.Automation.SwitchParameter]
    # If set to true, indicates that ingestion should ignore the first record of every file.
    ${IgnoreFirstRecord},

    [Parameter(ParameterSetName='CreateExpandedIotHub', Mandatory)]
    [Microsoft.Azure.PowerShell.Cmdlets.Kusto.Category('Body')]
    [System.String]
    # The resource ID of the Iot hub to be used to create a data connection.
    ${IotHubResourceId},

    [Parameter(ParameterSetName='CreateExpandedIotHub', Mandatory)]
    [Microsoft.Azure.PowerShell.Cmdlets.Kusto.Category('Body')]
    [System.String]
    # The name of the share access policy.
    ${SharedAccessPolicyName},

    [Parameter()]
    [Alias('AzureRMContext', 'AzureCredential')]
    [ValidateNotNull()]
    [Microsoft.Azure.PowerShell.Cmdlets.Kusto.Category('Azure')]
    [System.Management.Automation.PSObject]
    # The credentials, account, tenant, and subscription used for communication with Azure.
    ${DefaultProfile},

    [Parameter()]
    [Microsoft.Azure.PowerShell.Cmdlets.Kusto.Category('Runtime')]
    [System.Management.Automation.SwitchParameter]
    # Run the command as a job
    ${AsJob},

    [Parameter(DontShow)]
    [Microsoft.Azure.PowerShell.Cmdlets.Kusto.Category('Runtime')]
    [System.Management.Automation.SwitchParameter]
    # Wait for .NET debugger to attach
    ${Break},

    [Parameter(DontShow)]
    [ValidateNotNull()]
    [Microsoft.Azure.PowerShell.Cmdlets.Kusto.Category('Runtime')]
    [Microsoft.Azure.PowerShell.Cmdlets.Kusto.Runtime.SendAsyncStep[]]
    # SendAsync Pipeline Steps to be appended to the front of the pipeline
    ${HttpPipelineAppend},

    [Parameter(DontShow)]
    [ValidateNotNull()]
    [Microsoft.Azure.PowerShell.Cmdlets.Kusto.Category('Runtime')]
    [Microsoft.Azure.PowerShell.Cmdlets.Kusto.Runtime.SendAsyncStep[]]
    # SendAsync Pipeline Steps to be prepended to the front of the pipeline
    ${HttpPipelinePrepend},

    [Parameter()]
    [Microsoft.Azure.PowerShell.Cmdlets.Kusto.Category('Runtime')]
    [System.Management.Automation.SwitchParameter]
    # Run the command asynchronously
    ${NoWait},

    [Parameter(DontShow)]
    [Microsoft.Azure.PowerShell.Cmdlets.Kusto.Category('Runtime')]
    [System.Uri]
    # The URI for the proxy server to use
    ${Proxy},

    [Parameter(DontShow)]
    [ValidateNotNull()]
    [Microsoft.Azure.PowerShell.Cmdlets.Kusto.Category('Runtime')]
    [System.Management.Automation.PSCredential]
    # Credentials for a proxy server to use for the remote call
    ${ProxyCredential},

    [Parameter(DontShow)]
    [Microsoft.Azure.PowerShell.Cmdlets.Kusto.Category('Runtime')]
    [System.Management.Automation.SwitchParameter]
    # Use the default credentials for the proxy
    ${ProxyUseDefaultCredentials}
)

begin {
    try {
        $outBuffer = $null
        if ($PSBoundParameters.TryGetValue('OutBuffer', [ref]$outBuffer)) {
            $PSBoundParameters['OutBuffer'] = 1
        }
        $parameterSet = $PSCmdlet.ParameterSetName
        $mapping = @{
            CreateExpandedEventHub = 'Az.Kusto.custom\New-AzKustoDataConnection';
            CreateExpandedEventGrid = 'Az.Kusto.custom\New-AzKustoDataConnection';
            UpdateViaIdentityExpandedEventGrid = 'Az.Kusto.custom\New-AzKustoDataConnection';
            UpdateExpandedEventGrid = 'Az.Kusto.custom\New-AzKustoDataConnection';
            CreateExpandedIotHub = 'Az.Kusto.custom\New-AzKustoDataConnection';
        }
        if (('CreateExpandedEventHub', 'CreateExpandedEventGrid', 'UpdateViaIdentityExpandedEventGrid', 'UpdateExpandedEventGrid', 'CreateExpandedIotHub') -contains $parameterSet -and -not $PSBoundParameters.ContainsKey('SubscriptionId')) {
            $PSBoundParameters['SubscriptionId'] = (Get-AzContext).Subscription.Id
        }
        $wrappedCmd = $ExecutionContext.InvokeCommand.GetCommand(($mapping[$parameterSet]), [System.Management.Automation.CommandTypes]::Cmdlet)
        $scriptCmd = {& $wrappedCmd @PSBoundParameters}
        $steppablePipeline = $scriptCmd.GetSteppablePipeline($MyInvocation.CommandOrigin)
        $steppablePipeline.Begin($PSCmdlet)
    } catch {
        throw
    }
}

process {
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
}

end {
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
}
}
