﻿// ----------------------------------------------------------------------------------
//
// Copyright Microsoft Corporation
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// http://www.apache.org/licenses/LICENSE-2.0
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// ----------------------------------------------------------------------------------

using System;
using System.Management.Automation;
using Microsoft.Azure.Commands.ManagementPartner.Properties;
using Microsoft.Azure.Management.ManagementPartner;

namespace Microsoft.Azure.Commands.ManagementPartner
{
    [Cmdlet(VerbsCommon.Get, "AzureRmManagementPartner"), OutputType(typeof(PSManagementPartner))]
    public class GetManagementPartner : AzureManagementPartnerCmdletsBase
    {
        [Parameter(Position = 0, Mandatory = false)]
        public string PartnerId { get; set; }

        public override void ExecuteCmdlet()
        {
            PartnerId = PartnerId ?? string.Empty;
            try
            {
                var response = new PSManagementPartner(AceProvisioningManagementPartnerApiClient.Partner.GetAsync(PartnerId).Result);
                WriteObject(response);
            }
            catch (AggregateException ex)
            {
                foreach (var innerEx in ex.InnerExceptions)
                {
                    if (innerEx.Message.Contains("invalid status code \'NotFound\'"))
                    {
                        WriteObject(Resources.NotFoundManagementParnterMessage);
                        return;
                    }
                }

                LogException(ex);
            }
        }
    }
}
