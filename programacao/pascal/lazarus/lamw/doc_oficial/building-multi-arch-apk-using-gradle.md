<div class="header" id="myHeader">
  <div class="navbar" w3-include-html="/menu.inc"> </div>
</div>
<div class="title"><script> document.write(document.title);</script></div>  
<main>
<!-- markdownlint-disable-next-line -->
<span id="topo"><span>

# Posts: 1229

Re: Android Module Wizard 
Reply#1210 on: March 13, 2020, 05:14:35 am

[By DonAlfredo]


Hi,

...I have added a Gradle option into build.gradle:

    splits {
        abi {
            enable true
            reset()
            include 'arm64-v8a'
            universalApk false
        }
    }


To make a combined apk, build with Gradle use [something like] this:

    splits {
        abi {
            enable true
            reset()
            include 'armeabi-v7a','arm64-v8a'
            universalApk true
        }
    }
</main>

[🔝🔝](#topo "Retorna ao topo")