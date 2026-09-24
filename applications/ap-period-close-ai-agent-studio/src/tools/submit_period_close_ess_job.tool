{
  "toolId": "300000210695577",
  "$context": {
    "etag": "1"
  },
  "createdBy": "bolnu@deloitte.com",
  "toolCreatedDate": "2026-09-23",
  "toolCode": "SUBMIT_PERIOD_CLOSE_ESS_JOB",
  "name": "Submit Period Close ESS Job",
  "description": "Submits an ESS job request to open a period, close a period, or run Create Accounting, for GL or AP.",
  "family": "FIN",
  "product": "FINANCIAL_COMMON",
  "type": "EXTERNAL_REST",
  "status": "PUBLISHED",
  "version": 1,
  "userInputRequiredFlag": false,
  "userInputMessage": "",
  "subType": "",
  "namespace": "FIN.FINANCIAL_COMMON",
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
          "description": "Submits an ESS job request to open a period, close a period, or run Create Accounting for GL or AP, parameterized by job package/definition and a comma-separated ESS parameter string (module, ledger, period, and for Create Accounting the Subledger Application).",
          "name": "submitEssJob",
          "operationType": "POST",
          "parameterDefinitions": [
            {
              "dataType": "String",
              "description": "",
              "name": "jobPackageName",
              "isToken": true,
              "location": "body",
              "required": true,
              "requiredLocked": true,
              "source": "placeholder"
            },
            {
              "dataType": "String",
              "description": "",
              "name": "jobDefName",
              "isToken": true,
              "location": "body",
              "required": true,
              "requiredLocked": true,
              "source": "placeholder"
            },
            {
              "dataType": "String",
              "description": "",
              "name": "essParams",
              "isToken": true,
              "location": "body",
              "required": true,
              "requiredLocked": true,
              "source": "placeholder"
            }
          ],
          "resourcePath": "/fscmRestApi/resources/11.13.18.05/erpintegrations",
          "bodyTemplate": "{\"OperationName\":\"submitESSJobRequest\",\"JobPackageName\":\"{jobPackageName}\",\"JobDefName\":\"{jobDefName}\",\"ESSParameters\":\"{essParams}\"}",
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
