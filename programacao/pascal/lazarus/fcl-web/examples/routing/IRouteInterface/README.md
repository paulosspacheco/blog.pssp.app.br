<div class="header" id="myHeader">
  <div class="navbar" w3-include-html="/menu.inc"> </div>
</div>
<div class="title"><script> document.write(document.title);</script></div>  
<main>
<!-- markdownlint-disable-next-line -->
<span id="topo"><span>


This demo demonstrates the routing mechanism of fpWeb.

It can be run as a CGI or as a HTTP standalone server program.

In order to get a correct set of routes in the demo, demorouting.ini file
must be configured correctly and placed next to the binary.

There is a different section for each type of binary: (CGI or Standalone)

Each section needs at least the BaseURL key, this is the URL where the
application can be reached.

Example:

[CGI]
; Assuming the demo is in cgi-bin
BaseURL=http://localhost/cgi-bin/demorouting.cgi

[Standalone]
Port=8080
; Optional, the following is the default.
;BaseURL=http://localhost:8080/

</main>

[🔝🔝](#topo "Retorna ao topo")