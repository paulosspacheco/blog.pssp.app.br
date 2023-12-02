<div class="header" id="myHeader">
  <div class="navbar" w3-include-html="/menu.inc"> </div>
</div>
<div class="title"><script> document.write(document.title);</script></div>  
<main>
<!-- markdownlint-disable-next-line -->
<span id="topo"><span>

# How to Sign apk or bundle using gradle by ADiV

https://forum.lazarus.freepascal.org/index.php/topic,52313.msg386040/

by ADiV Software

https://adiv.sourceforge.io/
https://adiv.sourceforge.io/lng/spa/index.html

"With the latest LAMW update we can sign our apk or bundle more easily:

First we will execute "release-keystore" if we do not have the signature created.

- Then we will fill in the signature file "gradle.properties" as follows:
  - RELEASE_STORE_FILE = yourapp.keystore
  - RELEASE_STORE_PASSWORD = yourpassword
  - RELEASE_KEY_ALIAS = yourappaliaskey
  - RELEASE_KEY_PASSWORD = yourpassword

And to finish we close and open the project and it will automatically include the signature."

</main>

[🔝🔝](#topo "Retorna ao topo")