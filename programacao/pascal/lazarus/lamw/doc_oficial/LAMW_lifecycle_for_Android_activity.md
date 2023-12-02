<div class="header" id="myHeader">
  <div class="navbar" w3-include-html="/menu.inc"> </div>
</div>
<div class="title"><script> document.write(document.title);</script></div>  
<main>
<!-- markdownlint-disable-next-line -->
<span id="topo"><span>

# LAMW lifecycle for Android activity 

```txt

    ---------------------------------------
    |                                     |
    | LAMW lifecycle for Android activity |
    | ----------------------------------- |
    ---------------------------------------

    ReCreate  ------------------------------
    Activity  | Activity                   |
    |-------->|  Create  OnActivityCreate()|
    |         ------------------------------
    |               |
    |              \|/
    |         OnActivityReCreate() // Only main or splash module call this, if recreate activity
    |               |
    |              \|/
    | |------>OnActivityResume()
    | |             |
    | |            \|/  
    | |	   When the application is visible, automatic "updatelayout" of the main form
    | |       ----------------------
    | |       | ....Run LAMW App   |
    | |       ----------------------
    | |             |
    | |            \|/
    | |-------OnPause()
    |               |
    |              \|/
    ----------OnStop()
                    |
                    \|/
            OnDestroy()
                    |
                    \|/
            -------------
            | Activity  |
            | Shut down |
            -------------

```

</main>

[🔝🔝](#topo "Retorna ao topo")
