#French Press DOM Generator
The DOM generator exports the virtual DOM for use in templates.

##List of virtual nodes to generate:

    tags = [
        "a","abbr","address","area","article","aside","audio","b","base","bdi","bdo","big","blockquote","body","br",
        "button","canvas","caption","cite","code","col","colgroup","data","datalist","dd","del","details","dfn","div",
        "dl","dt","em","embed","fieldset","figcaption","figure","footer","form","h1","h2","h3","h4","h5","h6","head",
        "header","hr","html","i","iframe","img","input","ins","kbd","keygen","label","legend","li","link","main","map",
        "mark","menu","menuitem","meta","meter","nav","noscript","object","ol","optgroup","option","output","p","param",
        "pre","progress","q","rp","rt","ruby","s","samp","script","section","select","small","source","span","strong",
        "style","sub","summary","sup","table","tbody","td","textarea","tfoot","th","thead","time","title","tr","track",
        "u","ul","var","video","wbr","circle","defs","ellipse","g","line","linearGradient","mask","path","pattern",
        "polygon","polyline","radialGradient","rect","stop","svg","tspan","injection", "text"
    ]

##Make Virtual DOM Node
Creates a virtual node, recursively adding all child nodes.

**PARAMS**: tagName is used during initial generation of the virtual DOM other params are curried and used in templates.

+ `tagName`: The tagName for the generated node.
+ `args`: Attributes for the node. (If not an object arg will be added to children)
+ `children`: Child nodes for the current node.

**RETURNS**: Virtual DOM node with all nested children.

    Node = (tagName)-> (args, children...)->
        if args?
            if typeof args is "object" then attrs = args
            else children.unshift args

        for child, i in children
            unless child? then children.splice i, 1
            else if Array.isArray child then children.splice i, 1, child...

        result = {tagName, isNode: yes}
        result.attrs = attrs if attrs?
        result.children = children if children[0]?
        result

##Exports: Virtual DOM

    nodes = {}
    nodes[tag] = Node tag for tag in tags

    module.exports = nodes