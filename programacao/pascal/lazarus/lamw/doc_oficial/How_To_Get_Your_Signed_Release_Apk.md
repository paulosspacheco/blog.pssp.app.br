<div class="header" id="myHeader">
  <div class="navbar" w3-include-html="/menu.inc"> </div>
</div>
<div class="title"><script> document.write(document.title);</script></div>  
<main>
<!-- markdownlint-disable-next-line -->
<span id="topo"><span>

# Tutorial: How to get your 'signed' release Apk: 'AppLAMWProject1'

- 1) Edit/change the project file "keytool_input.txt" to more representative informations:"
  - .Your keystore password [--ks-pass pass] : 123456
  - .Re-enter/confirm the keystore password: 123456
  - .Your first and last name: MyFirstName MyLastName
  - .Your Organizational unit: MyDevelopmentUnit
  - .Your Organization name: MyCompany
  - .Your City or Locality: MyCity
  - .Your State or Province: MT
  - .The two-letter country code: BR
  - .All correct: y
  - .Your key password for this Apk alias [--key-pass pass]: 123456 

- 2) If you are using "Ant" then edit/change "ant.properties" according, too!
  - 1) Execute the [project] command "release-keystore.bat" or "release-keystore.sh" or "release-keystore-macos.sh" to get the "applamwproject1-release.keystore"
    - warning: the file "applamwproject1-release.keystore" should be created only 
    - once [per application] otherwise it will fail [and NEVER delete it!]
  - 1) [Gradle]: Edit/change the values [123456] "--ks-pass pass:" and "--key-pass pass:" in project file "gradle-local-apksigner.bat" [or .sh]  according "keytool_input.txt" file
    - Edit/change the values [123456] "--ks-pass pass:" and "--key-pass pass:" in project file "gradle-local-universal-apksigner.bat" [or .sh]  according "keytool_input.txt" file

    - 1) [Gradle]: Execute the [project] command "gradle-local-apksigner.bat" [.sh] to get the [release] signed Apk!
             OR execute "gradle-local-universal-apksigner.bat" [.sh] if your are supporting multi-architecture (ex.: armeabi-v7a + arm64-v8a + ...) 
             hint: look for your generated "AppLAMWProject1-release.apk" in [project] folder "...\build\outputs\apk\release"

- 6) [Ant]: Execute the [project] command "ant-build-release.bat" [.sh] to get the [release] signed Apk!"
  - hint: look for your generated "AppLAMWProject1-release.apk" in [project] folder ...\bin"

- Success! You can now upload your nice "AppLAMWProject1-release.apk" to "Google Play" [or others stores...]!

- ....  Thanks to All!
- ....  Special thanks to ADiV/TR3E!

- ....  by jmpessoa_hotmail_com

```css

    <style>
    /*From extension vscode.github*/

    /*---------------------------------------------------------------------*/
    Copyright (c) Microsoft Corporation. All rights reserved.
    Licensed under the MIT License. See License.txt in the project root for license information.
    /*---------------------------------------------------------------------*/


    .vscode-dark img[src$=\#gh-light-mode-only],
    .vscode-light img[src$=\#gh-dark-mode-only] {
        display: none;   
    }


    /* From extension bierner.markdown-checkbox */
    .contains-task-list {
        padding-left: 0;
    }

    .contains-task-list li {
        margin-left: 24px;
    }

    .contains-task-list .task-list-item {
        list-style: none;
        padding-left: 0;
        margin-left: 0;
    }

    .contains-task-list .contains-task-list {
        padding-left: 20px;
    } 
    

    /* From extension davidmwhynot.markdown-higlightjs */
    /*

    - Atom One Dark by Daniel Gamage
    - Original One Dark Syntax theme from https://github.com/atom/one-dark-syntax


    base:    #282c34
    mono-1:  #abb2bf
    mono-2:  #818896
    mono-3:  #5c6370
    hue-1:   #56b6c2
    hue-2:   #61aeee
    hue-3:   #c678dd
    hue-4:   #98c379
    hue-5:   #e06c75
    hue-5-2: #be5046
    hue-6:   #d19a66
    hue-6-2: #e6c07b

    */

    .hljs {
    display: block;
    overflow-x: auto;
    padding: 0.5em;
    color: #abb2bf;
    background: #282c34;
    }

    .hljs-comment,
    .hljs-quote {
    color: #5c6370;
    font-style: italic;
    }

    .hljs-doctag,
    .hljs-keyword,
    .hljs-formula {
    color: #c678dd;
    }

    .hljs-section,
    .hljs-name,
    .hljs-selector-tag,
    .hljs-deletion,
    .hljs-subst {
    color: #e06c75;
    }

    .hljs-literal {
    color: #56b6c2;
    }

    .hljs-string,
    .hljs-regexp,
    .hljs-addition,
    .hljs-attribute,
    .hljs-meta-string {
    color: #98c379;
    }

    .hljs-built_in,
    .hljs-class .hljs-title {
    color: #e6c07b;
    }

    .hljs-attr,
    .hljs-variable,
    .hljs-template-variable,
    .hljs-type,
    .hljs-selector-class,
    .hljs-selector-attr,
    .hljs-selector-pseudo,
    .hljs-number {
    color: #d19a66;
    }

    .hljs-symbol,
    .hljs-bullet,
    .hljs-link,
    .hljs-meta,
    .hljs-selector-id,
    .hljs-title {
    color: #61aeee;
    }

    .hljs-emphasis {
    font-style: italic;
    }

    .hljs-strong {
    font-weight: bold;
    }

    .hljs-link {
    text-decoration: underline;
    }

    </style>
            
            
            <style>
    .task-list-item {
        list-style-type: none;
    }

    .task-list-item-checkbox {
        margin-left: -20px;
        vertical-align: middle;
        pointer-events: none;
    }
    </style>
<style>

```
</main>

[🔝🔝](#topo "Retorna ao topo")