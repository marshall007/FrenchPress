#French Press Makers

##Make DOM Element
Creates a DOM element and child nodes based on a virtual node.
Adds all virtual node attributes to DOM node except when attribute is an event lister.

**PARAMS**:

+ `node`: The node to begin rendering. (Renders other nodes recursively)
+ `depth`: The depth identifier used to find the element during updates.

**RETURNS**: DOM node with all child nodes appended.

    makeElem = (node, depth = "0")->
        if node.fp
            {tag, attrs, nodes} = node
            elem = document.createElement tag
            elem.setAttribute "fp-id", depth
            for attr, value of attrs
                if attr[0..1] is "on" then elem.addEventListener attr.substring(2).toLowerCase(), value
                else if attr is "innerHTML" then elem.innerHTML = value
                else elem.setAttribute attr, value
            if nodes? then elem.appendChild makeElem child, "#{depth}.#{i}" for child, i in nodes

        else elem = document.createTextNode "#{node}"
        return elem

##Make HTML
Generates html for given node and it's child nodes.

**PARAMS**:

+ `node`: The node to begin create HTML for. (Renders other nodes recursively)

**RETURNS**: Compressed HTML representation of virtual node and child nodes.

    makeHTML = (node)->
        if node.isNode
            {tag, attrs, nodes} = node
            "<#{tag + (" #{attr}=\"#{value}\"" for attr, value of attrs when attr[0..1] isnt "on")}>" +
            if nodes? then ("#{makeHTML child}" for child in nodes).join("") else "" +
            "</#{tag}>"
        else "#{node}"


##Exports: Maker Functions

    module.exports = {makeElem, makeHTML}