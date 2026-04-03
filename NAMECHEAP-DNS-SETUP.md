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

---

## HTTPS error: `NET::ERR_CERT_COMMON_NAME_INVALID`

Chrome shows **“Your connection is not private”** when the **TLS certificate** on the server does **not** list **`irenecorfu.com`** (and/or **`www.irenecorfu.com`**) in its allowed names. This is **not** fixed by changing website files in Git; it is fixed **on the server or at your SSL provider**.

### What to do (pick what matches your setup)

**1. Site on Namecheap shared hosting / EasyWP**

- Namecheap → **SSL Certificates** or hosting panel → install or enable **SSL** for **`irenecorfu.com`**.
- Choose a certificate that covers **both** apex and **www** (or add **www** as a SAN).
- Use **AutoSSL / Let’s Encrypt** in cPanel if available.

**2. Site on your own VPS (A records point to your server IPs)**

- SSH into the server and issue a certificate for **both** names, e.g. with **Certbot** (Let’s Encrypt):

  ```bash
  sudo certbot certonly --nginx -d irenecorfu.com -d www.irenecorfu.com
  ```

  (Use `--apache` instead of `--nginx` if you use Apache.)

- Reload the web server. Ensure the **vhost** for HTTPS uses that certificate and **ServerName** matches the domain.

**3. Wrong certificate still installed after a DNS change**

- If you moved DNS to new IPs but the **old** server still answers, or the new server has a **default** cert (e.g. another hostname), install a **new** cert on the machine that actually serves **`35.157.26.135` / `63.176.8.218`** for **`irenecorfu.com`**.

**4. Quick option: Cloudflare in front (free HTTPS at the edge)**

- Add the domain to [Cloudflare](https://www.cloudflare.com/), use their nameservers.
- Create **A** records for **`@`** and **`www`** pointing to your server IPs; turn **proxy** on (orange cloud).
- **SSL/TLS** → set mode to **Full** (or **Full (strict)** once the origin has a valid cert).
- Visitors then get a certificate issued for **your domain** at Cloudflare’s edge (fixes **common name invalid** in the browser as long as DNS is correct).

### After fixing

- Open **`https://irenecorfu.com`** and **`https://www.irenecorfu.com`** in an **Incognito** window and confirm the padlock with **no** warning.
- If **www** works but **non-www** does not (or the reverse), add the missing name to the certificate or add a **301 redirect** to your preferred hostname.
