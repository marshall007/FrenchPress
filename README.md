#![French Press](http://dylanpiercey.com/img/fp.png)French Press 
####(6kb minified and 2.3kb gzipped)
A very tiny, very fast and extremely flexible MVC designed specifically for coffee-script.
##[View The Demo](https://github.com/DylanPiercey/FPMusic)
##[View The JavaScript Demo](https://github.com/DylanPiercey/FPMusicJS)

##News
Some breaking errors were introduced yesterday. If your DOM is not redrawing properly please update.

##Download
The minified js version of French Press can be found in the [bin folder](https://github.com/DylanPiercey/FrenchPress/blob/master/bin/frenchpress.min.js).

#Tutorial
The FrenchPress API is exposed through a global "fp" object.

##Rendering an FP Element:
Simply use: "fp.render **DOMParentNode**, **fpElementToRender**"

Like So:

```CoffeeScript
fp.render document.body, ToDoList()
```

##Creating an FP Element:

1. Each FP element must provide a render function with a coffee-script template.
Render must return a virtual dom node. (usually with children)
    ```CoffeeScript
    TodoList = fp.element(
        render: (DOM, props)-> aNode(aSubNode)
    )
    ```

2. Extract all wanted virtual elements (functions) from the provided DOM.
    ```CoffeeScript
    render: (DOM, props)->
        {div, h1, h2, input, span, ul, li, del, label, button} = DOM
    ```
        
3. Virtual nodes can accept the following arguments:
    + `Object`: First argument to use as the attributes for the element. (Optional)
    + `Virtual Elements`: Taken as children.
    + `FP Elements`: Taken as children
    + `Arrays`: Simply added to children
    + `Anything else`: Converted to a string 
    ```CoffeeScript
    render: (DOM, props)->
        {div, h1, h2, input, span, ul, li, del, label, button} = DOM
        #This next div is returned.
        div class: "todo-app",
            h1 "Todo's By FrenchPress" 
            input type: "text", placeholder: "What needs to be done?"
    ```
####Will generate:
    ```HTML
    <div class="todo-app">
        <h1>Todo's By FrenchPress</h1>
        <input type="text" placeholder="What needs to be done?">
    </div>
    ```
        
4. So why is this cool?
    + You can use ALL of coffeescript in these templates, because everything is an expression!
    + It automatically handles eventListeners and changes to the DOM.
    + When the virtual DOM is updated, it only updates the minimal amount of DOM nodes.
    
As an example lets add a for loop of todo's (Defined outside of the fp.element just because thats possible) and some buttons to work with todos. (This will render all of the todos in a list, but you cannot load more or do anything with them yet.)

```CoffeeScript
render: (DOM)->
    {div, h1, h2, input, span, ul, li, del, label, button} = DOM
    div(
        h1 "Todo's By FrenchPress"
        input type: "text", placeholder: "What needs to be done?"
        if list.length > 0
            label(
                input type: "checkbox"
                span "Mark all as completed"
            )

        #Note that the comprehension returns virtual nodes to the ul node. "When" filters work too!
        ul (for todo, i in list
                li class: "todo",
                    #And here the if/else returns a string (Undo or Finish)
                    button (if todo.checked then "Undo" else "Finish")
                    #Here we are even choosing a virtual element inline based on the status of the todo (del or span element)
                    (if todo.checked then del else span) " #{todo.text}"
            )

        div "#{list.count((n)-> not n.checked)} left."
        button "Remove all completed."
    )
```

##Init Element / Add Events / Update View
FP Elements optionally can have an "init" function that can initialize an element (asynchronously or not).

Init can return an object which will be bound to the elements state inside the template.

Bound to the init function is a **REDRAW** function that when invoked will intelligently update the DOM.

1. Creating an eventListener is as easy as HTML, French Press will automatically map your listeners to action listeners.
    ```CoffeeScript
    list = []
    
    TodoList = fp.element(
        init: ->
            #Any startup code can happen here... (Access to @REDRAW())
            
            #Finally it can return the state object for the element.
            addToDo: ({keyCode, target})=> #Note that in order to use REDRAW we must bind with fat arrow.
                #This is a regular event, we have taken out the target element to get the value, as well as the keycode.
                
                unless keyCode is "13" return
                list.push text: target.value, checked: no
                target.value = ""
                
                #After we have done our changes to the state we simply call @REDRAW() to fix the updated elements.
                
                @REDRAW()
            
        
        
        render: (DOM, props)-> ...
            input type: "text", placeholder: "What needs to be done?", *onKeyUp*: @addToDo
    )
    ```
    
2. Finishing up.
It's as simple as using events and calling @REDRAW when there should be an update.
    ```CoffeeScript
    list = []
    
    ToDoList = fp.element(
        init: ->
            completeAll: ({target: {checked}})=>
                list = (for todo in list
                    todo.checked = checked
                    todo
                )
                @REDRAW()
    
            removeCompleted: =>
                list = list.exclude (n)-> n.checked
                @REDRAW()
    
    
            toggleChecked: (index)=> => #This is a curried function so that I can pass in some state to the event listener, extremely useful.
                list[index].checked = not list[index].checked
                @REDRAW()
    
            addToDo: ({keyCode, target})=>
                if keyCode is 13
                    list.push {text: target.value, checked: no}
                    target.value = ""
                    @REDRAW()
    
        render: (DOM)->
            {div, h1, h2, input, span, ul, li, del, label, button} = DOM
            div(
                h1 "Todo's By FrenchPress"
                input type: "text", placeholder: "What needs to be done?", onKeyDown: @addToDo
                if list.length > 0
                    label(
                        input type: "checkbox", onClick: @completeAll
                        span "Mark all as completed"
                    )
    
                h2 "Incomplete"
                ul (for todo, i in list
                        li class: "todo",
                            button(onClick: @toggleChecked(i), if todo.checked then "Undo" else "Finish")
                            (if todo.checked then del else span)(" #{todo.text}")
                    )
    
                div "#{list.count((n)-> not n.checked)} left."
                button onClick: @removeCompleted, "Remove all completed."
            )
    )
    
    fp.render document.body, ToDoList()
    ```

##Thats It!
####Simply write your markup, throw in coffee-script expressions the way they were designed and REDRAW when you need too!

This is a brand new project and the goal of it is to improve the expressiveness of modern MVC's with the help of coffee-script.

If you have an idea, suggestion, concern or anything feel free to contact me or submit an issue.