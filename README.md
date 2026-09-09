By using or modifying this template, you agree to the  
Google Tag Manager Community Template Gallery Developer Terms of Service:  
https://developers.google.com/tag-manager/gallery-tos

# Fallback Number – GTM Server Variable

A smart and reliable **Server-Side Google Tag Manager Variable** that returns the first valid numeric value from a primary input or a list of fallback values. This ensures your numeric data is consistent and prevents errors caused by invalid or missing numbers.

---

## 🚀 What This Variable Does

The **Fallback Number** variable:

- Accepts a primary numeric input value  
- Accepts a list of fallback numeric values  
- Returns the first valid number found (primary or fallback)  
- Returns `null` if no valid number is found  
- Helps avoid conversion errors or missing numeric data in server-side GTM workflows

**Example:**

| Primary Value | Fallback Values           | Output |
|---------------|---------------------------|--------|
| 42            | [10, 20, 30]              | 42     |
| NaN           | [null, 0, 99]             | 0      |
| null          | [null, false, undefined]  | null   |

---

## 🧩 Use Cases

This variable is useful in **Server-Side GTM** setups where you may have multiple possible sources for a numeric value and want to ensure a valid number is always used, such as:

- Prioritizing main order values but falling back to secondary metrics  
- Using multiple possible revenue or price fields without conversion errors  
- Handling incomplete or inconsistent data from clients or APIs  
- Guaranteeing numeric data integrity before passing to downstream platforms  

---

## ⚙️ How It Works

The template exposes these fields:

- **Primary value** (`primaryValue`): The main numeric input to use if valid.  
- **Fallback values** (`fallbackList`): A list of fallback numeric values to check if primary is invalid.

The variable evaluates the primary value first; if invalid (e.g., `null`, `undefined`, `NaN`), it iterates through the fallback list and returns the first valid number it finds. If none are valid, it returns `null`.

---

## 👤 Author

**Stefano Ghisoni**  
Website: [https://stefanoghisoni.it](https://stefanoghisoni.it)  
Email: [info@stefanoghisoni.it](mailto:info@stefanoghisoni.it)

---

## 📜 License

Licensed under the [Apache License, Version 2.0](LICENSE).

Google Tag Manager is a registered trademark of Google LLC.
