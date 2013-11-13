gecosccui Cookbook
===================

This is the recipe to deploy the gecoscc ui

Requirements
------------

This cookbook was made to run in Centos 6.3 or newer.


#### packages

The recipe will install all the rpm required packages


Attributes
----------

e.g.
#### gecoscc-ui::default
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>default['gecoscc-ui']['backend']['package']</tt></td>
    <td>String/td>
    <td>The package name or a URL to the package</td>
    <td><tt>https://github.com/gecos-team/gecoscc-ui/archive/dummy.tar.gz</tt></td>
  </tr>
  <tr>
    <td><tt>default['gecoscc-ui']['backend']['version']</tt></td>
    <td>String/td>
    <td>The package version name</td>
    <td><tt>dummy</tt></td>
  </tr>
  <tr>
    <td><tt>default['gecoscc-ui']['backend']['virtual_prefix']</tt></td>
    <td>String/td>
    <td>The virtualenv prefix, the version variable is append</td>
    <td><tt>/opt/gecosccui-</tt></td>
  </tr>
</table>

Usage
-----
#### gecoscc-ui::default

Just include `gecosccui` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[gecosccui]"
  ]
}
```

Contributing
------------

1.  Fork the repository on Github
2.  Create a named feature branch (like `add_component_x`)
3.  Write your change
4.  Test your changes in a clear Centos 6.3 system (only with ssh package selected during the OS installation)(
6.  Submit a Pull Request using Github

License and Authors
-------------------

Copyright © 2013 Junta de Andalucia < http://www.juntadeandalucia.es >
Licensed under the EUPL V.1.1

The license text is available at http://www.osor.eu/eupl and the attached PDF

Authors: Antonio Perez-Aranda Alcaide <aperezaranda@yaco.es>
