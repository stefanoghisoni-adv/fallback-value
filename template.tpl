___TERMS_OF_SERVICE___

By creating or modifying this file you agree to Google Tag Manager's Community
Template Gallery Developer Terms of Service available at
https://developers.google.com/tag-manager/gallery-tos (or such other URL as
Google may provide), as modified from time to time.


___INFO___

{
  "type": "MACRO",
  "id": "cvt_temp_public_id",
  "version": 1,
  "categories": ["UTILITIES"],
  "securityGroups": [],
  "displayName": "Fallback Value",
  "description": "Smart number fallback variable that returns the first valid numeric value from primary or fallback list—ensuring reliable numeric data without conversion errors.",

  "metadata": {
    "author": {
      "name": "stefano-ghisoni",
      "url": "https://stefanoghisoni.it",
      "email": "info@stefanoghisoni.it"
    }
  },

  "containerContexts": [
    "SERVER"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "SIMPLE_TABLE",
    "name": "alt_value",
    "displayName": "",
    "simpleTableColumns": [
      {
        "defaultValue": "",
        "displayName": "Fallback values",
        "name": "column1",
        "type": "TEXT"
      }
    ]
  }
]


___SANDBOXED_JS_FOR_SERVER___

var primaryValue = data.primary_value;
var altValues = (data.alt_value && data.alt_value) || [];

function isInvalid(v) {
  if (v === null || v === undefined || v === false) return true;
  if (typeof v !== "number") return true;
  // Controllo manuale NaN:
  if (v !== v) return true;
  return false;
}

if (!isInvalid(primaryValue)) {
  return primaryValue;
}

for (var i = 0; i < altValues.length; i++) {
  var val = altValues[i].column1;
  if (!isInvalid(val)) {
    return val;
  }
}

return null;


___TESTS___

scenarios: []


___NOTES___

Created on 07/12/2025, 22:37:38


