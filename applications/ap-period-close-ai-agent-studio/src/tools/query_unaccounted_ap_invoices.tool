{
  "toolId": "300000210695238",
  "$context": {
    "etag": "1"
  },
  "createdBy": "bolnu@deloitte.com",
  "toolCreatedDate": "2026-09-23",
  "toolCode": "QUERY_UNACCOUNTED_AP_INVOICES",
  "name": "Query Unaccounted AP Invoices",
  "description": "Queries Fusion Payables invoices with Unaccounted accounting status in a given date range, to check for invoices that would block AP period close.",
  "family": "FIN",
  "product": "PAYABLES",
  "type": "EXTERNAL_REST",
  "status": "PUBLISHED",
  "version": 1,
  "userInputRequiredFlag": false,
  "userInputMessage": "",
  "subType": "",
  "namespace": "FIN.PAYABLES",
  "specification": {
    "customFlag": false,
    "jsonSchemaName": "Tool.spec",
    "jsonSchemaVersion": "1",
    "businessObjectMetadata": {
      "functions": []
    },
    "externalRestMetadata": {
      "endpoints": [
        {
          "description": "Query AP invoices with Unaccounted accounting status within a given accounting date range, to check for invoices that would block AP period close.",
          "name": "getUnaccountedInvoices",
          "operationType": "GET",
          "parameterDefinitions": [
            {
              "dataType": "String",
              "description": "",
              "name": "startDate",
              "isToken": true,
              "location": "query",
              "required": true,
              "requiredLocked": true,
              "source": "placeholder"
            },
            {
              "dataType": "String",
              "description": "",
              "name": "endDate",
              "isToken": true,
              "location": "query",
              "required": true,
              "requiredLocked": true,
              "source": "placeholder"
            }
          ],
          "resourcePath": "/fscmRestApi/resources/11.13.18.05/invoices?q=AccountingStatus=Unaccounted;AccountingDate>={startDate};AccountingDate<={endDate}",
          "bodyTemplate": "",
          "resourceType": "REST",
          "sampleQueries": [],
          "headers": []
        }
      ],
      "instanceURL": "https://eiiv-dev10.fa.us6.oraclecloud.com",
      "extensionId": "",
      "serviceConnectionId": "",
      "authInfo": {
        "type": "none"
      }
    },
    "mcpConfig": {
      "credentialId": "",
      "credentialType": "none",
      "instanceURL": "",
      "tools": [],
      "type": "sse"
    },
    "kmConnectorConfig": {
      "connectorReferenceKey": "",
      "externalDocId": "",
      "externalDocVersionId": "",
      "type": "",
      "filters": [],
      "tools": []
    },
    "ragDocumentMetadata": {
      "authorization": {},
      "content": {},
      "contentArray": []
    },
    "sourceObjectCode": "",
    "uiInput": {
      "responseSpec": "",
      "uiPatternSpec": "",
      "uiPatternType": "",
      "userInputType": ""
    }
  },
  "restTool": [],
  "deepLinkTool": [],
  "retrievalDocuments": [],
  "messageDeliveryOptions": []
}
