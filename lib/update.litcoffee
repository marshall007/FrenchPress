#French Press Update/Diffing Algorithm

##Dependancies

    {makeElem} = require "./makers"

##Update Function

**PARAMS**:

+ `cur`: Node from recently rendered template.
+ `old`: Node from previously rendered template.
+ `depth`: Current depth of the update algorithm (Used to find DOM Element).

**RETURNS**: Function packaged DOM updates to be invoked later.

    getUpdates = (cur, old, depth = "0")->

####Helper Functions:

Gets parent element in DOM based on current depth by removing last index.

        getParent = -> document.querySelector "[fp-id='#{depth[0...depth.lastIndexOf "."]}']"

Gets the current element in the DOM based on depth.

        getElem = -> document.querySelector "[fp-id='#{depth}']"

Gets a textNode in DOM based on depth.

        getTextElem = -> getParent().childNodes[depth.substring(depth.lastIndexOf(".") + 1)]

####Begin Update Algorithm:

        changes = []

        #Must be at least one virtual node to calculate update.
        if cur? or old?

            #No old node: append cur node to parent element.
            unless old? then changes.push -> getParent().appendChild makeElem cur, depth

            #No cur element: remove previous element.
            else unless cur? then changes.push -> getElem().remove()

            #Start comparison of two nodes.
            else if cur.isNode and old.isNode

                #Tag name changed, replace old node with cur node.
                if cur.tagName isnt old.tagName
                    elem = getElem()
                    changes.push -> elem.parentNode.replaceChild makeElem(cur, depth), elem

                else

                    #Scan cur node for attributes that have changed from old node.
                    for attr, value of cur.attrs when old.attrs[attr]?.toString() isnt value.toString()

                        #If attr is event (starts with on): remove old event, add new event.
                        if attr[0..1] is "on"
                            elem = getElem()
                            event = attr.substring(2).toLowerCase()
                            changes.push ->
                                elem.removeEventListener event, old.attrs[attr]
                                elem.addEventListener event, value

                        #If attr is innerHTML: Set innerHTML
                        else if attr is "innerHTML" then changes.push -> getElem().innerHTML = value

                        #Otherwise change the attr.
                        else changes.push -> getElem().setAttribute attr, value

                    #Scan old node for attributes that have been removed in cur node.
                    for attr, value of old.attrs when not cur.attrs[attr]?

                        #If attr is event (starts with on): remove old event.
                        if attr[0..1] is "on"
                            event = attr.substring(2).toLowerCase()
                            changes.push -> getElem().removeEventListener event, old.attrs[attr]

                        #If attr is innerHTML: remove innerHTML
                        else if attr is "innerHTML" then changes.push -> getElem().innerHTML = ""

                        #Otherwise remove the attribute.
                        else changes.push -> getElem().removeAttribute attr

                    #If both elements have children then we must diff them.
                    if cur.children? and old.children?
                        for i in [0...Math.max cur.children.length, old.children.length]
                            changes.splice changes.length, 0, (
                                getUpdates cur.children[i], old.children[i], "#{depth}.#{i}"
                            )...

                    #If old node has children and cur node doesn't: Remove all old nodes children.
                    else if old.children? then changes.push -> getElem().innerHTML = ""

                    #If cur node has children and old node doesn't: Add all cur nodes children.
                    else if cur.children?
                        changes.push -> getElem().appendChild makeElem child, "#{depth}.#{i}" for child, i in cur.children


            #When old node is textNode and cur node isn't: Rebuild node.
            else if cur.isNode
                elem = getTextElem()
                changes.push -> elem.parentNode.replaceChild makeElem(cur, depth), elem

            #If nodes are textNodes and are different: Replace old node text with cur node text.
            else if cur.toString() isnt old.toString() then changes.push -> getTextElem().textContent = "#{cur}"

        return changes

##Exports: DOM Update Function

    module.exports = getUpdates