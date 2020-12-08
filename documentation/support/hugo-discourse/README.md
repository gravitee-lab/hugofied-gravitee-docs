Where : https://discourse.gohugo.io/t/associate-layout-and-content/29843

# Question 1 (desperate)
### Answer 1

### Answer to Answer 2

Hi pointyfar,

Thank you so much for your answer. I have just tried your suggestion :
* I might, though, not understand one of the things you are suggesting : indeed, I still have the same result, absolutely all pages, except the root page, are empty.
* Now let me describe exactly What I tested, following your suggestions.

Again:

```bash
~/hugofied-gravitee-doc$ hugo env
Hugo Static Site Generator v0.78.2-959724F0 linux/amd64 BuildDate: 2020-11-13T10:08:14Z
GOOS="linux"
GOARCH="amd64"
GOVERSION="go1.15.1"
~/hugofied-gravitee-doc$ git --version
git version 2.11.0
~/hugofied-gravitee-doc$

```

### My Content, `config.toml`, and my layouts folder

```bash
~/hugofied-gravitee-doc$ tree content/
content/
├── _index.md
├── test
│   ├── _index.md
│   ├── test1.md
│   ├── test2.md
│   └── test4
│       └── _index.md
├── test2
│   └── test3
│       └── default.md
└── testjb2
    └── test6.md

5 directories, 7 files
~/hugofied-gravitee-doc$ cat content/test/test1.md
---
type: testjb2
---

Fichier `content/test/test1.md`

~/hugofied-gravitee-doc$ cat config.toml
baseURL = "http://127.0.0.1:1313/"
languageCode = "en-us"
title = "Gravitee.io API Platform"
themesDir = "themes"
theme = "gravitee-docs"
~/hugofied-gravitee-doc$ tree layouts/
layouts/

0 directories, 0 files

```

All the files in the `content`, contain :
* the front matter you suggested me :

```
---
type: testjb2
---
```

* and one sentence containing the path of the file.


### My Theme

Last, in my hugo theme, in all folders, the same 4 Html files are present:
* `index.html` and `baseof.html` have the exact same content, and use 2 blocks :

```
{{ block "main" . }}
{{ end }}
{{ block "footer" . }}
{{ end }}
```
* list.html and single.html have the exact same content, and they define main and footer blocks :

```
{{ define "main" }}
<!--  a lot of HTML -->
  {{ .Content }}
<!--  a lot of HTML -->
{{ end }}

{{ define "footer" }}
<!--  a lot of HTML but no .Content -->
{{ end }}

```
And here is exactly the tree of my hugot theme :
```bash
~/hugofied-gravitee-doc$ tree themes/gravitee-docs/
themes/gravitee-docs/
├── layouts
│   ├── _default
│   │   ├── baseof.html
│   │   ├── index.html
│   │   ├── list.html
│   │   └── single.html
│   ├── index.html
│   ├── testjb
│   │   ├── baseof.html
│   │   ├── index.html
│   │   ├── list.html
│   │   └── single.html
│   └── testjb2
│       ├── baseof.html
│       ├── index.html
│       ├── list.html
│       └── single.html
└── theme.toml

4 directories, 14 files
~/hugofied-gravitee-doc$ cat themes/gravitee-docs/theme.toml
name = "gravitee-docs"
license = "AGPL v3"
licenselink = "https://www.gnu.org/licenses/agpl-3.0.txt"
description = "A Hugo theme for all Gravitee.io documentation websites"
homepage = "https://github.com/gravitee-lab/hugofied-gravitee-docs/"
tags = ["documentation", "clean", "customizable", "light", "highlighting", "minimal", "corporate", "responsive", "simple"]
features = ["documentation", "APi documentation"]
min_version = 0.54

[author]
  name = "Jean-Baptiste-Lasselle"
  homepage = "https://github.com/Jean-Baptiste-Lasselle"

[original]
    author = "Gravitee.io"
    homepage = "https://github.com/gravitee-io/gravitee-docs"
~/hugofied-gravitee-doc$ # index.html has exactly same content than all themes/gravitee-docs/layouts/*/index.html
~/hugofied-gravitee-doc$ ls -allh themes/gravitee-docs/layouts/*/index.html
-rw-r--r-- 1 jibl jibl 3.7K Dec  7 15:25 themes/gravitee-docs/layouts/_default/index.html
-rw-r--r-- 1 jibl jibl 3.7K Dec  7 15:19 themes/gravitee-docs/layouts/testjb2/index.html
-rw-r--r-- 1 jibl jibl 3.7K Dec  7 15:25 themes/gravitee-docs/layouts/testjb/index.html

```

* Finally :
  * The `themes/gravitee-docs/layouts/testjb2/index.html` theme Layout file contains the following sentence:
<pre>
  I am the [themes/gravitee-docs/layouts/testjb2/index.html] file
</pre>
  * The `content/_index.md` content file contains the following sentence:
<pre>
Voilà le `content/_index.md` à la racine du répertoire hugo `content`.
</pre>


Tests :
* I stop any server, delete the `public/` folder, and run the `hugo` command, result is :
  * All Html files in the `public/` folder are empty.(Not even one character inside), except `public/index.html`
* I then start the hugo server in watch mode, with `hugo serve --watch -b http://127.0.0.1:1313/`, result is :
  * the page at http://127.0.0.1:1313/ exists (no 404), I can see the rendered `public/index.html`, and I know it is built from the 2 `themes/gravitee-docs/layouts/testjb2/index.html`, and `content/_index.md` files, because it contains both of the sentences present in those 2 files.
  * the pages at the following URLs exist (no 404), and all display a blank page (replace below `BASE_URL` by `http://127.0.0.1:1313` ) :
    * `BASE_URL/test/`
    * `BASE_URL/test/test1`
    * `BASE_URL/test/test2`
    * `BASE_URL/test/test4`
    * `BASE_URL/test2/test3`
    * `BASE_URL/testjb2/test6`

Now I am sure we are getting very close to make clear how to use a layouts in hugo, and we willfind what I am doing wrong, but I really am dismayed of my test results, now...
