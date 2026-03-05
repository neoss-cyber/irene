# Namecheap DNS setup – Option 2 (TXT verification)

Use this **after** you switch nameservers from NS1 to Namecheap.  
These are the same targets your site uses now, so the site should keep working.

---

## Step 1: Switch nameservers in Namecheap

1. Log in at **namecheap.com** → **Domain List** → **irenecorfu.com** → **Manage**.
2. Under **NAMESERVERS**, change from **Custom DNS** to **Namecheap BasicDNS**.
3. Click the **✓** to save.

---

## Step 2: Add DNS records in Advanced DNS

1. On the same domain page, open the **Advanced DNS** tab.
2. Remove any old **A**, **CNAME**, or **URL Redirect** records for **@** and **www** that you don’t need (or leave default ones if Namecheap added them).
3. Add these records (use **ADD NEW RECORD** for each):

### A records (so irenecorfu.com and www keep working)

| Type | Host | Value           | TTL  |
|------|------|-----------------|------|
| A    | @    | 35.157.26.135   | 300  |
| A    | @    | 63.176.8.218    | 300  |
| A    | www  | 35.157.26.135   | 300  |
| A    | www  | 63.176.8.218    | 300  |

- **Host:** `@` for the first two, `www` for the last two.  
- **Value:** the IP (no `http://`).  
- **TTL:** 300 (or Automatic).

### TXT record (Google Search Console)

| Type | Host | Value |
|------|------|--------|
| TXT  | @    | google-site-verification=lT5QBdhOel1TEq44NToCkD3UXxEIVaXDkYu4NUtilo0 |

- **Host:** `@`  
- **Value:** copy exactly: `google-site-verification=lT5QBdhOel1TEq44NToCkD3UXxEIVaXDkYu4NUtilo0`  
- If Google gave you a different TXT value, use that one instead.

4. Save all records.

---

## Step 3: Wait and verify

- DNS can take **5–30 minutes** (sometimes up to a few hours).
- Check the site: open **https://irenecorfu.com** and **https://www.irenecorfu.com**.
- In **Google Search Console**, run **Verify** for the domain property.

---

## If the site doesn’t load

- Wait 15–30 minutes and try again (cache/DNS propagation).
- In Namecheap **Advanced DNS**, confirm the 4 A records and 1 TXT are there and the IPs are correct.
- If it’s still broken, you can switch back to **Custom DNS** and the NS1 nameservers (dns1.p04.nsone.net, etc.) to restore the previous setup.
