---
title: "Ide"
date: 2020-12-16T00:44:23+01:00
draft: false
menu: developer_guide
# menu:
  # developer_guide:
    # parent: 'mainmenu'
type: developer-guide
---


Je suis un artclie sur l'IDE / developer


## About Hugo shortcodes

Shortcodes are simple, and useful.


What's making shortcodes even more powerful, is the concept of _nested shotcodes_ : Shortcodes inside shortcodes

See :
* https://discourse.gohugo.io/t/shortcode-and-nested-shortcodes-with-variables/2874/2
* https://gist.github.com/search?q=hugo+nested+shortcode
* https://gist.github.com/Lego2012/bf98ed2482d6ffb1d420fca90a6c9c91


And here is a working example of what a nested Hugo Shortcode could do :

{{< preamble-information
  text_before="Want to know how to create, use and deploy a custom policy? Check out the"
  text_after="."

  >}}
{{< html_link text="Policies Developer Guide" link="/apim/3.x/apim_devguide_policies.html" >}}
{{< /preamble-information >}}


{{< preamble-information
  text_before="Want to know how to create, use and deploy a custom policy? Check out the"
  text_after="."
  >}}

  {{< html_link text_before="" text="Policies Developer Guide" link="/apim/3.x/apim_devguide_policies.html" >}}
  {{< html_link text_before=" this is between the two links and ther you go hugo !!!" text="Link Two" link="/apim/3.x/apim_devguide_policies.html" >}}

{{< /preamble-information >}}

{{< preamble-information
  text_before="Want to know how to create, use and deploy a custom policy? Check out the"
  text_after="."
  >}}

  {{< html_link text_before="" text="Policies Developer Guide" link="/apim/3.x/apim_devguide_policies.html" >}}
  {{< html_link text_before=" this is between the link one and link two, and there you go hugo !!!" text="Link Two" link="/apim/3.x/apim_devguide_policies.html" >}}
  {{< html_link text_before=" this is between the link two and link three, and there you go hugo !!!" text="Link Three" link="/apim/3.x/apim_devguide_policies.html" >}}
  {{< html_link text_before=" this is between the link three and link four, and there you go hugo !!!" text="Link Four" link="/apim/3.x/apim_devguide_policies.html" >}}

{{< /preamble-information >}}

{{< preamble-warning
  text_before="Want to know "
  text_after="."
  >}}
  {{< bold text_before="" text="how to create" >}}
  {{< bold text_before=", use and" text="deploy a custom policy" >}}
  {{< html_link text_before="? Check out the" text="Policies Developer Guide" link="/apim/3.x/apim_devguide_policies.html" >}}
  {{< oneliner_code color="#FF6E14" backcolor="#eeeeee" text_before=" Wanna talk about a technical thing like " text="workflow_state" >}}
  {{< html_link text_before="  ? No prob man, Hugo can do anything  !!! this is between the link one and link two, and there you go hugo !!!" text="Link Two" link="/apim/3.x/apim_devguide_policies.html" >}}
  {{< html_link text_before=" this is between the link two and link three, and there you go hugo !!!" text="Link Three" link="/apim/3.x/apim_devguide_policies.html" >}}
  {{< html_link text_before=" this is between the link three and link four, and there you go hugo !!!" text="Link Four" link="/apim/3.x/apim_devguide_policies.html" >}}

{{< /preamble-warning >}}

from https://github.com/simonfrey/hugo-leaflet :

{{< leafflet/leaflet-simple mapHeight="500px" mapWidth="500px" mapLon="51.508" mapLat="-0.11" zoom="2">}}
