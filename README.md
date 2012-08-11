# bootstrap-helpers
## Rails bootstrap helpers

### Install

``` rb
  gem "bootstrap-helpers"
```

## List of helpers

### Scaffold

 * `container(opts = {}, &block)`
 * `row(opts = {}, &block)`
 * `span(size, opts = {}, &block)`
 * `icon(icon_id)`

*eg*

``` erb
<%= container :id => "main" do %>
  <%= row :class => "myRow" do %>
    <%= span 5, :offset => 2 do %>
      <p>Span content</p>
    <% end %>
  <% end %>
<% end %> 
```

Passing `:fluid => true` to `container` will set the layout to fluid and thus rows will be builded accordingly as `row-fluid`.

### Base CSS

 * `button(*args, &block)`
 * `form_actions(&block)`

*eg*

``` erb
	  <%= button "New Post", new_post_path, :type => :primary %>
```

### Navigation  
 
 * `navbar(*args, &block)`
 * `nav(options = {}, &block)`
 * `pills(options = {}, &block)`
 * `nav_header(title)`
 * `nav_list(options = {}, &block)`
 * `dropdown_nav_item(label, opts = {}, &block)`
 * `nav_item(*args, &block)`
 * `brand(*args, &block)`

``` erb
<%= navbar :fixed => :top do %>
  <%= brand app_name, "/" %>
<% end %>
```

``` erb
<%= nav do %>
  <%= nav_item "Homepage", "/", :icon => "home" , :icon_color => :white %>
  <%= dropdown_nav_item "Account", :icon => "user" , :icon_color => :white do %>
      <%= nav_item 'Logout', destroy_user_session_path, :method => :delete %>
  <% end %>
<% end %>
```

``` erb
<%= nav_list do %>
  <%= nav_header "Website" %>    
  <%= nav_item "Pages", admin_pages_path %>
  <%= nav_item "Menus", admin_menus_path %>

  <%= nav_header "Contents" %>    
  <%= nav_item "Photogalleries", admin_photogalleries_path %>
  <%= nav_item "Posts", admin_posts_path %>

  <%= nav_header "Users" %>
  <%= nav_item "Users", admin_users_path %>    
<% end %>
```

### Components

* `tabs(opts = {})`
* `accordion(opts = {})`
* `alert(message)`


``` erb
<%= accordion do |a| %>

  <%= a.pane "Pane1" do %>
    Content 1
  <% end %>

  <%= a.pane "Pane2" do %>
    Content 2
  <% end %>

  <%= a.pane "Pane3" do %>
    Content 3
  <% end %>

<% end %>
```


``` erb
<%= tabs do |t| %>

  <%= t.pane "Pane1" do %>
    Content 1
  <% end %>

  <%= t.pane "Pane2" do %>
    Content 2
  <% end %>

  <%= t.pane "Pane3" do %>
    Content 3
  <% end %>

<% end %>
```

---

Copyright (c) 2012 mcasimir

MIT License

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
