By using or modifying this template, you agree to the  
Google Tag Manager Community Template Gallery Developer Terms of Service:  
https://developers.google.com/tag-manager/gallery-tos

# Fallback Value – GTM Server Variable

**Fallback Value** is a Server-Side Google Tag Manager variable that returns the first usable value from a primary input or an ordered list of fallback values.

Unlike a basic fallback or coalesce mechanism, the variable also performs built-in value validation before returning a result. It preserves the original value type, rejects invalid or empty values, and can optionally reject Stape's `ZZ` geographic placeholder when working with Stape geographic data.

---

## What This Variable Does

The **Fallback Value** variable:

- Evaluates a primary value first
- Evaluates fallback values in order when the primary value is invalid
- Returns the first valid value found
- Preserves the original value type
- Keeps numeric `0` as a valid value
- Rejects `null`
- Rejects `undefined`
- Rejects boolean values
- Rejects `NaN`
- Rejects empty strings
- Rejects whitespace-only strings
- Rejects objects, functions, and unsupported data types
- Can optionally reject Stape's uppercase `ZZ` geographic placeholder
- Returns `undefined` when no valid value is available

This makes the variable useful not only for fallback logic, but also for sanitizing server-side values before they are passed to downstream analytics, advertising, or API tags.

---

## Validation Rules

The following validation rules are always applied:

| Value | Result |
|---|---|
| `null` | Ignored |
| `undefined` | Ignored |
| `false` | Ignored |
| `true` | Ignored |
| `NaN` | Ignored |
| `""` | Ignored |
| `"   "` | Ignored |
| Object | Ignored |
| Function | Ignored |
| `0` | Valid |
| Valid number | Valid |
| Valid string | Valid |

The handling of `ZZ` depends on the **Stape code** option.

| Value | Stape option disabled | Stape option enabled |
|---|---|---|
| `"ZZ"` | Valid | Ignored |
| `" ZZ "` | Valid | Ignored |
| `"IT"` | Valid | Valid |
| `"Lombardia"` | Valid | Valid |
| `0` | Valid | Valid |

The check is applied after trimming leading and trailing whitespace.

Only the uppercase value `ZZ` is specifically treated as the Stape placeholder.

---

## Stape Geographic Code Handling

The template includes the optional checkbox:

**This variable is using Stape code (as country, zipcode, city and state)**

Internally, this option is represented by:

`stape_country_code`

The checkbox is disabled by default.

### Checkbox disabled

When the option is not selected, `ZZ` is treated like any other non-empty string.

Example:

**Primary value**

`ZZ`

**Fallback values**

1. `IT`
2. `DE`

**Output**

`ZZ`

---

### Checkbox enabled

When the option is selected, the exact uppercase value `ZZ` is treated as invalid.

The template then continues evaluating the configured fallback values.

Example:

**Primary value**

`ZZ`

**Fallback values**

1. `IT`
2. `DE`

**Output**

`IT`

The same behavior applies if the value contains surrounding whitespace:

`" ZZ "`

After trimming, the value becomes `ZZ` and is rejected.

---

## Why Stape `ZZ` Handling Is Optional

In server-side tracking environments, the value `ZZ` can be used as a geographic placeholder when information such as country, region, city, or other location-related data cannot be resolved.

However, `ZZ` may also be a legitimate string in contexts unrelated to Stape geographic data.

For this reason, Fallback Value does not reject `ZZ` globally.

Instead, the behavior is explicitly enabled only when the variable is being used with Stape geographic values.

This prevents provider-specific sanitization rules from being applied to unrelated data.

---

## Examples

| Primary Value | Fallback Values | Stape Option | Output |
|---|---|---|---|
| `42` | `[10, 20, 30]` | Off | `42` |
| `NaN` | `[null, 0, 99]` | Off | `0` |
| `null` | `["", "EUR", "USD"]` | Off | `"EUR"` |
| `"   "` | `[false, 25]` | Off | `25` |
| `"ZZ"` | `["IT", "DE"]` | Off | `"ZZ"` |
| `"ZZ"` | `["IT", "DE"]` | On | `"IT"` |
| `" ZZ "` | `["Liguria", "IT"]` | On | `"Liguria"` |
| `null` | `[null, false, undefined]` | Off | `undefined` |

---

## Use Cases

This variable is useful in **Server-Side Google Tag Manager** environments where the same logical value may come from multiple possible sources and some of those sources may return invalid, empty, or provider-specific placeholder data.

Common use cases include:

- Falling back between Event Data, request headers, cookies, or custom variables
- Selecting the first available country, region, city, or ZIP code
- Handling Stape geographic values that may resolve to `ZZ`
- Prioritizing ecommerce values from multiple data sources
- Falling back between different revenue or order value fields
- Handling incomplete or inconsistent client data
- Handling incomplete data received from APIs
- Preventing empty values from being passed to downstream tags
- Preventing invalid numeric values such as `NaN` from being propagated
- Preserving numeric `0` as a valid value
- Preserving the original data type of the selected value

---

## How It Works

The template exposes a primary value, an optional Stape-specific validation setting, and an ordered list of fallback values.

### Primary value

`primary_value`

The primary value is evaluated first.

It can contain:

- A Google Tag Manager variable
- A static string
- A numeric value

If the primary value is valid, it is immediately returned.

If the primary value is invalid, the template starts evaluating the configured fallback values.

---

### Stape code

`stape_country_code`

Optional checkbox used to enable special handling for Stape geographic placeholder values.

When disabled:

`ZZ` → valid

When enabled:

`ZZ` → invalid

The checkbox affects both the primary value and every configured fallback value.

---

### Fallback values

`alt_value`

An ordered list of alternative values.

If the primary value is invalid, each fallback value is evaluated sequentially from top to bottom.

The first valid fallback is returned.

If every configured value is invalid, the output is:

`undefined`

---

## Evaluation Flow

The template evaluates values in the following order:

1. Evaluate the primary value
2. Apply the standard validation rules
3. If Stape mode is enabled, reject `ZZ`
4. Return the primary value if valid
5. Otherwise evaluate the first fallback value
6. Apply the same validation rules
7. Continue through the fallback list until a valid value is found
8. Return `undefined` if no valid value exists

Conceptually:

    Primary value
          |
          v
    Standard validation
          |
          v
    Stape mode enabled?
       /        \
     Yes         No
      |           |
 Reject ZZ     Keep ZZ
       \        /
          |
          v
       Valid?
      /      \
    Yes       No
     |         |
   Return   Fallback 1
               |
               v
            Repeat
               |
               v
       No valid values
               |
               v
          undefined

---

## Numeric Zero Handling

Numeric `0` is considered a valid value.

Example:

**Primary value**

`0`

**Fallback values**

1. `99`
2. `100`

**Output**

`0`

This prevents a common fallback issue where generic falsy-value checks incorrectly treat numeric zero as missing.

---

## NaN Handling

`NaN` is considered invalid.

Example:

**Primary value**

`NaN`

**Fallback values**

1. `0`
2. `25`

**Output**

`0`

This prevents invalid numeric values from being propagated to downstream tags.

---

## Empty String Handling

The template rejects both completely empty strings and strings containing only whitespace.

The following values are invalid:

- `""`
- `" "`
- `"   "`

Example:

**Primary value**

`"   "`

**Fallback values**

1. `EUR`
2. `USD`

**Output**

`EUR`

---

## Type Preservation

Fallback Value preserves the original type of valid values instead of converting them to strings before returning them.

| Input | Output | Type |
|---|---|---|
| `0` | `0` | Number |
| `"0"` | `"0"` | String |
| `49.90` | `49.90` | Number |
| `"49.90"` | `"49.90"` | String |
| `"EUR"` | `"EUR"` | String |

This can be important in Server-Side GTM because downstream templates, APIs, and platforms may behave differently depending on whether a value is received as a number or as a string.

---

## Example: Stape Geographic Data

**Primary value**

`{{Stape - Country Code}}`

**Stape code option**

Enabled

**Fallback values**

1. `{{Event Data - country}}`
2. `{{Request Header - Country}}`
3. `IT`

Suppose the variables resolve to:

- `{{Stape - Country Code}}` → `ZZ`
- `{{Event Data - country}}` → `""`
- `{{Request Header - Country}}` → `IT`

The template evaluates:

`ZZ` → rejected because Stape mode is enabled

`""` → rejected because it is empty

`IT` → valid

**Output**

`IT`

---

## Example: Stape Region

**Primary value**

`{{Stape - Region}}`

**Stape code option**

Enabled

**Fallback values**

1. `{{Event Data - region}}`
2. `{{Custom Geo Variable}}`

Suppose the variables resolve to:

- `{{Stape - Region}}` → `ZZ`
- `{{Event Data - region}}` → `Liguria`

**Output**

`Liguria`

---

## Example: Non-Stape Data

The Stape option should remain disabled when `ZZ` should be accepted as a legitimate value.

**Primary value**

`ZZ`

**Stape code option**

Disabled

**Fallback values**

1. `ABC`
2. `DEF`

**Output**

`ZZ`

The value is returned because Stape-specific validation is not active.

---

## Example: Ecommerce Value

**Primary value**

`{{Event Data - value}}`

**Stape code option**

Disabled

**Fallback values**

1. `{{Event Data - ecommerce.value}}`
2. `{{Custom Order Value}}`
3. `0`

Suppose the variables resolve to:

- `{{Event Data - value}}` → `NaN`
- `{{Event Data - ecommerce.value}}` → `undefined`
- `{{Custom Order Value}}` → `49.90`

**Output**

`49.90`

The numeric type is preserved.

---

## Example: Currency

**Primary value**

`{{Event Data - currency}}`

**Stape code option**

Disabled

**Fallback values**

1. `{{Cookie - cart_currency}}`
2. `EUR`

Suppose the variables resolve to:

- `{{Event Data - currency}}` → `""`
- `{{Cookie - cart_currency}}` → `EUR`

**Output**

`EUR`

---

## Difference From a Standard Coalesce Variable

A standard coalesce variable generally checks multiple values and returns the first populated or non-empty value.

**Fallback Value** additionally performs built-in server-side validation before accepting a value.

It automatically handles:

- `null`
- `undefined`
- Boolean values
- `NaN`
- Empty strings
- Whitespace-only strings
- Objects and unsupported data types

It also includes an optional validation mode specifically designed for Stape geographic data, allowing the `ZZ` placeholder to be rejected only when appropriate.

In addition, valid values are returned without forcing them into a string representation, preserving their original type.

This makes the template suitable for server-side data pipelines where:

- A populated value is not necessarily a usable value
- Numeric types need to remain numeric
- Provider-specific placeholders need contextual validation
- A generic skip list would otherwise need to be manually configured

---

## Why This Matters in Server-Side GTM

Server-side containers frequently receive the same information from multiple sources.

For example, a geographic property may be available from:

- Event Data
- Request headers
- Stape geographic headers
- Cookies
- Custom variables
- API responses
- Static fallback values

Some sources may return valid information while others may return:

- `undefined`
- `null`
- `false`
- `NaN`
- `""`
- `"   "`
- `ZZ`

A generic coalesce mechanism may treat some of these values as populated even when they should not be propagated downstream.

Fallback Value combines ordered fallback logic with built-in validation and optional Stape-specific sanitization so that only a usable value is returned.

---

## Template Fields

### `primary_value`

The main value evaluated first.

If valid, it is returned immediately.

If invalid, the template evaluates the fallback values.

### `stape_country_code`

Optional checkbox.

Checkbox label:

**This variable is using Stape code (as country, zipcode, city and state)**

Default state:

Disabled

Behavior:

- Disabled → `ZZ` is accepted
- Enabled → `ZZ` is rejected

### `alt_value`

An ordered table containing fallback values.

Each row is evaluated sequentially.

Example:

1. `{{Variable A}}`
2. `{{Variable B}}`
3. `{{Variable C}}`
4. `Static fallback`

The first valid value is returned.

---

## Internal Validation Logic

The base validation logic behaves as follows:

    null        → invalid
    undefined   → invalid
    false       → invalid
    true        → invalid
    NaN         → invalid
    ""          → invalid
    "   "       → invalid
    object      → invalid
    function    → invalid

    0           → valid
    number      → valid
    string      → valid

When Stape mode is enabled:

    "ZZ"        → invalid
    " ZZ "      → invalid

When Stape mode is disabled:

    "ZZ"        → valid
    " ZZ "      → valid as the original string value

The template uses the trimmed version only for validation. A valid string is returned in its original form.

---

## Output Behavior

If the primary value is valid:

    return primary_value

If the primary value is invalid:

    evaluate alt_value rows

If Stape mode is enabled:

    reject "ZZ" values during evaluation

If a valid fallback exists:

    return first valid fallback

If every configured value is invalid:

    return undefined

---

## Notes

- Fallback values are evaluated strictly in configured order
- Numeric `0` is considered valid
- Boolean values are not considered valid outputs
- `NaN` is rejected
- Empty strings are rejected
- Whitespace-only strings are rejected
- Objects and functions are rejected
- Valid numbers remain numbers
- Valid strings remain strings
- Stape `ZZ` filtering is optional
- `ZZ` is accepted when the Stape option is disabled
- `ZZ` is rejected when the Stape option is enabled
- Surrounding whitespace is ignored when checking for `ZZ`
- The variable returns `undefined` when no valid value is available
- No template permissions are required

---

## Author

**Stefano Ghisoni**  
Website: [https://stefanoghisoni.it](https://stefanoghisoni.it)  
Email: [info@stefanoghisoni.it](mailto:info@stefanoghisoni.it)

---

## License

Licensed under the [Apache License, Version 2.0](LICENSE).

Google Tag Manager is a registered trademark of Google LLC.
