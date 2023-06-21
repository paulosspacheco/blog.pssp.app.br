<!-- markdownlint-disable-next-line -->
# GUI Design WYSIWYG

## [LAMW: Lazarus Android Module Wizard](https://github.com/jmpessoa/lazandroidmodulewizard)

### How to design a GUI layout that shown same in real device?

- For visual components configure these properties:
  - Anchor
  - PosRelativeToParent
  - PosRelativeToAnchor
  - LayoutParamHeight
  - LayoutParamWhidth

- **Example**
  - 1 Put a  **jTextView** component on _LAMW Form_ and set properties:

	```java
		PosRelativeToParent
		rpCenterHorizontal = [True]
		rpTop = [True]
		Text = GUI Design WYSIWYG   
		//(Because only Position Relative to Parent(form) is need to localize jTextView1)
	```

  - 2 - Put a **jEditText** component on _LAMW Form_ and set properties:

    ```java
       Anchor = jTextView1
       LayoutParamWidth = lpTwoThirdOfParent
       PosRelativeToAnchor
       raBelow = [True]
       PosRelativeToParent
       rpCenterHorizontal = [True]
       Text = Ok

      //(Because we want it to be bellow the jTextView1)
	```

  - 3 - Put a **jButton** component on _LAMW Form_ and set properties:

    ```java

       Anchor = jEditText1
       LayoutParamWidth = lpTwoThirdOfParent 
       PosRelativeToAnchor
       raBelow = [True]
       PosRelativeToParent
       rpCenterHorizontal = [True]
       Text = Sample    
       //(Because we want it to be bellow the jEditText1)
	
    ```

  - 4 - Hint:
    - To Change _width/height_ of a visual component you should configure _LayoutParamWhidth_ and _LayoutParamHeight!_

### Others references

1. [Tutorial: My First "Hello Word" App](https://github.com/jmpessoa/lazandroidmodulewizard/blob/master/docs/AppHelloWorld.md)

2. [Multi-Form demo](https://github.com/jmpessoa/lazandroidmodulewizard/tree/master/demos/GUI/AppTest1)

3. [All GUI demos](https://github.com/jmpessoa/lazandroidmodulewizard/tree/master/demos/GUI)
