#French Press Main
Creates global "fp" object.

##Dependancies

    DOM = require "./lib/dom"
    update = require "./lib/update"
    makeElem = require "./lib/makeElem"

####Cache for previous fp element.

    CACHE = null

####Get requestAnimationFrame

    requestAnimationFrame = window.requestAnimationFrame or window.mozRequestAnimationFrame or window.webkitRequestAnimationFrame or window.oRequestAnimationFrame

##Export fp (French Press) Object
The entry point to the API for French Press.

    window.fp =

##Attach Element to DOM
Renders a French Press element to the DOM at a given parent element.

**PARAMS**:

+ `parent`: The DOM element/node to append the fp element to.
+ `element`: The fp element to attach to the DOM.

        render: (parent, element)->
            CACHE = element
            parent.innerHTML = null
            parent.appendChild makeElem element


##Create an FP Element
Creates a French Press element with optional initialization function and a template to render.

**PARAMS**: Both render and init functions have REDRAW function attached to them to update the view.

+ `init`: A function that can initialize an fp Element and can return an object to represent its state.
+ `render`: The coffee-script template to render for the fp Element.

        element: ({init, render})-> (props)->

####REDRAW Function
Accessed in init and render through their state (@REDRAW()).
This function will start a virtual DOM update, eventually updating the DOM and the cache.

            REDRAW = ->
                nodes = render.bind(state, DOM, props)()
                changes = update nodes, CACHE
                requestAnimationFrame -> do change for change in changes
                CACHE = nodes

####Initialize state and props (if unset) for the element.

            state = if init? then init.bind({REDRAW})() or {} else {}
            props or= {}

####Returns the initial fp element.

            render.bind(state, DOM, props)()