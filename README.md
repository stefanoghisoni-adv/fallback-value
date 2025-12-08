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

- **Primary value** (number): The main numeric input to use if valid.  
- **Fallback values** (simple table): A list of fallback numeric values to check if primary is invalid.

The variable returns the first valid number it finds, or `null` if none are valid.

---

## 👤 Authors

Stefano Ghisoni  
https://stefanoghisoni.it  
info@stefanoghisoni.it

---

## 📜 License & Terms

© 2025 Stefano Ghisoni. All rights reserved.

Use, modification, and redistribution are permitted only with explicit permission from the author.

Google Tag Manager is a registered trademark of Google LLC.

This software is provided "as is", without any warranties or guarantees.

Please retain original attribution when using or distributing this code.

For infringement reports or commercial license inquiries, contact: info@stefanoghisoni.it
