{
  "toolCode": "QUERY_OPEN_AP_INVOICE_HOLDS",
  "name": "Query Open AP Invoice Holds",
  "description": "Queries Fusion Payables invoice holds that have not been released, to check for open holds that would block AP period close.",
  "family": "FIN",
  "product": "PAYABLES",
  "type": "EXTERNAL_REST",
  "status": "DRAFT",
  "version": 1,
  "userInputRequiredFlag": false,
  "userInputMessage": "",
  "subType": "",
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
          "description": "Query AP invoice holds that have not been released, to check for open holds that would block AP period close.",
          "name": "getOpenInvoiceHolds",
          "operationType": "GET",
          "parameterDefinitions": [],
          "resourcePath": "/fscmRestApi/resources/11.13.18.05/invoiceHolds?q=ReleaseDate is null",
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
