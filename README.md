By using or modifying this template, you agree to the  
Google Tag Manager Community Template Gallery Developer Terms of Service:  
https://developers.google.com/tag-manager/gallery-tos

# Fallback Value – GTM Server Variable

A smart and reliable **Server-Side Google Tag Manager Variable** that returns the first valid value from a primary input or an ordered list of fallback values.

Unlike a basic fallback or coalesce mechanism, **Fallback Value** also performs built-in value validation before returning a result. It preserves the original value type and automatically rejects invalid, empty, or provider-specific placeholder values such as Stape's `ZZ`.

---

## 🚀 What This Variable Does

The **Fallback Value** variable:

- Accepts a primary value
- Accepts an ordered list of fallback values
- Evaluates the primary value first
- Returns the first valid value found
- Preserves the original value type
- Keeps numeric `0` as a valid value
- Rejects `null`
- Rejects `undefined`
- Rejects boolean values
- Rejects `NaN`
- Rejects empty strings
- Rejects whitespace-only strings
- Rejects Stape's `ZZ` geographic placeholder
- Rejects unsupported data types such as objects and functions
- Returns `undefined` if no valid value is found

This makes the variable useful not only for fallback logic, but also for sanitizing server-side values before they are passed to downstream analytics, advertising, or API tags.

**Examples:**

| Primary Value | Fallback Values | Output |
|---------------|-----------------|--------|
| `42` | `[10, 20, 30]` | `42` |
| `NaN` | `[null, 0, 99]` | `0` |
| `null` | `["", "EUR", "USD"]` | `"EUR"` |
| `"ZZ"` | `["IT", "DE"]` | `"IT"` |
| `"   "` | `[false, 25]` | `25` |
| `null` | `[null, false, undefined]` | `undefined` |

---

## ✅ Validation Rules

A value is considered invalid when it matches one of the following conditions:

| Value | Result |
|-------|--------|
| `null` | Ignored |
| `undefined` | Ignored |
| `false` | Ignored |
| `true` | Ignored |
| `NaN` | Ignored |
| `""` | Ignored |
| `"   "` | Ignored |
| `"ZZ"` | Ignored |
| Object | Ignored |
| Function | Ignored |
| `0` | Valid |
| Valid number | Valid |
| Valid string | Valid |

The exact string `ZZ` is treated as invalid because it can be returned by Stape or other server-side data sources as a placeholder when geographic information is unavailable.

Numeric `0` remains valid and is not treated as an empty or falsy fallback value.

---

## 🧩 Use Cases

This variable is useful in **Server-Side Google Tag Manager** setups where the same logical value may come from multiple possible sources and some of those sources may return invalid, empty, or placeholder data.

Common use cases include:

- Falling back between Event Data, request headers, cookies, or custom variables
- Selecting the first available country, region, or geographic value
- Ignoring Stape's `ZZ` geographic placeholder
- Prioritizing ecommerce values from multiple sources
- Falling back between different revenue or order value fields
- Handling incomplete or inconsistent client data
- Handling incomplete data received from APIs
- Preventing empty values from being passed to downstream tags
- Preventing invalid numeric values such as `NaN` from being propagated
- Preserving numeric `0` as a valid result
- Preserving the original data type of the selected value

---

## ⚙️ How It Works

The template exposes two main fields:

### Primary value

`primary_value`

The primary value is evaluated first.

It can be:

- A Google Tag Manager variable
- A static string
- A numeric value

If the primary value is valid, it is immediately returned and no fallback value is used.

Example:

**Primary value**

`{{Event Data - region}}`

If it resolves to:

`Lombardia`

the variable returns:

`Lombardia`

---

### Fallback values

`alt_value`

Fallback values are evaluated sequentially from top to bottom.

If the primary value is invalid, the variable checks each fallback value until it finds the first valid one.

Example:

**Primary value**

`{{Event Data - region}}`

**Fallback values**

1. `{{Request Header - Region}}`
2. `{{Geo Lookup - Region}}`
3. `IT`

If the values resolve to:

- `{{Event Data - region}}` → `ZZ`
- `{{Request Header - Region}}` → `""`
- `{{Geo Lookup - Region}}` → `Lombardia`

the final output is:

`Lombardia`

If no valid value exists, the variable returns:

`undefined`

---

## 🔄 Evaluation Order

Values are always evaluated in this order:

1. Primary value
2. First fallback value
3. Second fallback value
4. Third fallback value
5. Any additional fallback values

The first valid value immediately becomes the output.

Conceptually:

    Primary value
          ↓
        Valid?
       /      \
     Yes       No
      ↓         ↓
    Return   Fallback 1
                ↓
              Valid?
             /      \
           Yes       No
            ↓         ↓
          Return   Fallback 2
                       ↓
                      ...
                       ↓
               No valid value
                       ↓
                  undefined

---

## 🔢 Numeric Zero Handling

Numeric `0` is considered a valid value.

For example:

**Primary value**

`0`

**Fallback values**

- `99`
- `100`

Output:

`0`

This prevents a common fallback issue where generic falsy-value checks incorrectly treat numeric zero as missing.

---

## 🔎 NaN Handling

`NaN` is considered invalid.

For example:

**Primary value**

`NaN`

**Fallback values**

- `0`
- `25`

Output:

`0`

This prevents an invalid numeric value from being propagated to downstream tags.

---

## 🧹 Empty String Handling

The template rejects both completely empty strings and strings containing only whitespace.

The following values are therefore invalid:

- `""`
- `" "`
- `"   "`

For example:

**Primary value**

`"   "`

**Fallback values**

- `EUR`
- `USD`

Output:

`EUR`

---

## 🌍 Stape `ZZ` Handling

Server-side environments may return placeholder values when geographic information cannot be resolved.

One relevant example is:

`ZZ`

This value may appear in geographic data where the actual country, region, or location is unavailable.

**Fallback Value** automatically treats the exact string `ZZ` as invalid.

Example:

**Primary value**

`ZZ`

**Fallback values**

- `IT`
- `DE`
- `FR`

Output:

`IT`

Another example:

**Primary value**

`{{Stape - X-Geo-Region}}`

**Fallback values**

1. `{{Event Data - region}}`
2. `{{Custom Geo Variable}}`

If:

- `{{Stape - X-Geo-Region}}` → `ZZ`
- `{{Event Data - region}}` → `Liguria`

the output is:

`Liguria`

This prevents unresolved geographic placeholders from being propagated to analytics or advertising platforms when another usable value is available.

---

## 🧬 Type Preservation

Fallback Value preserves the original type of valid values instead of converting everything to a string.

For example:

| Input | Output | Type |
|-------|--------|------|
| `0` | `0` | Number |
| `"0"` | `"0"` | String |
| `49.90` | `49.90` | Number |
| `"49.90"` | `"49.90"` | String |
| `"EUR"` | `"EUR"` | String |

This can be important in Server-Side GTM because downstream templates, APIs, and platforms may behave differently depending on whether a value is received as a number or as a string.

---

## 🆚 Difference From a Standard Coalesce Variable

A standard coalesce variable generally checks multiple values and returns the first populated or non-empty value.

**Fallback Value** additionally performs built-in server-side validation before accepting a value.

It automatically handles:

- `null`
- `undefined`
- Boolean values
- `NaN`
- Empty strings
- Whitespace-only strings
- Stape's `ZZ` geographic placeholder
- Unsupported object or function values

It also preserves the original type of valid strings and numbers rather than forcing the selected value into a string representation.

This makes the template particularly useful in server-side data pipelines where a populated value is not necessarily a usable value.

---

## 🖥️ Why This Matters in Server-Side GTM

Server-side containers frequently receive the same information from different sources.

For example, a country or region may be available from:

- Event Data
- Request headers
- Stape geographic headers
- Cookies
- Custom variables
- API responses
- Static fallback values

Some sources may return a valid value while others may return:

- `undefined`
- `null`
- `false`
- `NaN`
- `""`
- `"   "`
- `ZZ`

Without additional validation, some of these values may incorrectly be treated as usable and sent to downstream platforms.

Fallback Value combines ordered fallback logic with built-in validation so that only a usable value is returned.

---

## 📍 Example: Geographic Data

**Primary value**

`{{Stape - X-Geo-Region}}`

**Fallback values**

1. `{{Event Data - region}}`
2. `{{Request Header - Region}}`
3. `{{Geo Lookup - Region}}`

Suppose the variables resolve to:

- `{{Stape - X-Geo-Region}}` → `ZZ`
- `{{Event Data - region}}` → `""`
- `{{Request Header - Region}}` → `Lombardia`
- `{{Geo Lookup - Region}}` → `IT-25`

Output:

`Lombardia`

The first two values are rejected and the first valid fallback is returned.

---

## 🛒 Example: Ecommerce Value

**Primary value**

`{{Event Data - value}}`

**Fallback values**

1. `{{Event Data - ecommerce.value}}`
2. `{{Custom Order Value}}`
3. `0`

Suppose the variables resolve to:

- `{{Event Data - value}}` → `NaN`
- `{{Event Data - ecommerce.value}}` → `undefined`
- `{{Custom Order Value}}` → `49.90`

Output:

`49.90`

The numeric type is preserved.

---

## 💱 Example: Currency

**Primary value**

`{{Event Data - currency}}`

**Fallback values**

1. `{{Cookie - cart_currency}}`
2. `EUR`

Suppose the variables resolve to:

- `{{Event Data - currency}}` → `""`
- `{{Cookie - cart_currency}}` → `EUR`

Output:

`EUR`

---

## 📋 Template Fields

### `primary_value`

The main value evaluated by the variable.

If valid, it is returned immediately.

If invalid, the template starts evaluating the fallback values.

### `alt_value`

An ordered table of fallback values.

Each row is evaluated sequentially.

For example:

1. `{{Variable A}}`
2. `{{Variable B}}`
3. `{{Variable C}}`
4. `Static fallback`

The first valid value is returned.

---

## 🧠 Internal Validation Logic

The template follows these validation rules:

    null        → invalid
    undefined   → invalid
    false       → invalid
    true        → invalid
    NaN         → invalid
    ""          → invalid
    "   "       → invalid
    "ZZ"        → invalid
    object      → invalid
    function    → invalid

    0           → valid
    number      → valid
    string      → valid

Valid strings and numbers are returned without changing their original type.

---

## 📤 Output Behavior

If the primary value is valid:

    return primary_value

If the primary value is invalid:

    evaluate alt_value rows

If a valid fallback exists:

    return first valid fallback

If every configured value is invalid:

    return undefined

---

## 📝 Notes

- Fallback values are evaluated strictly in configured order
- Numeric `0` is considered valid
- Boolean values are not considered valid outputs
- `NaN` is rejected
- Empty strings are rejected
- Whitespace-only strings are rejected
- The exact string `ZZ` is rejected
- Valid numbers remain numbers
- Valid strings remain strings
- Objects and functions are rejected
- The variable returns `undefined` when no valid value is available
- No template permissions are required

---

## 👤 Author

**Stefano Ghisoni**  
Website: [https://stefanoghisoni.it](https://stefanoghisoni.it)  
Email: [info@stefanoghisoni.it](mailto:info@stefanoghisoni.it)

---

## 📜 License

Licensed under the [Apache License, Version 2.0](LICENSE).

Google Tag Manager is a registered trademark of Google LLC.
