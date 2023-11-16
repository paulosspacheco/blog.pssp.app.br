document.addEventListener("DOMContentLoaded", function() {
    // Create the menu using JavaScript
    var menuContainer = document.getElementById("menuContainer");
    menuContainer.innerHTML = `
      <ul class="treeview">
        <li class="tree-item">item 01</li>
        <li class="tree-item">item 02</li>
        <li class="tree-item with-submenu">
          SubMenu01
          <ul class="submenu">
            <li class="tree-item">Item 01</li>
            <li class="tree-item">item 02</li>
            <li class="tree-item">Item 03</li>
            <li class="tree-item with-submenu">
              SubMenu02
              <ul class="submenu">
                <li class="tree-item">item 01</li>
                <li class="tree-item">item 02</li>
              </ul>
            </li>
          </ul>
        </li>
      </ul>
    `;
  });
  