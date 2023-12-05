<div class="header" id="myHeader">
  <div class="navbar" w3-include-html="/menu.inc"> </div>
</div>
<div class="title"><script> document.write(document.title);</script></div>  
<main>
<!-- markdownlint-disable-next-line -->
<span id="topo"><span>

# This is a test of Markdown syntax

Arquivo usado para testar o programa pasdoc.

{ @abstract(**This is a test of Markdown syntax**)
Correct lists

- list item #1.1
- list item #1.2

end list

  - list item #2.1
  - list item #2.2

end list

  * list item #3

end list

  - list item #4

1. list item #5.1
2. list item #5.2
10. list item #5.10

Simple list with multiline text

 - item 6.1
  text
text
     text

 - item 6.2
 
   item text
   
end list

List with nested list

 * item 7.1
   text
   * item 7.1.1
     text
     
   text2

List with more nesting

 - item 8.1
  - item 8.1.1
   - item 8.1.1.1
     
    text 8.1.1
  - item 8.1.2
   - item 8.1.2.1
     
   text 8.1

end list

You can even mix markdown and PasDoc tags

@unorderedList(
- list
 item #8.1
- list
 item #8.2
)

Incorrect lists

*not a list*

1not a list

1 not a list

1.not a list


  Emphasis, aka italics, with *asterisks* or _underscores_.

  Strong emphasis, aka bold, with **asterisks** or __underscores__.

  Some **bold text**.

  Some **_bold and italic text_**.

  Some **some bold and _italic_ and _italic_
    and _italic once again_ text**.

  Some _italic text_.

  Some **bold text with some tags: My name is @name,
    some @code(begin end) and a link to me: @link(ok_markdown)**.

  \*markers could be escaped
  
  *and also escaped at end\*
  of a word*
  
  or placed inside_word or placed_inside_word_multiple_times or at the end_
  
  Multiplications are OK: A*B*C*D and with spaces too: A * B * C * D
  
  underscore _ is used to name some deprecated thing: something_

  Some `inline code`, some `**formatting** _inside_ code`

  Some preformatted code:

    ```pascal
    program Foo;
      Some long code
      with
      syntax highlight
    ```

  Some Pascal code:

    ```pascal
    program Foo;
      Some long code
      with
      syntax highlight
    ```

  Correct URLs:
  
  [Some one-line descr](http://example)
  
  [Some multi-line
   descr](http://example)

  [Escaped \[\] descr](http://example)

  [\\](http://example)
  
  [a\\](http://example)

  [Bracket URL](http://example/(foo))

  Incorrect URLs:
  
  (http://example)
  
  [Some descr] (http://example)
  
  [Some descr](http://example
  
  [Bug fix: URL preceeded by block in square brackets] [descr](http://example)

}
unit ok_markdown;

interface

const
  // [Bug fix: URL at the end of comment](http://example)
  foo = 1;

implementation

end.

</main>

[🔝🔝](#topo "Retorna ao topo")