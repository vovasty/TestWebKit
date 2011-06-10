document.ontouchmove = function(event){event.preventDefault();}

Bookmate = function()
{
    var gap = 20;

    this.paginate = function(colsPerPage)
    {
        var desiredWidth = window.innerWidth;
        var desiredHeight = window.innerHeight;
        
        var colWidth = Math.floor(desiredWidth / colsPerPage) - gap;
        
        var sStyle =  "html{" + 
        "width:"+(desiredWidth - gap)+ "px;" + 
        "height:"+desiredHeight+"px;"+
        "-webkit-columns-count:"+colsPerPage+";"+
        "-webkit-column-width:"+colWidth + "px;" + 
        "-webkit-column-gap:"+gap + "px;" + 
        "}" +
        "img{" + 
        "max-width:"+colWidth+"px;" + 
        "max-height:"+Math.floor((desiredHeight*5)/6)+"px;" + 
        "}"+
        "body{" + 
        "padding-left:"+gap+"px;" + 
        "}";

        
        var style = document.getElementById("__pagination");
        if (!style)
        {
            style = document.createElement("style");
            style.id = "__pagination";
            document.head.appendChild(style);
        }
        
        style.innerHTML = sStyle;
        
        return Math.round(document.body.scrollWidth / window.innerWidth);
    }
    
    this.setPage = function(page)
    {
        var prev = document.body.scrollLeft;
        document.body.scrollLeft=page*window.innerWidth;
        return document.body.scrollLeft != prev;
    }
    
    this.loadResource = function(filename, filetype){
        if (filetype=="js"){ //if filename is a external JavaScript file
            var fileref=document.createElement('script')
            fileref.setAttribute("type","text/javascript")
            fileref.setAttribute("src", filename)
        }
        else if (filetype=="css"){ //if filename is an external CSS file
            var fileref=document.createElement("link")
            fileref.setAttribute("rel", "stylesheet")
            fileref.setAttribute("type", "text/css")
            fileref.setAttribute("href", filename)
        }
        if (typeof fileref!="undefined")
            document.getElementsByTagName("head")[0].appendChild(fileref)
        }

    this.linkAtCGPoint = function(x,y)
    {
        var lx = x + window.pageXOffset;
        var ly = y + window.pageYOffset;
        var e = document.elementFromPoint(lx,ly);
        if ( e.tagName == "a" )
        {
            var link = {"frame":{"height":e.offsetHeight,"width":e.offsetWidth,"x":x,"y":y}};
            link.text = e.innerText;
            link.attributes = {};
            for (var i=0; i<e.attributes.length;i++)
            {
                var attr = e.attributes[i];
                link.attributes[attr.name] = attr.value;
            }
            return JSON.stringify(link);
        }
        else
            return null;
    }
}
__bm = new Bookmate();

__bm.loadResource("http://vovasty.local:8888/target/target-script-min.js#anonymous", "js");