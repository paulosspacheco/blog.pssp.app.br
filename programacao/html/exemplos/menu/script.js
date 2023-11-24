function myTopnav_menu() {
  var x = document.getElementById("myTopnav");
  if (x.className.indexOf("responsive") === -1) {
    x.className += " responsive";
  } else {
    x.className = x.className.replace(" responsive", "");
  }
}

function toggleDropdown() {
  var dropdown = document.querySelector('.dropdown');
  if (dropdown.className.indexOf("show") === -1) {
    dropdown.className += " show";
  } else {
    dropdown.className = dropdown.className.replace(" show", "");
  }
}
