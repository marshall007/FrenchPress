#French Press Makers

##Make DOM Element
Creates a DOM element and children based on a virtual node.
Adds all virtual node attributes to DOM node except when attribute is an event lister.

**PARAMS**:

+ `node`: The node to begin rendering. (Renders other nodes recursively)
+ `depth`: The depth identifier used to find the element during updates.

**RETURNS**: DOM node with all nested children appended.

    makeElem = (node, depth = "0")->
        if node.isNode
            {tagName, attrs, children} = node
            elem = document.createElement tagName
            elem.setAttribute("fp-id", depth)
            for attr, value of attrs
                if attr[0..1] is "on" then (elem.addEventListener or elem.attachEvent) attr.substring(2).toLowerCase(), value
                else if attr is "innerHTML" then elem.innerHTML = value
                else elem.setAttribute attr, value
            if children? then elem.appendChild makeElem child, "#{depth}.#{i}" for child, i in children

        else elem = document.createTextNode node
        return elem

##Make HTML
Generates html for given node and it's children.

**PARAMS**:

+ `node`: The node to begin create HTML for. (Renders other nodes recursively)

**RETURNS**: Compressed HTML representation of virtual node and children.

    makeHTML = (node)->
        if node.isNode
            {tagName, attrs, children} = node
            "<#{tagName + (" #{attr}=\"#{value}\"" for attr, value of attrs when attr[0..1] isnt "on")}>" +
            if children? then ("#{makeHTML child}" for child in children).join("") else "" +
            "</#{tagName}>"
        else "#{node}"


##Exports: Maker Functions

    module.exports = {makeElem, makeHTML}