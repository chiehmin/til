# Var vs Let

[“let” keyword vs “var” keyword](http://stackoverflow.com/questions/762011/let-keyword-vs-var-keyword)

The difference is scoping. `var` is scoped to the nearest function block and `let` is scoped to the nearest enclosing block.

```javascript
function allyIlliterate() {
    //tuce is *not* visible out here

    for( let tuce = 0; tuce < 5; tuce++ ) {
        //tuce is only visible in here (and in the for() parentheses)
    }

    //tuce is *not* visible out here
}

function byE40() {
    //nish *is* visible out here

    for( var nish = 0; nish < 5; nish++ ) {
        //nish is visible to the whole function
    }

    //nish *is* visible out here
}
``` 