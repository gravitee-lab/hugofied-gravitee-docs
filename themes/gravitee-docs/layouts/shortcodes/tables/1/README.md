A table shortcode for hugo.
Until 0.60.0, Mmark was good option, convenient way in order to add any attributes to table. But from 0.60.0, mmark is marked as deprecated.
On the other hand, new standard markdown parser, goldmark does not support that's way. So, I created a table shortcode for hugo. This shortcode supports both of markdown table and attributes.

Example usage:

```
{{< table id="sample" class="bordered" data-sample=10 >}}
|A|B|
|------|------|
|A|B|
{{</ table >}}
```

above code will be:

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
