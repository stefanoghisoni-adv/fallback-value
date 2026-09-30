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
  "description": "Server-side fallback and sanitization variable that preserves native types, skips invalid values, and can optionally reject Stape's ZZ geographic placeholder.",
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
    "type": "TEXT",
    "name": "primary_value",
    "displayName": "Primary value",
    "simpleValueType": true,
    "help": "Enter the primary value or select a variable to evaluate first."
  },
  {
    "type": "CHECKBOX",
    "name": "stape_country_code",
    "checkboxText": "This variable is using Stape code (as country, zipcode, city and state)",
    "simpleValueType": true,
    "defaultValue": false
  },
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
var altValues = data.alt_value || [];
var rejectStapeZZ = data.stape_country_code === true;

function isInvalid(v) {
  // Valori assenti o non validi
  if (v === null || v === undefined || v === false) {
    return true;
  }

  // Numeri: esclude valori numerici non validi, mantiene valido 0
  if (typeof v === "number") {
    return v !== v;
  }

  // Stringhe: esclude vuote e solo spazi
  if (typeof v === "string") {
    var trimmed = v.trim();

    if (trimmed === "") {
      return true;
    }

    // Se abilitato, rigetta il placeholder Stape "ZZ"
    if (rejectStapeZZ && trimmed === "ZZ") {
      return true;
    }

    return false;
  }

  // Esclude oggetti, funzioni, boolean true e altri tipi
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

return undefined;


___TESTS___

scenarios:
- name: Returns primary value when valid
  code: |-
    const mockData = {
      primary_value: 42,
      stape_country_code: false,
      alt_value: [
        { column1: 10 },
        { column1: 20 }
      ]
    };

    const variableResult = runCode(mockData);

    assertThat(variableResult).isEqualTo(42);

- name: Preserves numeric zero as valid primary value
  code: |-
    const mockData = {
      primary_value: 0,
      stape_country_code: false,
      alt_value: [
        { column1: 99 }
      ]
    };

    const variableResult = runCode(mockData);

    assertThat(variableResult).isEqualTo(0);

- name: Falls back when primary value is null
  code: |-
    const mockData = {
      primary_value: null,
      stape_country_code: false,
      alt_value: [
        { column1: null },
        { column1: 150 },
        { column1: 300 }
      ]
    };

    const variableResult = runCode(mockData);

    assertThat(variableResult).isEqualTo(150);

- name: Falls back when primary value is undefined
  code: |-
    const mockData = {
      primary_value: undefined,
      stape_country_code: false,
      alt_value: [
        { column1: 50 },
        { column1: 100 }
      ]
    };

    const variableResult = runCode(mockData);

    assertThat(variableResult).isEqualTo(50);

- name: Rejects false and returns next valid fallback
  code: |-
    const mockData = {
      primary_value: false,
      stape_country_code: false,
      alt_value: [
        { column1: false },
        { column1: 25 }
      ]
    };

    const variableResult = runCode(mockData);

    assertThat(variableResult).isEqualTo(25);

- name: Rejects invalid numeric value and preserves zero fallback
  code: |-
    const mockData = {
      primary_value: 0 / 0,
      stape_country_code: false,
      alt_value: [
        { column1: 0 / 0 },
        { column1: 0 },
        { column1: 99 }
      ]
    };

    const variableResult = runCode(mockData);

    assertThat(variableResult).isEqualTo(0);

- name: Rejects empty and whitespace-only strings
  code: |-
    const mockData = {
      primary_value: '',
      stape_country_code: false,
      alt_value: [
        { column1: '   ' },
        { column1: '' },
        { column1: 'EUR' }
      ]
    };

    const variableResult = runCode(mockData);

    assertThat(variableResult).isEqualTo('EUR');

- name: Accepts ZZ when Stape option is disabled
  code: |-
    const mockData = {
      primary_value: 'ZZ',
      stape_country_code: false,
      alt_value: [
        { column1: 'IT' },
        { column1: 'DE' }
      ]
    };

    const variableResult = runCode(mockData);

    assertThat(variableResult).isEqualTo('ZZ');

- name: Rejects ZZ when Stape option is enabled
  code: |-
    const mockData = {
      primary_value: 'ZZ',
      stape_country_code: true,
      alt_value: [
        { column1: 'IT' },
        { column1: 'DE' }
      ]
    };

    const variableResult = runCode(mockData);

    assertThat(variableResult).isEqualTo('IT');

- name: Rejects ZZ with surrounding spaces when Stape option is enabled
  code: |-
    const mockData = {
      primary_value: ' ZZ ',
      stape_country_code: true,
      alt_value: [
        { column1: 'Liguria' },
        { column1: 'IT' }
      ]
    };

    const variableResult = runCode(mockData);

    assertThat(variableResult).isEqualTo('Liguria');

- name: Accepts ZZ with surrounding spaces when Stape option is disabled
  code: |-
    const mockData = {
      primary_value: ' ZZ ',
      stape_country_code: false,
      alt_value: [
        { column1: 'IT' }
      ]
    };

    const variableResult = runCode(mockData);

    assertThat(variableResult).isEqualTo(' ZZ ');

- name: Rejects ZZ inside fallback values when Stape option is enabled
  code: |-
    const mockData = {
      primary_value: null,
      stape_country_code: true,
      alt_value: [
        { column1: 'ZZ' },
        { column1: ' ZZ ' },
        { column1: 'IT' }
      ]
    };

    const variableResult = runCode(mockData);

    assertThat(variableResult).isEqualTo('IT');

- name: Accepts ZZ inside fallback values when Stape option is disabled
  code: |-
    const mockData = {
      primary_value: null,
      stape_country_code: false,
      alt_value: [
        { column1: 'ZZ' },
        { column1: 'IT' }
      ]
    };

    const variableResult = runCode(mockData);

    assertThat(variableResult).isEqualTo('ZZ');

- name: Returns undefined when all values are invalid
  code: |-
    const mockData = {
      primary_value: null,
      stape_country_code: false,
      alt_value: [
        { column1: null },
        { column1: undefined },
        { column1: false },
        { column1: '' },
        { column1: '   ' }
      ]
    };

    const variableResult = runCode(mockData);

    assertThat(variableResult).isUndefined();

- name: Returns undefined when all values are ZZ and Stape option is enabled
  code: |-
    const mockData = {
      primary_value: 'ZZ',
      stape_country_code: true,
      alt_value: [
        { column1: 'ZZ' },
        { column1: ' ZZ ' }
      ]
    };

    const variableResult = runCode(mockData);

    assertThat(variableResult).isUndefined();

- name: Returns ZZ when Stape option is disabled
  code: |-
    const mockData = {
      primary_value: 'ZZ',
      stape_country_code: false,
      alt_value: [
        { column1: 'IT' }
      ]
    };

    const variableResult = runCode(mockData);

    assertThat(variableResult).isEqualTo('ZZ');

- name: Preserves numeric fallback type
  code: |-
    const mockData = {
      primary_value: null,
      stape_country_code: false,
      alt_value: [
        { column1: 49.9 }
      ]
    };

    const variableResult = runCode(mockData);

    assertThat(variableResult).isEqualTo(49.9);

- name: Preserves string fallback type
  code: |-
    const mockData = {
      primary_value: null,
      stape_country_code: false,
      alt_value: [
        { column1: '49.9' }
      ]
    };

    const variableResult = runCode(mockData);

    assertThat(variableResult).isEqualTo('49.9');

- name: Rejects boolean true
  code: |-
    const mockData = {
      primary_value: true,
      stape_country_code: false,
      alt_value: [
        { column1: 'valid-value' }
      ]
    };

    const variableResult = runCode(mockData);

    assertThat(variableResult).isEqualTo('valid-value');

- name: Rejects object values
  code: |-
    const mockData = {
      primary_value: {
        country: 'IT'
      },
      stape_country_code: false,
      alt_value: [
        { column1: 'IT' }
      ]
    };

    const variableResult = runCode(mockData);

    assertThat(variableResult).isEqualTo('IT');


___NOTES___

Created on 09/03/2026, 22:56:55


