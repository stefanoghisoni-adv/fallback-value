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
  "securityGroups": [],
  "displayName": "Fallback value",
  "categories": ["UTILITY"],
  "description": "Smart number fallback variable that returns the first valid numeric value from primary or fallback list—ensuring reliable numeric data without conversion errors.",
  "containerContexts": [
    "SERVER"
  ],
  "metadata": {
    "author": {
      "name": "stefano-ghisoni",
      "url": "https://stefanoghisoni.it",
      "email": "info@stefanoghisoni.it"
    }
  }
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "TEXT",
    "name": "primary_value",
    "displayName": "Primary value",
    "simpleValueType": true,
    "help": "Enter the primary value or select a variable to evaluate first."
  },
  {
    "type": "SIMPLE_TABLE",
    "name": "alt_value",
    "displayName": "Fallback values",
    "simpleTableColumns": [
      {
        "defaultValue": "",
        "displayName": "Value",
        "name": "column1",
        "type": "TEXT"
      }
    ]
  }
]


___SANDBOXED_JS_FOR_SERVER___

var primaryValue = data.primary_value;
var altValues = data.alt_value || [];

function isInvalid(v) {
  if (v === null || v === undefined || v === false) return true;

  if (typeof v === "number") {
    return v !== v;
  }

  if (typeof v === "string") {
    return v.trim() === "";
  }

  return true;
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

scenarios:
- name: Returns primary value when valid
  code: |-
    const mockData = {
      primary_value: 42,
      alt_value: [
        { column1: 10 },
        { column1: 20 }
      ]
    };

    const variableResult = runCode(mockData);

    assertThat(variableResult).isEqualTo(42);
- name: Returns 0 when primary value is 0
  code: |-
    const mockData = {
      primary_value: 0,
      alt_value: [
        { column1: 99 }
      ]
    };

    const variableResult = runCode(mockData);

    assertThat(variableResult).isEqualTo(0);
- name: Falls back to first valid table value when primary is null
  code: |-
    const mockData = {
      primary_value: null,
      alt_value: [
        { column1: null },
        { column1: 150 },
        { column1: 300 }
      ]
    };

    const variableResult = runCode(mockData);

    assertThat(variableResult).isEqualTo(150);
- name: Ignores empty strings, spaces, and false in fallbacks
  code: |-
    const mockData = {
      primary_value: undefined,
      alt_value: [
        { column1: '' },
        { column1: '   ' },
        { column1: false },
        { column1: 85 }
      ]
    };

    const variableResult = runCode(mockData);

    assertThat(variableResult).isEqualTo(85);
- name: Returns null when all inputs are invalid
  code: |-
    const mockData = {
      primary_value: null,
      alt_value: [
        { column1: null },
        { column1: '' },
        { column1: false }
      ]
    };

    const variableResult = runCode(mockData);

    assertThat(variableResult).isNull();
- name: Returns null when fallback list is empty and primary is missing
  code: |-
    const mockData = {
      primary_value: undefined,
      alt_value: []
    };

    const variableResult = runCode(mockData);

    assertThat(variableResult).isNull();


___NOTES___

Created on 09/02/2026, 12:08:21
