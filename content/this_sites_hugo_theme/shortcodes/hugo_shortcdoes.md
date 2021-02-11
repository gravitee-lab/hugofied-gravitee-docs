---
title: "Hugo Short Codes"
date: 2020-12-16T00:44:23+01:00
draft: false
nav_menu: "This Site's Hugo Theme"
menu: hugo_short_codes
menu_index: 500
# menu:
  # developer_guide:
    # parent: 'mainmenu'
type: this-sites-hugo-theme
---

A table shortcode for hugo.

### Example usage

{{< pre >}}

{{/*< table id="sample" class="bordered" data-sample=10 > */}}
|A|B|
|------|------|
|A|B|
{{/* </ table > */}}

{{</ pre >}}

above code will render as :

```
<table id="sample" class="bordered" data-sample="10">
<thead>
<tr>
<th>A</th>
<th>B</th>
</tr>
</thead>
<tbody>
<tr>
<td>A</td>
<td>B</td>
</tr>
</tbody>
</table>

```

---

This snippet is licensed under CC0 (publicdomain, waived all copyrights).
